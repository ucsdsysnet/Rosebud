`include "struct_s.sv"

module pigasus_sme_wrapper # (
  parameter BYTE_COUNT = 16
) (
  input  wire            clk,
  input  wire            rst,

  // AXI Stream input
  input  wire [BYTE_COUNT*8-1:0]       s_axis_tdata,
  input  wire [$clog2(BYTE_COUNT)-1:0] s_axis_tempty,
  input  wire                          s_axis_tvalid,
  input  wire                          s_axis_tlast,
  output wire                          s_axis_tready,

  input  wire [71:0]     wr_data,
  input  wire [18:0]     wr_addr,
  input  wire            wr_en,

  // Preamble state (7B data and 1B len)
  input  wire [8*8-1:0]  preamble_state,
  input  wire            reload,

  // Match output
  input  wire            match_release,
  output reg  [15:0]     match_rule_ID,
  output reg             match_valid,

  // Last bytes (7B data and 1B len)
  output wire [8*8-1:0]  last_bytes_state,

  // merged state
  output reg  [7:0]      match_valid_stat
);

  ///////////////////////////////////////////////
  //////////   Selecting input data   ///////////
  ///////////////////////////////////////////////

  // TODO: add pkt_data_mover

  reg valid_r;
  always @ (posedge clk)
    if(rst)
      valid_r <= 1'b0;
    else
      valid_r <= s_axis_tvalid;

  wire s_axis_tsop = s_axis_tvalid & !valid_r;

  reg [BYTE_COUNT*8-1:0] s_axis_tdata_rev;
  integer i;
  always @ (*)
    for (i=1;i<=BYTE_COUNT;i=i+1)
      s_axis_tdata_rev[(i-1)*8+:8] = s_axis_tdata[(BYTE_COUNT-i)*8+:8];
      // {8{~s_axis_tkeep[BYTE_COUNT-i]}};

  ///////////////////////////////////////////////
  ////////// Check for fast patterns ////////////
  ///////////////////////////////////////////////
  wire [127:0] pigasus_data;
  wire         pigasus_valid;
  wire         pigasus_ready;
  wire         pigasus_sop;
  wire         pigasus_eop;
  wire [3:0]   pigasus_empty;

  string_matcher pigasus (
    .clk(clk),
    .rst(rst),

    .in_pkt_data(s_axis_tdata_rev),
    .in_pkt_empty(s_axis_tempty),
    .in_pkt_valid(s_axis_tvalid),
    .in_pkt_sop(s_axis_tsop),
    .in_pkt_eop(s_axis_tlast),
    .in_pkt_ready(s_axis_tready),

    .wr_data(wr_data[63:0]),
    .wr_addr(wr_addr),
    .wr_en(wr_en),

    .out_usr_data(pigasus_data),
    .out_usr_valid(pigasus_valid),
    .out_usr_ready(pigasus_ready),
    .out_usr_sop(pigasus_sop),
    .out_usr_eop(pigasus_eop),
    .out_usr_empty(pigasus_empty)
  );

  wire [127:0] concat_sme_output;
  metadata_t meta;

  initial begin
    meta.tuple.sPort = 16'd1025;
    meta.tuple.dPort = 16'd1024;
    meta.prot        = PROT_TCP;
  end

  port_group pg_inst (
    .clk(clk),
    .rst(rst),

    .in_usr_sop(pigasus_sop),
    .in_usr_eop(pigasus_eop),
    .in_usr_data(pigasus_data),
    .in_usr_empty(pigasus_empty),
    .in_usr_valid(pigasus_valid),
    .in_usr_ready(pigasus_ready),

    .in_meta_valid(1'b1),
    .in_meta_data(meta),
    .in_meta_ready(),

    .wr_data(wr_data[71:0]),
    .wr_addr(wr_addr[12:0]),
    .wr_en(wr_en && (wr_addr[18:17]==2'b11)),

    .out_usr_data(concat_sme_output),
    .out_usr_valid(sme_output_v),
    .out_usr_ready(1'b1),
    .out_usr_sop(),
    .out_usr_eop(),
    .out_usr_empty(),

    .no_pg_rule_cnt(),
    .pg_rule_cnt()
  );

  // FIFO
  wire [127:0] sme_output_f;
  wire         sme_output_f_v;
  wire         sme_output_f_ready;

  reg  [127:0] sme_output_r;
  reg  [7:0]   sme_output_r_v;

  simple_fifo # (
    .ADDR_WIDTH(2),
    .DATA_WIDTH(128)
  ) accel_fifo (
    .clk(clk),
    .rst(rst),
    .clear(reload),

    .din_valid(sme_output_v),
    .din(concat_sme_output),
    .din_ready(),

    .dout_valid(sme_output_f_v),
    .dout(sme_output_f),
    .dout_ready(sme_output_f_ready)
  );

  integer m;
  always @ (posedge clk) begin
    if (sme_output_f_v & sme_output_f_ready) begin
      sme_output_r <= sme_output_f;
      for (m=0;m<8;m=m+1)
        sme_output_r_v <= (sme_output_f[m*16+:16]==0) ? 1'b0 : 1'b1;
    end
    if (rst)
        sme_output_r_v <= 8'd0;
  end

  assign sme_output_f_ready = !(|sme_output_r_v);

  reg [7:0]  selected_match;
  reg [7:0]  selected_match_r;
  reg [15:0] selected_match_index;
  reg [7:0]  match_mask;

  integer k;
  always @ (*) begin
    selected_match       = 8'd1;
    selected_match_index = sme_output_r[0*16+:16];

    for (k=7;k>=0;k=k-1)
      if (sme_output_r_v[k] & match_mask[k]) begin
        selected_match       = 8'd1 << k;
        selected_match_index = sme_output_r[k*16+:16];
      end
  end

  always @ (posedge clk) begin
    selected_match_r <= selected_match;
    match_rule_ID    <= selected_match_index;

    match_valid      <= |(sme_output_r_v & match_mask);
    match_valid_stat <= sme_output_r_v & match_mask;

    if (rst) begin
      match_valid      <= 1'b0;
      match_valid_stat <= 8'd0;
    end
  end

  always @ (posedge clk) begin
    if (rst || reload)
      match_mask <= 8'hFF;
    else if (match_release)
      match_mask <= match_mask & ~selected_match_r;
  end

  // ///////////////////////////////////////////////
  // ////////// Keeping last bytes logic ///////////
  // ///////////////////////////////////////////////
  // reg [63:0] last_chunk1;
  // reg [63:0] last_chunk2;
  // reg [2:0]  last_chunk_shift;
  // reg        last_chunk_valid;
  //
  // reg [3:0] one_count;
  // integer l;
  // always @ (*) begin
  //   one_count = 8;
  //   for (l=7; l>=0; l=l-1)
  //     if (!s_axis_tkeep[l])
  //       one_count = one_count-1;
  // end

  // always @ (posedge clk) begin
  //   if (s_axis_tvalid && s_axis_tready) begin
  //     last_chunk2      <= last_chunk1;
  //     last_chunk1      <= s_axis_tdata;
  //     last_chunk_shift <= one_count;
  //     if (s_axis_tlast)
  //       last_chunk_valid <= 1'b1;
  //   end
  //   if (reload | rst)
  //     last_chunk_valid <= 1'b0;
  // end
  //
  // wire [63:0] full_chunk = {last_chunk1, last_chunk2} >> last_chunk_shift;

  assign last_bytes_state = 64'hffff_ffff_ffff_ffff; // {full_chunk[55:0], 7'd0, last_chunk_valid};

endmodule

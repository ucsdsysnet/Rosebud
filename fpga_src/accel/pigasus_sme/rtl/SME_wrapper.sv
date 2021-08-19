`include "struct_s.sv"

module pigasus_sme_wrapper # (
  parameter BYTE_COUNT = 16,
  parameter STRB_COUNT = $clog2(BYTE_COUNT)
) (
  input  wire                    clk,
  input  wire                    rst,

  // AXI Stream input
  input  wire [BYTE_COUNT*8-1:0] s_axis_tdata,
  input  wire [STRB_COUNT-1:0]   s_axis_tempty,
  input  wire                    s_axis_tvalid,
  input  wire                    s_axis_tlast,
  output wire                    s_axis_tready,

  input  wire [71:0]             wr_data,
  input  wire [18:0]             wr_addr,
  input  wire                    wr_en,

  // Metadata state in
  input  wire [63:0]             preamble_state_in,
  input  wire [15:0]             src_port,
  input  wire [15:0]             dst_port,
  input  wire                    meta_valid,
  output wire                    meta_ready,

  // Match output
  input  wire                    match_release,
  output wire [15:0]             match_rule_ID,
  output reg                     match_valid,

  // Metadata state out
  output reg [63:0]              preamble_state_out,

  // merged state
  output reg  [7:0]              match_valid_stat
);

  ///////////////////////////////////////////////
  //////////   Adjusting input data   ///////////
  ///////////////////////////////////////////////

  // Metadata state, 56 bits preamble, 1 bit is_tcp,
  // 3 bits zero, 1 bit has_preamble, 3 bits zero.
  // For the first packet RISCV would set the tcp bit
  // and output of this wrapper would fill the has_preamble
  // for next packets
  wire [55:0] preamble     = preamble_state_in[55:0];
  wire        is_tcp       = preamble_state_in[56];
  wire        has_preamble = preamble_state_in[60];

  reg valid_r;
  always @ (posedge clk)
    if(rst)
      valid_r <= 1'b0;
    else
      valid_r <= s_axis_tvalid;

  wire s_axis_tfirst = s_axis_tvalid & !valid_r;

  // TODO: should test if real run also needs it
  reg [BYTE_COUNT*8-1:0] s_axis_tdata_rev;
  integer i;
  always @ (*)
    for (i=1;i<=BYTE_COUNT;i=i+1)
      s_axis_tdata_rev[(i-1)*8+:8] = s_axis_tdata[(BYTE_COUNT-i)*8+:8];

  // Latching of LSB 7 bytes and state for extra cycle if necessary
  reg [55:0]            rest_7;
  reg [STRB_COUNT-1:0]  rem_empty;
  wire                  has_extra;
  reg                   has_extra_r;

  assign has_extra = s_axis_tlast && has_preamble && (s_axis_tempty < 7);

  always @ (posedge clk) begin
    rest_7      <= s_axis_tdata_rev[55:0];
    has_extra_r <= has_extra | (has_extra_r && !s_axis_tready);
    rem_empty   <= (BYTE_COUNT-7) + s_axis_tempty[2:0];

    if (rst)
      has_extra_r <= 1'b0;
  end

  // Add the preamble if necessary
  reg  [BYTE_COUNT*8-1:0] in_pkt_data;
  wire [STRB_COUNT-1:0]   in_pkt_empty;
  wire                    in_pkt_valid;
  wire                    in_pkt_sop;
  wire                    in_pkt_eop;
  wire                    in_pkt_ready;

  assign in_pkt_eop    = has_extra ? 1'b0 : (s_axis_tlast | has_extra_r);
  assign in_pkt_valid  = s_axis_tvalid | has_extra_r;
  assign in_pkt_sop    = s_axis_tfirst;
  assign in_pkt_empty  = (!has_preamble) ? s_axis_tempty :
                             has_extra_r ? rem_empty :
                     (s_axis_tempty > 7) ? (s_axis_tempty-7) :
                                           {STRB_COUNT{1'b0}};

  assign s_axis_tready = in_pkt_ready;

  // Note that if there are non_valid bytes at LSB, first_filter masks the empty
  // bytes, so tempty takes care of them, even in case of EOP and empty>=7
  always @ (*)
    if (has_preamble) begin
      if (s_axis_tfirst)
        in_pkt_data = {preamble, s_axis_tdata_rev[8*BYTE_COUNT-1:56]};
      else if (!has_extra_r)
        in_pkt_data = {rest_7,   s_axis_tdata_rev[8*BYTE_COUNT-1:56]};
      else
        in_pkt_data = {rest_7,   {8*(BYTE_COUNT-7){1'b1}}};
    end else begin
        in_pkt_data = s_axis_tdata_rev;
    end

  // Save last 7 bytes. Use 0xFF for fillers so preamble is padded
  reg [55:0] last_7;
  always @ (posedge clk)
    if (s_axis_tlast && s_axis_tvalid)
      if (s_axis_tfirst) begin
        if (has_preamble)
          last_7 <= {preamble, s_axis_tdata_rev}   >> (8*s_axis_tempty);
        else
          last_7 <= {{56{1'b1}}, s_axis_tdata_rev} >> (8*s_axis_tempty);
      end else begin
          last_7 <= {rest_7, s_axis_tdata_rev}     >> (8*s_axis_tempty);
      end

  // If it's not TCP, no need for preamble. But if it is TCP, output
  // would have the has_preamble set
  assign preamble_state_out = {3'd0, is_tcp, 3'd0, is_tcp, last_7};

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

    .in_pkt_data(in_pkt_data),
    .in_pkt_empty(in_pkt_empty),
    .in_pkt_valid(in_pkt_valid),
    .in_pkt_sop(in_pkt_sop),
    .in_pkt_eop(in_pkt_eop),
    .in_pkt_ready(in_pkt_ready),

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

  port_group pg_inst (
    .clk(clk),
    .rst(rst),

    .in_usr_sop(pigasus_sop),
    .in_usr_eop(pigasus_eop),
    .in_usr_data(pigasus_data),
    .in_usr_empty(pigasus_empty),
    .in_usr_valid(pigasus_valid),
    .in_usr_ready(pigasus_ready),

    .in_meta_valid(meta_valid),
    .src_port(src_port),
    .dst_port(dst_port),
    .is_tcp(is_tcp),
    .in_meta_ready(meta_ready),

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

  // FIFOs, assuming no overflow for now
  wire [12:0] sme_output_f [8];
  wire [7:0]  sme_output_f_v;
  wire [7:0]  sme_output_f_ready;

  genvar m;
  generate
    for (m=0;m<8;m=m+1) begin: match_fifos
      simple_fifo # (
        .ADDR_WIDTH(2),
        .DATA_WIDTH(13)
      ) match_fifo (
        .clk(clk),
        .rst(rst),
        .clear(1'b0),

        .din_valid(sme_output_v &&
            (concat_sme_output[m*16+:13]!=13'd0)),
        .din(concat_sme_output[m*16+:13]),
        .din_ready(),

        .dout_valid(sme_output_f_v[m]),
        .dout(sme_output_f[m]),
        .dout_ready(sme_output_f_ready[m])
      );
    end
  endgenerate

  wire [2:0] selected_fifo;
  wire [7:0] ack;

  arbiter # (.PORTS(8), .TYPE("PRIORITY")) match_arb (
    .clk (clk),
    .rst (rst),

    .request      (sme_output_f_v & ~sme_output_f_ready),
    .acknowledge  (8'd0),

    .grant        (ack),
    .grant_valid  (match_valid),
    .grant_encoded(selected_fifo)
  );

  assign sme_output_f_ready = ack & {8{match_release}};
  assign match_rule_ID      = {3'd0, sme_output_f[selected_fifo]};
  assign match_valid_stat   = sme_output_f_v;

endmodule

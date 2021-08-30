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
  input  wire [16:0]             wr_addr,
  input  wire                    wr_en,

  // Metadata state in
  input  wire [63:0]             preamble_state_in,
  input  wire [15:0]             src_port,
  input  wire [15:0]             dst_port,
  input  wire                    meta_valid,
  output wire                    meta_ready,

  // Match output
  output wire [31:0]             match_rules_ID,
  output wire                    match_last,
  output wire                    match_valid,
  input  wire                    match_release,

  // Metadata state out
  output wire [63:0]             preamble_state_out,
  output reg                     state_out_valid
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
  wire                  in_pkt_ready;

  assign has_extra = s_axis_tlast && has_preamble && (s_axis_tempty < 7);

  always @ (posedge clk) begin
    rest_7      <= s_axis_tdata_rev[55:0];
    rem_empty   <= (BYTE_COUNT-7) + s_axis_tempty[2:0];

    if (s_axis_tvalid && s_axis_tready && has_extra)
      has_extra_r <= 1'b1;
    else if (has_extra_r && in_pkt_ready)
      has_extra_r <= 1'b0;

    if (rst)
      has_extra_r <= 1'b0;
  end

  // Add the preamble if necessary
  reg  [BYTE_COUNT*8-1:0] in_pkt_data;
  wire [STRB_COUNT-1:0]   in_pkt_empty;
  wire                    in_pkt_valid;
  wire                    in_pkt_sop;
  wire                    in_pkt_eop;

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
  always @ (posedge clk)
    if (rst)
      state_out_valid <= 1'b0;
    else
      state_out_valid <= s_axis_tlast && s_axis_tvalid && s_axis_tready;

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

  wire [63:0] pigasus_data_r;
  wire        pigasus_valid_r;
  wire        pigasus_ready_r;
  wire        pigasus_sop_r;
  wire        pigasus_eop_r;
  wire [2:0]  pigasus_empty_r;

  rule_depacker_128_64 rule_depacker1_inst (
    .clk(clk),
    .rst(rst),

    .in_rule_sop(pigasus_sop),
    .in_rule_eop(pigasus_eop),
    .in_rule_data(pigasus_data),
    .in_rule_empty(pigasus_empty),
    .in_rule_valid(pigasus_valid),
    .in_rule_ready(pigasus_ready),

    .out_rule_data(pigasus_data_r),
    .out_rule_valid(pigasus_valid_r),
    .out_rule_ready(pigasus_ready_r),
    .out_rule_sop(pigasus_sop_r),
    .out_rule_eop(pigasus_eop_r),
    .out_rule_empty(pigasus_empty_r)
  );

  wire [63:0]  sme_output;
  wire         sme_output_valid;
  wire         sme_output_ready;
  wire         sme_output_eop;

  port_group pg_inst (
    .clk(clk),
    .rst(rst),

    .in_usr_sop(pigasus_sop_r),
    .in_usr_eop(pigasus_eop_r),
    .in_usr_data(pigasus_data_r),
    .in_usr_empty(pigasus_empty_r),
    .in_usr_valid(pigasus_valid_r),
    .in_usr_ready(pigasus_ready_r),

    .in_meta_valid(meta_valid),
    .src_port({src_port[7:0], src_port[15:8]}),
    .dst_port({dst_port[7:0], dst_port[15:8]}),
    .is_tcp(is_tcp),
    .in_meta_ready(meta_ready),

    .wr_data(wr_data[71:0]),
    .wr_addr(wr_addr[11:0]),
    .wr_en(wr_en && (wr_addr[16:15]==2'b11)),

    .out_usr_data(sme_output),
    .out_usr_valid(sme_output_v),
    .out_usr_ready(sme_output_ready),
    .out_usr_sop(),
    .out_usr_eop(sme_output_eop),
    .out_usr_empty(),

    .no_pg_rule_cnt(),
    .pg_rule_cnt()
  );

  rule_depacker_64_32 rule_depacker2_inst (
    .clk(clk),
    .rst(rst),

    .in_rule_sop(1'b0),
    .in_rule_eop(sme_output_eop),
    .in_rule_empty(3'd0),
    .in_rule_valid(sme_output_v),
    .in_rule_data(sme_output),
    .in_rule_ready(sme_output_ready),

    .out_rule_sop(),
    .out_rule_eop(match_last),
    .out_rule_valid(match_valid),
    .out_rule_data(match_rules_ID),
    .out_rule_empty(),
    .out_rule_ready(match_release)
  );

endmodule

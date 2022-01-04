/*

Copyright (c) 2021 Moein Khazraee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

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
  input  wire                    s_axis_tfirst,
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

  //////////////////////////////////////////////////////////////////////////
  //////////////////////   Preprocessing input data   //////////////////////
  //////////////////////////////////////////////////////////////////////////

  reg [BYTE_COUNT*8-1:0] s_axis_tdata_rev_r;
  reg [STRB_COUNT-1:0]   s_axis_tempty_r;
  reg                    s_axis_tvalid_r;
  reg                    s_axis_tfirst_r;
  reg                    s_axis_tlast_r;
  reg [STRB_COUNT-1:0]   empty_minus_7;
  reg                    empty_less_than_7;
  integer i;

  always @ (posedge clk) begin
    s_axis_tvalid_r <= (s_axis_tvalid   && s_axis_tready) ||
                       (s_axis_tvalid_r && !s_axis_tready);

    // Ready is asserted based on the registerred input data,
    // so when extra_r or pigasus ready do not accept the incoming
    // data, proper SoP is already in the registerred data, just
    // not used for 1 or 2 cycles based on extra_r state;
    if (s_axis_tvalid && s_axis_tready) begin
      s_axis_tempty_r   <= s_axis_tempty;
      s_axis_tfirst_r   <= s_axis_tfirst;
      s_axis_tlast_r    <= s_axis_tlast;
      empty_less_than_7 <= (s_axis_tempty < 7);

      // If more than 7 overflows and becomes empty-7
      // If less than 7, becomes the extra cycle tempty
      empty_minus_7   <= (BYTE_COUNT-7) + s_axis_tempty;

      // Byte swap the input data
      for (i=1;i<=BYTE_COUNT;i=i+1)
        s_axis_tdata_rev_r[(i-1)*8+:8] <= s_axis_tdata[(BYTE_COUNT-i)*8+:8];
    end

    if (rst)
      s_axis_tvalid_r <= 1'b0;
  end

  // Metadata state, 56 bits preamble, 1 bit is_tcp,
  // 3 bits zero, 1 bit has_preamble, 3 bits zero.
  // For the first packet RISCV would set the tcp bit
  // and output of this wrapper would fill the has_preamble
  // for next packets
  wire [55:0] preamble     = preamble_state_in[55:0];
  wire        is_tcp       = preamble_state_in[56];
  wire        has_preamble = preamble_state_in[60];


  //////////////////////////////////////////////////////////////////////////
  /////// Latching of LSB 7 bytes and check if extra cycle is needed ///////
  //////////////////////////////////////////////////////////////////////////

  reg [55:0]            rest_7;
  reg [STRB_COUNT-1:0]  rem_empty;
  reg                   extra_cycle;
  wire                  in_pkt_ready;

  always @ (posedge clk) begin
    if (s_axis_tvalid_r && in_pkt_ready) begin
      rest_7    <= s_axis_tdata_rev_r[55:0];
      rem_empty <= empty_minus_7;
    end

    if (s_axis_tvalid_r && s_axis_tlast_r && in_pkt_ready &&
        has_preamble && empty_less_than_7)
      extra_cycle <= 1'b1;
    else if (extra_cycle && in_pkt_ready)
      extra_cycle <= 1'b0;

    if (rst)
      extra_cycle <= 1'b0;
  end


  //////////////////////////////////////////////////////////////////////////
  ///////////////////   Add the preamble if necessary   ////////////////////
  //////////////////////////////////////////////////////////////////////////

  reg  [BYTE_COUNT*8-1:0] in_pkt_data;
  wire [STRB_COUNT-1:0]   in_pkt_empty;
  wire                    in_pkt_valid;
  wire                    in_pkt_sop;
  wire                    in_pkt_eop;

  assign in_pkt_eop    = extra_cycle || (s_axis_tlast_r &&
                      !(has_preamble && empty_less_than_7));
  assign in_pkt_valid  = s_axis_tvalid_r ||  extra_cycle;
  assign in_pkt_sop    = s_axis_tfirst_r && !extra_cycle;
  assign in_pkt_empty  = (!has_preamble) ? s_axis_tempty_r :
                             extra_cycle ? rem_empty :
                       empty_less_than_7 ? {STRB_COUNT{1'b0}} :
                                           empty_minus_7;

  assign s_axis_tready = in_pkt_ready && !extra_cycle;

  // Note that if there are non_valid bytes at LSB, first_filter masks the empty
  // bytes, so tempty takes care of them, even in case of EOP and empty>=7
  always @ (*)
    if (has_preamble) begin
      if (extra_cycle)
        in_pkt_data = {rest_7,   {8*(BYTE_COUNT-7){1'b1}}};
      else if (s_axis_tfirst_r)
        in_pkt_data = {preamble, s_axis_tdata_rev_r[8*BYTE_COUNT-1:56]};
      else
        in_pkt_data = {rest_7,   s_axis_tdata_rev_r[8*BYTE_COUNT-1:56]};
    end else begin
        in_pkt_data = s_axis_tdata_rev_r;
    end


  //////////////////////////////////////////////////////////////////////////
  //////////////////////   processing output state   ///////////////////////
  //////////////////////////////////////////////////////////////////////////

  // Save last 7 bytes. Use 0xFF for fillers so preamble is padded
  reg [55:0] last_7;
  always @ (posedge clk)
    if (s_axis_tlast_r && s_axis_tvalid_r)
      if (s_axis_tfirst_r) begin
        if (has_preamble)
          last_7 <= {preamble, s_axis_tdata_rev_r}   >> (8*s_axis_tempty_r);
        else
          last_7 <= {{56{1'b1}}, s_axis_tdata_rev_r} >> (8*s_axis_tempty_r);
      end else begin
          last_7 <= {rest_7, s_axis_tdata_rev_r}     >> (8*s_axis_tempty_r);
      end

  // If it's not TCP, no need for preamble. But if it is TCP, output
  // would have the has_preamble set
  assign preamble_state_out = {preamble_state_in[63:61], is_tcp,
                               preamble_state_in[59:57], is_tcp, last_7};
  always @ (posedge clk)
    if (rst)
      state_out_valid <= 1'b0;
    else
      state_out_valid <= s_axis_tlast_r && s_axis_tvalid_r && s_axis_tready;


  //////////////////////////////////////////////////////////////////////////
  ////////////   Pigasus fast pattern matcher and port group   /////////////
  //////////////////////////////////////////////////////////////////////////

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

`resetall

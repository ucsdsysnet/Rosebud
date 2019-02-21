/*

Copyright (c) 2014-2018 Alex Forencich

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

`timescale 1ns / 1ps

/*
 * FPGA core logic
 */
module fpga_core
(
    /*
     * Clock: 156.25MHz
     * Synchronous reset
     */
    input  wire       clk,
    input  wire       rst,

    /*
     * GPIO
     */
    output wire [1:0] sfp_1_led,
    output wire [1:0] sfp_2_led,
    output wire [1:0] sma_led,

    /*
     * Ethernet: QSFP28
     */
    input  wire        sfp_1_tx_clk,
    input  wire        sfp_1_tx_rst,
    output wire [63:0] sfp_1_txd,
    output wire [7:0]  sfp_1_txc,
    input  wire        sfp_1_rx_clk,
    input  wire        sfp_1_rx_rst,
    input  wire [63:0] sfp_1_rxd,
    input  wire [7:0]  sfp_1_rxc,
    input  wire        sfp_2_tx_clk,
    input  wire        sfp_2_tx_rst,
    output wire [63:0] sfp_2_txd,
    output wire [7:0]  sfp_2_txc,
    input  wire        sfp_2_rx_clk,
    input  wire        sfp_2_rx_rst,
    input  wire [63:0] sfp_2_rxd,
    input  wire [7:0]  sfp_2_rxc
);

assign sfp_2_txd = 64'h0707070707070707;
assign sfp_2_txc = 8'hff;

full_riscv_sys sys (
  .rx_clk(sfp_1_rx_clk),
  .rx_rst(sfp_1_rx_rst),
  .tx_clk(sfp_1_tx_clk),
  .tx_rst(sfp_1_tx_rst),
  .logic_clk(clk),
  .logic_rst(rst),

  .xgmii_rxd(sfp_1_rxd),
  .xgmii_rxc(sfp_1_rxc),
  .ifg_delay(8'd12),

  // Outputs
  .xgmii_txd(sfp_1_txd),
  .xgmii_txc(sfp_1_txc),

  .m_axis_tx_desc_status_tag(),
  .m_axis_tx_desc_status_valid(),
  .m_axis_rx_desc_status_len(),
  .m_axis_rx_desc_status_tag(),
  .m_axis_rx_desc_status_user(),
  .m_axis_rx_desc_status_valid(),

  .rx_error_bad_frame(),
  .rx_error_bad_fcs(),
  .tx_fifo_overflow(),
  .tx_fifo_bad_frame(),
  .tx_fifo_good_frame(),
  .rx_fifo_overflow(),
  .rx_fifo_bad_frame(),
  .rx_fifo_good_frame()
);

endmodule

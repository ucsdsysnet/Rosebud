/*

Copyright (c) 2015-2018 Alex Forencich

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
 * Testbench for eth_mac_10g
 */
module test_dma_full;

// Parameters
parameter DATA_WIDTH = 64;
parameter CTRL_WIDTH = (DATA_WIDTH/8);
parameter AXI_ADDR_WIDTH = 16;

// Inputs
reg clk = 0;
reg rst = 0;
reg [7:0] current_test = 0;

reg rx_clk = 0;
reg rx_rst = 0;
reg tx_clk = 0;
reg tx_rst = 0;
reg [DATA_WIDTH-1:0] xgmii_rxd = 0;
reg [CTRL_WIDTH-1:0] xgmii_rxc = 0;

reg [6:0]  inject_rx_desc = 0;
reg        inject_rx_desc_valid = 0;
reg [3:0]  slot_addr_wr_no = 0;
reg [6:0]  slot_addr_wr_data = 0;
reg        slot_addr_wr_valid = 0;

// Outputs
wire [DATA_WIDTH-1:0] xgmii_txd;
wire [CTRL_WIDTH-1:0] xgmii_txc;
wire                  inject_rx_desc_ready;

// Internal wire

initial begin
    // myhdl integration
    $from_myhdl(
        clk,
        rst,
        current_test,
        rx_clk,
        rx_rst,
        tx_clk,
        tx_rst,
        xgmii_rxd,
        xgmii_rxc,

        inject_rx_desc,
        inject_rx_desc_valid,
        slot_addr_wr_no,
        slot_addr_wr_data,
        slot_addr_wr_valid
    );
    $to_myhdl(
        xgmii_txd,
        xgmii_txc,
        inject_rx_desc_ready
    );

    // dump file
    $dumpfile("test_dma_full.lxt");
    $dumpvars(0, test_dma_full);
end

full_riscv_sys sys (
  .rx_clk(rx_clk),
  .rx_rst(rx_rst),
  .tx_clk(tx_clk),
  .tx_rst(tx_rst),
  .logic_clk(clk),
  .logic_rst(rst),

  .xgmii_rxd(xgmii_rxd),
  .xgmii_rxc(xgmii_rxc),
  .ifg_delay(8'd12),

  // Outputs
  .xgmii_txd(xgmii_txd),
  .xgmii_txc(xgmii_txc),

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
  .rx_fifo_good_frame(),

  .inject_rx_desc(inject_rx_desc),
  .inject_rx_desc_valid(inject_rx_desc_valid),
  .inject_rx_desc_ready(inject_rx_desc_ready),
  
  .slot_addr_wr_no(slot_addr_wr_no),
  .slot_addr_wr_data(slot_addr_wr_data),
  .slot_addr_wr_valid(slot_addr_wr_valid)
);

endmodule

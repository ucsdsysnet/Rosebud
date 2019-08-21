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
module test_fpga_core;

// Parameters
parameter DATA_WIDTH = 64;
parameter CTRL_WIDTH = (DATA_WIDTH/8);

// Inputs
reg sys_clk = 0;
reg sys_rst = 0;
reg core_clk = 0;
reg core_rst = 0;

reg rx_clk_0 = 0;
reg rx_rst_0 = 0;
reg tx_clk_0 = 0;
reg tx_rst_0 = 0;
reg [DATA_WIDTH-1:0] xgmii_rxd_0 = 0;
reg [CTRL_WIDTH-1:0] xgmii_rxc_0 = 0;

reg rx_clk_1 = 0;
reg rx_rst_1 = 0;
reg tx_clk_1 = 0;
reg tx_rst_1 = 0;
reg [DATA_WIDTH-1:0] xgmii_rxd_1 = 0;
reg [CTRL_WIDTH-1:0] xgmii_rxc_1 = 0;

// Outputs
wire [DATA_WIDTH-1:0] xgmii_txd_0;
wire [CTRL_WIDTH-1:0] xgmii_txc_0;

wire [DATA_WIDTH-1:0] xgmii_txd_1;
wire [CTRL_WIDTH-1:0] xgmii_txc_1;

// Internal wire

initial begin
    // myhdl integration
    $from_myhdl(
        sys_clk,
        sys_rst,
        core_clk,
        core_rst,
        rx_clk_0,
        rx_rst_0,
        tx_clk_0,
        tx_rst_0,
        rx_clk_1,
        rx_rst_1,
        tx_clk_1,
        tx_rst_1,
        xgmii_rxd_0,
        xgmii_rxc_0,
        xgmii_rxd_1,
        xgmii_rxc_1
    );
    $to_myhdl(
        xgmii_txd_0,
        xgmii_txc_0,
        xgmii_txd_1,
        xgmii_txc_1
    );

    // dump file
    $dumpfile("test_fpga_core.lxt");
    $dumpvars(0, test_fpga_core);
end


fpga_core UUT(
    .sys_clk(sys_clk),
    .sys_rst(sys_rst),
    .core_clk_i(core_clk),
    .core_rst_i(core_rst),

    .sfp_1_led(),
    .sfp_2_led(),
    .sma_led(),

    .sfp_1_tx_clk(tx_clk_0),
    .sfp_1_tx_rst(tx_rst_0),
    .sfp_1_txd(xgmii_txd_0),
    .sfp_1_txc(xgmii_txc_0),
    .sfp_1_rx_clk(rx_clk_0),
    .sfp_1_rx_rst(rx_rst_0),
    .sfp_1_rxd(xgmii_rxd_0),
    .sfp_1_rxc(xgmii_rxc_0),

    .sfp_2_tx_clk(tx_clk_1),
    .sfp_2_tx_rst(tx_rst_1),
    .sfp_2_txd(xgmii_txd_1),
    .sfp_2_txc(xgmii_txc_1),
    .sfp_2_rx_clk(rx_clk_1),
    .sfp_2_rx_rst(rx_rst_1),
    .sfp_2_rxd(xgmii_rxd_1),
    .sfp_2_rxc(xgmii_rxc_1)
);

endmodule

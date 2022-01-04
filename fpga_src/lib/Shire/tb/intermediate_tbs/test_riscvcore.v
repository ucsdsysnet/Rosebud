/*

Copyright (c) 2019 Moein Khazraee

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

/*
 * Testbench for riscv_core
 */
module test_riscvcore;

// Parameters

// Inputs
reg clk = 0;
reg core_reset = 0;
reg [7:0] current_test = 0;

// Data memory DMA port
reg         data_dma_en= 1'b0;
reg         data_dma_ren= 1'b0;
reg  [7:0]  data_dma_wen = 8'd0;
reg  [15:0] data_dma_addr = 0;
reg  [63:0] data_dma_wr_data = 0;
wire [63:0] data_dma_rd_data;

// Instrucion memory DMA port
reg  [7:0]  ins_dma_wen = 8'd0;
reg  [15:0] ins_dma_addr = 13'd0;
reg  [63:0] ins_dma_data = 0;

wire stat_update;
reg  [15:0] stat_rd_addr = 1'b0;
wire [31:0] stat_rd_data;
reg  stat_rd_en;


initial begin
    // myhdl integration
    $from_myhdl(
        clk,
        core_reset,
        current_test,
        data_dma_en,
        data_dma_ren,
        data_dma_wen,
        data_dma_addr,
        data_dma_wr_data,
        ins_dma_wen,
        ins_dma_addr,
        ins_dma_data,
        stat_rd_en,
        stat_rd_addr
    );
    $to_myhdl(
        data_dma_rd_data,
        stat_update,
        stat_rd_data
    );

    // dump file
    $dumpfile("test_riscvcore.lxt");
    $dumpvars(0, test_riscvcore);
end

riscvcore #(
  .DATA_WIDTH     (64),
  .ADDR_WIDTH     (16),
  .IMEM_SIZE_BYTES(8192),
  .DMEM_SIZE_BYTES(32768),
  .STAT_ADDR_WIDTH(1)
) UUT (
    .clk(clk),
    .core_reset(core_reset),

    .data_dma_en(data_dma_en),
    .data_dma_ren(data_dma_ren),
    .data_dma_wen(data_dma_wen),
    .data_dma_addr(data_dma_addr),
    .data_dma_wr_data(data_dma_wr_data),
    .data_dma_rd_data(data_dma_rd_data),

    .ins_dma_wen(ins_dma_wen),
    .ins_dma_addr(ins_dma_addr),
    .ins_dma_wr_data(ins_dma_data),

    .stat_rd_en(stat_rd_en),
    .stat_rd_addr(stat_rd_addr),
    .stat_rd_data(stat_rd_data),

    .status_update(stat_update)
);

endmodule

`resetall

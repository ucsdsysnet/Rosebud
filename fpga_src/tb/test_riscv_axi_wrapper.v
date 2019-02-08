/*

Copyright (c) 2018 Alex Forencich

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
 * Testbench for axi_ram
 */
module test_riscv_axi_wrapper;

// Parameters
parameter DATA_WIDTH      = 64;
parameter ADDR_WIDTH      = 16;
parameter ID_WIDTH        = 8;
parameter PIPELINE_OUTPUT = 0;
parameter IMEM_SIZE_BYTES = 8192;
parameter DMEM_SIZE_BYTES = 32768;
parameter STAT_ADDR_WIDTH = 1;
parameter STRB_WIDTH      = (DATA_WIDTH/8);
parameter INTERLEAVE      = 0;

// Inputs
reg clk = 0;
reg rst = 0;


reg [ID_WIDTH-1:0] s_axi_awid = 0;
reg [ADDR_WIDTH-1:0] s_axi_awaddr = 0;
reg [7:0] s_axi_awlen = 0;
reg [2:0] s_axi_awsize = 0;
reg [1:0] s_axi_awburst = 0;
reg s_axi_awlock = 0;
reg [3:0] s_axi_awcache = 0;
reg [2:0] s_axi_awprot = 0;
reg s_axi_awvalid = 0;
reg [DATA_WIDTH-1:0] s_axi_wdata = 0;
reg [STRB_WIDTH-1:0] s_axi_wstrb = 0;
reg s_axi_wlast = 0;
reg s_axi_wvalid = 0;
reg s_axi_bready = 0;
reg [ID_WIDTH-1:0] s_axi_arid = 0;
reg [ADDR_WIDTH-1:0] s_axi_araddr = 0;
reg [7:0] s_axi_arlen = 0;
reg [2:0] s_axi_arsize = 0;
reg [1:0] s_axi_arburst = 0;
reg s_axi_arlock = 0;
reg [3:0] s_axi_arcache = 0;
reg [2:0] s_axi_arprot = 0;
reg s_axi_arvalid = 0;
reg s_axi_rready = 0;

// Outputs
wire s_axi_awready;
wire s_axi_wready;
wire [ID_WIDTH-1:0] s_axi_bid;
wire [1:0] s_axi_bresp;
wire s_axi_bvalid;
wire s_axi_arready;
wire [ID_WIDTH-1:0] s_axi_rid;
wire [DATA_WIDTH-1:0] s_axi_rdata;
wire [1:0] s_axi_rresp;
wire s_axi_rlast;
wire s_axi_rvalid;

wire status_update;

initial begin
    // myhdl integration
    $from_myhdl(
        clk,
        rst,
        s_axi_awid,
        s_axi_awaddr,
        s_axi_awlen,
        s_axi_awsize,
        s_axi_awburst,
        s_axi_awlock,
        s_axi_awcache,
        s_axi_awprot,
        s_axi_awvalid,
        s_axi_wdata,
        s_axi_wstrb,
        s_axi_wlast,
        s_axi_wvalid,
        s_axi_bready,
        s_axi_arid,
        s_axi_araddr,
        s_axi_arlen,
        s_axi_arsize,
        s_axi_arburst,
        s_axi_arlock,
        s_axi_arcache,
        s_axi_arprot,
        s_axi_arvalid,
        s_axi_rready
    );
    $to_myhdl(
        s_axi_awready,
        s_axi_wready,
        s_axi_bid,
        s_axi_bresp,
        s_axi_bvalid,
        s_axi_arready,
        s_axi_rid,
        s_axi_rdata,
        s_axi_rresp,
        s_axi_rlast,
        s_axi_rvalid,
        status_update
    );

    // dump file
    $dumpfile("test_riscv_axi_wrapper.lxt");
    $dumpvars(0, test_riscv_axi_wrapper);
end

riscv_axi_wrapper #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .ID_WIDTH(ID_WIDTH),
    .PIPELINE_OUTPUT(PIPELINE_OUTPUT),
    .IMEM_SIZE_BYTES(IMEM_SIZE_BYTES),
    .DMEM_SIZE_BYTES(DMEM_SIZE_BYTES),
    .STAT_ADDR_WIDTH(STAT_ADDR_WIDTH),
    .INTERLEAVE(INTERLEAVE)
)
UUT (
    .clk(clk),
    .rst(rst),
    .s_axi_awid(s_axi_awid),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awlen(s_axi_awlen),
    .s_axi_awsize(s_axi_awsize),
    .s_axi_awburst(s_axi_awburst),
    .s_axi_awlock(s_axi_awlock),
    .s_axi_awcache(s_axi_awcache),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wlast(s_axi_wlast),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bid(s_axi_bid),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    .s_axi_arid(s_axi_arid),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arlen(s_axi_arlen),
    .s_axi_arsize(s_axi_arsize),
    .s_axi_arburst(s_axi_arburst),
    .s_axi_arlock(s_axi_arlock),
    .s_axi_arcache(s_axi_arcache),
    .s_axi_arprot(s_axi_arprot),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_rid(s_axi_rid),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rlast(s_axi_rlast),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),
    .status_update(status_update)
);

integer i,j;

initial begin
    // two nested loops for smaller number of iterations per loop
    // workaround for synthesizer complaints about large loop counts
    for (i = 0; i < 2**(ADDR_WIDTH-1); i = i + 2**((ADDR_WIDTH-1)/2)) begin
        for (j = i; j < i + 2**((ADDR_WIDTH-1)/2); j = j + 1) begin
            UUT.core.dmem.mem[j] = 0;
        end
    end
end


endmodule

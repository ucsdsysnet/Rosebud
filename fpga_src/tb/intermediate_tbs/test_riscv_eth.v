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
 * Testbench for axi_dma
 */
module test_riscv_eth;

// Parameters
parameter DATA_WIDTH = 64;
parameter CTRL_WIDTH = (DATA_WIDTH/8);
parameter AXI_DATA_WIDTH = 64;
parameter AXI_ADDR_WIDTH = 16;
parameter AXI_STRB_WIDTH = (AXI_DATA_WIDTH/8);
parameter AXI_ID_WIDTH = 8;
parameter AXI_MAX_BURST_LEN = 16;
parameter AXIS_DATA_WIDTH = AXI_DATA_WIDTH;
parameter AXIS_KEEP_ENABLE = (AXIS_DATA_WIDTH>8);
parameter AXIS_KEEP_WIDTH = (AXIS_DATA_WIDTH/8);
parameter AXIS_LAST_ENABLE = 1;
parameter AXIS_ID_ENABLE = 1;
parameter AXIS_ID_WIDTH = 8;
parameter AXIS_DEST_ENABLE = 0;
parameter AXIS_DEST_WIDTH = 8;
parameter AXIS_USER_ENABLE = 1;
parameter AXIS_USER_WIDTH = 1;
parameter LEN_WIDTH = 20;
parameter TAG_WIDTH = 8;
parameter ENABLE_SG = 0;
parameter ENABLE_UNALIGNED = 1;
parameter IMEM_SIZE_BYTES = 8192;
parameter DMEM_SIZE_BYTES = 32768;
parameter INTERLEAVE      = 1;
parameter PIPELINE_OUTPUT = 0;
parameter STAT_ADDR_WIDTH = 1;
parameter ENABLE_PADDING = 1;
parameter ENABLE_DIC = 1;
parameter MIN_FRAME_LENGTH = 64;
parameter TX_FRAME_FIFO = 1;
parameter TX_DROP_WHEN_FULL = 0;
parameter RX_FRAME_FIFO = 1;

// Inputs
reg  rx_clk = 0;
reg  rx_rst = 0;
reg  tx_clk = 0;
reg  tx_rst = 0;
reg  logic_clk = 0;
reg  logic_rst = 0;
reg  [7:0] current_test = 0;

reg  [AXI_ADDR_WIDTH-1:0] s_axis_tx_desc_addr = 0;
reg  [LEN_WIDTH-1:0] s_axis_tx_desc_len = 0;
reg  [TAG_WIDTH-1:0] s_axis_tx_desc_tag = 0;
reg  [AXIS_USER_WIDTH-1:0] s_axis_tx_desc_user = 0;
reg  s_axis_tx_desc_valid = 0;
reg  [AXI_ADDR_WIDTH-1:0] s_axis_rx_desc_addr = 0;
reg  [LEN_WIDTH-1:0] s_axis_rx_desc_len = 0;
reg  [TAG_WIDTH-1:0] s_axis_rx_desc_tag = 0;
reg  s_axis_rx_desc_valid = 0;
wire m_axi_awready;
wire m_axi_wready;
wire [AXI_ID_WIDTH-1:0] m_axi_bid;
wire [1:0] m_axi_bresp;
wire m_axi_bvalid;
wire m_axi_arready;
wire [AXI_ID_WIDTH-1:0] m_axi_rid;
wire [AXI_DATA_WIDTH-1:0] m_axi_rdata;
wire [1:0] m_axi_rresp;
wire m_axi_rlast;
wire m_axi_rvalid;
reg  tx_enable = 0;
reg  rx_enable = 0;
reg  rx_abort = 0;
reg [DATA_WIDTH-1:0] xgmii_rxd = 0;
reg [CTRL_WIDTH-1:0] xgmii_rxc = 0;
reg [7:0] ifg_delay = 0;

// Outputs
wire s_axis_tx_desc_ready;
wire [TAG_WIDTH-1:0] m_axis_tx_desc_status_tag;
wire m_axis_tx_desc_status_valid;
wire s_axis_rx_desc_ready;
wire [LEN_WIDTH-1:0] m_axis_rx_desc_status_len;
wire [TAG_WIDTH-1:0] m_axis_rx_desc_status_tag;
wire [AXIS_USER_WIDTH-1:0] m_axis_rx_desc_status_user;
wire m_axis_rx_desc_status_valid;
wire [AXI_ID_WIDTH-1:0] m_axi_awid;
wire [AXI_ADDR_WIDTH-1:0] m_axi_awaddr;
wire [7:0] m_axi_awlen;
wire [2:0] m_axi_awsize;
wire [1:0] m_axi_awburst;
wire m_axi_awlock;
wire [3:0] m_axi_awcache;
wire [2:0] m_axi_awprot;
wire m_axi_awvalid;
wire [AXI_DATA_WIDTH-1:0] m_axi_wdata;
wire [AXI_STRB_WIDTH-1:0] m_axi_wstrb;
wire m_axi_wlast;
wire m_axi_wvalid;
wire m_axi_bready;
wire [AXI_ID_WIDTH-1:0] m_axi_arid;
wire [AXI_ADDR_WIDTH-1:0] m_axi_araddr;
wire [7:0] m_axi_arlen;
wire [2:0] m_axi_arsize;
wire [1:0] m_axi_arburst;
wire m_axi_arlock;
wire [3:0] m_axi_arcache;
wire [2:0] m_axi_arprot;
wire m_axi_arvalid;
wire m_axi_rready;
wire [DATA_WIDTH-1:0] xgmii_txd;
wire [CTRL_WIDTH-1:0] xgmii_txc;

wire status_update;
initial begin
    // myhdl integration
    $from_myhdl(
        logic_clk,
        logic_rst,
        rx_clk,
        rx_rst,
        tx_clk,
        tx_rst,
        current_test,

        s_axis_tx_desc_addr,
        s_axis_tx_desc_len,
        s_axis_tx_desc_tag,
        s_axis_tx_desc_user,
        s_axis_tx_desc_valid,
        s_axis_rx_desc_addr,
        s_axis_rx_desc_len,
        s_axis_rx_desc_tag,
        s_axis_rx_desc_valid,
        
        xgmii_rxd,
        xgmii_rxc,
        ifg_delay,

        tx_enable,
        rx_enable,
        rx_abort
    );
    $to_myhdl(
        s_axis_tx_desc_ready,
        m_axis_tx_desc_status_tag,
        m_axis_tx_desc_status_valid,
        s_axis_rx_desc_ready,
        m_axis_rx_desc_status_len,
        m_axis_rx_desc_status_tag,
        m_axis_rx_desc_status_user,
        m_axis_rx_desc_status_valid,
        
        xgmii_txd,
        xgmii_txc,
        rx_error_bad_frame,
        rx_error_bad_fcs,
        tx_fifo_overflow,
        tx_fifo_bad_frame,
        tx_fifo_good_frame,
        rx_fifo_overflow,
        rx_fifo_bad_frame,
        rx_fifo_good_frame,

        status_update
    );

    // dump file
    $dumpfile("test_riscv_eth.lxt");
    $dumpvars(0, test_riscv_eth);
end

eth_interface #(
    .DATA_WIDTH(DATA_WIDTH),
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .AXI_ID_WIDTH(AXI_ID_WIDTH),
    .AXI_MAX_BURST_LEN(AXI_MAX_BURST_LEN),
    .LEN_WIDTH(LEN_WIDTH),
    .TAG_WIDTH(TAG_WIDTH),
    .ENABLE_SG(ENABLE_SG),
    .ENABLE_UNALIGNED(ENABLE_UNALIGNED),
    .ENABLE_PADDING(ENABLE_PADDING),
    .ENABLE_DIC(ENABLE_DIC),
    .MIN_FRAME_LENGTH(MIN_FRAME_LENGTH),
    .TX_FRAME_FIFO(TX_FRAME_FIFO),
    .TX_DROP_WHEN_FULL(TX_DROP_WHEN_FULL),
    .RX_FRAME_FIFO(RX_FRAME_FIFO)  
)
UUT (
    .logic_clk(logic_clk),
    .logic_rst(logic_rst),
    .rx_clk(rx_clk),
    .rx_rst(rx_rst),
    .tx_clk(tx_clk),
    .tx_rst(tx_rst),

    .s_axis_tx_desc_addr(s_axis_tx_desc_addr),
    .s_axis_tx_desc_len(s_axis_tx_desc_len),
    .s_axis_tx_desc_tag(s_axis_tx_desc_tag),
    .s_axis_tx_desc_user(s_axis_tx_desc_user),
    .s_axis_tx_desc_valid(s_axis_tx_desc_valid),
    .s_axis_tx_desc_ready(s_axis_tx_desc_ready),

    .m_axis_tx_desc_status_tag(m_axis_tx_desc_status_tag),
    .m_axis_tx_desc_status_valid(m_axis_tx_desc_status_valid),

    .s_axis_rx_desc_addr(s_axis_rx_desc_addr),
    .s_axis_rx_desc_len(s_axis_rx_desc_len),
    .s_axis_rx_desc_tag(s_axis_rx_desc_tag),
    .s_axis_rx_desc_valid(s_axis_rx_desc_valid),
    .s_axis_rx_desc_ready(s_axis_rx_desc_ready),

    .m_axis_rx_desc_status_len(m_axis_rx_desc_status_len),
    .m_axis_rx_desc_status_tag(m_axis_rx_desc_status_tag),
    .m_axis_rx_desc_status_user(m_axis_rx_desc_status_user),
    .m_axis_rx_desc_status_valid(m_axis_rx_desc_status_valid),

    .m_axi_awid(m_axi_awid),
    .m_axi_awaddr(m_axi_awaddr),
    .m_axi_awlen(m_axi_awlen),
    .m_axi_awsize(m_axi_awsize),
    .m_axi_awburst(m_axi_awburst),
    .m_axi_awlock(m_axi_awlock),
    .m_axi_awcache(m_axi_awcache),
    .m_axi_awprot(m_axi_awprot),
    .m_axi_awvalid(m_axi_awvalid),
    .m_axi_awready(m_axi_awready),
    .m_axi_wdata(m_axi_wdata),
    .m_axi_wstrb(m_axi_wstrb),
    .m_axi_wlast(m_axi_wlast),
    .m_axi_wvalid(m_axi_wvalid),
    .m_axi_wready(m_axi_wready),
    .m_axi_bid(m_axi_bid),
    .m_axi_bresp(m_axi_bresp),
    .m_axi_bvalid(m_axi_bvalid),
    .m_axi_bready(m_axi_bready),
    .m_axi_arid(m_axi_arid),
    .m_axi_araddr(m_axi_araddr),
    .m_axi_arlen(m_axi_arlen),
    .m_axi_arsize(m_axi_arsize),
    .m_axi_arburst(m_axi_arburst),
    .m_axi_arlock(m_axi_arlock),
    .m_axi_arcache(m_axi_arcache),
    .m_axi_arprot(m_axi_arprot),
    .m_axi_arvalid(m_axi_arvalid),
    .m_axi_arready(m_axi_arready),
    .m_axi_rid(m_axi_rid),
    .m_axi_rdata(m_axi_rdata),
    .m_axi_rresp(m_axi_rresp),
    .m_axi_rlast(m_axi_rlast),
    .m_axi_rvalid(m_axi_rvalid),
    .m_axi_rready(m_axi_rready),

    .xgmii_rxd(xgmii_rxd),
    .xgmii_rxc(xgmii_rxc),
    .xgmii_txd(xgmii_txd),
    .xgmii_txc(xgmii_txc),
    
    .rx_error_bad_frame(rx_error_bad_frame),
    .rx_error_bad_fcs(rx_error_bad_fcs),
    
    .tx_fifo_overflow(tx_fifo_overflow),
    .tx_fifo_bad_frame(tx_fifo_bad_frame),
    .tx_fifo_good_frame(tx_fifo_good_frame),
    
    .rx_fifo_overflow(rx_fifo_overflow),
    .rx_fifo_bad_frame(rx_fifo_bad_frame),
    .rx_fifo_good_frame(rx_fifo_good_frame),

    .tx_enable(tx_enable),
    .rx_enable(rx_enable),
    .rx_abort(rx_abort),
    .ifg_delay(ifg_delay)
);

riscv_axi_wrapper #(
    .DATA_WIDTH(AXI_DATA_WIDTH),
    .ADDR_WIDTH(AXI_ADDR_WIDTH),
    .ID_WIDTH(AXI_ID_WIDTH),
    .PIPELINE_OUTPUT(PIPELINE_OUTPUT),
    .IMEM_SIZE_BYTES(IMEM_SIZE_BYTES),
    .DMEM_SIZE_BYTES(DMEM_SIZE_BYTES),
    .STAT_ADDR_WIDTH(STAT_ADDR_WIDTH),
    .INTERLEAVE(INTERLEAVE)
)
RISCV (
    .clk(logic_clk),
    .rst(logic_rst),
    .s_axi_awid(m_axi_awid),
    .s_axi_awaddr(m_axi_awaddr),
    .s_axi_awlen(m_axi_awlen),
    .s_axi_awsize(m_axi_awsize),
    .s_axi_awburst(m_axi_awburst),
    .s_axi_awlock(m_axi_awlock),
    .s_axi_awcache(m_axi_awcache),
    .s_axi_awprot(m_axi_awprot),
    .s_axi_awvalid(m_axi_awvalid),
    .s_axi_awready(m_axi_awready),
    .s_axi_wdata(m_axi_wdata),
    .s_axi_wstrb(m_axi_wstrb),
    .s_axi_wlast(m_axi_wlast),
    .s_axi_wvalid(m_axi_wvalid),
    .s_axi_wready(m_axi_wready),
    .s_axi_bid(m_axi_bid),
    .s_axi_bresp(m_axi_bresp),
    .s_axi_bvalid(m_axi_bvalid),
    .s_axi_bready(m_axi_bready),
    .s_axi_arid(m_axi_arid),
    .s_axi_araddr(m_axi_araddr),
    .s_axi_arlen(m_axi_arlen),
    .s_axi_arsize(m_axi_arsize),
    .s_axi_arburst(m_axi_arburst),
    .s_axi_arlock(m_axi_arlock),
    .s_axi_arcache(m_axi_arcache),
    .s_axi_arprot(m_axi_arprot),
    .s_axi_arvalid(m_axi_arvalid),
    .s_axi_arready(m_axi_arready),
    .s_axi_rid(m_axi_rid),
    .s_axi_rdata(m_axi_rdata),
    .s_axi_rresp(m_axi_rresp),
    .s_axi_rlast(m_axi_rlast),
    .s_axi_rvalid(m_axi_rvalid),
    .s_axi_rready(m_axi_rready),

    .status_update(status_update)
);


integer i,j;

initial begin
    // two nested loops for smaller number of iterations per loop
    // workaround for synthesizer complaints about large loop counts
    for (i = 0; i < 2**(AXI_ADDR_WIDTH-1); i = i + 2**((AXI_ADDR_WIDTH-1)/2)) begin
        for (j = i; j < i + 2**((AXI_ADDR_WIDTH-1)/2); j = j + 1) begin
            RISCV.core.dmem.mem[j] = 0;
        end
    end
end

// For now before adding second DMA master for instructions
initial begin
    $readmemh("../../c_code/test.hex", RISCV.core.imem.mem);
end 
  
endmodule

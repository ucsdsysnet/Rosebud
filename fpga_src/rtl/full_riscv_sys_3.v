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
module full_riscv_sys # (
  // riscv core parameters
  parameter CORE_ADDR_WIDTH = 16,
  parameter IMEM_SIZE_BYTES = 8192,
  parameter DMEM_SIZE_BYTES = 32768,
  parameter STAT_ADDR_WIDTH = 1,
  parameter SLOT_COUNT      = 8,
  parameter INTERLEAVE      = 1,
  parameter PIPELINE_OUTPUT = 1,
  // interconnect parameters
  parameter S_COUNT         = 4,
  parameter M_COUNT         = 16,
  parameter M_REGIONS       = 1,
  // parameter M_BASE_ADDR     = {21'h1f0000, 21'h1e0000, 21'h1d0000, 21'h1c0000,
  //                              21'h1b0000, 21'h1a0000, 21'h190000, 21'h180000,
  //                              21'h170000, 21'h160000, 21'h150000, 21'h140000,
  //                              21'h130000, 21'h120000, 21'h110000, 21'h100000,
  //                              21'h0f0000, 21'h0e0000, 21'h0d0000, 21'h0c0000,
  //                              21'h0b0000, 21'h0a0000, 21'h090000, 21'h080000,
  //                              21'h070000, 21'h060000, 21'h050000, 21'h040000,
  //                              21'h030000, 21'h020000, 21'h010000, 21'h000000},
  parameter M_BASE_ADDR     = {20'hf0000, 20'he0000, 20'hd0000, 20'hc0000,
                               20'hb0000, 20'ha0000, 20'h90000, 20'h80000,
                               20'h70000, 20'h60000, 20'h50000, 20'h40000,
                               20'h30000, 20'h20000, 20'h10000, 20'h00000},
  // parameter M_BASE_ADDR     = {19'h70000, 19'h60000, 19'h50000, 19'h40000,
  //                              19'h30000, 19'h20000, 19'h10000, 19'h00000},
  parameter M_ADDR_WIDTH    = {M_COUNT{{M_REGIONS{CORE_ADDR_WIDTH}}}},
  // AXI DMA paramaters
  parameter AXI_DATA_WIDTH    = 64,
  parameter AXI_ADDR_WIDTH    = CORE_ADDR_WIDTH+$clog2(M_COUNT),
  parameter AXI_STRB_WIDTH    = (AXI_DATA_WIDTH/8),
  parameter AXI_ID_WIDTH      = 2, //10, //8,
  parameter AXI_CORE_ID_WIDTH = 2,// 10, // AXI_ID_WIDTH+$clog2(S_COUNT),
  parameter AXI_MAX_BURST_LEN = 16, //8,
  parameter DESC_WIDTH        = $clog2(M_COUNT)+$clog2(SLOT_COUNT),
  parameter SLOT_LEAD_ZERO    = 8,
  parameter RX_WRITE_OFFSET   = 8'h08, // A,
  // eth interface parameters 
  parameter DATA_WIDTH        = 64,
  parameter CTRL_WIDTH        = (DATA_WIDTH/8),
  parameter AXIS_USER_WIDTH   = 1,
  parameter LEN_WIDTH         = 16,
  parameter TAG_WIDTH         = 8,
  parameter ENABLE_UNALIGNED  = 1,
  parameter ENABLE_PADDING    = 1,
  parameter MIN_FRAME_LENGTH  = 64,
  parameter TX_DROP_WHEN_FULL = 0,
  // Aribter parameters
  parameter CORE_FIFO_ADDR_SIZE   = 3,
  // temp PCI-e parameters. 
  // There are additional 8 leading zeros for these values
  parameter SLOT_ADDR_EFF = CORE_ADDR_WIDTH-1-SLOT_LEAD_ZERO,
  parameter FIRST_SLOT_ADDR = 7'h40,
  parameter SLOT_ADDR_STEP  = 7'h08,
  // AXI masters FIFO parameters
  parameter AXI_WRITE_FIFO_DEPTH = 32,
  parameter AXI_READ_FIFO_DEPTH  = 32
)(
  // Inputs
  input [2-1:0] rx_clk,
  input [2-1:0] rx_rst,
  input [2-1:0] tx_clk,
  input [2-1:0] tx_rst,
  input logic_clk,
  input logic_rst,

  input[2*DATA_WIDTH-1:0] xgmii_rxd,
  input[2*CTRL_WIDTH-1:0] xgmii_rxc,

  // Outputs
  output [2*DATA_WIDTH-1:0] xgmii_txd,
  output [2*CTRL_WIDTH-1:0] xgmii_txc

);

`define FIFOED_MASTERS
parameter ETH0_LOC = 0;
parameter ETH1_LOC = 1;
parameter CTRL_LOC = 2;
parameter PCI_LOC  = 3;

// eth conncections
wire[7:0] ifg_delay = 8'd12;

wire [2*TAG_WIDTH-1:0] m_axis_tx_desc_status_tag;
wire [2-1:0] m_axis_tx_desc_status_valid;
wire [2*LEN_WIDTH-1:0] m_axis_rx_desc_status_len;
wire [2*TAG_WIDTH-1:0] m_axis_rx_desc_status_tag;
wire [2*AXIS_USER_WIDTH-1:0] m_axis_rx_desc_status_user;
wire [2-1:0]m_axis_rx_desc_status_valid;

wire [2-1:0] rx_error_bad_frame;
wire [2-1:0] rx_error_bad_fcs;
wire [2-1:0] tx_fifo_overflow;
wire [2-1:0] tx_fifo_bad_frame;
wire [2-1:0] tx_fifo_good_frame;
wire [2-1:0] rx_fifo_overflow;
wire [2-1:0] rx_fifo_bad_frame;
wire [2-1:0] rx_fifo_good_frame;

wire [2*AXI_ADDR_WIDTH-1:0] s_axis_tx_desc_addr;
wire [2*LEN_WIDTH-1:0] s_axis_tx_desc_len;
wire [2*TAG_WIDTH-1:0] s_axis_tx_desc_tag;
wire [2*AXIS_USER_WIDTH-1:0] s_axis_tx_desc_user;
wire [2-1:0] s_axis_tx_desc_valid;
wire [2-1:0] s_axis_tx_desc_ready;

wire [2*AXI_ADDR_WIDTH-1:0] s_axis_rx_desc_addr;
wire [2*LEN_WIDTH-1:0] s_axis_rx_desc_len;
wire [2*TAG_WIDTH-1:0] s_axis_rx_desc_tag;
wire [2-1:0] s_axis_rx_desc_valid;
wire [2-1:0] s_axis_rx_desc_ready;

wire [2-1:0] tx_enable; 
wire [2-1:0] rx_enable;
wire [2-1:0] rx_abort;

// Internal wires
wire [S_COUNT*AXI_ID_WIDTH-1:0] m_axi_awid;
wire [S_COUNT*AXI_ADDR_WIDTH-1:0] m_axi_awaddr;
wire [S_COUNT*8-1:0] m_axi_awlen;
wire [S_COUNT*3-1:0] m_axi_awsize;
wire [S_COUNT*2-1:0] m_axi_awburst;
wire [S_COUNT-1:0] m_axi_awlock;
wire [S_COUNT*4-1:0] m_axi_awcache;
wire [S_COUNT*3-1:0] m_axi_awprot;
wire [S_COUNT-1:0] m_axi_awvalid;
wire [S_COUNT*AXI_DATA_WIDTH-1:0] m_axi_wdata;
wire [S_COUNT*AXI_STRB_WIDTH-1:0] m_axi_wstrb;
wire [S_COUNT-1:0] m_axi_wlast;
wire [S_COUNT-1:0] m_axi_wvalid;
wire [S_COUNT-1:0] m_axi_bready;
wire [S_COUNT*AXI_ID_WIDTH-1:0] m_axi_arid;
wire [S_COUNT*AXI_ADDR_WIDTH-1:0] m_axi_araddr;
wire [S_COUNT*8-1:0] m_axi_arlen;
wire [S_COUNT*3-1:0] m_axi_arsize;
wire [S_COUNT*2-1:0] m_axi_arburst;
wire [S_COUNT-1:0] m_axi_arlock;
wire [S_COUNT*4-1:0] m_axi_arcache;
wire [S_COUNT*3-1:0] m_axi_arprot;
wire [S_COUNT-1:0] m_axi_arvalid;
wire [S_COUNT-1:0] m_axi_rready;
wire [S_COUNT-1:0] m_axi_awready;
wire [S_COUNT-1:0] m_axi_wready;
wire [S_COUNT*AXI_ID_WIDTH-1:0] m_axi_bid;
wire [S_COUNT*2-1:0] m_axi_bresp;
wire [S_COUNT-1:0] m_axi_bvalid;
wire [S_COUNT-1:0] m_axi_arready;
wire [S_COUNT*AXI_ID_WIDTH-1:0] m_axi_rid;
wire [S_COUNT*AXI_DATA_WIDTH-1:0] m_axi_rdata;
wire [S_COUNT*2-1:0] m_axi_rresp;
wire [S_COUNT-1:0] m_axi_rlast;
wire [S_COUNT-1:0] m_axi_rvalid;

wire [S_COUNT*AXI_ID_WIDTH-1:0] fifoed_m_axi_awid;
wire [S_COUNT*AXI_ADDR_WIDTH-1:0] fifoed_m_axi_awaddr;
wire [S_COUNT*8-1:0] fifoed_m_axi_awlen;
wire [S_COUNT*3-1:0] fifoed_m_axi_awsize;
wire [S_COUNT*2-1:0] fifoed_m_axi_awburst;
wire [S_COUNT-1:0] fifoed_m_axi_awlock;
wire [S_COUNT*4-1:0] fifoed_m_axi_awcache;
wire [S_COUNT*3-1:0] fifoed_m_axi_awprot;
wire [S_COUNT-1:0] fifoed_m_axi_awvalid;
wire [S_COUNT*AXI_DATA_WIDTH-1:0] fifoed_m_axi_wdata;
wire [S_COUNT*AXI_STRB_WIDTH-1:0] fifoed_m_axi_wstrb;
wire [S_COUNT-1:0] fifoed_m_axi_wlast;
wire [S_COUNT-1:0] fifoed_m_axi_wvalid;
wire [S_COUNT-1:0] fifoed_m_axi_bready;
wire [S_COUNT*AXI_ID_WIDTH-1:0] fifoed_m_axi_arid;
wire [S_COUNT*AXI_ADDR_WIDTH-1:0] fifoed_m_axi_araddr;
wire [S_COUNT*8-1:0] fifoed_m_axi_arlen;
wire [S_COUNT*3-1:0] fifoed_m_axi_arsize;
wire [S_COUNT*2-1:0] fifoed_m_axi_arburst;
wire [S_COUNT-1:0] fifoed_m_axi_arlock;
wire [S_COUNT*4-1:0] fifoed_m_axi_arcache;
wire [S_COUNT*3-1:0] fifoed_m_axi_arprot;
wire [S_COUNT-1:0] fifoed_m_axi_arvalid;
wire [S_COUNT-1:0] fifoed_m_axi_rready;
wire [S_COUNT-1:0] fifoed_m_axi_awready;
wire [S_COUNT-1:0] fifoed_m_axi_wready;
wire [S_COUNT*AXI_ID_WIDTH-1:0] fifoed_m_axi_bid;
wire [S_COUNT*2-1:0] fifoed_m_axi_bresp;
wire [S_COUNT-1:0] fifoed_m_axi_bvalid;
wire [S_COUNT-1:0] fifoed_m_axi_arready;
wire [S_COUNT*AXI_ID_WIDTH-1:0] fifoed_m_axi_rid;
wire [S_COUNT*AXI_DATA_WIDTH-1:0] fifoed_m_axi_rdata;
wire [S_COUNT*2-1:0] fifoed_m_axi_rresp;
wire [S_COUNT-1:0] fifoed_m_axi_rlast;
wire [S_COUNT-1:0] fifoed_m_axi_rvalid;

wire [M_COUNT*AXI_CORE_ID_WIDTH-1:0] s_axi_awid;
wire [M_COUNT*AXI_ADDR_WIDTH-1:0] s_axi_awaddr;
wire [M_COUNT*8-1:0] s_axi_awlen;
wire [M_COUNT*3-1:0] s_axi_awsize;
wire [M_COUNT*2-1:0] s_axi_awburst;
wire [M_COUNT-1:0] s_axi_awlock;
wire [M_COUNT*4-1:0] s_axi_awcache;
wire [M_COUNT*3-1:0] s_axi_awprot;
wire [M_COUNT-1:0] s_axi_awvalid;
wire [M_COUNT*AXI_DATA_WIDTH-1:0] s_axi_wdata;
wire [M_COUNT*AXI_STRB_WIDTH-1:0] s_axi_wstrb;
wire [M_COUNT-1:0] s_axi_wlast;
wire [M_COUNT-1:0] s_axi_wvalid;
wire [M_COUNT-1:0] s_axi_bready;
wire [M_COUNT*AXI_CORE_ID_WIDTH-1:0] s_axi_arid;
wire [M_COUNT*AXI_ADDR_WIDTH-1:0] s_axi_araddr;
wire [M_COUNT*8-1:0] s_axi_arlen;
wire [M_COUNT*3-1:0] s_axi_arsize;
wire [M_COUNT*2-1:0] s_axi_arburst;
wire [M_COUNT-1:0] s_axi_arlock;
wire [M_COUNT*4-1:0] s_axi_arcache;
wire [M_COUNT*3-1:0] s_axi_arprot;
wire [M_COUNT-1:0] s_axi_arvalid;
wire [M_COUNT-1:0] s_axi_rready;
wire [M_COUNT-1:0] s_axi_awready;
wire [M_COUNT-1:0] s_axi_wready;
wire [M_COUNT*AXI_CORE_ID_WIDTH-1:0] s_axi_bid;
wire [M_COUNT*2-1:0] s_axi_bresp;
wire [M_COUNT-1:0] s_axi_bvalid;
wire [M_COUNT-1:0] s_axi_arready;
wire [M_COUNT*AXI_CORE_ID_WIDTH-1:0] s_axi_rid;
wire [M_COUNT*AXI_DATA_WIDTH-1:0] s_axi_rdata;
wire [M_COUNT*2-1:0] s_axi_rresp;
wire [M_COUNT-1:0] s_axi_rlast;
wire [M_COUNT-1:0] s_axi_rvalid;

wire  [$clog2(SLOT_COUNT)-1:0]                slot_addr_wr_no;
wire  [CORE_ADDR_WIDTH-1-SLOT_LEAD_ZERO-1:0]  slot_addr_wr_data;
wire                                          slot_addr_wr_valid;
  
wire [DESC_WIDTH-1:0]  inject_rx_desc;
wire                   inject_rx_desc_valid;
wire                   inject_rx_desc_ready;


wire [M_COUNT-1:0] core_msg_valid;
wire [64*M_COUNT-1:0] core_msg_data;

wire [63:0] msg_data;
wire        msg_valid;
wire        msg_ready;
wire [$clog2(M_COUNT)-1:0] msg_core_no;

wire tx_enable_out;
wire rx_enable_out;
wire rx_abort_out;

eth_interface #(
    .DATA_WIDTH(DATA_WIDTH),
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .AXI_ID_WIDTH(AXI_ID_WIDTH),
    .AXI_MAX_BURST_LEN(AXI_MAX_BURST_LEN),
    .LEN_WIDTH(LEN_WIDTH),
    .TAG_WIDTH(TAG_WIDTH),
    .ENABLE_UNALIGNED(ENABLE_UNALIGNED),
    .ENABLE_PADDING(ENABLE_PADDING),
    .MIN_FRAME_LENGTH(MIN_FRAME_LENGTH),
    .TX_DROP_WHEN_FULL(TX_DROP_WHEN_FULL)
)
eth_dma_1 (
    .logic_clk(logic_clk),
    .logic_rst(logic_rst),
    .rx_clk(rx_clk[1]),
    .rx_rst(rx_rst[1]),
    .tx_clk(tx_clk[1]),
    .tx_rst(tx_rst[1]),

    .s_axis_tx_desc_addr(s_axis_tx_desc_addr[1*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
    .s_axis_tx_desc_len(s_axis_tx_desc_len[1*LEN_WIDTH +: LEN_WIDTH]),
    .s_axis_tx_desc_tag(s_axis_tx_desc_tag[1*TAG_WIDTH +: TAG_WIDTH]),
    .s_axis_tx_desc_user(s_axis_tx_desc_user[1*AXIS_USER_WIDTH +: AXIS_USER_WIDTH]),
    .s_axis_tx_desc_valid(s_axis_tx_desc_valid[1]),
    .s_axis_tx_desc_ready(s_axis_tx_desc_ready[1]),

    .m_axis_tx_desc_status_tag(m_axis_tx_desc_status_tag[1*TAG_WIDTH +: TAG_WIDTH]),
    .m_axis_tx_desc_status_valid(m_axis_tx_desc_status_valid[1]),

    .s_axis_rx_desc_addr(s_axis_rx_desc_addr[1*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
    .s_axis_rx_desc_len(s_axis_rx_desc_len[1*LEN_WIDTH +: LEN_WIDTH]),
    .s_axis_rx_desc_tag(s_axis_rx_desc_tag[1*TAG_WIDTH +: TAG_WIDTH]),
    .s_axis_rx_desc_valid(s_axis_rx_desc_valid[1]),
    .s_axis_rx_desc_ready(s_axis_rx_desc_ready[1]),

    .m_axis_rx_desc_status_len(m_axis_rx_desc_status_len[1*LEN_WIDTH +: LEN_WIDTH]),
    .m_axis_rx_desc_status_tag(m_axis_rx_desc_status_tag[1*TAG_WIDTH +: TAG_WIDTH]),
    .m_axis_rx_desc_status_user(m_axis_rx_desc_status_user[1*AXIS_USER_WIDTH +: AXIS_USER_WIDTH]),
    .m_axis_rx_desc_status_valid(m_axis_rx_desc_status_valid[1]),

    .m_axi_awid(m_axi_awid[ETH1_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_awaddr(m_axi_awaddr[ETH1_LOC*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
    .m_axi_awlen(m_axi_awlen[ETH1_LOC*8 +: 8]),
    .m_axi_awsize(m_axi_awsize[ETH1_LOC*3 +: 3]),
    .m_axi_awburst(m_axi_awburst[ETH1_LOC*2 +: 2]),
    .m_axi_awlock(m_axi_awlock[ETH1_LOC]),
    .m_axi_awcache(m_axi_awcache[ETH1_LOC*4 +: 4]),
    .m_axi_awprot(m_axi_awprot[ETH1_LOC*3 +: 3]),
    .m_axi_awvalid(m_axi_awvalid[ETH1_LOC]),
    .m_axi_awready(m_axi_awready[ETH1_LOC]),
    .m_axi_wdata(m_axi_wdata[ETH1_LOC*AXI_DATA_WIDTH +: AXI_DATA_WIDTH]),
    .m_axi_wstrb(m_axi_wstrb[ETH1_LOC*AXI_STRB_WIDTH +: AXI_STRB_WIDTH]),
    .m_axi_wlast(m_axi_wlast[ETH1_LOC]),
    .m_axi_wvalid(m_axi_wvalid[ETH1_LOC]),
    .m_axi_wready(m_axi_wready[ETH1_LOC]),
    .m_axi_bid(m_axi_bid[ETH1_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_bresp(m_axi_bresp[ETH1_LOC*2 +: 2]),
    .m_axi_bvalid(m_axi_bvalid[ETH1_LOC]),
    .m_axi_bready(m_axi_bready[ETH1_LOC]),
    .m_axi_arid(m_axi_arid[ETH1_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_araddr(m_axi_araddr[ETH1_LOC*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
    .m_axi_arlen(m_axi_arlen[ETH1_LOC*8 +: 8]),
    .m_axi_arsize(m_axi_arsize[ETH1_LOC*3 +: 3]),
    .m_axi_arburst(m_axi_arburst[ETH1_LOC*2 +: 2]),
    .m_axi_arlock(m_axi_arlock[ETH1_LOC]),
    .m_axi_arcache(m_axi_arcache[ETH1_LOC*4 +: 4]),
    .m_axi_arprot(m_axi_arprot[ETH1_LOC*3 +: 3]),
    .m_axi_arvalid(m_axi_arvalid[ETH1_LOC]),
    .m_axi_arready(m_axi_arready[ETH1_LOC]),
    .m_axi_rid(m_axi_rid[ETH1_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_rdata(m_axi_rdata[ETH1_LOC*AXI_DATA_WIDTH +: AXI_DATA_WIDTH]),
    .m_axi_rresp(m_axi_rresp[ETH1_LOC*2 +: 2]),
    .m_axi_rlast(m_axi_rlast[ETH1_LOC]),
    .m_axi_rvalid(m_axi_rvalid[ETH1_LOC]),
    .m_axi_rready(m_axi_rready[ETH1_LOC]),

    .xgmii_rxd(xgmii_rxd[1*DATA_WIDTH +: DATA_WIDTH]),
    .xgmii_rxc(xgmii_rxc[1*CTRL_WIDTH +: CTRL_WIDTH]),
    .xgmii_txd(xgmii_txd[1*DATA_WIDTH +: DATA_WIDTH]),
    .xgmii_txc(xgmii_txc[1*CTRL_WIDTH +: CTRL_WIDTH]),
    
    .rx_error_bad_frame(rx_error_bad_frame[1]),
    .rx_error_bad_fcs(rx_error_bad_fcs[1]),
    
    .tx_fifo_overflow(tx_fifo_overflow[1]),
    .tx_fifo_bad_frame(tx_fifo_bad_frame[1]),
    .tx_fifo_good_frame(tx_fifo_good_frame[1]),
    
    .rx_fifo_overflow(rx_fifo_overflow[1]),
    .rx_fifo_bad_frame(rx_fifo_bad_frame[1]),
    .rx_fifo_good_frame(rx_fifo_good_frame[1]),

    .tx_enable(tx_enable[1]),
    .rx_enable(rx_enable[1]),
    .rx_abort(rx_abort[1]),

    .ifg_delay(ifg_delay)
);

assign tx_enable = {tx_enable_out, tx_enable_out};
assign rx_enable = {rx_enable_out, rx_enable_out};
assign rx_abort  = {rx_abort_out,  rx_abort_out};

eth_interface #(
    .DATA_WIDTH(DATA_WIDTH),
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .AXI_ID_WIDTH(AXI_ID_WIDTH),
    .AXI_MAX_BURST_LEN(AXI_MAX_BURST_LEN),
    .LEN_WIDTH(LEN_WIDTH),
    .TAG_WIDTH(TAG_WIDTH),
    .ENABLE_UNALIGNED(ENABLE_UNALIGNED),
    .ENABLE_PADDING(ENABLE_PADDING),
    .MIN_FRAME_LENGTH(MIN_FRAME_LENGTH),
    .TX_DROP_WHEN_FULL(TX_DROP_WHEN_FULL)
)
eth_dma_0 (
    .logic_clk(logic_clk),
    .logic_rst(logic_rst),
    .rx_clk(rx_clk[0]),
    .rx_rst(rx_rst[0]),
    .tx_clk(tx_clk[0]),
    .tx_rst(tx_rst[0]),

    .s_axis_tx_desc_addr(s_axis_tx_desc_addr[0*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
    .s_axis_tx_desc_len(s_axis_tx_desc_len[0*LEN_WIDTH +: LEN_WIDTH]),
    .s_axis_tx_desc_tag(s_axis_tx_desc_tag[0*TAG_WIDTH +: TAG_WIDTH]),
    .s_axis_tx_desc_user(s_axis_tx_desc_user[0*AXIS_USER_WIDTH +: AXIS_USER_WIDTH]),
    .s_axis_tx_desc_valid(s_axis_tx_desc_valid[0]),
    .s_axis_tx_desc_ready(s_axis_tx_desc_ready[0]),

    .m_axis_tx_desc_status_tag(m_axis_tx_desc_status_tag[0*TAG_WIDTH +: TAG_WIDTH]),
    .m_axis_tx_desc_status_valid(m_axis_tx_desc_status_valid[0]),

    .s_axis_rx_desc_addr(s_axis_rx_desc_addr[0*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
    .s_axis_rx_desc_len(s_axis_rx_desc_len[0*LEN_WIDTH +: LEN_WIDTH]),
    .s_axis_rx_desc_tag(s_axis_rx_desc_tag[0*TAG_WIDTH +: TAG_WIDTH]),
    .s_axis_rx_desc_valid(s_axis_rx_desc_valid[0]),
    .s_axis_rx_desc_ready(s_axis_rx_desc_ready[0]),

    .m_axis_rx_desc_status_len(m_axis_rx_desc_status_len[0*LEN_WIDTH +: LEN_WIDTH]),
    .m_axis_rx_desc_status_tag(m_axis_rx_desc_status_tag[0*TAG_WIDTH +: TAG_WIDTH]),
    .m_axis_rx_desc_status_user(m_axis_rx_desc_status_user[0*AXIS_USER_WIDTH +: AXIS_USER_WIDTH]),
    .m_axis_rx_desc_status_valid(m_axis_rx_desc_status_valid[0]),

    .m_axi_awid(m_axi_awid[ETH0_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_awaddr(m_axi_awaddr[ETH0_LOC*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
    .m_axi_awlen(m_axi_awlen[ETH0_LOC*8 +: 8]),
    .m_axi_awsize(m_axi_awsize[ETH0_LOC*3 +: 3]),
    .m_axi_awburst(m_axi_awburst[ETH0_LOC*2 +: 2]),
    .m_axi_awlock(m_axi_awlock[ETH0_LOC]),
    .m_axi_awcache(m_axi_awcache[ETH0_LOC*4 +: 4]),
    .m_axi_awprot(m_axi_awprot[ETH0_LOC*3 +: 3]),
    .m_axi_awvalid(m_axi_awvalid[ETH0_LOC]),
    .m_axi_awready(m_axi_awready[ETH0_LOC]),
    .m_axi_wdata(m_axi_wdata[ETH0_LOC*AXI_DATA_WIDTH +: AXI_DATA_WIDTH]),
    .m_axi_wstrb(m_axi_wstrb[ETH0_LOC*AXI_STRB_WIDTH +: AXI_STRB_WIDTH]),
    .m_axi_wlast(m_axi_wlast[ETH0_LOC]),
    .m_axi_wvalid(m_axi_wvalid[ETH0_LOC]),
    .m_axi_wready(m_axi_wready[ETH0_LOC]),
    .m_axi_bid(m_axi_bid[ETH0_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_bresp(m_axi_bresp[ETH0_LOC*2 +: 2]),
    .m_axi_bvalid(m_axi_bvalid[ETH0_LOC]),
    .m_axi_bready(m_axi_bready[ETH0_LOC]),
    .m_axi_arid(m_axi_arid[ETH0_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_araddr(m_axi_araddr[ETH0_LOC*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
    .m_axi_arlen(m_axi_arlen[ETH0_LOC*8 +: 8]),
    .m_axi_arsize(m_axi_arsize[ETH0_LOC*3 +: 3]),
    .m_axi_arburst(m_axi_arburst[ETH0_LOC*2 +: 2]),
    .m_axi_arlock(m_axi_arlock[ETH0_LOC]),
    .m_axi_arcache(m_axi_arcache[ETH0_LOC*4 +: 4]),
    .m_axi_arprot(m_axi_arprot[ETH0_LOC*3 +: 3]),
    .m_axi_arvalid(m_axi_arvalid[ETH0_LOC]),
    .m_axi_arready(m_axi_arready[ETH0_LOC]),
    .m_axi_rid(m_axi_rid[ETH0_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_rdata(m_axi_rdata[ETH0_LOC*AXI_DATA_WIDTH +: AXI_DATA_WIDTH]),
    .m_axi_rresp(m_axi_rresp[ETH0_LOC*2 +: 2]),
    .m_axi_rlast(m_axi_rlast[ETH0_LOC]),
    .m_axi_rvalid(m_axi_rvalid[ETH0_LOC]),
    .m_axi_rready(m_axi_rready[ETH0_LOC]),

    .xgmii_rxd(xgmii_rxd[0*DATA_WIDTH +: DATA_WIDTH]),
    .xgmii_rxc(xgmii_rxc[0*CTRL_WIDTH +: CTRL_WIDTH]),
    .xgmii_txd(xgmii_txd[0*DATA_WIDTH +: DATA_WIDTH]),
    .xgmii_txc(xgmii_txc[0*CTRL_WIDTH +: CTRL_WIDTH]),
    
    .rx_error_bad_frame(rx_error_bad_frame[0]),
    .rx_error_bad_fcs(rx_error_bad_fcs[0]),
    
    .tx_fifo_overflow(tx_fifo_overflow[0]),
    .tx_fifo_bad_frame(tx_fifo_bad_frame[0]),
    .tx_fifo_good_frame(tx_fifo_good_frame[0]),
    
    .rx_fifo_overflow(rx_fifo_overflow[0]),
    .rx_fifo_bad_frame(rx_fifo_bad_frame[0]),
    .rx_fifo_good_frame(rx_fifo_good_frame[0]),

    .tx_enable(tx_enable[0]),
    .rx_enable(rx_enable[0]),
    .rx_abort(rx_abort[0]),

    .ifg_delay(ifg_delay)
);

// axi_interconnect #
// axi_crossbar #
axi_crossbar_0 
// (
//     .S_COUNT(S_COUNT),
//     .M_COUNT(M_COUNT),
//     .DATA_WIDTH(AXI_DATA_WIDTH),
//     .ADDR_WIDTH(AXI_ADDR_WIDTH),
//     .STRB_WIDTH(AXI_STRB_WIDTH),
//     .S_ID_WIDTH(AXI_ID_WIDTH),
//     .M_REGIONS(M_REGIONS),
//     .M_BASE_ADDR(M_BASE_ADDR),
//     .M_ADDR_WIDTH(M_ADDR_WIDTH)
// )
interconnect (
    .aclk(logic_clk),
    .aresetn(~logic_rst),
    .s_axi_awid(fifoed_m_axi_awid),
    .s_axi_awaddr(fifoed_m_axi_awaddr),
    .s_axi_awlen(fifoed_m_axi_awlen),
    .s_axi_awsize(fifoed_m_axi_awsize),
    .s_axi_awburst(fifoed_m_axi_awburst),
    .s_axi_awlock(fifoed_m_axi_awlock),
    .s_axi_awcache(fifoed_m_axi_awcache),
    .s_axi_awprot(fifoed_m_axi_awprot),
    .s_axi_awqos(),
    // .s_axi_awuser(),
    .s_axi_awvalid(fifoed_m_axi_awvalid),
    .s_axi_awready(fifoed_m_axi_awready),
    .s_axi_wdata(fifoed_m_axi_wdata),
    .s_axi_wstrb(fifoed_m_axi_wstrb),
    .s_axi_wlast(fifoed_m_axi_wlast),
    // .s_axi_wuser(),
    .s_axi_wvalid(fifoed_m_axi_wvalid),
    .s_axi_wready(fifoed_m_axi_wready),
    .s_axi_bid(fifoed_m_axi_bid),
    .s_axi_bresp(fifoed_m_axi_bresp),
    // .s_axi_buser(),
    .s_axi_bvalid(fifoed_m_axi_bvalid),
    .s_axi_bready(fifoed_m_axi_bready),
    .s_axi_arid(fifoed_m_axi_arid),
    .s_axi_araddr(fifoed_m_axi_araddr),
    .s_axi_arlen(fifoed_m_axi_arlen),
    .s_axi_arsize(fifoed_m_axi_arsize),
    .s_axi_arburst(fifoed_m_axi_arburst),
    .s_axi_arlock(fifoed_m_axi_arlock),
    .s_axi_arcache(fifoed_m_axi_arcache),
    .s_axi_arprot(fifoed_m_axi_arprot),
    .s_axi_arqos(),
    // .s_axi_aruser(),
    .s_axi_arvalid(fifoed_m_axi_arvalid),
    .s_axi_arready(fifoed_m_axi_arready),
    .s_axi_rid(fifoed_m_axi_rid),
    .s_axi_rdata(fifoed_m_axi_rdata),
    .s_axi_rresp(fifoed_m_axi_rresp),
    .s_axi_rlast(fifoed_m_axi_rlast),
    // .s_axi_ruser(),
    .s_axi_rvalid(fifoed_m_axi_rvalid),
    .s_axi_rready(fifoed_m_axi_rready),

    .m_axi_awid(s_axi_awid),
    .m_axi_awaddr(s_axi_awaddr),
    .m_axi_awlen(s_axi_awlen),
    .m_axi_awsize(s_axi_awsize),
    .m_axi_awburst(s_axi_awburst),
    .m_axi_awlock(s_axi_awlock),
    .m_axi_awcache(s_axi_awcache),
    .m_axi_awprot(s_axi_awprot),
    .m_axi_awqos(),
    .m_axi_awregion(),
    // .m_axi_awuser(),
    .m_axi_awvalid(s_axi_awvalid),
    .m_axi_awready(s_axi_awready),
    .m_axi_wdata(s_axi_wdata),
    .m_axi_wstrb(s_axi_wstrb),
    .m_axi_wlast(s_axi_wlast),
    // .m_axi_wuser(),
    .m_axi_wvalid(s_axi_wvalid),
    .m_axi_wready(s_axi_wready),
    .m_axi_bid(s_axi_bid),
    .m_axi_bresp(s_axi_bresp),
    // .m_axi_buser(),
    .m_axi_bvalid(s_axi_bvalid),
    .m_axi_bready(s_axi_bready),
    .m_axi_arid(s_axi_arid),
    .m_axi_araddr(s_axi_araddr),
    .m_axi_arlen(s_axi_arlen),
    .m_axi_arsize(s_axi_arsize),
    .m_axi_arburst(s_axi_arburst),
    .m_axi_arlock(s_axi_arlock),
    .m_axi_arcache(s_axi_arcache),
    .m_axi_arprot(s_axi_arprot),
    .m_axi_arqos(),
    .m_axi_arregion(),
    // .m_axi_aruser(),
    .m_axi_arvalid(s_axi_arvalid),
    .m_axi_arready(s_axi_arready),
    .m_axi_rid(s_axi_rid),
    .m_axi_rdata(s_axi_rdata),
    .m_axi_rresp(s_axi_rresp),
    .m_axi_rlast(s_axi_rlast),
    // .m_axi_ruser(),
    .m_axi_rvalid(s_axi_rvalid),
    .m_axi_rready(s_axi_rready)
);

dma_controller # (
    .DATA_WIDTH(AXI_DATA_WIDTH),   
    .ADDR_WIDTH(AXI_ADDR_WIDTH),
    .ID_WIDTH(AXI_ID_WIDTH),
    .LEN_WIDTH(LEN_WIDTH),
    .TAG_WIDTH(TAG_WIDTH),
    .CORE_COUNT(M_COUNT),
    .SLOT_COUNT(SLOT_COUNT), 
    .SLOT_LEAD_ZERO(SLOT_LEAD_ZERO),
    .RX_WRITE_OFFSET(RX_WRITE_OFFSET),
    .CORE_ADDR_WIDTH(CORE_ADDR_WIDTH),
    .SLOT_ADDR_EFF(SLOT_ADDR_EFF),
    .DESC_WIDTH(DESC_WIDTH),
    .CORE_FLAG_SIZE(SLOT_COUNT+8),
    .ERR_FLAG_SIZE(M_COUNT+2),
    .DEF_MAX_PKT_LEN({{(LEN_WIDTH-SLOT_ADDR_EFF){1'b0}},SLOT_ADDR_STEP}<<SLOT_LEAD_ZERO)
) controller 
(
    .clk(logic_clk),
    .rst(logic_rst),

    /*
     * AXI master interface
     */
    .m_axi_awid(m_axi_awid[CTRL_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_awaddr(m_axi_awaddr[CTRL_LOC*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
    .m_axi_awlen(m_axi_awlen[CTRL_LOC*8 +: 8]),
    .m_axi_awsize(m_axi_awsize[CTRL_LOC*3 +: 3]),
    .m_axi_awburst(m_axi_awburst[CTRL_LOC*2 +: 2]),
    .m_axi_awlock(m_axi_awlock[CTRL_LOC]),
    .m_axi_awcache(m_axi_awcache[CTRL_LOC*4 +: 4]),
    .m_axi_awprot(m_axi_awprot[CTRL_LOC*3 +: 3]),
    .m_axi_awvalid(m_axi_awvalid[CTRL_LOC]),
    .m_axi_awready(m_axi_awready[CTRL_LOC]),
    .m_axi_wdata(m_axi_wdata[CTRL_LOC*AXI_DATA_WIDTH +: AXI_DATA_WIDTH]),
    .m_axi_wstrb(m_axi_wstrb[CTRL_LOC*AXI_STRB_WIDTH +: AXI_STRB_WIDTH]),
    .m_axi_wlast(m_axi_wlast[CTRL_LOC]),
    .m_axi_wvalid(m_axi_wvalid[CTRL_LOC]),
    .m_axi_wready(m_axi_wready[CTRL_LOC]),
    .m_axi_bid(m_axi_bid[CTRL_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_bresp(m_axi_bresp[CTRL_LOC*2 +: 2]),
    .m_axi_bvalid(m_axi_bvalid[CTRL_LOC]),
    .m_axi_bready(m_axi_bready[CTRL_LOC]),
    .m_axi_arid(m_axi_arid[CTRL_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_araddr(m_axi_araddr[CTRL_LOC*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
    .m_axi_arlen(m_axi_arlen[CTRL_LOC*8 +: 8]),
    .m_axi_arsize(m_axi_arsize[CTRL_LOC*3 +: 3]),
    .m_axi_arburst(m_axi_arburst[CTRL_LOC*2 +: 2]),
    .m_axi_arlock(m_axi_arlock[CTRL_LOC]),
    .m_axi_arcache(m_axi_arcache[CTRL_LOC*4 +: 4]),
    .m_axi_arprot(m_axi_arprot[CTRL_LOC*3 +: 3]),
    .m_axi_arvalid(m_axi_arvalid[CTRL_LOC]),
    .m_axi_arready(m_axi_arready[CTRL_LOC]),
    .m_axi_rid(m_axi_rid[CTRL_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_rdata(m_axi_rdata[CTRL_LOC*AXI_DATA_WIDTH +: AXI_DATA_WIDTH]),
    .m_axi_rresp(m_axi_rresp[CTRL_LOC*2 +: 2]),
    .m_axi_rlast(m_axi_rlast[CTRL_LOC]),
    .m_axi_rvalid(m_axi_rvalid[CTRL_LOC]),
    .m_axi_rready(m_axi_rready[CTRL_LOC]),
 
    /*
     * Transmit descriptor output
     */
    .s_axis_tx_desc_addr (s_axis_tx_desc_addr),
    .s_axis_tx_desc_len  (s_axis_tx_desc_len),
    .s_axis_tx_desc_tag  (s_axis_tx_desc_tag),
    .s_axis_tx_desc_user (s_axis_tx_desc_user),
    .s_axis_tx_desc_valid(s_axis_tx_desc_valid),
    .s_axis_tx_desc_ready(s_axis_tx_desc_ready),

    /*
     * Receive descriptor output
     */
    .s_axis_rx_desc_addr (s_axis_rx_desc_addr),
    .s_axis_rx_desc_len  (s_axis_rx_desc_len),
    .s_axis_rx_desc_tag  (s_axis_rx_desc_tag),
    .s_axis_rx_desc_valid(s_axis_rx_desc_valid),
    .s_axis_rx_desc_ready(s_axis_rx_desc_ready),

    .incoming_pkt_ready(rx_fifo_good_frame),
    .pkt_sent_to_core_valid(m_axis_rx_desc_status_valid),
    .pkt_sent_to_core_len(m_axis_rx_desc_status_len),
    .pkt_sent_out_valid(m_axis_tx_desc_status_valid),

    .drop_list({M_COUNT{1'b0}}),
    .drop_list_valid(1'b0),
    .max_pkt_len({LEN_WIDTH{1'b0}}),
    .max_pkt_len_valid(1'b0),
    
    .inject_rx_desc(inject_rx_desc),
    .inject_rx_desc_valid(inject_rx_desc_valid),
    .inject_rx_desc_ready(inject_rx_desc_ready),
    
    .slot_addr_wr_no(slot_addr_wr_no),
    .slot_addr_wr_data(slot_addr_wr_data),
    .slot_addr_wr_valid(slot_addr_wr_valid),
    
    .core_status_rd_addr({$clog2(M_COUNT){1'b0}}),
    .core_status_rd_valid(1'b0),
    .core_status(),
    .core_status_valid(),
    
    .err(),
    .err_type(),
    
    .msg_data(msg_data),
    .msg_core_no(msg_core_no),
    .msg_valid(msg_valid),
    .msg_ready(msg_ready)

);

temp_pcie # (
    .DATA_WIDTH(AXI_DATA_WIDTH),
    .ADDR_WIDTH(AXI_ADDR_WIDTH),
    .ID_WIDTH(AXI_ID_WIDTH),
    .LEN_WIDTH(LEN_WIDTH),
    .TAG_WIDTH(TAG_WIDTH),
    .RISCV_CORES(M_COUNT),
    .RISCV_SLOTS(SLOT_COUNT),
    .SLOT_ADDR_EFF(SLOT_ADDR_EFF),
    .FIRST_SLOT_ADDR(FIRST_SLOT_ADDR),
    .SLOT_ADDR_STEP(SLOT_ADDR_STEP)
) temp_pcie_master (
    .clk(logic_clk),
    .rst(logic_rst),

    .m_axi_awid(m_axi_awid[PCI_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_awaddr(m_axi_awaddr[PCI_LOC*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
    .m_axi_awlen(m_axi_awlen[PCI_LOC*8 +: 8]),
    .m_axi_awsize(m_axi_awsize[PCI_LOC*3 +: 3]),
    .m_axi_awburst(m_axi_awburst[PCI_LOC*2 +: 2]),
    .m_axi_awlock(m_axi_awlock[PCI_LOC]),
    .m_axi_awcache(m_axi_awcache[PCI_LOC*4 +: 4]),
    .m_axi_awprot(m_axi_awprot[PCI_LOC*3 +: 3]),
    .m_axi_awvalid(m_axi_awvalid[PCI_LOC]),
    .m_axi_awready(m_axi_awready[PCI_LOC]),
    .m_axi_wdata(m_axi_wdata[PCI_LOC*AXI_DATA_WIDTH +: AXI_DATA_WIDTH]),
    .m_axi_wstrb(m_axi_wstrb[PCI_LOC*AXI_STRB_WIDTH +: AXI_STRB_WIDTH]),
    .m_axi_wlast(m_axi_wlast[PCI_LOC]),
    .m_axi_wvalid(m_axi_wvalid[PCI_LOC]),
    .m_axi_wready(m_axi_wready[PCI_LOC]),
    .m_axi_bid(m_axi_bid[PCI_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_bresp(m_axi_bresp[PCI_LOC*2 +: 2]),
    .m_axi_bvalid(m_axi_bvalid[PCI_LOC]),
    .m_axi_bready(m_axi_bready[PCI_LOC]),
    .m_axi_arid(m_axi_arid[PCI_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_araddr(m_axi_araddr[PCI_LOC*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
    .m_axi_arlen(m_axi_arlen[PCI_LOC*8 +: 8]),
    .m_axi_arsize(m_axi_arsize[PCI_LOC*3 +: 3]),
    .m_axi_arburst(m_axi_arburst[PCI_LOC*2 +: 2]),
    .m_axi_arlock(m_axi_arlock[PCI_LOC]),
    .m_axi_arcache(m_axi_arcache[PCI_LOC*4 +: 4]),
    .m_axi_arprot(m_axi_arprot[PCI_LOC*3 +: 3]),
    .m_axi_arvalid(m_axi_arvalid[PCI_LOC]),
    .m_axi_arready(m_axi_arready[PCI_LOC]),
    .m_axi_rid(m_axi_rid[PCI_LOC*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
    .m_axi_rdata(m_axi_rdata[PCI_LOC*AXI_DATA_WIDTH +: AXI_DATA_WIDTH]),
    .m_axi_rresp(m_axi_rresp[PCI_LOC*2 +: 2]),
    .m_axi_rlast(m_axi_rlast[PCI_LOC]),
    .m_axi_rvalid(m_axi_rvalid[PCI_LOC]),
    .m_axi_rready(m_axi_rready[PCI_LOC]),
    
    .slot_addr_wr_no(slot_addr_wr_no),
    .slot_addr_wr_data(slot_addr_wr_data),
    .slot_addr_wr_valid(slot_addr_wr_valid),
    
    .inject_rx_desc(inject_rx_desc),
    .inject_rx_desc_valid(inject_rx_desc_valid),
    .inject_rx_desc_ready(inject_rx_desc_ready),
 
    .tx_enable(tx_enable_out),
    .rx_enable(rx_enable_out),
    .rx_abort(rx_abort_out)
);

genvar i;
generate
  for (i=0; i<M_COUNT; i=i+1) begin
    // (* keep_hierarchy = "yes" *)
    riscv_axi_wrapper #(
        .DATA_WIDTH(AXI_DATA_WIDTH),
        .ADDR_WIDTH(AXI_ADDR_WIDTH-$clog2(M_COUNT)),
        .ID_WIDTH(AXI_CORE_ID_WIDTH),
        .PIPELINE_OUTPUT(PIPELINE_OUTPUT),
        .IMEM_SIZE_BYTES(IMEM_SIZE_BYTES),
        .DMEM_SIZE_BYTES(DMEM_SIZE_BYTES),
        .STAT_ADDR_WIDTH(STAT_ADDR_WIDTH),
        .INTERLEAVE(INTERLEAVE)
    )
    RISCV (
        .clk(logic_clk),
        .rst(logic_rst),
        .s_axi_awid(s_axi_awid[AXI_CORE_ID_WIDTH*i +: AXI_CORE_ID_WIDTH]),
        .s_axi_awaddr(s_axi_awaddr[AXI_ADDR_WIDTH*i +: AXI_ADDR_WIDTH-$clog2(M_COUNT)]),
        .s_axi_awlen(s_axi_awlen[8*i +: 8]),
        .s_axi_awsize(s_axi_awsize[3*i +: 3]),
        .s_axi_awburst(s_axi_awburst[2*i +: 2]),
        .s_axi_awlock(s_axi_awlock[i]),
        .s_axi_awcache(s_axi_awcache[4*i +: 4]),
        .s_axi_awprot(s_axi_awprot[3*i +: 3]),
        .s_axi_awvalid(s_axi_awvalid[i]),
        .s_axi_awready(s_axi_awready[i]),
        .s_axi_wdata(s_axi_wdata[AXI_DATA_WIDTH*i +: AXI_DATA_WIDTH]),
        .s_axi_wstrb(s_axi_wstrb[AXI_STRB_WIDTH*i +: AXI_STRB_WIDTH]),
        .s_axi_wlast(s_axi_wlast[i]),
        .s_axi_wvalid(s_axi_wvalid[i]),
        .s_axi_wready(s_axi_wready[i]),
        .s_axi_bid(s_axi_bid[AXI_CORE_ID_WIDTH*i +: AXI_CORE_ID_WIDTH]),
        .s_axi_bresp(s_axi_bresp[2*i +: 2]),
        .s_axi_bvalid(s_axi_bvalid[i]),
        .s_axi_bready(s_axi_bready[i]),
        .s_axi_arid(s_axi_arid[AXI_CORE_ID_WIDTH*i +: AXI_CORE_ID_WIDTH]),
        .s_axi_araddr(s_axi_araddr[AXI_ADDR_WIDTH*i +: AXI_ADDR_WIDTH-$clog2(M_COUNT)]),
        .s_axi_arlen(s_axi_arlen[8*i +: 8]),
        .s_axi_arsize(s_axi_arsize[3*i +: 3]),
        .s_axi_arburst(s_axi_arburst[2*i +: 2]),
        .s_axi_arlock(s_axi_arlock[i]),
        .s_axi_arcache(s_axi_arcache[4*i +: 4]),
        .s_axi_arprot(s_axi_arprot[3*i +: 3]),
        .s_axi_arvalid(s_axi_arvalid[i]),
        .s_axi_arready(s_axi_arready[i]),
        .s_axi_rid(s_axi_rid[AXI_CORE_ID_WIDTH*i +: AXI_CORE_ID_WIDTH]),
        .s_axi_rdata(s_axi_rdata[AXI_DATA_WIDTH*i +: AXI_DATA_WIDTH]),
        .s_axi_rresp(s_axi_rresp[2*i +: 2]),
        .s_axi_rlast(s_axi_rlast[i]),
        .s_axi_rvalid(s_axi_rvalid[i]),
        .s_axi_rready(s_axi_rready[i]),
    
        .core_msg_data(core_msg_data[i*64 +: 64]),
        .core_msg_valid(core_msg_valid[i])
    );
  end
endgenerate
    
core_msg_arbiter # (
  .CORE_COUNT(M_COUNT),
  .CORE_FIFO_ADDR_SIZE(CORE_FIFO_ADDR_SIZE)
) msg_arbiter (
    .clk(logic_clk),
    .rst(logic_rst),

    .core_msg_data(core_msg_data),
    .core_msg_valid(core_msg_valid),

    .msg_data(msg_data),
    .msg_valid(msg_valid),
    .msg_core_no(msg_core_no),
    .msg_ready(msg_ready)
);

`ifdef FIFOED_MASTERS

    // A fifo after each master's AXI output 
    genvar j;
    generate
      for (j=0; j<S_COUNT; j=j+1) begin
        axi_fifo # (
        .DATA_WIDTH(AXI_DATA_WIDTH),
        .ADDR_WIDTH(AXI_ADDR_WIDTH),
        .ID_WIDTH(AXI_ID_WIDTH),
        .WRITE_FIFO_DEPTH(AXI_WRITE_FIFO_DEPTH),
        .READ_FIFO_DEPTH(AXI_READ_FIFO_DEPTH)
        ) axi_masters_fifo (
            .clk(logic_clk),
            .rst(logic_rst),
    
            .s_axi_awid    (m_axi_awid[j*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
            .s_axi_awaddr  (m_axi_awaddr[j*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
            .s_axi_awlen   (m_axi_awlen[j*8 +: 8]),
            .s_axi_awsize  (m_axi_awsize[j*3 +: 3]),
            .s_axi_awburst (m_axi_awburst[j*2 +: 2]),
            .s_axi_awlock  (m_axi_awlock[j]),
            .s_axi_awcache (m_axi_awcache[j*4 +: 4]),
            .s_axi_awprot  (m_axi_awprot[j*3 +: 3]),
            .s_axi_awqos   (),
            .s_axi_awregion(),
            .s_axi_awuser  (),
            .s_axi_awvalid (m_axi_awvalid[j]),
            .s_axi_awready (m_axi_awready[j]),
            .s_axi_wdata   (m_axi_wdata[j*AXI_DATA_WIDTH +: AXI_DATA_WIDTH]),
            .s_axi_wstrb   (m_axi_wstrb[j*AXI_STRB_WIDTH +: AXI_STRB_WIDTH]),
            .s_axi_wlast   (m_axi_wlast[j]),
            .s_axi_wuser   (),
            .s_axi_wvalid  (m_axi_wvalid[j]),
            .s_axi_wready  (m_axi_wready[j]),
            .s_axi_bid     (m_axi_bid[j*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
            .s_axi_bresp   (m_axi_bresp[j*2 +: 2]),
            .s_axi_buser   (),
            .s_axi_bvalid  (m_axi_bvalid[j]),
            .s_axi_bready  (m_axi_bready[j]),
            .s_axi_arid    (m_axi_arid[j*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
            .s_axi_araddr  (m_axi_araddr[j*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
            .s_axi_arlen   (m_axi_arlen[j*8 +: 8]),
            .s_axi_arsize  (m_axi_arsize[j*3 +: 3]),
            .s_axi_arburst (m_axi_arburst[j*2 +: 2]),
            .s_axi_arlock  (m_axi_arlock[j]),
            .s_axi_arcache (m_axi_arcache[j*4 +: 4]),
            .s_axi_arprot  (m_axi_arprot[j*3 +: 3]),
            .s_axi_arqos   (),
            .s_axi_arregion(),
            .s_axi_aruser  (),
            .s_axi_arvalid (m_axi_arvalid[j]),
            .s_axi_arready (m_axi_arready[j]),
            .s_axi_rid     (m_axi_rid[j*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
            .s_axi_rdata   (m_axi_rdata[j*AXI_DATA_WIDTH +: AXI_DATA_WIDTH]),
            .s_axi_rresp   (m_axi_rresp[j*2 +: 2]),
            .s_axi_rlast   (m_axi_rlast[j]),
            .s_axi_ruser   (),
            .s_axi_rvalid  (m_axi_rvalid[j]),
            .s_axi_rready  (m_axi_rready[j]),
    
            .m_axi_awid    (fifoed_m_axi_awid[j*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
            .m_axi_awaddr  (fifoed_m_axi_awaddr[j*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
            .m_axi_awlen   (fifoed_m_axi_awlen[j*8 +: 8]),
            .m_axi_awsize  (fifoed_m_axi_awsize[j*3 +: 3]),
            .m_axi_awburst (fifoed_m_axi_awburst[j*2 +: 2]),
            .m_axi_awlock  (fifoed_m_axi_awlock[j]),
            .m_axi_awcache (fifoed_m_axi_awcache[j*4 +: 4]),
            .m_axi_awprot  (fifoed_m_axi_awprot[j*3 +: 3]),
            .m_axi_awqos   (),
            .m_axi_awregion(),
            .m_axi_awuser  (),
            .m_axi_awvalid (fifoed_m_axi_awvalid[j]),
            .m_axi_awready (fifoed_m_axi_awready[j]),
            .m_axi_wdata   (fifoed_m_axi_wdata[j*AXI_DATA_WIDTH +: AXI_DATA_WIDTH]),
            .m_axi_wstrb   (fifoed_m_axi_wstrb[j*AXI_STRB_WIDTH +: AXI_STRB_WIDTH]),
            .m_axi_wlast   (fifoed_m_axi_wlast[j]),
            .m_axi_wuser   (),
            .m_axi_wvalid  (fifoed_m_axi_wvalid[j]),
            .m_axi_wready  (fifoed_m_axi_wready[j]),
            .m_axi_bid     (fifoed_m_axi_bid[j*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
            .m_axi_bresp   (fifoed_m_axi_bresp[j*2 +: 2]),
            .m_axi_buser   (),
            .m_axi_bvalid  (fifoed_m_axi_bvalid[j]),
            .m_axi_bready  (fifoed_m_axi_bready[j]),
            .m_axi_arid    (fifoed_m_axi_arid[j*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
            .m_axi_araddr  (fifoed_m_axi_araddr[j*AXI_ADDR_WIDTH +: AXI_ADDR_WIDTH]),
            .m_axi_arlen   (fifoed_m_axi_arlen[j*8 +: 8]),
            .m_axi_arsize  (fifoed_m_axi_arsize[j*3 +: 3]),
            .m_axi_arburst (fifoed_m_axi_arburst[j*2 +: 2]),
            .m_axi_arlock  (fifoed_m_axi_arlock[j]),
            .m_axi_arcache (fifoed_m_axi_arcache[j*4 +: 4]),
            .m_axi_arprot  (fifoed_m_axi_arprot[j*3 +: 3]),
            .m_axi_arqos   (),
            .m_axi_arregion(),
            .m_axi_aruser  (),
            .m_axi_arvalid (fifoed_m_axi_arvalid[j]),
            .m_axi_arready (fifoed_m_axi_arready[j]),
            .m_axi_rid     (fifoed_m_axi_rid[j*AXI_ID_WIDTH +: AXI_ID_WIDTH]),
            .m_axi_rdata   (fifoed_m_axi_rdata[j*AXI_DATA_WIDTH +: AXI_DATA_WIDTH]),
            .m_axi_rresp   (fifoed_m_axi_rresp[j*2 +: 2]),
            .m_axi_rlast   (fifoed_m_axi_rlast[j]),
            .m_axi_ruser   (),
            .m_axi_rvalid  (fifoed_m_axi_rvalid[j]),
            .m_axi_rready  (fifoed_m_axi_rready[j])
        );
      end
    endgenerate

`else

    assign fifoed_m_axi_awid    = m_axi_awid; 
    assign fifoed_m_axi_awaddr  = m_axi_awaddr; 
    assign fifoed_m_axi_awlen   = m_axi_awlen; 
    assign fifoed_m_axi_awsize  = m_axi_awsize; 
    assign fifoed_m_axi_awburst = m_axi_awburst; 
    assign fifoed_m_axi_awlock  = m_axi_awlock; 
    assign fifoed_m_axi_awcache = m_axi_awcache; 
    assign fifoed_m_axi_awprot  = m_axi_awprot; 
    assign fifoed_m_axi_awvalid = m_axi_awvalid; 
    assign        m_axi_awready = fifoed_m_axi_awready; 
    assign fifoed_m_axi_wdata   = m_axi_wdata; 
    assign fifoed_m_axi_wstrb   = m_axi_wstrb; 
    assign fifoed_m_axi_wlast   = m_axi_wlast; 
    assign fifoed_m_axi_wvalid  = m_axi_wvalid; 
    assign        m_axi_wready  = fifoed_m_axi_wready; 
    assign        m_axi_bid     = fifoed_m_axi_bid; 
    assign        m_axi_bresp   = fifoed_m_axi_bresp; 
    assign        m_axi_bvalid  = fifoed_m_axi_bvalid; 
    assign fifoed_m_axi_bready  = m_axi_bready; 
    assign fifoed_m_axi_arid    = m_axi_arid; 
    assign fifoed_m_axi_araddr  = m_axi_araddr; 
    assign fifoed_m_axi_arlen   = m_axi_arlen; 
    assign fifoed_m_axi_arsize  = m_axi_arsize; 
    assign fifoed_m_axi_arburst = m_axi_arburst; 
    assign fifoed_m_axi_arlock  = m_axi_arlock; 
    assign fifoed_m_axi_arcache = m_axi_arcache; 
    assign fifoed_m_axi_arprot  = m_axi_arprot; 
    assign fifoed_m_axi_arvalid = m_axi_arvalid; 
    assign        m_axi_arready = fifoed_m_axi_arready; 
    assign        m_axi_rid     = fifoed_m_axi_rid; 
    assign        m_axi_rdata   = fifoed_m_axi_rdata; 
    assign        m_axi_rresp   = fifoed_m_axi_rresp; 
    assign        m_axi_rlast   = fifoed_m_axi_rlast; 
    assign        m_axi_rvalid  = fifoed_m_axi_rvalid; 
    assign fifoed_m_axi_rready  = m_axi_rready;   

`endif

endmodule

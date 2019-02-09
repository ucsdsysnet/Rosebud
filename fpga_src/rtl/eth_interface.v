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
 * Ethernet interface
 */
module eth_interface #
(
    parameter DATA_WIDTH = 64,
    parameter CTRL_WIDTH = (DATA_WIDTH/8),
    parameter AXI_DATA_WIDTH = 256,  // width of data bus in bits
    parameter AXI_ADDR_WIDTH = 16,  // width of address bus in bits
    parameter AXI_STRB_WIDTH = (AXI_DATA_WIDTH/8),
    parameter AXI_ID_WIDTH = 8,
    parameter AXI_MAX_BURST_LEN = 16,
    parameter LEN_WIDTH = 20,
    parameter TAG_WIDTH = 8,
    parameter ENABLE_SG = 0,
    parameter ENABLE_UNALIGNED = 0,
    parameter ENABLE_PADDING = 1,
    parameter ENABLE_DIC = 1,
    parameter MIN_FRAME_LENGTH = 64,
    parameter TX_FIFO_ADDR_WIDTH = 12-$clog2(AXI_STRB_WIDTH),
    parameter TX_FRAME_FIFO = 1,
    parameter TX_DROP_BAD_FRAME = TX_FRAME_FIFO,
    parameter TX_DROP_WHEN_FULL = 0,
    parameter RX_FIFO_ADDR_WIDTH = 12-$clog2(AXI_STRB_WIDTH),
    parameter RX_FRAME_FIFO = 1,
    parameter RX_DROP_BAD_FRAME = RX_FRAME_FIFO,
    parameter RX_DROP_WHEN_FULL = RX_FRAME_FIFO
)
(
    input  wire                       rx_clk,
    input  wire                       rx_rst,
    input  wire                       tx_clk,
    input  wire                       tx_rst,
    input  wire                       logic_clk,
    input  wire                       logic_rst,

    /*
     * Transmit descriptor input
     */
    input  wire [AXI_ADDR_WIDTH-1:0]  s_axis_tx_desc_addr,
    input  wire [LEN_WIDTH-1:0]       s_axis_tx_desc_len,
    input  wire [TAG_WIDTH-1:0]       s_axis_tx_desc_tag,
    input  wire                       s_axis_tx_desc_user,
    input  wire                       s_axis_tx_desc_valid,
    output wire                       s_axis_tx_desc_ready,

    /*
     * Transmit descriptor status output
     */
    output wire [TAG_WIDTH-1:0]       m_axis_tx_desc_status_tag,
    output wire                       m_axis_tx_desc_status_valid,

    /*
     * Receive descriptor input
     */
    input  wire [AXI_ADDR_WIDTH-1:0]  s_axis_rx_desc_addr,
    input  wire [LEN_WIDTH-1:0]       s_axis_rx_desc_len,
    input  wire [TAG_WIDTH-1:0]       s_axis_rx_desc_tag,
    input  wire                       s_axis_rx_desc_valid,
    output wire                       s_axis_rx_desc_ready,

    /*
     * Receive descriptor status output
     */
    output wire [LEN_WIDTH-1:0]       m_axis_rx_desc_status_len,
    output wire [TAG_WIDTH-1:0]       m_axis_rx_desc_status_tag,
    output wire                       m_axis_rx_desc_status_user,
    output wire                       m_axis_rx_desc_status_valid,

    /*
     * AXI master interface
     */
    output wire [AXI_ID_WIDTH-1:0]    m_axi_awid,
    output wire [AXI_ADDR_WIDTH-1:0]  m_axi_awaddr,
    output wire [7:0]                 m_axi_awlen,
    output wire [2:0]                 m_axi_awsize,
    output wire [1:0]                 m_axi_awburst,
    output wire                       m_axi_awlock,
    output wire [3:0]                 m_axi_awcache,
    output wire [2:0]                 m_axi_awprot,
    output wire                       m_axi_awvalid,
    input  wire                       m_axi_awready,
    output wire [AXI_DATA_WIDTH-1:0]  m_axi_wdata,
    output wire [AXI_STRB_WIDTH-1:0]  m_axi_wstrb,
    output wire                       m_axi_wlast,
    output wire                       m_axi_wvalid,
    input  wire                       m_axi_wready,
    input  wire [AXI_ID_WIDTH-1:0]    m_axi_bid,
    input  wire [1:0]                 m_axi_bresp,
    input  wire                       m_axi_bvalid,
    output wire                       m_axi_bready,
    output wire [AXI_ID_WIDTH-1:0]    m_axi_arid,
    output wire [AXI_ADDR_WIDTH-1:0]  m_axi_araddr,
    output wire [7:0]                 m_axi_arlen,
    output wire [2:0]                 m_axi_arsize,
    output wire [1:0]                 m_axi_arburst,
    output wire                       m_axi_arlock,
    output wire [3:0]                 m_axi_arcache,
    output wire [2:0]                 m_axi_arprot,
    output wire                       m_axi_arvalid,
    input  wire                       m_axi_arready,
    input  wire [AXI_ID_WIDTH-1:0]    m_axi_rid,
    input  wire [AXI_DATA_WIDTH-1:0]  m_axi_rdata,
    input  wire [1:0]                 m_axi_rresp,
    input  wire                       m_axi_rlast,
    input  wire                       m_axi_rvalid,
    output wire                       m_axi_rready,

    /*
     * XGMII interface
     */
    input  wire [DATA_WIDTH-1:0]      xgmii_rxd,
    input  wire [CTRL_WIDTH-1:0]      xgmii_rxc,
    output wire [DATA_WIDTH-1:0]      xgmii_txd,
    output wire [CTRL_WIDTH-1:0]      xgmii_txc,

    /*
     * Status
     */
    output wire                       tx_fifo_overflow,
    output wire                       tx_fifo_bad_frame,
    output wire                       tx_fifo_good_frame,
    output wire                       rx_error_bad_frame,
    output wire                       rx_error_bad_fcs,
    output wire                       rx_fifo_overflow,
    output wire                       rx_fifo_bad_frame,
    output wire                       rx_fifo_good_frame,

    /*
     * Configuration
     */
    input  wire                       tx_enable,
    input  wire                       rx_enable,
    input  wire                       rx_abort,
    input  wire [7:0]                 ifg_delay
);

localparam KEEP_WIDTH = CTRL_WIDTH;

wire [AXI_DATA_WIDTH-1:0] tx_axis_tdata;
wire [AXI_STRB_WIDTH-1:0] tx_axis_tkeep;
wire                      tx_axis_tvalid;
wire                      tx_axis_tready;
wire                      tx_axis_tlast;
wire                      tx_axis_tuser;

wire [AXI_DATA_WIDTH-1:0] rx_axis_tdata;
wire [AXI_STRB_WIDTH-1:0] rx_axis_tkeep;
wire                      rx_axis_tvalid;
wire                      rx_axis_tready;
wire                      rx_axis_tlast;
wire                      rx_axis_tuser;

wire [AXI_DATA_WIDTH-1:0] tx_fifo_axis_tdata;
wire [AXI_STRB_WIDTH-1:0] tx_fifo_axis_tkeep;
wire                      tx_fifo_axis_tvalid;
wire                      tx_fifo_axis_tready;
wire                      tx_fifo_axis_tlast;
wire                      tx_fifo_axis_tuser;

wire [AXI_DATA_WIDTH-1:0] rx_fifo_axis_tdata;
wire [AXI_STRB_WIDTH-1:0] rx_fifo_axis_tkeep;
wire                      rx_fifo_axis_tvalid;
wire                      rx_fifo_axis_tlast;
wire                      rx_fifo_axis_tuser;

wire [DATA_WIDTH-1:0] tx_adapt_axis_tdata;
wire [KEEP_WIDTH-1:0] tx_adapt_axis_tkeep;
wire                  tx_adapt_axis_tvalid;
wire                  tx_adapt_axis_tready;
wire                  tx_adapt_axis_tlast;
wire                  tx_adapt_axis_tuser;

wire [DATA_WIDTH-1:0] rx_adapt_axis_tdata;
wire [KEEP_WIDTH-1:0] rx_adapt_axis_tkeep;
wire                  rx_adapt_axis_tvalid;
wire                  rx_adapt_axis_tlast;
wire                  rx_adapt_axis_tuser;

// synchronize MAC status signals into logic clock domain
wire rx_error_bad_frame_int;
wire rx_error_bad_fcs_int;

reg [1:0] rx_sync_reg_1 = 2'd0;
reg [1:0] rx_sync_reg_2 = 2'd0;
reg [1:0] rx_sync_reg_3 = 2'd0;
reg [1:0] rx_sync_reg_4 = 2'd0;

assign rx_error_bad_frame = rx_sync_reg_3[0] ^ rx_sync_reg_4[0];
assign rx_error_bad_fcs = rx_sync_reg_3[1] ^ rx_sync_reg_4[1];

always @(posedge rx_clk or posedge rx_rst) begin
    if (rx_rst) begin
        rx_sync_reg_1 <= 2'd0;
    end else begin
        rx_sync_reg_1 <= rx_sync_reg_1 ^ {rx_error_bad_frame_int, rx_error_bad_frame_int};
    end
end

always @(posedge logic_clk or posedge logic_rst) begin
    if (logic_rst) begin
        rx_sync_reg_2 <= 2'd0;
        rx_sync_reg_3 <= 2'd0;
        rx_sync_reg_4 <= 2'd0;
    end else begin
        rx_sync_reg_2 <= rx_sync_reg_1;
        rx_sync_reg_3 <= rx_sync_reg_2;
        rx_sync_reg_4 <= rx_sync_reg_3;
    end
end

eth_mac_10g #(
    .DATA_WIDTH(DATA_WIDTH),
    .KEEP_WIDTH(KEEP_WIDTH),
    .CTRL_WIDTH(CTRL_WIDTH),
    .ENABLE_PADDING(ENABLE_PADDING),
    .ENABLE_DIC(ENABLE_DIC),
    .MIN_FRAME_LENGTH(MIN_FRAME_LENGTH)
)
eth_mac_10g_inst (
    .tx_clk(tx_clk),
    .tx_rst(tx_rst),
    .rx_clk(rx_clk),
    .rx_rst(rx_rst),

    .tx_axis_tdata(tx_adapt_axis_tdata),
    .tx_axis_tkeep(tx_adapt_axis_tkeep),
    .tx_axis_tvalid(tx_adapt_axis_tvalid),
    .tx_axis_tready(tx_adapt_axis_tready),
    .tx_axis_tlast(tx_adapt_axis_tlast),
    .tx_axis_tuser(tx_adapt_axis_tuser),

    .rx_axis_tdata(rx_adapt_axis_tdata),
    .rx_axis_tkeep(rx_adapt_axis_tkeep),
    .rx_axis_tvalid(rx_adapt_axis_tvalid),
    .rx_axis_tlast(rx_adapt_axis_tlast),
    .rx_axis_tuser(rx_adapt_axis_tuser),

    .xgmii_rxd(xgmii_rxd),
    .xgmii_rxc(xgmii_rxc),
    .xgmii_txd(xgmii_txd),
    .xgmii_txc(xgmii_txc),

    .rx_error_bad_frame(rx_error_bad_frame_int),
    .rx_error_bad_fcs(rx_error_bad_fcs_int),

    .ifg_delay(ifg_delay)
);

axis_adapter #(
    .S_DATA_WIDTH(AXI_DATA_WIDTH),
    .S_KEEP_ENABLE(1'b1),
    .S_KEEP_WIDTH(AXI_STRB_WIDTH),
    .M_DATA_WIDTH(DATA_WIDTH),
    .M_KEEP_ENABLE(1'b1),
    .M_KEEP_WIDTH(KEEP_WIDTH),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(1)
)
tx_adapter (
    .clk(tx_clk),
    .rst(tx_rst),
    // AXI input
    .s_axis_tdata(tx_fifo_axis_tdata),
    .s_axis_tkeep(tx_fifo_axis_tkeep),
    .s_axis_tvalid(tx_fifo_axis_tvalid),
    .s_axis_tready(tx_fifo_axis_tready),
    .s_axis_tlast(tx_fifo_axis_tlast),
    .s_axis_tid(0),
    .s_axis_tdest(0),
    .s_axis_tuser(tx_fifo_axis_tuser),
    // AXI output
    .m_axis_tdata(tx_adapt_axis_tdata),
    .m_axis_tkeep(tx_adapt_axis_tkeep),
    .m_axis_tvalid(tx_adapt_axis_tvalid),
    .m_axis_tready(tx_adapt_axis_tready),
    .m_axis_tlast(tx_adapt_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(tx_adapt_axis_tuser)
);

axis_async_fifo #(
    .ADDR_WIDTH(TX_FIFO_ADDR_WIDTH),
    .DATA_WIDTH(AXI_DATA_WIDTH),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(AXI_STRB_WIDTH),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(1),
    .FRAME_FIFO(TX_FRAME_FIFO),
    .USER_BAD_FRAME_VALUE(1'b1),
    .USER_BAD_FRAME_MASK(1'b1),
    .DROP_BAD_FRAME(TX_DROP_BAD_FRAME),
    .DROP_WHEN_FULL(TX_DROP_WHEN_FULL)
)
tx_fifo (
    // Common reset
    .async_rst(logic_rst | tx_rst),
    // AXI input
    .s_clk(logic_clk),
    .s_axis_tdata(tx_axis_tdata),
    .s_axis_tkeep(tx_axis_tkeep),
    .s_axis_tvalid(tx_axis_tvalid),
    .s_axis_tready(tx_axis_tready),
    .s_axis_tlast(tx_axis_tlast),
    .s_axis_tid(0),
    .s_axis_tdest(0),
    .s_axis_tuser(tx_axis_tuser),
    // AXI output
    .m_clk(tx_clk),
    .m_axis_tdata(tx_fifo_axis_tdata),
    .m_axis_tkeep(tx_fifo_axis_tkeep),
    .m_axis_tvalid(tx_fifo_axis_tvalid),
    .m_axis_tready(tx_fifo_axis_tready),
    .m_axis_tlast(tx_fifo_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(tx_fifo_axis_tuser),
    // Status
    .s_status_overflow(tx_fifo_overflow),
    .s_status_bad_frame(tx_fifo_bad_frame),
    .s_status_good_frame(tx_fifo_good_frame),
    .m_status_overflow(),
    .m_status_bad_frame(),
    .m_status_good_frame()
);

axis_adapter #(
    .S_DATA_WIDTH(DATA_WIDTH),
    .S_KEEP_ENABLE(1),
    .S_KEEP_WIDTH(KEEP_WIDTH),
    .M_DATA_WIDTH(AXI_DATA_WIDTH),
    .M_KEEP_ENABLE(1),
    .M_KEEP_WIDTH(AXI_STRB_WIDTH),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(1)
)
rx_adapter (
    .clk(rx_clk),
    .rst(rx_rst),
    // AXI input
    .s_axis_tdata(rx_adapt_axis_tdata),
    .s_axis_tkeep(rx_adapt_axis_tkeep),
    .s_axis_tvalid(rx_adapt_axis_tvalid),
    .s_axis_tready(),
    .s_axis_tlast(rx_adapt_axis_tlast),
    .s_axis_tid(0),
    .s_axis_tdest(0),
    .s_axis_tuser(rx_adapt_axis_tuser),
    // AXI output
    .m_axis_tdata(rx_fifo_axis_tdata),
    .m_axis_tkeep(rx_fifo_axis_tkeep),
    .m_axis_tvalid(rx_fifo_axis_tvalid),
    .m_axis_tready(1'b1),
    .m_axis_tlast(rx_fifo_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(rx_fifo_axis_tuser)
);

axis_async_fifo #(
    .ADDR_WIDTH(RX_FIFO_ADDR_WIDTH),
    .DATA_WIDTH(AXI_DATA_WIDTH),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(AXI_STRB_WIDTH),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(1),
    .FRAME_FIFO(RX_FRAME_FIFO),
    .USER_BAD_FRAME_VALUE(1'b1),
    .USER_BAD_FRAME_MASK(1'b1),
    .DROP_BAD_FRAME(RX_DROP_BAD_FRAME),
    .DROP_WHEN_FULL(RX_DROP_WHEN_FULL)
)
rx_fifo (
    // Common reset
    .async_rst(rx_rst | logic_rst),
    // AXI input
    .s_clk(rx_clk),
    .s_axis_tdata(rx_fifo_axis_tdata),
    .s_axis_tkeep(rx_fifo_axis_tkeep),
    .s_axis_tvalid(rx_fifo_axis_tvalid),
    .s_axis_tready(),
    .s_axis_tlast(rx_fifo_axis_tlast),
    .s_axis_tid(0),
    .s_axis_tdest(0),
    .s_axis_tuser(rx_fifo_axis_tuser),
    // AXI output
    .m_clk(logic_clk),
    .m_axis_tdata(rx_axis_tdata),
    .m_axis_tkeep(rx_axis_tkeep),
    .m_axis_tvalid(rx_axis_tvalid),
    .m_axis_tready(rx_axis_tready),
    .m_axis_tlast(rx_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(rx_axis_tuser),
    // Status
    .s_status_overflow(),
    .s_status_bad_frame(),
    .s_status_good_frame(),
    .m_status_overflow(rx_fifo_overflow),
    .m_status_bad_frame(rx_fifo_bad_frame),
    .m_status_good_frame(rx_fifo_good_frame)
);

axi_dma #(
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .AXI_STRB_WIDTH(AXI_STRB_WIDTH),
    .AXI_ID_WIDTH(AXI_ID_WIDTH),
    .AXI_MAX_BURST_LEN(AXI_MAX_BURST_LEN),
    .AXIS_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXIS_KEEP_ENABLE(1),
    .AXIS_KEEP_WIDTH(AXI_STRB_WIDTH),
    .AXIS_LAST_ENABLE(1),
    .AXIS_ID_ENABLE(0),
    .AXIS_DEST_ENABLE(0),
    .AXIS_USER_ENABLE(1),
    .AXIS_USER_WIDTH(1),
    .LEN_WIDTH(LEN_WIDTH),
    .TAG_WIDTH(TAG_WIDTH),
    .ENABLE_SG(ENABLE_SG),
    .ENABLE_UNALIGNED(ENABLE_UNALIGNED)
)
axi_dma_inst (
    .clk(logic_clk),
    .rst(logic_rst),

    .s_axis_read_desc_addr(s_axis_tx_desc_addr),
    .s_axis_read_desc_len(s_axis_tx_desc_len),
    .s_axis_read_desc_tag(s_axis_tx_desc_tag),
    .s_axis_read_desc_id(0),
    .s_axis_read_desc_dest(0),
    .s_axis_read_desc_user(s_axis_tx_desc_user),
    .s_axis_read_desc_valid(s_axis_tx_desc_valid),
    .s_axis_read_desc_ready(s_axis_tx_desc_ready),

    .m_axis_read_desc_status_tag(m_axis_tx_desc_status_tag),
    .m_axis_read_desc_status_valid(m_axis_tx_desc_status_valid),

    .m_axis_read_data_tdata(tx_axis_tdata),
    .m_axis_read_data_tkeep(tx_axis_tkeep),
    .m_axis_read_data_tvalid(tx_axis_tvalid),
    .m_axis_read_data_tready(tx_axis_tready),
    .m_axis_read_data_tlast(tx_axis_tlast),
    .m_axis_read_data_tid(),
    .m_axis_read_data_tdest(),
    .m_axis_read_data_tuser(tx_axis_tuser),

    .s_axis_write_desc_addr(s_axis_rx_desc_addr),
    .s_axis_write_desc_len(s_axis_rx_desc_len),
    .s_axis_write_desc_tag(s_axis_rx_desc_tag),
    .s_axis_write_desc_valid(s_axis_rx_desc_valid),
    .s_axis_write_desc_ready(s_axis_rx_desc_ready),

    .m_axis_write_desc_status_len(m_axis_rx_desc_status_len),
    .m_axis_write_desc_status_tag(m_axis_rx_desc_status_tag),
    .m_axis_write_desc_status_id(),
    .m_axis_write_desc_status_dest(),
    .m_axis_write_desc_status_user(m_axis_rx_desc_status_user),
    .m_axis_write_desc_status_valid(m_axis_rx_desc_status_valid),

    .s_axis_write_data_tdata(rx_axis_tdata),
    .s_axis_write_data_tkeep(rx_axis_tkeep),
    .s_axis_write_data_tvalid(rx_axis_tvalid),
    .s_axis_write_data_tready(rx_axis_tready),
    .s_axis_write_data_tlast(rx_axis_tlast),
    .s_axis_write_data_tid(0),
    .s_axis_write_data_tdest(0),
    .s_axis_write_data_tuser(rx_axis_tuser),

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

    .read_enable(tx_enable),
    .write_enable(rx_enable),
    .write_abort(rx_abort)
);

endmodule

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

// assign sfp_2_txd = 64'h0707070707070707;
// assign sfp_2_txc = 8'hff;
assign sfp_1_led = 0;
assign sfp_2_led = 0;
assign sma_led   = 0;

// RISCV system parameters
parameter CORE_COUNT      = 16;
parameter CORE_ADDR_WIDTH = 16;
parameter CORE_LEAD_ZERO  = 8;
parameter SLOT_COUNT      = 8;
parameter SLOT_START_ADDR = 8'h20;
parameter SLOT_ADDR_STEP  = 8'h08;
parameter AXIS_DATA_WIDTH = 64;
parameter AXIS_STRB_WIDTH = AXIS_DATA_WIDTH/8;
parameter TX_FIFO_DEPTH   = 32768;
parameter RX_FIFO_DEPTH   = 32768;
parameter AXIS_DEST_IN    = $clog2(CORE_COUNT)+CORE_ADDR_WIDTH-CORE_LEAD_ZERO;
parameter AXIS_DEST_OUT   = $clog2(2); //output ports
parameter AXIS_USER_IN    = AXIS_DEST_OUT;
parameter AXIS_USER_OUT   = AXIS_DEST_IN;
parameter IMEM_SIZE_BYTES = 8192;
parameter DMEM_SIZE_BYTES = 32768;
parameter COHERENT_START  = 16'h6FFF;
parameter RECV_DESC_DEPTH = 8;
parameter SEND_DESC_DEPTH = 8;
parameter MSG_FIFO_DEPTH  = 16;
parameter CORE_MSG_WIDTH  = 4+$clog2(DMEM_SIZE_BYTES)+32;
parameter LEN_WIDTH       = 16;
parameter INTERLEAVE      = 1;
parameter CTRL_DEST_WIDTH = $clog2(CORE_COUNT);
parameter CTRL_USER_WIDTH = $clog2(CORE_COUNT);
parameter ENABLE_ILA      = 0;

// ETH interfaces
parameter ETH0_LOC = 0;
parameter ETH1_LOC = 1;

wire [2*AXIS_DATA_WIDTH-1:0] tx_axis_tdata;
wire [2*AXIS_STRB_WIDTH-1:0] tx_axis_tkeep;
wire [2-1:0] tx_axis_tvalid, tx_axis_tready, tx_axis_tlast;
wire [2*AXIS_DATA_WIDTH-1:0] rx_axis_tdata;
wire [2*AXIS_STRB_WIDTH-1:0] rx_axis_tkeep;
wire [2-1:0] rx_axis_tvalid, rx_axis_tready, rx_axis_tlast;
wire [2-1:0] rx_fifo_overflow;
wire [2-1:0] rx_fifo_good_frame;
wire [7:0] ifg_delay = 8'd12;
    
wire [2-1:0] tx_fifo_overflow;
wire [2-1:0] tx_fifo_bad_frame;
wire [2-1:0] tx_fifo_good_frame;

eth_mac_10g_fifo #
(
    .DATA_WIDTH(AXIS_DATA_WIDTH),
    .ENABLE_PADDING(1),
    .ENABLE_DIC(1),
    .TX_FIFO_DEPTH(TX_FIFO_DEPTH),
    .TX_DROP_WHEN_FULL(0),
    .RX_FIFO_DEPTH(RX_FIFO_DEPTH)
) eth_mac_0
(
    .rx_clk(sfp_1_rx_clk),
    .rx_rst(sfp_1_rx_rst),
    .tx_clk(sfp_1_tx_clk),
    .tx_rst(sfp_1_tx_rst),
    .logic_clk(clk),
    .logic_rst(rst),

    /*
     * XGMII interface
     */
    .xgmii_rxd(sfp_1_rxd),
    .xgmii_rxc(sfp_1_rxc),
    .xgmii_txd(sfp_1_txd),
    .xgmii_txc(sfp_1_txc),
    
    /*
     * AXI input
     */
    .tx_axis_tdata(tx_axis_tdata[ETH0_LOC*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
    .tx_axis_tkeep(tx_axis_tkeep[ETH0_LOC*AXIS_STRB_WIDTH +: AXIS_STRB_WIDTH]),
    .tx_axis_tvalid(tx_axis_tvalid[ETH0_LOC]),
    .tx_axis_tready(tx_axis_tready[ETH0_LOC]),
    .tx_axis_tlast(tx_axis_tlast[ETH0_LOC]),
    .tx_axis_tuser(0),

    /*
     * AXI output
     */
    .rx_axis_tdata(rx_axis_tdata[ETH0_LOC*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
    .rx_axis_tkeep(rx_axis_tkeep[ETH0_LOC*AXIS_STRB_WIDTH +: AXIS_STRB_WIDTH]),
    .rx_axis_tvalid(rx_axis_tvalid[ETH0_LOC]),
    .rx_axis_tready(rx_axis_tready[ETH0_LOC]),
    .rx_axis_tlast(rx_axis_tlast[ETH0_LOC]),
    .rx_axis_tuser(),

    /*
     * Status
     */
    .rx_fifo_overflow(rx_fifo_overflow[ETH0_LOC]),
    .rx_fifo_good_frame(rx_fifo_good_frame[ETH0_LOC]),
    .tx_error_underflow(),
    .tx_fifo_overflow(tx_fifo_overflow[ETH0_LOC]),
    .tx_fifo_bad_frame(tx_fifo_bad_frame[ETH0_LOC]),
    .tx_fifo_good_frame(tx_fifo_good_frame[ETH0_LOC]),
    .rx_error_bad_frame(),
    .rx_error_bad_fcs(),
    .rx_fifo_bad_frame(),

    /*
     * Configuration
     */
    .ifg_delay(ifg_delay),

    /*
     * PTP not used
     */
    .ptp_ts_96(0),
    .m_axis_rx_ptp_ts_ready(0),
    .m_axis_tx_ptp_ts_ready(0),
    .s_axis_tx_ptp_ts_tag (0),
    .s_axis_tx_ptp_ts_valid (0),
    .ptp_sample_clk (0)
);

eth_mac_10g_fifo #
(
    .DATA_WIDTH(AXIS_DATA_WIDTH),
    .ENABLE_PADDING(1),
    .ENABLE_DIC(1),
    .TX_FIFO_DEPTH(TX_FIFO_DEPTH),
    .TX_DROP_WHEN_FULL(0),
    .RX_FIFO_DEPTH(RX_FIFO_DEPTH)
) eth_mac_1
(
    .rx_clk(sfp_2_rx_clk),
    .rx_rst(sfp_2_rx_rst),
    .tx_clk(sfp_2_tx_clk),
    .tx_rst(sfp_2_tx_rst),
    .logic_clk(clk),
    .logic_rst(rst),

    /*
     * XGMII interface
     */
    .xgmii_rxd(sfp_2_rxd),
    .xgmii_rxc(sfp_2_rxc),
    .xgmii_txd(sfp_2_txd),
    .xgmii_txc(sfp_2_txc),
    
    /*
     * AXI input
     */
    .tx_axis_tdata(tx_axis_tdata[ETH1_LOC*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
    .tx_axis_tkeep(tx_axis_tkeep[ETH1_LOC*AXIS_STRB_WIDTH +: AXIS_STRB_WIDTH]),
    .tx_axis_tvalid(tx_axis_tvalid[ETH1_LOC]),
    .tx_axis_tready(tx_axis_tready[ETH1_LOC]),
    .tx_axis_tlast(tx_axis_tlast[ETH1_LOC]),
    .tx_axis_tuser(0),

    /*
     * AXI output
     */
    .rx_axis_tdata(rx_axis_tdata[ETH1_LOC*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
    .rx_axis_tkeep(rx_axis_tkeep[ETH1_LOC*AXIS_STRB_WIDTH +: AXIS_STRB_WIDTH]),
    .rx_axis_tvalid(rx_axis_tvalid[ETH1_LOC]),
    .rx_axis_tready(rx_axis_tready[ETH1_LOC]),
    .rx_axis_tlast(rx_axis_tlast[ETH1_LOC]),
    .rx_axis_tuser(),

    /*
     * Status
     */
    .rx_fifo_overflow(rx_fifo_overflow[ETH1_LOC]),
    .rx_fifo_good_frame(rx_fifo_good_frame[ETH1_LOC]),
    .tx_error_underflow(),
    .tx_fifo_overflow(tx_fifo_overflow[ETH1_LOC]),
    .tx_fifo_bad_frame(tx_fifo_bad_frame[ETH1_LOC]),
    .tx_fifo_good_frame(tx_fifo_good_frame[ETH1_LOC]),
    .rx_error_bad_frame(),
    .rx_error_bad_fcs(),
    .rx_fifo_bad_frame(),

    /*
     * Configuration
     */
    .ifg_delay(ifg_delay),

    /*
     * PTP not used
     */
    .ptp_ts_96(0),
    .m_axis_rx_ptp_ts_ready(0),
    .m_axis_tx_ptp_ts_ready(0),
    .s_axis_tx_ptp_ts_tag (0),
    .s_axis_tx_ptp_ts_valid (0),
    .ptp_sample_clk (0)
);

// Scheduler 
wire [2*AXIS_DATA_WIDTH-1:0] sched_tx_axis_tdata;
wire [2*AXIS_STRB_WIDTH-1:0] sched_tx_axis_tkeep;
wire [2*AXIS_DEST_OUT-1:0]   sched_tx_axis_tdest;
wire [2*AXIS_USER_OUT-1:0]   sched_tx_axis_tuser;
wire [2-1:0] sched_tx_axis_tvalid, sched_tx_axis_tready, sched_tx_axis_tlast;

wire [2*AXIS_DATA_WIDTH-1:0] sched_rx_axis_tdata;
wire [2*AXIS_STRB_WIDTH-1:0] sched_rx_axis_tkeep;
wire [2*AXIS_DEST_IN-1:0]    sched_rx_axis_tdest;
wire [2*AXIS_USER_IN-1:0]    sched_rx_axis_tuser;
wire [2-1:0] sched_rx_axis_tvalid, sched_rx_axis_tready, sched_rx_axis_tlast;
    
wire [AXIS_DATA_WIDTH-1:0] sched_ctrl_m_axis_tdata;
wire                       sched_ctrl_m_axis_tvalid;
wire                       sched_ctrl_m_axis_tready;
wire                       sched_ctrl_m_axis_tlast;
wire [CTRL_DEST_WIDTH-1:0] sched_ctrl_m_axis_tdest;

wire [AXIS_DATA_WIDTH-1:0] sched_ctrl_s_axis_tdata;
wire                       sched_ctrl_s_axis_tvalid;
wire                       sched_ctrl_s_axis_tready;
wire                       sched_ctrl_s_axis_tlast;
wire [CTRL_USER_WIDTH-1:0] sched_ctrl_s_axis_tuser;

simple_scheduler # (
  .CORE_COUNT(CORE_COUNT),
  .DATA_WIDTH(AXIS_DATA_WIDTH),
  .LEN_WIDTH(LEN_WIDTH),
  .SLOT_COUNT(SLOT_COUNT),
  .SLOT_START_ADDR(SLOT_START_ADDR),
  .SLOT_ADDR_STEP(SLOT_ADDR_STEP),  
  .EFF_ADDR_WIDTH(CORE_ADDR_WIDTH-CORE_LEAD_ZERO),
  .DEST_WIDTH_OUT($clog2(2)), //output ports
  .ENABLE_ILA(ENABLE_ILA)
) scheduler (
  .clk(clk),
  .rst(rst),

  // Data line to/from Eth interfaces
  .tx_axis_tdata(tx_axis_tdata),
  .tx_axis_tkeep(tx_axis_tkeep),
  .tx_axis_tvalid(tx_axis_tvalid), 
  .tx_axis_tready(tx_axis_tready), 
  .tx_axis_tlast(tx_axis_tlast),
  
  .rx_axis_tdata(rx_axis_tdata),
  .rx_axis_tkeep(rx_axis_tkeep),
  .rx_axis_tvalid(rx_axis_tvalid), 
  .rx_axis_tready(rx_axis_tready), 
  .rx_axis_tlast(rx_axis_tlast),
  
  .rx_fifo_overflow(rx_fifo_overflow),
  .rx_fifo_good_frame(rx_fifo_good_frame),
  .tx_fifo_overflow(tx_fifo_overflow),
  .tx_fifo_bad_frame(tx_fifo_bad_frame),
  .tx_fifo_good_frame(tx_fifo_good_frame),

  // DATA lines to/from cores
  .data_m_axis_tdata(sched_rx_axis_tdata),
  .data_m_axis_tkeep(sched_rx_axis_tkeep),
  .data_m_axis_tdest(sched_rx_axis_tdest),
  .data_m_axis_tuser(sched_rx_axis_tuser),
  .data_m_axis_tvalid(sched_rx_axis_tvalid),
  .data_m_axis_tready(sched_rx_axis_tready),
  .data_m_axis_tlast(sched_rx_axis_tlast),
  
  .data_s_axis_tdata(sched_tx_axis_tdata),
  .data_s_axis_tkeep(sched_tx_axis_tkeep),
  .data_s_axis_tdest(sched_tx_axis_tdest),
  .data_s_axis_tuser(sched_tx_axis_tuser),
  .data_s_axis_tvalid(sched_tx_axis_tvalid), 
  .data_s_axis_tready(sched_tx_axis_tready), 
  .data_s_axis_tlast(sched_tx_axis_tlast),
      
  // Control lines to/from cores
  .ctrl_m_axis_tdata(sched_ctrl_m_axis_tdata),
  .ctrl_m_axis_tvalid(sched_ctrl_m_axis_tvalid),
  .ctrl_m_axis_tready(sched_ctrl_m_axis_tready),
  .ctrl_m_axis_tlast(sched_ctrl_m_axis_tlast),
  .ctrl_m_axis_tdest(sched_ctrl_m_axis_tdest),

  .ctrl_s_axis_tdata(sched_ctrl_s_axis_tdata),
  .ctrl_s_axis_tvalid(sched_ctrl_s_axis_tvalid),
  .ctrl_s_axis_tready(sched_ctrl_s_axis_tready),
  .ctrl_s_axis_tlast(sched_ctrl_s_axis_tlast),
  .ctrl_s_axis_tuser(sched_ctrl_s_axis_tuser)
);

// Data channel switch
wire [CORE_COUNT*AXIS_DATA_WIDTH-1:0] data_s_axis_tdata;
wire [CORE_COUNT*AXIS_STRB_WIDTH-1:0] data_s_axis_tkeep;
wire [CORE_COUNT*AXIS_DEST_IN-1:0]    data_s_axis_tdest;
wire [CORE_COUNT*AXIS_USER_IN-1:0]    data_s_axis_tuser;
wire [CORE_COUNT-1:0] data_s_axis_tvalid, data_s_axis_tready, data_s_axis_tlast;

wire [CORE_COUNT*AXIS_DATA_WIDTH-1:0] data_m_axis_tdata;
wire [CORE_COUNT*AXIS_STRB_WIDTH-1:0] data_m_axis_tkeep;
wire [CORE_COUNT*AXIS_DEST_OUT-1:0]   data_m_axis_tdest;
wire [CORE_COUNT*AXIS_USER_OUT-1:0]   data_m_axis_tuser;
wire [CORE_COUNT-1:0] data_m_axis_tvalid, data_m_axis_tready, data_m_axis_tlast;

wire [CORE_COUNT*AXIS_DATA_WIDTH-1:0] ctrl_s_axis_tdata;
wire [CORE_COUNT*CTRL_DEST_WIDTH-1:0] ctrl_s_axis_tdest;
wire [CORE_COUNT-1:0] ctrl_s_axis_tvalid, ctrl_s_axis_tready, ctrl_s_axis_tlast;

wire [CORE_COUNT*AXIS_DATA_WIDTH-1:0] ctrl_m_axis_tdata;
wire [CORE_COUNT*CTRL_USER_WIDTH-1:0] ctrl_m_axis_tuser;
wire [CORE_COUNT-1:0] ctrl_m_axis_tvalid, ctrl_m_axis_tready, ctrl_m_axis_tlast;

parameter CORE_START = {(CORE_ADDR_WIDTH-CORE_LEAD_ZERO){1'b0}};
parameter CORE_END   = {(CORE_ADDR_WIDTH-CORE_LEAD_ZERO){1'b1}};

axis_switch #
(
    .S_COUNT(2),
    .M_COUNT(CORE_COUNT),
    .DATA_WIDTH(AXIS_DATA_WIDTH),
    .DEST_WIDTH(AXIS_DEST_IN),
    .USER_WIDTH(AXIS_USER_IN),
    .M_BASE({{4'd15,CORE_START}, {4'd14,CORE_START}, {4'd13,CORE_START}, {4'd12,CORE_START},
             {4'd11,CORE_START}, {4'd10,CORE_START}, {4'd9, CORE_START}, {4'd8, CORE_START},
             {4'd7, CORE_START}, {4'd6, CORE_START}, {4'd5, CORE_START}, {4'd4, CORE_START},
             {4'd3, CORE_START}, {4'd2, CORE_START}, {4'd1, CORE_START}, {4'd0, CORE_START}}),
    .M_TOP({{4'd15,CORE_END}, {4'd14,CORE_END}, {4'd13,CORE_END}, {4'd12,CORE_END},
            {4'd11,CORE_END}, {4'd10,CORE_END}, {4'd9, CORE_END}, {4'd8, CORE_END},
            {4'd7, CORE_END}, {4'd6, CORE_END}, {4'd5, CORE_END}, {4'd4, CORE_END},
            {4'd3, CORE_END}, {4'd2, CORE_END}, {4'd1, CORE_END}, {4'd0, CORE_END}}),
    .M_REG_TYPE(2)
) data_in_sw
(
    .clk(clk),
    .rst(rst),

    /*
     * AXI Stream inputs
     */
    .s_axis_tdata(sched_rx_axis_tdata),
    .s_axis_tkeep(sched_rx_axis_tkeep),
    .s_axis_tvalid(sched_rx_axis_tvalid),
    .s_axis_tready(sched_rx_axis_tready),
    .s_axis_tlast(sched_rx_axis_tlast),
    .s_axis_tid(0),
    .s_axis_tdest(sched_rx_axis_tdest),
    .s_axis_tuser(sched_rx_axis_tuser),

    /*
     * AXI Stream outputs
     */
    .m_axis_tdata(data_s_axis_tdata),
    .m_axis_tkeep(data_s_axis_tkeep),
    .m_axis_tvalid(data_s_axis_tvalid),
    .m_axis_tready(data_s_axis_tready),
    .m_axis_tlast(data_s_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(data_s_axis_tdest),
    .m_axis_tuser(data_s_axis_tuser)
);

axis_switch #
(
    .S_COUNT(CORE_COUNT),
    .M_COUNT(2),
    .DATA_WIDTH(AXIS_DATA_WIDTH),
    .DEST_WIDTH(AXIS_DEST_OUT),
    .USER_WIDTH(AXIS_USER_OUT),
    .M_BASE({1'b1,1'b0}),
    .M_TOP({1'b1,1'b0})
) data_out_sw
(
    .clk(clk),
    .rst(rst),

    /*
     * AXI Stream inputs
     */
    .s_axis_tdata(data_m_axis_tdata),
    .s_axis_tkeep(data_m_axis_tkeep),
    .s_axis_tvalid(data_m_axis_tvalid),
    .s_axis_tready(data_m_axis_tready),
    .s_axis_tlast(data_m_axis_tlast),
    .s_axis_tid(0),
    .s_axis_tdest(data_m_axis_tdest),
    .s_axis_tuser(data_m_axis_tuser),

    /*
     * AXI Stream outputs
     */
    .m_axis_tdata(sched_tx_axis_tdata),
    .m_axis_tkeep(sched_tx_axis_tkeep),
    .m_axis_tvalid(sched_tx_axis_tvalid),
    .m_axis_tready(sched_tx_axis_tready),
    .m_axis_tlast(sched_tx_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(sched_tx_axis_tdest),
    .m_axis_tuser(sched_tx_axis_tuser)

);

axis_switch #
(
    .S_COUNT(1),
    .M_COUNT(CORE_COUNT),
    .DATA_WIDTH(AXIS_DATA_WIDTH),
    .DEST_WIDTH(CTRL_DEST_WIDTH),
    .USER_ENABLE(0),
    .KEEP_ENABLE(0),
    .M_BASE({4'd15,4'd14,4'd13,4'd12,
             4'd11,4'd10,4'd9, 4'd8, 
             4'd7, 4'd6, 4'd5, 4'd4, 
             4'd3, 4'd2, 4'd1, 4'd0}),
    .M_TOP({4'd15,4'd14,4'd13,4'd12,
            4'd11,4'd10,4'd9, 4'd8, 
            4'd7, 4'd6, 4'd5, 4'd4, 
            4'd3, 4'd2, 4'd1, 4'd0})
) ctrl_in_sw
(
    .clk(clk),
    .rst(rst),

    /*
     * AXI Stream inputs
     */
    .s_axis_tdata(sched_ctrl_m_axis_tdata),
    .s_axis_tkeep(),
    .s_axis_tvalid(sched_ctrl_m_axis_tvalid),
    .s_axis_tready(sched_ctrl_m_axis_tready),
    .s_axis_tlast(sched_ctrl_m_axis_tlast),
    .s_axis_tid(0),
    .s_axis_tdest(sched_ctrl_m_axis_tdest),
    .s_axis_tuser(),

    /*
     * AXI Stream outputs
     */
    .m_axis_tdata(ctrl_s_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tvalid(ctrl_s_axis_tvalid),
    .m_axis_tready(ctrl_s_axis_tready),
    .m_axis_tlast(ctrl_s_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(ctrl_s_axis_tdest),
    .m_axis_tuser()
);


axis_arb_mux #
(
    .S_COUNT(CORE_COUNT),
    .DATA_WIDTH(AXIS_DATA_WIDTH),
    .USER_WIDTH(CTRL_USER_WIDTH),
    .KEEP_ENABLE(0)
) ctrl_out_sw
(
    .clk(clk),
    .rst(rst),

    /*
     * AXI Stream inputs
     */
    .s_axis_tdata(ctrl_m_axis_tdata),
    .s_axis_tkeep(),
    .s_axis_tvalid(ctrl_m_axis_tvalid),
    .s_axis_tready(ctrl_m_axis_tready),
    .s_axis_tlast(ctrl_m_axis_tlast),
    .s_axis_tid(),
    .s_axis_tdest(),
    .s_axis_tuser(ctrl_m_axis_tuser),

    /*
     * AXI Stream output
     */
    .m_axis_tdata(sched_ctrl_s_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tvalid(sched_ctrl_s_axis_tvalid),
    .m_axis_tready(sched_ctrl_s_axis_tready),
    .m_axis_tlast(sched_ctrl_s_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(sched_ctrl_s_axis_tuser)
);


wire [CORE_COUNT-1:0] core_msg_in_valid;
wire [CORE_MSG_WIDTH*CORE_COUNT-1:0] core_msg_in_data;

wire [CORE_COUNT-1:0] core_msg_out_valid;
wire [CORE_COUNT-1:0] core_msg_out_ready;
wire [CORE_MSG_WIDTH*CORE_COUNT-1:0] core_msg_out_data;

genvar i;
generate
  for (i=0; i<CORE_COUNT; i=i+1) begin
    // (* keep_hierarchy = "yes" *)
    riscv_axis_wrapper #(
        .DATA_WIDTH(AXIS_DATA_WIDTH),
        .ADDR_WIDTH(CORE_ADDR_WIDTH),
        .IMEM_SIZE_BYTES(IMEM_SIZE_BYTES),
        .DMEM_SIZE_BYTES(DMEM_SIZE_BYTES),
        .COHERENT_START(COHERENT_START),
        .INTERLEAVE(INTERLEAVE),
        .RECV_DESC_DEPTH(RECV_DESC_DEPTH),
        .SEND_DESC_DEPTH(SEND_DESC_DEPTH),
        .MSG_FIFO_DEPTH(MSG_FIFO_DEPTH),
        .PORT_COUNT(2),
        .LEN_WIDTH(LEN_WIDTH),
        .ADDR_LEAD_ZERO(CORE_LEAD_ZERO),
        .CORE_ID(i),
        .CORE_ID_WIDTH($clog2(CORE_COUNT))
    )
    RISCV (
        .clk(clk),
        .rst(rst),

        // ---------------- DATA CHANNEL --------------- // 
        // Incoming data
        .data_s_axis_tdata(data_s_axis_tdata[AXIS_DATA_WIDTH*i +: AXIS_DATA_WIDTH]),
        .data_s_axis_tkeep(data_s_axis_tkeep[AXIS_STRB_WIDTH*i +: AXIS_STRB_WIDTH]),
        .data_s_axis_tvalid(data_s_axis_tvalid[i]),
        .data_s_axis_tready(data_s_axis_tready[i]),
        .data_s_axis_tlast(data_s_axis_tlast[i]),
        .data_s_axis_tdest(data_s_axis_tdest[AXIS_DEST_IN*i +: AXIS_DEST_IN]),
        .data_s_axis_tuser(data_s_axis_tuser[AXIS_USER_IN*i +: AXIS_USER_IN]),
  
        // Outgoing data
        .data_m_axis_tdata(data_m_axis_tdata[AXIS_DATA_WIDTH*i +: AXIS_DATA_WIDTH]),
        .data_m_axis_tkeep(data_m_axis_tkeep[AXIS_STRB_WIDTH*i +: AXIS_STRB_WIDTH]),
        .data_m_axis_tvalid(data_m_axis_tvalid[i]),
        .data_m_axis_tready(data_m_axis_tready[i]),
        .data_m_axis_tlast(data_m_axis_tlast[i]),
        .data_m_axis_tdest(data_m_axis_tdest[AXIS_DEST_OUT*i +: AXIS_DEST_OUT]),
        .data_m_axis_tuser(data_m_axis_tuser[AXIS_USER_OUT*i +: AXIS_USER_OUT]),
  
        // ---------------- CTRL CHANNEL --------------- // 
        // Incoming control
        .ctrl_s_axis_tdata(ctrl_s_axis_tdata[AXIS_DATA_WIDTH*i +: AXIS_DATA_WIDTH]),
        .ctrl_s_axis_tvalid(ctrl_s_axis_tvalid[i]),
        .ctrl_s_axis_tready(ctrl_s_axis_tready[i]),
        .ctrl_s_axis_tlast(ctrl_s_axis_tlast[i]),
        .ctrl_s_axis_tdest(ctrl_s_axis_tdata[CTRL_DEST_WIDTH*i +: CTRL_DEST_WIDTH]),
  
        // Outgoing control
        .ctrl_m_axis_tdata(ctrl_m_axis_tdata[AXIS_DATA_WIDTH*i +: AXIS_DATA_WIDTH]),
        .ctrl_m_axis_tvalid(ctrl_m_axis_tvalid[i]),
        .ctrl_m_axis_tready(ctrl_m_axis_tready[i]),
        .ctrl_m_axis_tlast(ctrl_m_axis_tlast[i]),
        .ctrl_m_axis_tuser(ctrl_m_axis_tuser[CTRL_USER_WIDTH*i +: CTRL_USER_WIDTH]),
   
        // ------------- CORE MSG CHANNEL -------------- // 
        // Core messages output  
        .core_msg_out_data(core_msg_out_data[CORE_MSG_WIDTH*i +: CORE_MSG_WIDTH]),
        .core_msg_out_valid(core_msg_out_valid[i]),
        .core_msg_out_ready(core_msg_out_ready[i]),

        // Core messages input
        .core_msg_in_data(core_msg_in_data[CORE_MSG_WIDTH*i +: CORE_MSG_WIDTH]),
        .core_msg_in_valid(core_msg_in_valid[i])
    );
  end

endgenerate

// core message broadcast system
wire core_msg_merged_valid;
wire core_msg_merged_ready;
wire [CORE_MSG_WIDTH-1:0] core_msg_merged_data;

axis_arb_mux #
(
    .S_COUNT(CORE_COUNT),
    .DATA_WIDTH(CORE_MSG_WIDTH),
    .USER_ENABLE(0),
    .KEEP_ENABLE(0)
) cores_to_broadcaster
(
    .clk(clk),
    .rst(rst),

    /*
     * AXI Stream inputs
     */
    .s_axis_tdata(core_msg_out_data),
    .s_axis_tkeep(),
    .s_axis_tvalid(core_msg_out_valid),
    .s_axis_tready(core_msg_out_ready),
    .s_axis_tlast({CORE_COUNT{1'b1}}),
    .s_axis_tid(0),
    .s_axis_tdest(0),
    .s_axis_tuser(0),

    /*
     * AXI Stream output
     */
    .m_axis_tdata(core_msg_merged_data),
    .m_axis_tkeep(),
    .m_axis_tvalid(core_msg_merged_valid),
    .m_axis_tready(core_msg_merged_ready),
    .m_axis_tlast(),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser()
);

// Broadcast the arbitted core messages. Since cores always accept
// the last cycle's core_msg_out_ready is the sender, so no broadcast to sender
reg [CORE_COUNT-1:0] core_msg_out_ready_r;
always @ (posedge clk)
  if (rst)
    core_msg_out_ready_r <= {CORE_COUNT{1'b1}};
  else
    core_msg_out_ready_r <= ~core_msg_out_ready;

assign core_msg_in_data = {CORE_COUNT{core_msg_merged_data}};
assign core_msg_in_valid = {CORE_COUNT{core_msg_merged_valid}} & core_msg_out_ready_r;
assign core_msg_merged_ready = 1'b1;

// ILA
if (ENABLE_ILA) begin
  reg [63:0] useful_tdest_h, useful_tdest_l;
  integer k;
  always @ (*)
    for (k=0; k<8; k=k+1) begin
      useful_tdest_h[k*8+:8]=data_s_axis_tdest[96+(k*12)+:8];
      useful_tdest_l[k*8+:8]=data_s_axis_tdest[k*12+:8];
    end

  ila_8x64 debugger3 (
    .clk    (clk),
 
    .trig_out(),
    .trig_out_ack(1'b0),
    .trig_in (1'b0),
    .trig_in_ack(),
 
    .probe0 ({
      data_s_axis_tvalid,
      data_s_axis_tready,
      data_s_axis_tlast,
      data_s_axis_tuser
    }),

    .probe1 ({
      data_m_axis_tvalid,
      data_m_axis_tready,
      data_m_axis_tlast,
      data_m_axis_tdest
    }),
        
    .probe2 (data_m_axis_tkeep[63:0]),
    .probe3 (data_m_axis_tkeep[127:64]),

    .probe4 (data_s_axis_tkeep[63:0]),
    .probe5 (data_s_axis_tkeep[127:64]),
    .probe6 (useful_tdest_l),
    .probe7 (useful_tdest_h)

  );
end

endmodule

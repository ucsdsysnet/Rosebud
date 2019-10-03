/*

Copyright 2019, The Regents of the University of California.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE REGENTS OF THE UNIVERSITY OF CALIFORNIA ''AS
IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE REGENTS OF THE UNIVERSITY OF CALIFORNIA OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of The Regents of the University of California.

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * FPGA core logic
 */
module fpga_core #
(
    parameter AXIS_PCIE_DATA_WIDTH = 256,
    parameter AXIS_PCIE_KEEP_WIDTH = (AXIS_PCIE_DATA_WIDTH/32)
)
(
    /*
     * Clock: 156.25MHz, 200MHz, 250MHz
     * Synchronous reset
     */
    input  wire       sys_clk,
    input  wire       sys_rst,
    input  wire       pcie_clk,
    input  wire       pcie_rst,
    input  wire       core_clk,
    input  wire       core_rst,

    /*
     * GPIO
     */
    output wire [1:0] sma_led,

    /*
     * PCIe
     */
    output wire [AXIS_PCIE_DATA_WIDTH-1:0] m_axis_rq_tdata,
    output wire [AXIS_PCIE_KEEP_WIDTH-1:0] m_axis_rq_tkeep,
    output wire                            m_axis_rq_tlast,
    input  wire                            m_axis_rq_tready,
    output wire [59:0]                     m_axis_rq_tuser,
    output wire                            m_axis_rq_tvalid,

    input  wire [AXIS_PCIE_DATA_WIDTH-1:0] s_axis_rc_tdata,
    input  wire [AXIS_PCIE_KEEP_WIDTH-1:0] s_axis_rc_tkeep,
    input  wire                            s_axis_rc_tlast,
    output wire                            s_axis_rc_tready,
    input  wire [74:0]                     s_axis_rc_tuser,
    input  wire                            s_axis_rc_tvalid,

    input  wire [AXIS_PCIE_DATA_WIDTH-1:0] s_axis_cq_tdata,
    input  wire [AXIS_PCIE_KEEP_WIDTH-1:0] s_axis_cq_tkeep,
    input  wire                            s_axis_cq_tlast,
    output wire                            s_axis_cq_tready,
    input  wire [84:0]                     s_axis_cq_tuser,
    input  wire                            s_axis_cq_tvalid,

    output wire [AXIS_PCIE_DATA_WIDTH-1:0] m_axis_cc_tdata,
    output wire [AXIS_PCIE_KEEP_WIDTH-1:0] m_axis_cc_tkeep,
    output wire                            m_axis_cc_tlast,
    input  wire                            m_axis_cc_tready,
    output wire [32:0]                     m_axis_cc_tuser,
    output wire                            m_axis_cc_tvalid,

    input  wire [2:0]                      cfg_max_payload,
    input  wire [2:0]                      cfg_max_read_req,
    input  wire                            ext_tag_enable,

    output wire [31:0]                     msi_irq,
    output wire                            status_error_cor,
    output wire                            status_error_uncor,

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

assign sma_led   = 2'd0;

// RISCV system parameters
parameter CORE_COUNT       = 16;
parameter INTERFACE_COUNT  = 2;
parameter PORT_COUNT       = INTERFACE_COUNT+2;
parameter CORE_ADDR_WIDTH  = 16;
parameter SLOT_COUNT       = 8;
parameter PCIE_SLOT_COUNT  = 16;
parameter SLOT_START_ADDR  = 16'h2000;
parameter SLOT_ADDR_STEP   = 16'h0800;
parameter LVL1_DATA_WIDTH  = 128;
parameter LVL1_CTRL_WIDTH  = 32+4; //DON'T CHANGE
parameter LVL1_DRAM_WIDTH  = 64; //DRAM CONTROL
parameter LVL2_DATA_WIDTH  = 64;
parameter LVL2_CTRL_WIDTH  = 32+4; //DON'T CHANGE
parameter LVL2_DRAM_WIDTH  = 64; //DON'T CHANGE
parameter TX_FIFO_DEPTH    = 32768;
parameter RX_FIFO_DEPTH    = 32768;
parameter RECV_DESC_DEPTH  = 8;
parameter SEND_DESC_DEPTH  = 8;
parameter DRAM_DESC_DEPTH  = 16;
parameter MSG_FIFO_DEPTH   = 16;
parameter STG_F_DATA_DEPTH = 8192;
parameter STG_F_CTRL_DEPTH = 32; // TKEEP is not enabled, so 32 words
parameter STG_F_DRAM_DEPTH = 1024; 
parameter IMEM_SIZE_BYTES  = 8192;
parameter DMEM_SIZE_BYTES  = 32768;
parameter COHERENT_START   = 16'h6FFF;
parameter LEN_WIDTH        = 16;
parameter INTERLEAVE       = 1;
parameter DRAM_PORT        = INTERFACE_COUNT+2-1;
parameter LOOPBACK_PORT    = INTERFACE_COUNT+1-1;
parameter LVL1_SW_PORTS    = 4;
parameter CORE_MSG_LVL1    = 16;
parameter SEPARATE_CLOCKS  = 1;
parameter ENABLE_ILA       = 0;

parameter CORE_WIDTH       = $clog2(CORE_COUNT);
parameter PORT_WIDTH       = $clog2(PORT_COUNT);
parameter SLOT_WIDTH       = $clog2(SLOT_COUNT+1);
parameter TAG_WIDTH        = (SLOT_WIDTH>5)? SLOT_WIDTH:5;
parameter ID_TAG_WIDTH     = CORE_WIDTH+TAG_WIDTH;
parameter LVL1_STRB_WIDTH  = LVL1_DATA_WIDTH/8;
parameter LVL2_STRB_WIDTH  = LVL2_DATA_WIDTH/8;
parameter CORE_MSG_WIDTH   = 4+$clog2(DMEM_SIZE_BYTES)+32;
parameter LVL2_SW_PORTS    = CORE_COUNT/LVL1_SW_PORTS;
parameter CORE_MSG_LVL2    = CORE_COUNT/CORE_MSG_LVL1;
parameter LVL1_DEST_BITS   = $clog2(LVL1_SW_PORTS);
parameter DATA_DEST_LVL2   = ID_TAG_WIDTH-LVL1_DEST_BITS;
parameter CTRL_DEST_LVL2   = CORE_WIDTH-LVL1_DEST_BITS;

wire select_core_clk = SEPARATE_CLOCKS ? core_clk : sys_clk;
wire select_core_rst = SEPARATE_CLOCKS ? core_rst : sys_rst;

// ETH interfaces renaming
wire [INTERFACE_COUNT-1:0]    sfp_tx_clk = {sfp_2_tx_clk, sfp_1_tx_clk};
wire [INTERFACE_COUNT-1:0]    sfp_tx_rst = {sfp_2_tx_rst, sfp_2_tx_rst};
wire [INTERFACE_COUNT*64-1:0] sfp_txd;  
wire [INTERFACE_COUNT*8-1:0]  sfp_txc; 
wire [INTERFACE_COUNT-1:0]    sfp_rx_clk = {sfp_2_rx_clk, sfp_1_rx_clk};
wire [INTERFACE_COUNT-1:0]    sfp_rx_rst = {sfp_2_rx_rst, sfp_1_rx_rst};
wire [INTERFACE_COUNT*64-1:0] sfp_rxd    = {sfp_2_rxd,    sfp_1_rxd};
wire [INTERFACE_COUNT*8-1:0]  sfp_rxc    = {sfp_2_rxc,    sfp_1_rxc};   

assign sfp_1_txd = sfp_txd[63:0];
assign sfp_1_txc = sfp_txc[7:0];
assign sfp_2_txd = sfp_txd[127:64];
assign sfp_2_txc = sfp_txc[15:8];

// ETH interfaces MAC
wire [INTERFACE_COUNT*LVL1_DATA_WIDTH-1:0] tx_axis_tdata;
wire [INTERFACE_COUNT*LVL1_STRB_WIDTH-1:0] tx_axis_tkeep;
wire [INTERFACE_COUNT-1:0] tx_axis_tvalid, tx_axis_tready, tx_axis_tlast;

wire [INTERFACE_COUNT*LVL1_DATA_WIDTH-1:0] rx_axis_tdata;
wire [INTERFACE_COUNT*LVL1_STRB_WIDTH-1:0] rx_axis_tkeep;
wire [INTERFACE_COUNT-1:0] rx_axis_tvalid, rx_axis_tready, rx_axis_tlast;

genvar l;
generate
    for (l=0;l<INTERFACE_COUNT;l=l+1)
        eth_mac_10g_fifo #
        (
            .DATA_WIDTH(64),
            .AXIS_DATA_WIDTH(LVL1_DATA_WIDTH),
            .ENABLE_PADDING(1),
            .ENABLE_DIC(1),
            .TX_FIFO_DEPTH(TX_FIFO_DEPTH),
            .TX_DROP_WHEN_FULL(0),
            .RX_FIFO_DEPTH(RX_FIFO_DEPTH)
        ) eth_mac
        (
            .rx_clk(sfp_rx_clk[l]),
            .rx_rst(sfp_rx_rst[l]),
            .tx_clk(sfp_tx_clk[l]),
            .tx_rst(sfp_tx_rst[l]),
            .logic_clk(sys_clk),
            .logic_rst(sys_rst),
        
            /*
             * XGMII interface
             */
            .xgmii_rxd(sfp_rxd[l*64 +:64]),
            .xgmii_rxc(sfp_rxc[l*8  +:8]),
            .xgmii_txd(sfp_txd[l*64 +:64]),
            .xgmii_txc(sfp_txc[l*8  +:8]),
            
            /*
             * AXI input
             */
            .tx_axis_tdata(tx_axis_tdata[l*LVL1_DATA_WIDTH +: LVL1_DATA_WIDTH]),
            .tx_axis_tkeep(tx_axis_tkeep[l*LVL1_STRB_WIDTH +: LVL1_STRB_WIDTH]),
            .tx_axis_tvalid(tx_axis_tvalid[l]),
            .tx_axis_tready(tx_axis_tready[l]),
            .tx_axis_tlast(tx_axis_tlast[l]),
            .tx_axis_tuser(1'b0),
        
            /*
             * AXI output
             */
            .rx_axis_tdata(rx_axis_tdata[l*LVL1_DATA_WIDTH +: LVL1_DATA_WIDTH]),
            .rx_axis_tkeep(rx_axis_tkeep[l*LVL1_STRB_WIDTH +: LVL1_STRB_WIDTH]),
            .rx_axis_tvalid(rx_axis_tvalid[l]),
            .rx_axis_tready(rx_axis_tready[l]),
            .rx_axis_tlast(rx_axis_tlast[l]),
            .rx_axis_tuser(),
        
            /*
             * Status
             */
            .rx_fifo_overflow(),
            .rx_fifo_good_frame(), 
            .tx_error_underflow(),
            .tx_fifo_overflow(), 
            .tx_fifo_bad_frame(),
            .tx_fifo_good_frame(), 
            .rx_error_bad_frame(),
            .rx_error_bad_fcs(),
            .rx_fifo_bad_frame(),
        
            /*
             * Configuration
             */
            .ifg_delay(8'd12),
        
            /*
             * PTP not used
             */
            .ptp_ts_96(96'd0),
            .m_axis_rx_ptp_ts_ready(1'b0),
            .m_axis_tx_ptp_ts_ready(1'b0),
            .s_axis_tx_ptp_ts_tag (16'd0),
            .s_axis_tx_ptp_ts_valid (1'b0),
            .ptp_sample_clk (1'b0)
        );
endgenerate

// PCIE and DRAM controller 

// DRAM DMA controller data 
wire [LVL1_DATA_WIDTH-1:0] dram_tx_axis_tdata;
wire [LVL1_STRB_WIDTH-1:0] dram_tx_axis_tkeep;
wire [PORT_WIDTH-1:0]      dram_tx_axis_tdest;
wire [ID_TAG_WIDTH-1:0]    dram_tx_axis_tuser;
wire                       dram_tx_axis_tvalid, 
                           dram_tx_axis_tready, 
                           dram_tx_axis_tlast;

wire [LVL1_DATA_WIDTH-1:0] dram_rx_axis_tdata;
wire [LVL1_STRB_WIDTH-1:0] dram_rx_axis_tkeep;
wire [ID_TAG_WIDTH-1:0]    dram_rx_axis_tdest;
wire [PORT_WIDTH-1:0]      dram_rx_axis_tuser;
wire                       dram_rx_axis_tvalid, 
                           dram_rx_axis_tready, 
                           dram_rx_axis_tlast;

// outgoing channel
wire [LVL1_DRAM_WIDTH-1:0] dram_ctrl_m_axis_tdata;
wire                       dram_ctrl_m_axis_tvalid;
wire                       dram_ctrl_m_axis_tready;
wire                       dram_ctrl_m_axis_tlast;
wire [CORE_WIDTH-1:0]      dram_ctrl_m_axis_tuser;

// incoming channel
wire [LVL1_DRAM_WIDTH-1:0] dram_ctrl_s_axis_tdata;
wire                       dram_ctrl_s_axis_tvalid;
wire                       dram_ctrl_s_axis_tready;
wire                       dram_ctrl_s_axis_tlast;
wire [CORE_WIDTH-1:0]      dram_ctrl_s_axis_tdest;

pcie_controller #
(
  .AXIS_PCIE_DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
  .AXIS_PCIE_KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
  .AXIS_DATA_WIDTH(LVL1_DATA_WIDTH),
  .AXIS_KEEP_WIDTH(LVL1_STRB_WIDTH),
  .AXIS_TAG_WIDTH(ID_TAG_WIDTH),  
  .CORE_DESC_WIDTH(LVL1_DRAM_WIDTH),
  .CORE_COUNT(CORE_COUNT),        
  .CORE_ADDR_WIDTH(CORE_ADDR_WIDTH), 
  .PCIE_SLOT_COUNT(PCIE_SLOT_COUNT)
) pcie_controller_inst (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .pcie_clk(pcie_clk),
  .pcie_rst(pcie_rst),

  /*
   * PCIe
   */
  .m_axis_rq_tdata   (m_axis_rq_tdata),
  .m_axis_rq_tkeep   (m_axis_rq_tkeep),
  .m_axis_rq_tlast   (m_axis_rq_tlast),
  .m_axis_rq_tready  (m_axis_rq_tready),
  .m_axis_rq_tuser   (m_axis_rq_tuser),
  .m_axis_rq_tvalid  (m_axis_rq_tvalid),

  .s_axis_rc_tdata   (s_axis_rc_tdata),
  .s_axis_rc_tkeep   (s_axis_rc_tkeep),
  .s_axis_rc_tlast   (s_axis_rc_tlast),
  .s_axis_rc_tready  (s_axis_rc_tready),
  .s_axis_rc_tuser   (s_axis_rc_tuser),
  .s_axis_rc_tvalid  (s_axis_rc_tvalid),

  .s_axis_cq_tdata   (s_axis_cq_tdata),
  .s_axis_cq_tkeep   (s_axis_cq_tkeep),
  .s_axis_cq_tlast   (s_axis_cq_tlast),
  .s_axis_cq_tready  (s_axis_cq_tready),
  .s_axis_cq_tuser   (s_axis_cq_tuser),
  .s_axis_cq_tvalid  (s_axis_cq_tvalid),

  .m_axis_cc_tdata   (m_axis_cc_tdata),
  .m_axis_cc_tkeep   (m_axis_cc_tkeep),
  .m_axis_cc_tlast   (m_axis_cc_tlast),
  .m_axis_cc_tready  (m_axis_cc_tready),
  .m_axis_cc_tuser   (m_axis_cc_tuser),
  .m_axis_cc_tvalid  (m_axis_cc_tvalid),

  .cfg_max_payload   (cfg_max_payload),
  .cfg_max_read_req  (cfg_max_read_req),
  .ext_tag_enable    (ext_tag_enable),

  .msi_irq           (msi_irq),
  .status_error_cor  (status_error_cor),
  .status_error_uncor(status_error_uncor),
  
  // Cores data
  .cores_tx_axis_tdata (dram_tx_axis_tdata),
  .cores_tx_axis_tkeep (dram_tx_axis_tkeep),
  .cores_tx_axis_tuser (dram_tx_axis_tuser),
  .cores_tx_axis_tvalid(dram_tx_axis_tvalid), 
  .cores_tx_axis_tready(dram_tx_axis_tready), 
  .cores_tx_axis_tlast (dram_tx_axis_tlast),
  
  .cores_rx_axis_tdata (dram_rx_axis_tdata),
  .cores_rx_axis_tkeep (dram_rx_axis_tkeep),
  .cores_rx_axis_tdest (dram_rx_axis_tdest),
  .cores_rx_axis_tvalid(dram_rx_axis_tvalid), 
  .cores_rx_axis_tready(dram_rx_axis_tready), 
  .cores_rx_axis_tlast (dram_rx_axis_tlast),
  
  // Cores DRAM requests
  .cores_ctrl_s_axis_tdata (dram_ctrl_m_axis_tdata),
  .cores_ctrl_s_axis_tvalid(dram_ctrl_m_axis_tvalid),
  .cores_ctrl_s_axis_tready(dram_ctrl_m_axis_tready),
  .cores_ctrl_s_axis_tlast (dram_ctrl_m_axis_tlast),
  .cores_ctrl_s_axis_tuser (dram_ctrl_m_axis_tuser),
  
  .cores_ctrl_m_axis_tdata (dram_ctrl_s_axis_tdata),
  .cores_ctrl_m_axis_tvalid(dram_ctrl_s_axis_tvalid),
  .cores_ctrl_m_axis_tready(dram_ctrl_s_axis_tready),
  .cores_ctrl_m_axis_tlast (dram_ctrl_s_axis_tlast),
  .cores_ctrl_m_axis_tdest (dram_ctrl_s_axis_tdest)
);

// no use for dram_tx_axis_tdest
assign dram_rx_axis_tuser = DRAM_PORT;

// Loopback message FIFO module
wire [LVL1_DATA_WIDTH-1:0] loopback_tx_axis_tdata;
wire [LVL1_STRB_WIDTH-1:0] loopback_tx_axis_tkeep;
wire [PORT_WIDTH-1:0]      loopback_tx_axis_tdest;
wire [ID_TAG_WIDTH-1:0]    loopback_tx_axis_tuser;
wire                       loopback_tx_axis_tvalid, 
                           loopback_tx_axis_tready, 
                           loopback_tx_axis_tlast;

wire [LVL1_DATA_WIDTH-1:0] loopback_rx_axis_tdata;
wire [LVL1_STRB_WIDTH-1:0] loopback_rx_axis_tkeep;
wire [ID_TAG_WIDTH-1:0]    loopback_rx_axis_tdest;
wire [PORT_WIDTH-1:0]      loopback_rx_axis_tuser;
wire                       loopback_rx_axis_tvalid, 
                           loopback_rx_axis_tready, 
                           loopback_rx_axis_tlast;

// Scheduler 
wire [INTERFACE_COUNT*LVL1_DATA_WIDTH-1:0] sched_tx_axis_tdata;
wire [INTERFACE_COUNT*LVL1_STRB_WIDTH-1:0] sched_tx_axis_tkeep;
wire [INTERFACE_COUNT*PORT_WIDTH-1:0]      sched_tx_axis_tdest;
wire [INTERFACE_COUNT*ID_TAG_WIDTH-1:0]    sched_tx_axis_tuser;
wire [INTERFACE_COUNT-1:0]                 sched_tx_axis_tvalid, 
                                           sched_tx_axis_tready, 
                                           sched_tx_axis_tlast;

wire [INTERFACE_COUNT*LVL1_DATA_WIDTH-1:0] sched_rx_axis_tdata;
wire [INTERFACE_COUNT*LVL1_STRB_WIDTH-1:0] sched_rx_axis_tkeep;
wire [INTERFACE_COUNT*ID_TAG_WIDTH-1:0]    sched_rx_axis_tdest;
wire [INTERFACE_COUNT*PORT_WIDTH-1:0]      sched_rx_axis_tuser;
wire [INTERFACE_COUNT-1:0]                 sched_rx_axis_tvalid, 
                                           sched_rx_axis_tready, 
                                           sched_rx_axis_tlast;
    
wire [LVL1_CTRL_WIDTH-1:0]                 sched_ctrl_m_axis_tdata;
wire                                       sched_ctrl_m_axis_tvalid;
wire                                       sched_ctrl_m_axis_tready;
wire                                       sched_ctrl_m_axis_tlast;
wire [CORE_WIDTH-1:0]                      sched_ctrl_m_axis_tdest;

wire [LVL1_CTRL_WIDTH-1:0]                 sched_ctrl_s_axis_tdata;
wire                                       sched_ctrl_s_axis_tvalid;
wire                                       sched_ctrl_s_axis_tready;
wire                                       sched_ctrl_s_axis_tlast;
wire [CORE_WIDTH-1:0]                      sched_ctrl_s_axis_tuser;

wire [ID_TAG_WIDTH-1:0]                    loopback_msg_src;
wire [ID_TAG_WIDTH-1:0]                    loopback_msg_dest;
wire                                       loopback_msg_valid;
wire                                       loopback_msg_ready;

simple_scheduler # (
  .PORT_COUNT(PORT_COUNT),
  .INTERFACE_COUNT(INTERFACE_COUNT),
  .CORE_COUNT(CORE_COUNT),
  .SLOT_COUNT(SLOT_COUNT),
  .DATA_WIDTH(LVL1_DATA_WIDTH),
  .CTRL_WIDTH(LVL1_CTRL_WIDTH),
  .LEN_WIDTH(LEN_WIDTH),
  .LVL1_SW_PORTS(LVL1_SW_PORTS),
  .LOOPBACK_PORT(LOOPBACK_PORT),
  .ENABLE_ILA(ENABLE_ILA)
) scheduler (
  .clk(sys_clk),
  .rst(sys_rst),

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
  .ctrl_s_axis_tuser(sched_ctrl_s_axis_tuser),
  
  // Descriptor for Loopback message FIFO among cores
  .loopback_msg_src  (loopback_msg_src),
  .loopback_msg_dest (loopback_msg_dest),
  .loopback_msg_valid(loopback_msg_valid),
  .loopback_msg_ready(loopback_msg_ready)
);


// Loopback inter core message FIFO
loopback_msg_fifo # (
  .DATA_WIDTH(LVL1_DATA_WIDTH),
  .STRB_WIDTH(LVL1_STRB_WIDTH),
  .PORT_WIDTH(PORT_WIDTH),
  .CORE_WIDTH(CORE_WIDTH), 
  .SLOT_WIDTH(SLOT_WIDTH),
  .ID_TAG_WIDTH(ID_TAG_WIDTH)
) loopback_msg_fifo_inst (
    .clk(sys_clk),
    .rst(sys_rst),

    .s_axis_tdata (loopback_tx_axis_tdata),
    .s_axis_tkeep (loopback_tx_axis_tkeep),
    .s_axis_tvalid(loopback_tx_axis_tvalid),
    .s_axis_tready(loopback_tx_axis_tready),
    .s_axis_tlast (loopback_tx_axis_tlast),
    .s_axis_tdest (loopback_tx_axis_tdest),
    .s_axis_tuser (loopback_tx_axis_tuser),
  
    .m_axis_tdata (loopback_rx_axis_tdata),
    .m_axis_tkeep (loopback_rx_axis_tkeep),
    .m_axis_tvalid(loopback_rx_axis_tvalid),
    .m_axis_tready(loopback_rx_axis_tready),
    .m_axis_tlast (loopback_rx_axis_tlast),
    .m_axis_tdest (loopback_rx_axis_tdest),
    .m_axis_tuser (loopback_rx_axis_tuser),
 
    .msg_src  (loopback_msg_src), 
    .msg_dest (loopback_msg_dest),
    .msg_valid(loopback_msg_valid),
    .msg_ready(loopback_msg_ready)
);

// Switches

// Level 1
wire [LVL1_SW_PORTS*LVL1_DATA_WIDTH-1:0] int_data_s_axis_tdata;
wire [LVL1_SW_PORTS*LVL1_STRB_WIDTH-1:0] int_data_s_axis_tkeep;
wire [LVL1_SW_PORTS*ID_TAG_WIDTH-1:0]    int_data_s_axis_tdest;
wire [LVL1_SW_PORTS*PORT_WIDTH-1:0]      int_data_s_axis_tuser;
wire [LVL1_SW_PORTS-1:0]                 int_data_s_axis_tvalid, 
                                         int_data_s_axis_tready, 
                                         int_data_s_axis_tlast;

wire [LVL1_SW_PORTS*LVL2_DATA_WIDTH-1:0] int_data_m_axis_tdata;
wire [LVL1_SW_PORTS*LVL2_STRB_WIDTH-1:0] int_data_m_axis_tkeep;
wire [LVL1_SW_PORTS*PORT_WIDTH-1:0]      int_data_m_axis_tdest;
wire [LVL1_SW_PORTS*ID_TAG_WIDTH-1:0]    int_data_m_axis_tuser;
wire [LVL1_SW_PORTS-1:0]                 int_data_m_axis_tvalid, 
                                         int_data_m_axis_tready, 
                                         int_data_m_axis_tlast;

wire [LVL1_SW_PORTS*LVL1_CTRL_WIDTH-1:0] int_ctrl_s_axis_tdata;
wire [LVL1_SW_PORTS*CORE_WIDTH-1:0]      int_ctrl_s_axis_tdest;
wire [LVL1_SW_PORTS-1:0]                 int_ctrl_s_axis_tvalid, 
                                         int_ctrl_s_axis_tready, 
                                         int_ctrl_s_axis_tlast;

wire [LVL1_SW_PORTS*LVL2_CTRL_WIDTH-1:0] int_ctrl_m_axis_tdata;
wire [LVL1_SW_PORTS*CORE_WIDTH-1:0]      int_ctrl_m_axis_tuser;
wire [LVL1_SW_PORTS-1:0]                 int_ctrl_m_axis_tvalid, 
                                         int_ctrl_m_axis_tready, 
                                         int_ctrl_m_axis_tlast;

wire [LVL1_SW_PORTS*LVL1_DRAM_WIDTH-1:0] int_dram_ctrl_s_axis_tdata;
wire [LVL1_SW_PORTS*CORE_WIDTH-1:0]      int_dram_ctrl_s_axis_tdest;
wire [LVL1_SW_PORTS-1:0]                 int_dram_ctrl_s_axis_tvalid, 
                                         int_dram_ctrl_s_axis_tready, 
                                         int_dram_ctrl_s_axis_tlast;

wire [LVL1_SW_PORTS*LVL2_DRAM_WIDTH-1:0] int_dram_ctrl_m_axis_tdata;
wire [LVL1_SW_PORTS*CORE_WIDTH-1:0]      int_dram_ctrl_m_axis_tuser;
wire [LVL1_SW_PORTS-1:0]                 int_dram_ctrl_m_axis_tvalid, 
                                         int_dram_ctrl_m_axis_tready, 
                                         int_dram_ctrl_m_axis_tlast;

wire [LVL1_SW_PORTS*LVL2_DATA_WIDTH-1:0] int_data_s_axis_tdata_f;
wire [LVL1_SW_PORTS*LVL2_STRB_WIDTH-1:0] int_data_s_axis_tkeep_f;
wire [LVL1_SW_PORTS*ID_TAG_WIDTH-1:0]    int_data_s_axis_tdest_f;
wire [LVL1_SW_PORTS*PORT_WIDTH-1:0]      int_data_s_axis_tuser_f;
wire [LVL1_SW_PORTS-1:0]                 int_data_s_axis_tvalid_f, 
                                         int_data_s_axis_tready_f, 
                                         int_data_s_axis_tlast_f;

wire [LVL1_SW_PORTS*LVL1_DATA_WIDTH-1:0] int_data_m_axis_tdata_f;
wire [LVL1_SW_PORTS*LVL1_STRB_WIDTH-1:0] int_data_m_axis_tkeep_f;
wire [LVL1_SW_PORTS*PORT_WIDTH-1:0]      int_data_m_axis_tdest_f;
wire [LVL1_SW_PORTS*ID_TAG_WIDTH-1:0]    int_data_m_axis_tuser_f;
wire [LVL1_SW_PORTS-1:0]                 int_data_m_axis_tvalid_f, 
                                         int_data_m_axis_tready_f, 
                                         int_data_m_axis_tlast_f;

wire [LVL1_SW_PORTS*LVL2_CTRL_WIDTH-1:0] int_ctrl_s_axis_tdata_f;
wire [LVL1_SW_PORTS*CORE_WIDTH-1:0]      int_ctrl_s_axis_tdest_f;
wire [LVL1_SW_PORTS-1:0]                 int_ctrl_s_axis_tvalid_f, 
                                         int_ctrl_s_axis_tready_f, 
                                         int_ctrl_s_axis_tlast_f;

wire [LVL1_SW_PORTS*LVL1_CTRL_WIDTH-1:0] int_ctrl_m_axis_tdata_f;
wire [LVL1_SW_PORTS*CORE_WIDTH-1:0]      int_ctrl_m_axis_tuser_f;
wire [LVL1_SW_PORTS-1:0]                 int_ctrl_m_axis_tvalid_f, 
                                         int_ctrl_m_axis_tready_f, 
                                         int_ctrl_m_axis_tlast_f;

wire [LVL1_SW_PORTS*LVL2_DRAM_WIDTH-1:0] int_dram_ctrl_s_axis_tdata_f;
wire [LVL1_SW_PORTS*CORE_WIDTH-1:0]      int_dram_ctrl_s_axis_tdest_f;
wire [LVL1_SW_PORTS-1:0]                 int_dram_ctrl_s_axis_tvalid_f, 
                                         int_dram_ctrl_s_axis_tready_f, 
                                         int_dram_ctrl_s_axis_tlast_f;

wire [LVL1_SW_PORTS*LVL1_DRAM_WIDTH-1:0] int_dram_ctrl_m_axis_tdata_f;
wire [LVL1_SW_PORTS*CORE_WIDTH-1:0]      int_dram_ctrl_m_axis_tuser_f;
wire [LVL1_SW_PORTS-1:0]                 int_dram_ctrl_m_axis_tvalid_f, 
                                         int_dram_ctrl_m_axis_tready_f, 
                                         int_dram_ctrl_m_axis_tlast_f;

// Data channel switch
axis_switch #
(
    .S_COUNT(PORT_COUNT),
    .M_COUNT(LVL1_SW_PORTS),
    .DATA_WIDTH(LVL1_DATA_WIDTH),
    .DEST_WIDTH(ID_TAG_WIDTH),
    .USER_WIDTH(PORT_WIDTH),
    .S_REG_TYPE(2),
    .M_REG_TYPE(2)
) data_in_sw_lvl1
(
    .clk(sys_clk),
    .rst(sys_rst),

    /*
     * AXI Stream inputs
     */
    .s_axis_tdata( {dram_rx_axis_tdata, loopback_rx_axis_tdata, sched_rx_axis_tdata}),
    .s_axis_tkeep( {dram_rx_axis_tkeep, loopback_rx_axis_tkeep, sched_rx_axis_tkeep}),
    .s_axis_tvalid({dram_rx_axis_tvalid,loopback_rx_axis_tvalid,sched_rx_axis_tvalid}),
    .s_axis_tready({dram_rx_axis_tready,loopback_rx_axis_tready,sched_rx_axis_tready}),
    .s_axis_tlast( {dram_rx_axis_tlast, loopback_rx_axis_tlast, sched_rx_axis_tlast}),
    .s_axis_tid({PORT_COUNT{8'd0}}),
    .s_axis_tdest( {dram_rx_axis_tdest, loopback_rx_axis_tdest, sched_rx_axis_tdest}),
    .s_axis_tuser( {dram_rx_axis_tuser, loopback_rx_axis_tuser, sched_rx_axis_tuser}),

    /*
     * AXI Stream outputs
     */
    .m_axis_tdata(int_data_s_axis_tdata),
    .m_axis_tkeep(int_data_s_axis_tkeep),
    .m_axis_tvalid(int_data_s_axis_tvalid),
    .m_axis_tready(int_data_s_axis_tready),
    .m_axis_tlast(int_data_s_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(int_data_s_axis_tdest),
    .m_axis_tuser(int_data_s_axis_tuser)
);

axis_switch #
(
    .S_COUNT(LVL1_SW_PORTS),
    .M_COUNT(PORT_COUNT),
    .DATA_WIDTH(LVL1_DATA_WIDTH),
    .DEST_WIDTH(PORT_WIDTH),
    .USER_WIDTH(ID_TAG_WIDTH),
    .S_REG_TYPE(2),
    .M_REG_TYPE(2)
) data_out_sw_lvl1
(
    .clk(sys_clk),
    .rst(sys_rst),

    /*
     * AXI Stream inputs
     */
    .s_axis_tdata(int_data_m_axis_tdata_f),
    .s_axis_tkeep(int_data_m_axis_tkeep_f),
    .s_axis_tvalid(int_data_m_axis_tvalid_f),
    .s_axis_tready(int_data_m_axis_tready_f),
    .s_axis_tlast(int_data_m_axis_tlast_f),
    .s_axis_tid({LVL1_SW_PORTS{8'd0}}),
    .s_axis_tdest(int_data_m_axis_tdest_f),
    .s_axis_tuser(int_data_m_axis_tuser_f),

    /*
     * AXI Stream outputs
     */
    .m_axis_tdata( {dram_tx_axis_tdata, loopback_tx_axis_tdata, sched_tx_axis_tdata}),
    .m_axis_tkeep( {dram_tx_axis_tkeep, loopback_tx_axis_tkeep, sched_tx_axis_tkeep}),
    .m_axis_tvalid({dram_tx_axis_tvalid,loopback_tx_axis_tvalid,sched_tx_axis_tvalid}),
    .m_axis_tready({dram_tx_axis_tready,loopback_tx_axis_tready,sched_tx_axis_tready}),
    .m_axis_tlast( {dram_tx_axis_tlast, loopback_tx_axis_tlast, sched_tx_axis_tlast}),
    .m_axis_tid(),                      
    .m_axis_tdest( {dram_tx_axis_tdest, loopback_tx_axis_tdest, sched_tx_axis_tdest}),
    .m_axis_tuser( {dram_tx_axis_tuser, loopback_tx_axis_tuser, sched_tx_axis_tuser})

);

axis_switch #
(
    .S_COUNT(1),
    .M_COUNT(LVL1_SW_PORTS),
    .DATA_WIDTH(LVL1_CTRL_WIDTH),
    .DEST_WIDTH(CORE_WIDTH),
    .USER_ENABLE(0),
    .KEEP_ENABLE(0),
    .S_REG_TYPE(2),
    .M_REG_TYPE(2)
) ctrl_in_sw_lvl1
(
    .clk(sys_clk),
    .rst(sys_rst),

    /*
     * AXI Stream inputs
     */
    .s_axis_tdata(sched_ctrl_m_axis_tdata),
    .s_axis_tkeep(),
    .s_axis_tvalid(sched_ctrl_m_axis_tvalid),
    .s_axis_tready(sched_ctrl_m_axis_tready),
    .s_axis_tlast(sched_ctrl_m_axis_tlast),
    .s_axis_tid(8'd0),
    .s_axis_tdest(sched_ctrl_m_axis_tdest),
    .s_axis_tuser(),

    /*
     * AXI Stream outputs
     */
    .m_axis_tdata(int_ctrl_s_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tvalid(int_ctrl_s_axis_tvalid),
    .m_axis_tready(int_ctrl_s_axis_tready),
    .m_axis_tlast(int_ctrl_s_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(int_ctrl_s_axis_tdest),
    .m_axis_tuser()
);


axis_arb_mux #
(
    .S_COUNT(LVL1_SW_PORTS),
    .DATA_WIDTH(LVL1_CTRL_WIDTH),
    .USER_WIDTH(CORE_WIDTH),
    .KEEP_ENABLE(0)
) ctrl_out_sw_lvl1
(
    .clk(sys_clk),
    .rst(sys_rst),

    /*
     * AXI Stream inputs
     */
    .s_axis_tdata(int_ctrl_m_axis_tdata_f),
    .s_axis_tkeep(),
    .s_axis_tvalid(int_ctrl_m_axis_tvalid_f),
    .s_axis_tready(int_ctrl_m_axis_tready_f),
    .s_axis_tlast(int_ctrl_m_axis_tlast_f),
    .s_axis_tid(),
    .s_axis_tdest(),
    .s_axis_tuser(int_ctrl_m_axis_tuser_f),

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

axis_switch #
(
    .S_COUNT(1),
    .M_COUNT(LVL1_SW_PORTS),
    .DATA_WIDTH(LVL1_DRAM_WIDTH),
    .DEST_WIDTH(CORE_WIDTH),
    .USER_ENABLE(0),
    .KEEP_ENABLE(0),
    .S_REG_TYPE(2),
    .M_REG_TYPE(2)
) dram_ctrl_in_sw_lvl1
(
    .clk(sys_clk),
    .rst(sys_rst),

    /*
     * AXI Stream inputs
     */
    .s_axis_tdata(dram_ctrl_s_axis_tdata),
    .s_axis_tkeep(),
    .s_axis_tvalid(dram_ctrl_s_axis_tvalid),
    .s_axis_tready(dram_ctrl_s_axis_tready),
    .s_axis_tlast(dram_ctrl_s_axis_tlast),
    .s_axis_tid(8'd0),
    .s_axis_tdest(dram_ctrl_s_axis_tdest),
    .s_axis_tuser(),

    /*
     * AXI Stream outputs
     */
    .m_axis_tdata(int_dram_ctrl_s_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tvalid(int_dram_ctrl_s_axis_tvalid),
    .m_axis_tready(int_dram_ctrl_s_axis_tready),
    .m_axis_tlast(int_dram_ctrl_s_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(int_dram_ctrl_s_axis_tdest),
    .m_axis_tuser()
);


axis_arb_mux #
(
    .S_COUNT(LVL1_SW_PORTS),
    .DATA_WIDTH(LVL1_DRAM_WIDTH),
    .USER_WIDTH(CORE_WIDTH),
    .KEEP_ENABLE(0)
) dram_ctrl_out_sw_lvl1
(
    .clk(sys_clk),
    .rst(sys_rst),

    /*
     * AXI Stream inputs
     */
    .s_axis_tdata(int_dram_ctrl_m_axis_tdata_f),
    .s_axis_tkeep(),
    .s_axis_tvalid(int_dram_ctrl_m_axis_tvalid_f),
    .s_axis_tready(int_dram_ctrl_m_axis_tready_f),
    .s_axis_tlast(int_dram_ctrl_m_axis_tlast_f),
    .s_axis_tid(),
    .s_axis_tdest(),
    .s_axis_tuser(int_dram_ctrl_m_axis_tuser_f),

    /*
     * AXI Stream output
     */
    .m_axis_tdata(dram_ctrl_m_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tvalid(dram_ctrl_m_axis_tvalid),
    .m_axis_tready(dram_ctrl_m_axis_tready),
    .m_axis_tlast(dram_ctrl_m_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(dram_ctrl_m_axis_tuser)
);

// Level 2 Switches

wire [CORE_COUNT*LVL2_DATA_WIDTH-1:0] data_s_axis_tdata;
wire [CORE_COUNT*LVL2_STRB_WIDTH-1:0] data_s_axis_tkeep;
wire [CORE_COUNT*DATA_DEST_LVL2-1:0]  data_s_axis_tdest;
wire [CORE_COUNT*PORT_WIDTH-1:0]      data_s_axis_tuser;
wire [CORE_COUNT-1:0]                 data_s_axis_tvalid, 
                                      data_s_axis_tready, 
                                      data_s_axis_tlast;

wire [CORE_COUNT*LVL2_DATA_WIDTH-1:0] data_m_axis_tdata;
wire [CORE_COUNT*LVL2_STRB_WIDTH-1:0] data_m_axis_tkeep;
wire [CORE_COUNT*PORT_WIDTH-1:0]      data_m_axis_tdest;
wire [CORE_COUNT*ID_TAG_WIDTH-1:0]    data_m_axis_tuser;
wire [CORE_COUNT-1:0]                 data_m_axis_tvalid, 
                                      data_m_axis_tready, 
                                      data_m_axis_tlast;

wire [CORE_COUNT*LVL2_CTRL_WIDTH-1:0] ctrl_s_axis_tdata;
wire [CORE_COUNT-1:0]                 ctrl_s_axis_tvalid, 
                                      ctrl_s_axis_tready, 
                                      ctrl_s_axis_tlast;

wire [CORE_COUNT*LVL2_CTRL_WIDTH-1:0] ctrl_m_axis_tdata;
wire [CORE_COUNT*CORE_WIDTH-1:0]      ctrl_m_axis_tuser;
wire [CORE_COUNT-1:0]                 ctrl_m_axis_tvalid, 
                                      ctrl_m_axis_tready, 
                                      ctrl_m_axis_tlast;

wire [CORE_COUNT*LVL2_DRAM_WIDTH-1:0] dram_s_axis_tdata;
wire [CORE_COUNT-1:0]                 dram_s_axis_tvalid, 
                                      dram_s_axis_tready, 
                                      dram_s_axis_tlast;

wire [CORE_COUNT*LVL2_DRAM_WIDTH-1:0] dram_m_axis_tdata;
wire [CORE_COUNT*CORE_WIDTH-1:0]      dram_m_axis_tuser;
wire [CORE_COUNT-1:0]                 dram_m_axis_tvalid, 
                                      dram_m_axis_tready, 
                                      dram_m_axis_tlast;

genvar j;
generate 
  if (LVL2_SW_PORTS == 1) begin
    assign data_s_axis_tdata        = int_data_s_axis_tdata;
    assign data_s_axis_tkeep        = int_data_s_axis_tkeep;
    assign data_s_axis_tuser        = int_data_s_axis_tuser;
    assign data_s_axis_tvalid       = int_data_s_axis_tvalid;
    assign data_s_axis_tlast        = int_data_s_axis_tlast;
    assign int_data_s_axis_tready   = data_s_axis_tready;
    
    for (j=0; j<LVL1_SW_PORTS; j=j+1) 
      assign data_s_axis_tdest[j*DATA_DEST_LVL2 +: DATA_DEST_LVL2] = 
         int_data_s_axis_tdest[j*ID_TAG_WIDTH +: DATA_DEST_LVL2];

    assign int_data_m_axis_tdata_f  = data_m_axis_tdata;
    assign int_data_m_axis_tkeep_f  = data_m_axis_tkeep;
    assign int_data_m_axis_tdest_f  = data_m_axis_tdest;
    assign int_data_m_axis_tuser_f  = data_m_axis_tuser;
    assign int_data_m_axis_tvalid_f = data_m_axis_tvalid;
    assign int_data_m_axis_tlast_f  = data_m_axis_tlast;
    assign data_m_axis_tready       = int_data_m_axis_tready_f;
  
    assign ctrl_s_axis_tdata        = int_ctrl_s_axis_tdata;
    assign ctrl_s_axis_tvalid       = int_ctrl_s_axis_tvalid; 
    assign ctrl_s_axis_tlast        = int_ctrl_s_axis_tlast;
    assign int_ctrl_s_axis_tready   = ctrl_s_axis_tready;
  
    assign int_ctrl_m_axis_tdata_f  = ctrl_m_axis_tdata;
    assign int_ctrl_m_axis_tuser_f  = ctrl_m_axis_tuser;
    assign int_ctrl_m_axis_tvalid_f = ctrl_m_axis_tvalid;
    assign int_ctrl_m_axis_tlast_f  = ctrl_m_axis_tlast;
    assign ctrl_m_axis_tready       = int_ctrl_m_axis_tready_f;
    
    assign dram_s_axis_tdata             = int_dram_ctrl_s_axis_tdata;
    assign dram_s_axis_tvalid            = int_dram_ctrl_s_axis_tvalid; 
    assign dram_s_axis_tlast             = int_dram_ctrl_s_axis_tlast;
    assign int_dram_ctrl_s_axis_tready   = dram_s_axis_tready;    
 
    assign int_dram_ctrl_m_axis_tdata_f  = dram_m_axis_tdata;
    assign int_dram_ctrl_m_axis_tuser_f  = dram_m_axis_tuser;
    assign int_dram_ctrl_m_axis_tvalid_f = dram_m_axis_tvalid;
    assign int_dram_ctrl_m_axis_tlast_f  = dram_m_axis_tlast;
    assign dram_m_axis_tready            = int_dram_ctrl_m_axis_tready_f;
  
  end else begin

    for (j=0; j<LVL1_SW_PORTS; j=j+1) begin
      // Data channel switch and FIFO
      axis_fifo_adapter # (
          .DEPTH(STG_F_DATA_DEPTH),
          .S_DATA_WIDTH(LVL1_DATA_WIDTH),
          .M_DATA_WIDTH(LVL2_DATA_WIDTH),
          .DEST_ENABLE(1),
          .DEST_WIDTH(DATA_DEST_LVL2),
          .USER_ENABLE(1),
          .USER_WIDTH(PORT_WIDTH),
          .FRAME_FIFO(0)
      ) data_in_sw_lvl2_fifo (
          .clk(sys_clk),
          .rst(sys_rst),

          .s_axis_tdata(int_data_s_axis_tdata[j*LVL1_DATA_WIDTH +: LVL1_DATA_WIDTH]),
          .s_axis_tkeep(int_data_s_axis_tkeep[j*LVL1_STRB_WIDTH +: LVL1_STRB_WIDTH]),
          .s_axis_tvalid(int_data_s_axis_tvalid[j]),
          .s_axis_tready(int_data_s_axis_tready[j]),
          .s_axis_tlast(int_data_s_axis_tlast[j]),
          .s_axis_tid({8'd0}),
          .s_axis_tdest(int_data_s_axis_tdest[j*ID_TAG_WIDTH +: DATA_DEST_LVL2]),
          .s_axis_tuser(int_data_s_axis_tuser[j*PORT_WIDTH +: PORT_WIDTH]),

          .m_axis_tdata(int_data_s_axis_tdata_f[j*LVL2_DATA_WIDTH +: LVL2_DATA_WIDTH]),
          .m_axis_tkeep(int_data_s_axis_tkeep_f[j*LVL2_STRB_WIDTH +: LVL2_STRB_WIDTH]),
          .m_axis_tvalid(int_data_s_axis_tvalid_f[j]),
          .m_axis_tready(int_data_s_axis_tready_f[j]),
          .m_axis_tlast(int_data_s_axis_tlast_f[j]),
          .m_axis_tid(),
          .m_axis_tdest(int_data_s_axis_tdest_f[j*ID_TAG_WIDTH +: DATA_DEST_LVL2]),
          .m_axis_tuser(int_data_s_axis_tuser_f[j*PORT_WIDTH +: PORT_WIDTH]),
   
          .status_overflow(),
          .status_bad_frame(),
          .status_good_frame()
      );

      axis_switch #
      (
          .S_COUNT(1),
          .M_COUNT(LVL2_SW_PORTS),
          .DATA_WIDTH(LVL2_DATA_WIDTH),
          .DEST_WIDTH(DATA_DEST_LVL2),
          .USER_WIDTH(PORT_WIDTH),
          .M_REG_TYPE(2)
      ) data_in_sw_lvl2
      (
          .clk(sys_clk),
          .rst(sys_rst),
      
          .s_axis_tdata(int_data_s_axis_tdata_f[j*LVL2_DATA_WIDTH +: LVL2_DATA_WIDTH]),
          .s_axis_tkeep(int_data_s_axis_tkeep_f[j*LVL2_STRB_WIDTH +: LVL2_STRB_WIDTH]),
          .s_axis_tvalid(int_data_s_axis_tvalid_f[j]),
          .s_axis_tready(int_data_s_axis_tready_f[j]),
          .s_axis_tlast(int_data_s_axis_tlast_f[j]),
          .s_axis_tid({8'd0}),
          .s_axis_tdest(int_data_s_axis_tdest_f[j*ID_TAG_WIDTH +: DATA_DEST_LVL2]),
          .s_axis_tuser(int_data_s_axis_tuser_f[j*PORT_WIDTH +: PORT_WIDTH]),
      
          .m_axis_tdata(data_s_axis_tdata[j*LVL2_SW_PORTS*LVL2_DATA_WIDTH +: LVL2_SW_PORTS*LVL2_DATA_WIDTH]),
          .m_axis_tkeep(data_s_axis_tkeep[j*LVL2_SW_PORTS*LVL2_STRB_WIDTH +: LVL2_SW_PORTS*LVL2_STRB_WIDTH]),
          .m_axis_tvalid(data_s_axis_tvalid[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .m_axis_tready(data_s_axis_tready[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .m_axis_tlast(data_s_axis_tlast[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .m_axis_tid(),
          .m_axis_tdest(data_s_axis_tdest[j*LVL2_SW_PORTS*DATA_DEST_LVL2 +: LVL2_SW_PORTS*DATA_DEST_LVL2]),
          .m_axis_tuser(data_s_axis_tuser[j*LVL2_SW_PORTS*PORT_WIDTH +: LVL2_SW_PORTS*PORT_WIDTH])
      );

      axis_fifo_adapter # (
          .DEPTH(STG_F_DATA_DEPTH),
          .S_DATA_WIDTH(LVL2_DATA_WIDTH),
          .M_DATA_WIDTH(LVL1_DATA_WIDTH),
          .DEST_ENABLE(1),
          .DEST_WIDTH(PORT_WIDTH),
          .USER_ENABLE(1),
          .USER_WIDTH(ID_TAG_WIDTH),
          .FRAME_FIFO(1)
      ) data_out_sw_lvl2_fifo (
 
          .clk(sys_clk),
          .rst(sys_rst),
          
          .s_axis_tdata(int_data_m_axis_tdata[j*LVL2_DATA_WIDTH +: LVL2_DATA_WIDTH]),
          .s_axis_tkeep(int_data_m_axis_tkeep[j*LVL2_STRB_WIDTH +: LVL2_STRB_WIDTH]),
          .s_axis_tvalid(int_data_m_axis_tvalid[j]),
          .s_axis_tready(int_data_m_axis_tready[j]),
          .s_axis_tlast(int_data_m_axis_tlast[j]),
          .s_axis_tid({8'd0}),
          .s_axis_tdest(int_data_m_axis_tdest[j*PORT_WIDTH +: PORT_WIDTH]),
          .s_axis_tuser(int_data_m_axis_tuser[j*ID_TAG_WIDTH +: ID_TAG_WIDTH]),

          .m_axis_tdata(int_data_m_axis_tdata_f[j*LVL1_DATA_WIDTH +: LVL1_DATA_WIDTH]),
          .m_axis_tkeep(int_data_m_axis_tkeep_f[j*LVL1_STRB_WIDTH +: LVL1_STRB_WIDTH]),
          .m_axis_tvalid(int_data_m_axis_tvalid_f[j]),
          .m_axis_tready(int_data_m_axis_tready_f[j]),
          .m_axis_tlast(int_data_m_axis_tlast_f[j]),
          .m_axis_tid(),
          .m_axis_tdest(int_data_m_axis_tdest_f[j*PORT_WIDTH +: PORT_WIDTH]),
          .m_axis_tuser(int_data_m_axis_tuser_f[j*ID_TAG_WIDTH +: ID_TAG_WIDTH]),

          .status_overflow(),
          .status_bad_frame(),
          .status_good_frame()
      );
      
      axis_arb_mux #
      (
          .S_COUNT(LVL2_SW_PORTS),
          .DATA_WIDTH(LVL2_DATA_WIDTH),
          .DEST_WIDTH(PORT_WIDTH),
          .USER_WIDTH(ID_TAG_WIDTH),
          .DEST_ENABLE(1)
      ) data_out_sw_lvl2 (

          .clk(sys_clk),
          .rst(sys_rst),
      
          /*
           * AXI Stream inputs
           */
          .s_axis_tdata(data_m_axis_tdata[j*LVL2_SW_PORTS*LVL2_DATA_WIDTH +: LVL2_SW_PORTS*LVL2_DATA_WIDTH]),
          .s_axis_tkeep(data_m_axis_tkeep[j*LVL2_SW_PORTS*LVL2_STRB_WIDTH +: LVL2_SW_PORTS*LVL2_STRB_WIDTH]),
          .s_axis_tvalid(data_m_axis_tvalid[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .s_axis_tready(data_m_axis_tready[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .s_axis_tlast(data_m_axis_tlast[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .s_axis_tid({LVL2_SW_PORTS{8'd0}}),
          .s_axis_tdest(data_m_axis_tdest[j*LVL2_SW_PORTS*PORT_WIDTH +: LVL2_SW_PORTS*PORT_WIDTH]),
          .s_axis_tuser(data_m_axis_tuser[j*LVL2_SW_PORTS*ID_TAG_WIDTH +: LVL2_SW_PORTS*ID_TAG_WIDTH]),
      
          /*
           * AXI Stream outputs
           */
          .m_axis_tdata(int_data_m_axis_tdata[j*LVL2_DATA_WIDTH +: LVL2_DATA_WIDTH]),
          .m_axis_tkeep(int_data_m_axis_tkeep[j*LVL2_STRB_WIDTH +: LVL2_STRB_WIDTH]),
          .m_axis_tvalid(int_data_m_axis_tvalid[j]),
          .m_axis_tready(int_data_m_axis_tready[j]),
          .m_axis_tlast(int_data_m_axis_tlast[j]),
          .m_axis_tid(),
          .m_axis_tdest(int_data_m_axis_tdest[j*PORT_WIDTH +: PORT_WIDTH]),
          .m_axis_tuser(int_data_m_axis_tuser[j*ID_TAG_WIDTH +: ID_TAG_WIDTH])
  
      );
      
      axis_fifo_adapter # (
          .DEPTH(STG_F_CTRL_DEPTH),
          .S_DATA_WIDTH(LVL1_CTRL_WIDTH),
          .M_DATA_WIDTH(LVL2_CTRL_WIDTH),
          .S_KEEP_ENABLE(0),
          .M_KEEP_ENABLE(0),
          .DEST_ENABLE(1),
          .DEST_WIDTH(CTRL_DEST_LVL2),
          .USER_ENABLE(0),
          .FRAME_FIFO(0)
      ) ctrl_in_sw_lvl2_fifo (
 
          .clk(sys_clk),
          .rst(sys_rst),
          
          .s_axis_tdata(int_ctrl_s_axis_tdata[j*LVL1_CTRL_WIDTH +: LVL1_CTRL_WIDTH]),
          .s_axis_tkeep(),
          .s_axis_tvalid(int_ctrl_s_axis_tvalid[j]),
          .s_axis_tready(int_ctrl_s_axis_tready[j]),
          .s_axis_tlast(int_ctrl_s_axis_tlast[j]),
          .s_axis_tid(8'd0),
          .s_axis_tdest(int_ctrl_s_axis_tdest[j*CORE_WIDTH +: CTRL_DEST_LVL2]),
          .s_axis_tuser(1'b0),
          
          .m_axis_tdata(int_ctrl_s_axis_tdata_f[j*LVL2_CTRL_WIDTH +: LVL2_CTRL_WIDTH]),
          .m_axis_tkeep(),
          .m_axis_tvalid(int_ctrl_s_axis_tvalid_f[j]),
          .m_axis_tready(int_ctrl_s_axis_tready_f[j]),
          .m_axis_tlast(int_ctrl_s_axis_tlast_f[j]),
          .m_axis_tid(),
          .m_axis_tdest(int_ctrl_s_axis_tdest_f[j*CORE_WIDTH +: CTRL_DEST_LVL2]),
          .m_axis_tuser(),

          .status_overflow(),
          .status_bad_frame(),
          .status_good_frame()
      );
      
      axis_switch #
      (
          .S_COUNT(1),
          .M_COUNT(LVL2_SW_PORTS),
          .DATA_WIDTH(LVL2_CTRL_WIDTH),
          .DEST_WIDTH(CTRL_DEST_LVL2),
          .USER_ENABLE(0),
          .KEEP_ENABLE(0)
      ) ctrl_in_sw_lvl2 (

          .clk(sys_clk),
          .rst(sys_rst),
      
          .s_axis_tdata(int_ctrl_s_axis_tdata_f[j*LVL2_CTRL_WIDTH +: LVL2_CTRL_WIDTH]),
          .s_axis_tkeep(),
          .s_axis_tvalid(int_ctrl_s_axis_tvalid_f[j]),
          .s_axis_tready(int_ctrl_s_axis_tready_f[j]),
          .s_axis_tlast(int_ctrl_s_axis_tlast_f[j]),
          .s_axis_tid(8'd0),
          .s_axis_tdest(int_ctrl_s_axis_tdest_f[j*CORE_WIDTH +: CTRL_DEST_LVL2]),
          .s_axis_tuser(),
  
          .m_axis_tdata(ctrl_s_axis_tdata[j*LVL2_SW_PORTS*LVL2_CTRL_WIDTH +: LVL2_SW_PORTS*LVL2_CTRL_WIDTH]),
          .m_axis_tkeep(),
          .m_axis_tvalid(ctrl_s_axis_tvalid[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .m_axis_tready(ctrl_s_axis_tready[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .m_axis_tlast(ctrl_s_axis_tlast[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .m_axis_tid(),
          .m_axis_tdest(),
          .m_axis_tuser()
      );
      
      axis_fifo_adapter # (
          .DEPTH(STG_F_CTRL_DEPTH),
          .S_DATA_WIDTH(LVL2_CTRL_WIDTH),
          .M_DATA_WIDTH(LVL1_CTRL_WIDTH),
          .S_KEEP_ENABLE(0),
          .M_KEEP_ENABLE(0),
          .DEST_ENABLE(0),
          .USER_ENABLE(1),
          .USER_WIDTH(CORE_WIDTH),
          .FRAME_FIFO(0)
      ) ctrl_out_sw_lvl2_fifo (
 
          .clk(sys_clk),
          .rst(sys_rst),
          
          .s_axis_tdata(int_ctrl_m_axis_tdata[j*LVL2_CTRL_WIDTH +: LVL2_CTRL_WIDTH]),
          .s_axis_tkeep(),
          .s_axis_tvalid(int_ctrl_m_axis_tvalid[j]),
          .s_axis_tready(int_ctrl_m_axis_tready[j]),
          .s_axis_tlast(int_ctrl_m_axis_tlast[j]),
          .s_axis_tid(),
          .s_axis_tdest(),
          .s_axis_tuser(int_ctrl_m_axis_tuser[j*CORE_WIDTH +: CORE_WIDTH]),
          
          .m_axis_tdata(int_ctrl_m_axis_tdata_f[j*LVL1_CTRL_WIDTH +: LVL1_CTRL_WIDTH]),
          .m_axis_tkeep(),
          .m_axis_tvalid(int_ctrl_m_axis_tvalid_f[j]),
          .m_axis_tready(int_ctrl_m_axis_tready_f[j]),
          .m_axis_tlast(int_ctrl_m_axis_tlast_f[j]),
          .m_axis_tid(),
          .m_axis_tdest(),
          .m_axis_tuser(int_ctrl_m_axis_tuser_f[j*CORE_WIDTH +: CORE_WIDTH]),
          
          .status_overflow(),
          .status_bad_frame(),
          .status_good_frame()
      );
      
      axis_arb_mux #
      (
          .S_COUNT(LVL2_SW_PORTS),
          .DATA_WIDTH(LVL2_CTRL_WIDTH),
          .USER_WIDTH(CORE_WIDTH),
          .KEEP_ENABLE(0)
      ) ctrl_out_sw_lvl2 (
          .clk(sys_clk),
          .rst(sys_rst),
      
          /*
           * AXI Stream inputs
           */
          .s_axis_tdata(ctrl_m_axis_tdata[j*LVL2_SW_PORTS*LVL2_CTRL_WIDTH +: LVL2_SW_PORTS*LVL2_CTRL_WIDTH]),
          .s_axis_tkeep(),
          .s_axis_tvalid(ctrl_m_axis_tvalid[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .s_axis_tready(ctrl_m_axis_tready[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .s_axis_tlast(ctrl_m_axis_tlast[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .s_axis_tid({LVL2_SW_PORTS{8'd0}}),
          .s_axis_tdest(),
          .s_axis_tuser(ctrl_m_axis_tuser[j*LVL2_SW_PORTS*CORE_WIDTH +: LVL2_SW_PORTS*CORE_WIDTH]),
  
          /*
           * AXI Stream output
           */
          .m_axis_tdata(int_ctrl_m_axis_tdata[j*LVL2_CTRL_WIDTH +: LVL2_CTRL_WIDTH]),
          .m_axis_tkeep(),
          .m_axis_tvalid(int_ctrl_m_axis_tvalid[j]),
          .m_axis_tready(int_ctrl_m_axis_tready[j]),
          .m_axis_tlast(int_ctrl_m_axis_tlast[j]),
          .m_axis_tid(),
          .m_axis_tdest(),
          .m_axis_tuser(int_ctrl_m_axis_tuser[j*CORE_WIDTH +: CORE_WIDTH])
  
      );

      axis_fifo_adapter # (
          .DEPTH(STG_F_DRAM_DEPTH),
          .S_DATA_WIDTH(LVL1_DRAM_WIDTH),
          .M_DATA_WIDTH(LVL2_DRAM_WIDTH),
          .S_KEEP_ENABLE(1),
          .M_KEEP_ENABLE(1),
          .DEST_ENABLE(1),
          .DEST_WIDTH(CTRL_DEST_LVL2),
          .USER_ENABLE(0),
          .FRAME_FIFO(0)
      ) dram_ctrl_in_sw_lvl2_fifo (
 
          .clk(sys_clk),
          .rst(sys_rst),
          
          .s_axis_tdata(int_dram_ctrl_s_axis_tdata[j*LVL1_DRAM_WIDTH +: LVL1_DRAM_WIDTH]),
          .s_axis_tkeep({(LVL1_DRAM_WIDTH/8){1'b1}}),
          .s_axis_tvalid(int_dram_ctrl_s_axis_tvalid[j]),
          .s_axis_tready(int_dram_ctrl_s_axis_tready[j]),
          .s_axis_tlast(int_dram_ctrl_s_axis_tlast[j]),
          .s_axis_tid(8'd0),
          .s_axis_tdest(int_dram_ctrl_s_axis_tdest[j*CORE_WIDTH +: CTRL_DEST_LVL2]),
          .s_axis_tuser(1'b0),
          
          .m_axis_tdata(int_dram_ctrl_s_axis_tdata_f[j*LVL2_DRAM_WIDTH +: LVL2_DRAM_WIDTH]),
          .m_axis_tkeep(),
          .m_axis_tvalid(int_dram_ctrl_s_axis_tvalid_f[j]),
          .m_axis_tready(int_dram_ctrl_s_axis_tready_f[j]),
          .m_axis_tlast(int_dram_ctrl_s_axis_tlast_f[j]),
          .m_axis_tid(),
          .m_axis_tdest(int_dram_ctrl_s_axis_tdest_f[j*CORE_WIDTH +: CTRL_DEST_LVL2]),
          .m_axis_tuser(),

          .status_overflow(),
          .status_bad_frame(),
          .status_good_frame()
      );
      
      axis_switch #
      (
          .S_COUNT(1),
          .M_COUNT(LVL2_SW_PORTS),
          .DATA_WIDTH(LVL2_DRAM_WIDTH),
          .DEST_WIDTH(CTRL_DEST_LVL2),
          .USER_ENABLE(0),
          .KEEP_ENABLE(0)
      ) dram_ctrl_in_sw_lvl2 (

          .clk(sys_clk),
          .rst(sys_rst),
      
          .s_axis_tdata(int_dram_ctrl_s_axis_tdata_f[j*LVL2_DRAM_WIDTH +: LVL2_DRAM_WIDTH]),
          .s_axis_tkeep(),
          .s_axis_tvalid(int_dram_ctrl_s_axis_tvalid_f[j]),
          .s_axis_tready(int_dram_ctrl_s_axis_tready_f[j]),
          .s_axis_tlast(int_dram_ctrl_s_axis_tlast_f[j]),
          .s_axis_tid(8'd0),
          .s_axis_tdest(int_dram_ctrl_s_axis_tdest_f[j*CORE_WIDTH +: CTRL_DEST_LVL2]),
          .s_axis_tuser(),
  
          .m_axis_tdata(dram_s_axis_tdata[j*LVL2_SW_PORTS*LVL2_DRAM_WIDTH +: LVL2_SW_PORTS*LVL2_DRAM_WIDTH]),
          .m_axis_tkeep(),
          .m_axis_tvalid(dram_s_axis_tvalid[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .m_axis_tready(dram_s_axis_tready[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .m_axis_tlast(dram_s_axis_tlast[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .m_axis_tid(),
          .m_axis_tdest(),
          .m_axis_tuser()
      );
      
      axis_fifo_adapter # (
          .DEPTH(STG_F_DRAM_DEPTH),
          .S_DATA_WIDTH(LVL2_DRAM_WIDTH),
          .M_DATA_WIDTH(LVL1_DRAM_WIDTH),
          .S_KEEP_ENABLE(1),
          .M_KEEP_ENABLE(1),
          .DEST_ENABLE(0),
          .USER_ENABLE(1),
          .USER_WIDTH(CORE_WIDTH),
          .FRAME_FIFO(0)
      ) dram_ctrl_out_sw_lvl2_fifo (
 
          .clk(sys_clk),
          .rst(sys_rst),
          
          .s_axis_tdata(int_dram_ctrl_m_axis_tdata[j*LVL2_DRAM_WIDTH +: LVL2_DRAM_WIDTH]),
          .s_axis_tkeep({(LVL2_DRAM_WIDTH/8){1'b1}}),
          .s_axis_tvalid(int_dram_ctrl_m_axis_tvalid[j]),
          .s_axis_tready(int_dram_ctrl_m_axis_tready[j]),
          .s_axis_tlast(int_dram_ctrl_m_axis_tlast[j]),
          .s_axis_tid(),
          .s_axis_tdest(),
          .s_axis_tuser(int_dram_ctrl_m_axis_tuser[j*CORE_WIDTH +: CORE_WIDTH]),
          
          .m_axis_tdata(int_dram_ctrl_m_axis_tdata_f[j*LVL1_DRAM_WIDTH +: LVL1_DRAM_WIDTH]),
          .m_axis_tkeep(),
          .m_axis_tvalid(int_dram_ctrl_m_axis_tvalid_f[j]),
          .m_axis_tready(int_dram_ctrl_m_axis_tready_f[j]),
          .m_axis_tlast(int_dram_ctrl_m_axis_tlast_f[j]),
          .m_axis_tid(),
          .m_axis_tdest(),
          .m_axis_tuser(int_dram_ctrl_m_axis_tuser_f[j*CORE_WIDTH +: CORE_WIDTH]),
          
          .status_overflow(),
          .status_bad_frame(),
          .status_good_frame()
      );
      
      axis_arb_mux #
      (
          .S_COUNT(LVL2_SW_PORTS),
          .DATA_WIDTH(LVL2_DRAM_WIDTH),
          .USER_WIDTH(CORE_WIDTH),
          .KEEP_ENABLE(0)
      ) dram_ctrl_out_sw_lvl2 (
          .clk(sys_clk),
          .rst(sys_rst),
      
          /*
           * AXI Stream inputs
           */
          .s_axis_tdata(dram_m_axis_tdata[j*LVL2_SW_PORTS*LVL2_DRAM_WIDTH +: LVL2_SW_PORTS*LVL2_DRAM_WIDTH]),
          .s_axis_tkeep(),
          .s_axis_tvalid(dram_m_axis_tvalid[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .s_axis_tready(dram_m_axis_tready[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .s_axis_tlast(dram_m_axis_tlast[j*LVL2_SW_PORTS +: LVL2_SW_PORTS]),
          .s_axis_tid({LVL2_SW_PORTS{8'd0}}),
          .s_axis_tdest(),
          .s_axis_tuser(dram_m_axis_tuser[j*LVL2_SW_PORTS*CORE_WIDTH +: LVL2_SW_PORTS*CORE_WIDTH]),
  
          /*
           * AXI Stream output
           */
          .m_axis_tdata(int_dram_ctrl_m_axis_tdata[j*LVL2_DRAM_WIDTH +: LVL2_DRAM_WIDTH]),
          .m_axis_tkeep(),
          .m_axis_tvalid(int_dram_ctrl_m_axis_tvalid[j]),
          .m_axis_tready(int_dram_ctrl_m_axis_tready[j]),
          .m_axis_tlast(int_dram_ctrl_m_axis_tlast[j]),
          .m_axis_tid(),
          .m_axis_tdest(),
          .m_axis_tuser(int_dram_ctrl_m_axis_tuser[j*CORE_WIDTH +: CORE_WIDTH])
  
      );

    end  
  end
endgenerate


// Core internal messaging
wire [CORE_MSG_LVL1*CORE_MSG_WIDTH-1:0] int_core_msg_out_data;
wire [CORE_MSG_LVL1*CORE_WIDTH-1:0]     int_core_msg_out_user;
wire [CORE_MSG_LVL1-1:0]                int_core_msg_out_valid;
wire [CORE_MSG_LVL1-1:0]                int_core_msg_out_ready;

wire [CORE_MSG_WIDTH-1:0] core_msg_merged_data;
wire [CORE_WIDTH-1:0]     core_msg_merged_user;
wire                      core_msg_merged_valid;
wire                      core_msg_merged_ready;

axis_arb_mux #
(
    .S_COUNT(CORE_MSG_LVL1),
    .DATA_WIDTH(CORE_MSG_WIDTH),
    .USER_WIDTH(CORE_WIDTH),
    .KEEP_ENABLE(0)
) cores_to_broadcaster_lvl1
(
    .clk(select_core_clk),
    .rst(select_core_rst),

    /*
     * AXI Stream inputs
     */
    .s_axis_tdata(int_core_msg_out_data),
    .s_axis_tkeep({CORE_MSG_LVL1{6'd0}}),
    .s_axis_tvalid(int_core_msg_out_valid),
    .s_axis_tready(int_core_msg_out_ready),
    .s_axis_tlast({CORE_MSG_LVL1{1'b1}}),
    .s_axis_tid({CORE_MSG_LVL1{8'd0}}),
    .s_axis_tdest({CORE_MSG_LVL1{8'd0}}),
    .s_axis_tuser(int_core_msg_out_user),

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
    .m_axis_tuser(core_msg_merged_user)
);

// Broadcast the arbitted core messages.
wire [CORE_COUNT*CORE_MSG_WIDTH-1:0] core_msg_in_data;
wire [CORE_COUNT*CORE_WIDTH-1:0]     core_msg_in_user;
wire [CORE_COUNT-1:0]                core_msg_in_valid;

assign core_msg_in_data  = {CORE_COUNT{core_msg_merged_data}};
assign core_msg_in_user  = {CORE_COUNT{core_msg_merged_user}};
assign core_msg_in_valid = {CORE_COUNT{core_msg_merged_valid}}; 
assign core_msg_merged_ready = 1'b1;

// lvl2 
wire [CORE_COUNT*CORE_MSG_WIDTH-1:0] core_msg_out_data;
wire [CORE_COUNT-1:0]                core_msg_out_valid;
wire [CORE_COUNT-1:0]                core_msg_out_ready;

genvar k;
generate
  if (CORE_MSG_LVL2 == 1) begin

    assign int_core_msg_out_valid = core_msg_out_valid;
    assign int_core_msg_out_data  = core_msg_out_data;
    assign int_core_msg_out_user  = ctrl_m_axis_tuser;
    assign core_msg_out_ready     = int_core_msg_out_ready;

  end else begin

    for (k=0; k<CORE_MSG_LVL1; k=k+1) begin
      axis_arb_mux #
      (
          .S_COUNT(CORE_MSG_LVL1),
          .DATA_WIDTH(CORE_MSG_WIDTH),
          .USER_WIDTH(CORE_WIDTH),
          .KEEP_ENABLE(0)
      ) cores_to_broadcaster_lvl2
      (
          .clk(select_core_clk),
          .rst(select_core_rst),
      
          /*
           * AXI Stream inputs
           */
          .s_axis_tdata(core_msg_out_data[k*CORE_MSG_LVL2*CORE_MSG_WIDTH +: CORE_MSG_LVL2*CORE_MSG_WIDTH]),
          .s_axis_tkeep({CORE_MSG_LVL2{6'd0}}),
          .s_axis_tvalid(core_msg_out_valid[k*CORE_MSG_LVL2 +: CORE_MSG_LVL2]),
          .s_axis_tready(core_msg_out_ready[k*CORE_MSG_LVL2 +: CORE_MSG_LVL2]),
          .s_axis_tlast({CORE_MSG_LVL2{1'b1}}),
          .s_axis_tid({CORE_MSG_LVL2{8'd0}}),
          .s_axis_tdest({CORE_MSG_LVL2{8'd0}}),
          .s_axis_tuser(ctrl_m_axis_tuser[k*CORE_MSG_LVL2*CORE_WIDTH +: CORE_MSG_LVL2*CORE_WIDTH]),
      
          /*
           * AXI Stream output
           */
          .m_axis_tdata(int_core_msg_out_data[k*CORE_MSG_WIDTH +: CORE_MSG_WIDTH]),
          .m_axis_tkeep(),
          .m_axis_tvalid(int_core_msg_out_valid[k]),
          .m_axis_tready(int_core_msg_out_ready[k]),
          .m_axis_tlast(),
          .m_axis_tid(),
          .m_axis_tdest(),
          .m_axis_tuser(int_core_msg_out_user[k*CORE_WIDTH +: CORE_WIDTH])
      );
    end
  end
endgenerate 

genvar i;
generate
  for (i=0; i<CORE_COUNT; i=i+1) begin
    // (* keep_hierarchy = "yes" *)
    riscv_axis_wrapper #(
        .DATA_WIDTH(LVL2_DATA_WIDTH),
        .ADDR_WIDTH(CORE_ADDR_WIDTH),
        .SLOT_COUNT(SLOT_COUNT),
        .IMEM_SIZE_BYTES(IMEM_SIZE_BYTES),
        .DMEM_SIZE_BYTES(DMEM_SIZE_BYTES),
        .COHERENT_START(COHERENT_START),
        .INTERLEAVE(INTERLEAVE),
        .RECV_DESC_DEPTH(RECV_DESC_DEPTH),
        .SEND_DESC_DEPTH(SEND_DESC_DEPTH),
        .DRAM_DESC_DEPTH(DRAM_DESC_DEPTH),
        .MSG_FIFO_DEPTH(MSG_FIFO_DEPTH),
        .PORT_COUNT(PORT_COUNT),
        .LEN_WIDTH(LEN_WIDTH),
        .CORE_ID(i),
        .CORE_ID_WIDTH(CORE_WIDTH),
        .SLOT_START_ADDR(SLOT_START_ADDR),
        .SLOT_ADDR_STEP(SLOT_ADDR_STEP),
        .DRAM_PORT(DRAM_PORT),
        .SEPARATE_CLOCKS(SEPARATE_CLOCKS)
    )
    core_wrapper (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .core_clk(select_core_clk),
        .core_rst(select_core_rst),

        // ---------------- DATA CHANNEL --------------- // 
        // Incoming data
        .data_s_axis_tdata(data_s_axis_tdata[LVL2_DATA_WIDTH*i +: LVL2_DATA_WIDTH]),
        .data_s_axis_tkeep(data_s_axis_tkeep[LVL2_STRB_WIDTH*i +: LVL2_STRB_WIDTH]),
        .data_s_axis_tvalid(data_s_axis_tvalid[i]),
        .data_s_axis_tready(data_s_axis_tready[i]),
        .data_s_axis_tlast(data_s_axis_tlast[i]),
        .data_s_axis_tdest(data_s_axis_tdest[DATA_DEST_LVL2*i +: TAG_WIDTH]),
        .data_s_axis_tuser(data_s_axis_tuser[PORT_WIDTH*i +: PORT_WIDTH]),
  
        // Outgoing data
        .data_m_axis_tdata(data_m_axis_tdata[LVL2_DATA_WIDTH*i +: LVL2_DATA_WIDTH]),
        .data_m_axis_tkeep(data_m_axis_tkeep[LVL2_STRB_WIDTH*i +: LVL2_STRB_WIDTH]),
        .data_m_axis_tvalid(data_m_axis_tvalid[i]),
        .data_m_axis_tready(data_m_axis_tready[i]),
        .data_m_axis_tlast(data_m_axis_tlast[i]),
        .data_m_axis_tdest(data_m_axis_tdest[PORT_WIDTH*i +: PORT_WIDTH]),
        .data_m_axis_tuser(data_m_axis_tuser[ID_TAG_WIDTH*i +: ID_TAG_WIDTH]),
  
        // ---------------- CTRL CHANNEL --------------- // 
        // Incoming control
        .ctrl_s_axis_tdata(ctrl_s_axis_tdata[LVL2_CTRL_WIDTH*i +: LVL2_CTRL_WIDTH]),
        .ctrl_s_axis_tvalid(ctrl_s_axis_tvalid[i]),
        .ctrl_s_axis_tready(ctrl_s_axis_tready[i]),
        .ctrl_s_axis_tlast(ctrl_s_axis_tlast[i]),
  
        // Outgoing control
        .ctrl_m_axis_tdata(ctrl_m_axis_tdata[LVL2_CTRL_WIDTH*i +: LVL2_CTRL_WIDTH]),
        .ctrl_m_axis_tvalid(ctrl_m_axis_tvalid[i]),
        .ctrl_m_axis_tready(ctrl_m_axis_tready[i]),
        .ctrl_m_axis_tlast(ctrl_m_axis_tlast[i]),
        .ctrl_m_axis_tuser(ctrl_m_axis_tuser[CORE_WIDTH*i +: CORE_WIDTH]),
    
        // ------------ DRAM RD REQ CHANNEL ------------- // 
        // Incoming DRAM request
        .dram_s_axis_tdata(dram_s_axis_tdata[LVL2_DRAM_WIDTH*i +: LVL2_DRAM_WIDTH]),
        .dram_s_axis_tvalid(dram_s_axis_tvalid[i]),
        .dram_s_axis_tready(dram_s_axis_tready[i]),
        .dram_s_axis_tlast(dram_s_axis_tlast[i]),
  
        // Outgoing DRAM request
        .dram_m_axis_tdata (dram_m_axis_tdata[LVL2_DRAM_WIDTH*i +: LVL2_DRAM_WIDTH]),
        .dram_m_axis_tvalid(dram_m_axis_tvalid[i]),
        .dram_m_axis_tready(dram_m_axis_tready[i]),
        .dram_m_axis_tlast (dram_m_axis_tlast[i]),
        .dram_m_axis_tuser (dram_m_axis_tuser[CORE_WIDTH*i +: CORE_WIDTH]),
   
        // ------------- CORE MSG CHANNEL -------------- // 
        // Core messages output  
        .core_msg_out_data(core_msg_out_data[CORE_MSG_WIDTH*i +: CORE_MSG_WIDTH]),
        .core_msg_out_valid(core_msg_out_valid[i]),
        .core_msg_out_ready(core_msg_out_ready[i]),

        // Core messages input
        .core_msg_in_data(core_msg_in_data[CORE_MSG_WIDTH*i +: CORE_MSG_WIDTH]),
        .core_msg_in_user(core_msg_in_user[CORE_WIDTH*i +: CORE_WIDTH]),
        .core_msg_in_valid(core_msg_in_valid[i])
    );
      
  end
        
endgenerate

// ILA
if (ENABLE_ILA) begin
  reg [63:0] data_s_slot;
  reg [63:0] ctrl_m_msg_type;
  reg [63:0] ctrl_m_msg_slot;
  reg [63:0] ctrl_m_msg_port;
  reg [63:0] ctrl_s_msg_type;
  reg [63:0] ctrl_s_msg_slot;
  reg [63:0] ctrl_s_msg_port;
  integer k;
  always @ (*)
    for (k=0; k<CORE_COUNT; k=k+1) begin
      data_s_slot [k*SLOT_WIDTH +: SLOT_WIDTH] = data_s_axis_tdest[DATA_DEST_LVL2*k +: SLOT_WIDTH];
      ctrl_m_msg_type [k*4+:4] = ctrl_m_axis_tdata [(k*LVL2_CTRL_WIDTH)+32 +:4];
      ctrl_m_msg_slot [k*4+:4] = ctrl_m_axis_tdata [(k*LVL2_CTRL_WIDTH)+16 +:4];
      ctrl_m_msg_port [k*4+:4] = ctrl_m_axis_tdata [(k*LVL2_CTRL_WIDTH)+24 +:4];
      ctrl_s_msg_type [k*4+:4] = ctrl_s_axis_tdata [(k*LVL2_CTRL_WIDTH)+32 +:4];
      ctrl_s_msg_slot [k*4+:4] = ctrl_s_axis_tdata [(k*LVL2_CTRL_WIDTH)+16 +:4];
      ctrl_s_msg_port [k*4+:4] = ctrl_s_axis_tdata [(k*LVL2_CTRL_WIDTH)+24 +:4];
    end

  // Updated signals, just disabled for BRAM utilization
  // ila_4x64 debugger3 (
  //   .clk    (sys_clk),
 
  //   .trig_out(),
  //   .trig_out_ack(1'b0),
  //   .trig_in (1'b0),
  //   .trig_in_ack(),
 
  //   .probe0 ({
  //     data_s_axis_tvalid,
  //     data_s_axis_tready,
  //     data_m_axis_tdest
  //   }),

  //   .probe1 ({
  //     data_m_axis_tvalid,
  //     data_m_axis_tready,
  //     data_m_axis_tlast,
  //     data_s_axis_tlast
  //   }),
  //       
  //   .probe2 (data_s_slot),
  //   .probe3 (data_s_axis_tuser)

  // );

  ila_8x64 debugger4 (
    .clk    (sys_clk),
 
    .trig_out(),
    .trig_out_ack(1'b0),
    .trig_in (1'b0),
    .trig_in_ack(),
 
    .probe0({ctrl_s_axis_tvalid, ctrl_s_axis_tready, 
            ctrl_s_axis_tlast}),
    .probe1(ctrl_s_msg_type),
    .probe2(ctrl_s_msg_slot),
    .probe3(ctrl_s_msg_port),
    
    .probe4({ctrl_m_axis_tvalid, ctrl_m_axis_tready, 
            ctrl_m_axis_tlast}),
    .probe5(ctrl_m_msg_type),
    .probe6(ctrl_m_msg_slot),
    .probe7(ctrl_m_msg_port)
  );

end

endmodule

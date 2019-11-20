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

module pcie_controller #
(
  parameter AXIS_PCIE_DATA_WIDTH    = 256,
  parameter AXIS_PCIE_KEEP_WIDTH    = (AXIS_PCIE_DATA_WIDTH/32),
  parameter AXIS_PCIE_RC_USER_WIDTH = 75,
  parameter AXIS_PCIE_RQ_USER_WIDTH = 60,
  parameter AXIS_PCIE_CQ_USER_WIDTH = 85,
  parameter AXIS_PCIE_CC_USER_WIDTH = 33,
  parameter PCIE_ADDR_WIDTH         = 64,
  parameter PCIE_RAM_ADDR_WIDTH     = 32,
  parameter TX_RX_RAM_SIZE          = 2**15, 
  parameter MAC_ASYNC_FIFO_SIZE     = 1024,
  parameter PCIE_DMA_LEN_WIDTH      = 16,
  parameter HOST_DMA_TAG_WIDTH      = 32,
  parameter AXIL_DATA_WIDTH         = 32,
  parameter AXIL_STRB_WIDTH         = (AXIL_DATA_WIDTH/8),
  parameter AXIL_ADDR_WIDTH         = 32,
  parameter AXIS_DATA_WIDTH         = 128, 
  parameter AXIS_KEEP_WIDTH         = 16, 
  parameter AXIS_TAG_WIDTH          = 9, 
  parameter CORE_SLOT_WIDTH         = 4,
  parameter CORE_DESC_WIDTH         = 128,
  parameter CORE_COUNT              = 16,
  parameter CORE_WIDTH              = $clog2(CORE_COUNT), 
  parameter CORE_ADDR_WIDTH         = 16, 
  parameter CORES_ADDR_WIDTH        = CORE_WIDTH+CORE_ADDR_WIDTH, 
  parameter CORES_DATA_FIFO_SIZE    = 1024,
  parameter CORES_CTRL_FIFO_SIZE    = 512,
  parameter PCIE_SLOT_COUNT         = 16,
  parameter PCIE_SLOT_WIDTH         = $clog2(PCIE_SLOT_COUNT),
  parameter IF_COUNT                = 2,
  parameter PORTS_PER_IF            = 1,
  parameter PORT_COUNT              = (IF_COUNT>0) ? IF_COUNT*PORTS_PER_IF : 1,
  parameter RAM_PIPELINE            = 4
) (
  input  wire                                  sys_clk,
  input  wire                                  sys_rst,
  input  wire                                  pcie_clk,
  input  wire                                  pcie_rst,

  /*
   * PCIe
   */
  output wire [AXIS_PCIE_DATA_WIDTH-1:0]       m_axis_rq_tdata,
  output wire [AXIS_PCIE_KEEP_WIDTH-1:0]       m_axis_rq_tkeep,
  output wire                                  m_axis_rq_tlast,
  input  wire                                  m_axis_rq_tready,
  output wire [AXIS_PCIE_RQ_USER_WIDTH-1:0]    m_axis_rq_tuser,
  output wire                                  m_axis_rq_tvalid,

  input  wire [AXIS_PCIE_DATA_WIDTH-1:0]       s_axis_rc_tdata,
  input  wire [AXIS_PCIE_KEEP_WIDTH-1:0]       s_axis_rc_tkeep,
  input  wire                                  s_axis_rc_tlast,
  output wire                                  s_axis_rc_tready,
  input  wire [AXIS_PCIE_RC_USER_WIDTH-1:0]    s_axis_rc_tuser,
  input  wire                                  s_axis_rc_tvalid,

  input  wire [AXIS_PCIE_DATA_WIDTH-1:0]       s_axis_cq_tdata,
  input  wire [AXIS_PCIE_KEEP_WIDTH-1:0]       s_axis_cq_tkeep,
  input  wire                                  s_axis_cq_tlast,
  output wire                                  s_axis_cq_tready,
  input  wire [AXIS_PCIE_CQ_USER_WIDTH-1:0]    s_axis_cq_tuser,
  input  wire                                  s_axis_cq_tvalid,

  output wire [AXIS_PCIE_DATA_WIDTH-1:0]       m_axis_cc_tdata,
  output wire [AXIS_PCIE_KEEP_WIDTH-1:0]       m_axis_cc_tkeep,
  output wire                                  m_axis_cc_tlast,
  input  wire                                  m_axis_cc_tready,
  output wire [AXIS_PCIE_CC_USER_WIDTH-1:0]    m_axis_cc_tuser,
  output wire                                  m_axis_cc_tvalid,

  input  wire [2:0]                            cfg_max_payload,
  input  wire [2:0]                            cfg_max_read_req,
  input  wire                                  ext_tag_enable,
  input  wire                                  pcie_dma_enable,

  output wire                                  status_error_cor,
  output wire                                  status_error_uncor,
  
  // Cores data (sys_clk)
  input  wire [AXIS_DATA_WIDTH-1:0]            cores_tx_axis_tdata,
  input  wire [AXIS_KEEP_WIDTH-1:0]            cores_tx_axis_tkeep,
  input  wire [AXIS_TAG_WIDTH-1:0]             cores_tx_axis_tuser,
  input  wire                                  cores_tx_axis_tvalid, 
  output wire                                  cores_tx_axis_tready, 
  input  wire                                  cores_tx_axis_tlast,
  
  output wire [AXIS_DATA_WIDTH-1:0]            cores_rx_axis_tdata,
  output wire [AXIS_KEEP_WIDTH-1:0]            cores_rx_axis_tkeep,
  output wire [AXIS_TAG_WIDTH-1:0]             cores_rx_axis_tdest,
  output wire                                  cores_rx_axis_tvalid, 
  input  wire                                  cores_rx_axis_tready, 
  output wire                                  cores_rx_axis_tlast,
  
  // Cores DRAM requests (pcie_clk)
  input  wire [CORE_DESC_WIDTH-1:0]            cores_ctrl_s_axis_tdata,
  input  wire                                  cores_ctrl_s_axis_tvalid,
  output wire                                  cores_ctrl_s_axis_tready,
  input  wire                                  cores_ctrl_s_axis_tlast,
  input  wire [CORE_WIDTH-1:0]                 cores_ctrl_s_axis_tuser,
  
  output wire [CORE_DESC_WIDTH-1:0]            cores_ctrl_m_axis_tdata,
  output wire                                  cores_ctrl_m_axis_tvalid,
  input  wire                                  cores_ctrl_m_axis_tready,
  output wire                                  cores_ctrl_m_axis_tlast,
  output wire [CORE_WIDTH-1:0]                 cores_ctrl_m_axis_tdest,
  
  // DMA requests from Host
  input  wire [PCIE_ADDR_WIDTH-1:0]            host_dma_read_desc_pcie_addr,
  input  wire [PCIE_RAM_ADDR_WIDTH-1:0]        host_dma_read_desc_ram_addr,
  input  wire [PCIE_DMA_LEN_WIDTH-1:0]         host_dma_read_desc_len,
  input  wire [HOST_DMA_TAG_WIDTH-1:0]         host_dma_read_desc_tag,
  input  wire                                  host_dma_read_desc_valid,
  output wire                                  host_dma_read_desc_ready,
  output wire [HOST_DMA_TAG_WIDTH-1:0]         host_dma_read_desc_status_tag,
  output wire                                  host_dma_read_desc_status_valid,

  input  wire [PCIE_ADDR_WIDTH-1:0]            host_dma_write_desc_pcie_addr,
  input  wire [PCIE_RAM_ADDR_WIDTH-1:0]        host_dma_write_desc_ram_addr,
  input  wire [PCIE_DMA_LEN_WIDTH-1:0]         host_dma_write_desc_len,
  input  wire [HOST_DMA_TAG_WIDTH-1:0]         host_dma_write_desc_tag,
  input  wire                                  host_dma_write_desc_valid,
  output wire                                  host_dma_write_desc_ready,
  output wire [HOST_DMA_TAG_WIDTH-1:0]         host_dma_write_desc_status_tag,
  output wire                                  host_dma_write_desc_status_valid,
 
  // AXI lite
  output wire [AXIL_ADDR_WIDTH-1:0]            axil_ctrl_awaddr,
  output wire [2:0]                            axil_ctrl_awprot,
  output wire                                  axil_ctrl_awvalid,
  input  wire                                  axil_ctrl_awready,
  output wire [AXIL_DATA_WIDTH-1:0]            axil_ctrl_wdata,
  output wire [AXIL_STRB_WIDTH-1:0]            axil_ctrl_wstrb,
  output wire                                  axil_ctrl_wvalid,
  input  wire                                  axil_ctrl_wready,
  input  wire [1:0]                            axil_ctrl_bresp,
  input  wire                                  axil_ctrl_bvalid,
  output wire                                  axil_ctrl_bready,
  output wire [AXIL_ADDR_WIDTH-1:0]            axil_ctrl_araddr,
  output wire [2:0]                            axil_ctrl_arprot,
  output wire                                  axil_ctrl_arvalid,
  input  wire                                  axil_ctrl_arready,
  input  wire [AXIL_DATA_WIDTH-1:0]            axil_ctrl_rdata,
  input  wire [1:0]                            axil_ctrl_rresp,
  input  wire                                  axil_ctrl_rvalid,
  output wire                                  axil_ctrl_rready,
    
  // Virtual MACs
  output wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0] tx_axis_tdata,
  output wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0] tx_axis_tkeep,
  output wire [PORT_COUNT-1:0]                 tx_axis_tvalid,
  input  wire [PORT_COUNT-1:0]                 tx_axis_tready,
  output wire [PORT_COUNT-1:0]                 tx_axis_tlast,
  output wire [PORT_COUNT-1:0]                 tx_axis_tuser,

  input  wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0] rx_axis_tdata,
  input  wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0] rx_axis_tkeep,
  input  wire [PORT_COUNT-1:0]                 rx_axis_tvalid,
  output wire [PORT_COUNT-1:0]                 rx_axis_tready,
  input  wire [PORT_COUNT-1:0]                 rx_axis_tlast,
  input  wire [PORT_COUNT-1:0]                 rx_axis_tuser,
    
  output wire [31:0]                           msi_irq
);
  
parameter IF_AXIL_ADDR_WIDTH  = (IF_COUNT>0) ? AXIL_ADDR_WIDTH-$clog2(IF_COUNT) : AXIL_ADDR_WIDTH;
parameter AXIL_CSR_ADDR_WIDTH = (IF_COUNT>0) ? IF_AXIL_ADDR_WIDTH-5-$clog2((PORTS_PER_IF+3)/8) 
                                             : AXIL_ADDR_WIDTH;

// PCIe DMA parameters
parameter PCIE_DMA_TAG_WIDTH    = (PCIE_SLOT_WIDTH>16) ? PCIE_SLOT_WIDTH :16;
parameter SEG_COUNT             = AXIS_PCIE_DATA_WIDTH > 64 ? AXIS_PCIE_DATA_WIDTH*2 / 128 : 2;
parameter SEG_DATA_WIDTH        = AXIS_PCIE_DATA_WIDTH*2/SEG_COUNT;
parameter SEG_ADDR_WIDTH        = 12; 
parameter SEG_BE_WIDTH          = SEG_DATA_WIDTH/8;
parameter RAM_ADDR_WIDTH        = SEG_ADDR_WIDTH+$clog2(SEG_COUNT)+$clog2(SEG_BE_WIDTH);
parameter RAM_SEL_WIDTH         = (IF_COUNT>0) ? $clog2(IF_COUNT+1)+$clog2(PORTS_PER_IF+1) : 1;
parameter IF_PCIE_DMA_TAG_WIDTH = PCIE_DMA_TAG_WIDTH-$clog2(IF_COUNT+1);
parameter IF_RAM_SEL_WIDTH      = (PORTS_PER_IF>0) ? $clog2(PORTS_PER_IF+1) : 1;

// -------------------------------------------------------------------//
// -------- Register axis input from PCIe, and error handling --------//
// -------------------------------------------------------------------//

wire [AXIS_PCIE_DATA_WIDTH-1:0]    axis_rc_tdata_r;
wire [AXIS_PCIE_KEEP_WIDTH-1:0]    axis_rc_tkeep_r;
wire                               axis_rc_tlast_r;
wire                               axis_rc_tready_r;
wire [AXIS_PCIE_RC_USER_WIDTH-1:0] axis_rc_tuser_r;
wire                               axis_rc_tvalid_r;

axis_register #(
    .DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(AXIS_PCIE_RC_USER_WIDTH)
)
rc_reg (
    .clk(pcie_clk),
    .rst(pcie_rst),

    /*
     * AXI input
     */
    .s_axis_tdata(s_axis_rc_tdata),
    .s_axis_tkeep(s_axis_rc_tkeep),
    .s_axis_tvalid(s_axis_rc_tvalid),
    .s_axis_tready(s_axis_rc_tready),
    .s_axis_tlast(s_axis_rc_tlast),
    .s_axis_tid(8'd0),
    .s_axis_tdest(8'd0),
    .s_axis_tuser(s_axis_rc_tuser),

    /*
     * AXI output
     */
    .m_axis_tdata(axis_rc_tdata_r),
    .m_axis_tkeep(axis_rc_tkeep_r),
    .m_axis_tvalid(axis_rc_tvalid_r),
    .m_axis_tready(axis_rc_tready_r),
    .m_axis_tlast(axis_rc_tlast_r),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(axis_rc_tuser_r)
);

wire [AXIS_PCIE_DATA_WIDTH-1:0]    axis_cq_tdata_r;
wire [AXIS_PCIE_KEEP_WIDTH-1:0]    axis_cq_tkeep_r;
wire                               axis_cq_tlast_r;
wire                               axis_cq_tready_r;
wire [AXIS_PCIE_CQ_USER_WIDTH-1:0] axis_cq_tuser_r;
wire                               axis_cq_tvalid_r;

axis_register #(
    .DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(AXIS_PCIE_CQ_USER_WIDTH)
)
cq_reg (
    .clk(pcie_clk),
    .rst(pcie_rst),

    /*
     * AXI input
     */
    .s_axis_tdata(s_axis_cq_tdata),
    .s_axis_tkeep(s_axis_cq_tkeep),
    .s_axis_tvalid(s_axis_cq_tvalid),
    .s_axis_tready(s_axis_cq_tready),
    .s_axis_tlast(s_axis_cq_tlast),
    .s_axis_tid(8'd0),
    .s_axis_tdest(8'd0),
    .s_axis_tuser(s_axis_cq_tuser),

    /*
     * AXI output
     */
    .m_axis_tdata(axis_cq_tdata_r),
    .m_axis_tkeep(axis_cq_tkeep_r),
    .m_axis_tvalid(axis_cq_tvalid_r),
    .m_axis_tready(axis_cq_tready_r),
    .m_axis_tlast(axis_cq_tlast_r),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(axis_cq_tuser_r)
);

wire [1:0] status_error_uncor_int;
wire [1:0] status_error_cor_int;

pulse_merge #(
    .INPUT_WIDTH(2),
    .COUNT_WIDTH(4)
)
status_error_cor_pm_inst (
    .clk(pcie_clk),
    .rst(pcie_rst),

    .pulse_in(status_error_cor_int),
    .count_out(),
    .pulse_out(status_error_cor)
);

pulse_merge #(
    .INPUT_WIDTH(2),
    .COUNT_WIDTH(4)
)
status_error_uncor_pm_inst (
    .clk(pcie_clk),
    .rst(pcie_rst),

    .pulse_in(status_error_uncor_int),
    .count_out(),
    .pulse_out(status_error_uncor)
);

// -------------------------------------------------------------------//
// ------------------------- Cross time domain -----------------------//
// -------------------------------------------------------------------//
wire [AXIS_DATA_WIDTH-1:0] cores_tx_tdata;
wire [AXIS_KEEP_WIDTH-1:0] cores_tx_tkeep;
wire [AXIS_TAG_WIDTH-1:0]  cores_tx_tuser;
wire                       cores_tx_tvalid; 
wire                       cores_tx_tready; 
wire                       cores_tx_tlast;

axis_async_fifo # (
    .DEPTH(CORES_DATA_FIFO_SIZE),
    .DATA_WIDTH(AXIS_DATA_WIDTH),
    .KEEP_ENABLE(1), 
    .KEEP_WIDTH(AXIS_KEEP_WIDTH),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(AXIS_TAG_WIDTH),
    .FRAME_FIFO(0)
) cores_tx_axis_data_async_fifo (
    .async_rst(pcie_rst),

    .s_clk(sys_clk),
    .s_axis_tdata (cores_tx_axis_tdata),
    .s_axis_tkeep (cores_tx_axis_tkeep),
    .s_axis_tvalid(cores_tx_axis_tvalid),
    .s_axis_tready(cores_tx_axis_tready),
    .s_axis_tlast (cores_tx_axis_tlast),
    .s_axis_tid   (8'd0),
    .s_axis_tdest (8'd0),
    .s_axis_tuser (cores_tx_axis_tuser),

    .m_clk(pcie_clk),
    .m_axis_tdata (cores_tx_tdata), 
    .m_axis_tkeep (cores_tx_tkeep), 
    .m_axis_tvalid(cores_tx_tvalid),
    .m_axis_tready(cores_tx_tready),
    .m_axis_tlast (cores_tx_tlast), 
    .m_axis_tid   (),
    .m_axis_tdest (),
    .m_axis_tuser (cores_tx_tuser),

    .s_status_overflow(),
    .s_status_bad_frame(),
    .s_status_good_frame(),
    .m_status_overflow(),
    .m_status_bad_frame(),
    .m_status_good_frame()
);

wire [AXIS_DATA_WIDTH-1:0] cores_rx_tdata;
wire [AXIS_KEEP_WIDTH-1:0] cores_rx_tkeep;
wire [AXIS_TAG_WIDTH-1:0]  cores_rx_tdest;
wire                       cores_rx_tvalid; 
wire                       cores_rx_tready; 
wire                       cores_rx_tlast;

axis_async_fifo # (
    .DEPTH(CORES_DATA_FIFO_SIZE),
    .DATA_WIDTH(AXIS_DATA_WIDTH),
    .KEEP_ENABLE(1), 
    .KEEP_WIDTH(AXIS_KEEP_WIDTH),
    .ID_ENABLE(0),
    .DEST_ENABLE(1),
    .DEST_WIDTH(AXIS_TAG_WIDTH),
    .USER_ENABLE(0),
    .FRAME_FIFO(0)
) cores_rx_axis_data_async_fifo (
    .async_rst(sys_rst),

    .s_clk(pcie_clk),
    .s_axis_tdata (cores_rx_tdata), 
    .s_axis_tkeep (cores_rx_tkeep), 
    .s_axis_tvalid(cores_rx_tvalid),
    .s_axis_tready(cores_rx_tready),
    .s_axis_tlast (cores_rx_tlast), 
    .s_axis_tid   (8'd0),
    .s_axis_tdest (cores_rx_tdest),
    .s_axis_tuser (1'b0),

    .m_clk(sys_clk),
    .m_axis_tdata (cores_rx_axis_tdata),
    .m_axis_tkeep (cores_rx_axis_tkeep),
    .m_axis_tvalid(cores_rx_axis_tvalid), 
    .m_axis_tready(cores_rx_axis_tready),
    .m_axis_tlast (cores_rx_axis_tlast),
    .m_axis_tid   (),
    .m_axis_tdest (cores_rx_axis_tdest),
    .m_axis_tuser (),

    .s_status_overflow(),
    .s_status_bad_frame(),
    .s_status_good_frame(),
    .m_status_overflow(),
    .m_status_bad_frame(),
    .m_status_good_frame()
);
  
localparam CORE_DESC_STRB_WIDTH = CORE_DESC_WIDTH/8;

wire [127:0]          cores_ctrl_s_tdata;
wire                  cores_ctrl_s_tvalid;
wire                  cores_ctrl_s_tready;
wire [CORE_WIDTH-1:0] cores_ctrl_s_tuser;
 
axis_fifo_adapter # (
    .DEPTH(CORES_CTRL_FIFO_SIZE),
    .S_DATA_WIDTH(CORE_DESC_WIDTH),
    .S_KEEP_ENABLE(1), 
    .S_KEEP_WIDTH(CORE_DESC_STRB_WIDTH),
    .M_DATA_WIDTH(128),
    .M_KEEP_ENABLE(1),
    .M_KEEP_WIDTH(16),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(CORE_WIDTH),
    .FRAME_FIFO(0)
) cores_ctrl_s_axis_async_fifo (
    .clk(pcie_clk),
    .rst(pcie_rst),
    .s_axis_tdata (cores_ctrl_s_axis_tdata),
    .s_axis_tkeep ({CORE_DESC_STRB_WIDTH{1'b1}}),
    .s_axis_tvalid(cores_ctrl_s_axis_tvalid),
    .s_axis_tready(cores_ctrl_s_axis_tready),
    .s_axis_tlast (cores_ctrl_s_axis_tlast),
    .s_axis_tid   (8'd0),
    .s_axis_tdest (8'd0),
    .s_axis_tuser (cores_ctrl_s_axis_tuser),

    .m_axis_tdata (cores_ctrl_s_tdata),
    .m_axis_tkeep (),
    .m_axis_tvalid(cores_ctrl_s_tvalid),
    .m_axis_tready(cores_ctrl_s_tready),
    .m_axis_tlast (),
    .m_axis_tid   (),
    .m_axis_tdest (),
    .m_axis_tuser (cores_ctrl_s_tuser),

    .status_overflow(),
    .status_bad_frame(),
    .status_good_frame()
);

wire  [127:0]         cores_ctrl_m_tdata;
wire                  cores_ctrl_m_tvalid;
wire [CORE_WIDTH-1:0] cores_ctrl_m_tdest;
wire                  cores_ctrl_m_tready;

axis_fifo_adapter # (
    .DEPTH(CORES_CTRL_FIFO_SIZE),
    .S_DATA_WIDTH(128),
    .S_KEEP_ENABLE(1), 
    .S_KEEP_WIDTH(16),
    .M_DATA_WIDTH(CORE_DESC_WIDTH),
    .M_KEEP_ENABLE(1),
    .M_KEEP_WIDTH(CORE_DESC_STRB_WIDTH),
    .ID_ENABLE(0),
    .DEST_ENABLE(1),
    .DEST_WIDTH(CORE_WIDTH),
    .USER_ENABLE(0),
    .FRAME_FIFO(0)
) cores_ctrl_m_axis_async_fifo (
    .clk(pcie_clk),
    .rst(pcie_rst),
    .s_axis_tdata (cores_ctrl_m_tdata),
    .s_axis_tkeep ({16{1'b1}}),
    .s_axis_tvalid(cores_ctrl_m_tvalid),
    .s_axis_tready(cores_ctrl_m_tready),
    .s_axis_tlast (1'b1),
    .s_axis_tid   (8'd0),
    .s_axis_tdest (cores_ctrl_m_tdest),
    .s_axis_tuser (1'b0),

    .m_axis_tdata (cores_ctrl_m_axis_tdata),
    .m_axis_tkeep (),
    .m_axis_tvalid(cores_ctrl_m_axis_tvalid),
    .m_axis_tready(cores_ctrl_m_axis_tready),
    .m_axis_tlast (cores_ctrl_m_axis_tlast),
    .m_axis_tid   (),
    .m_axis_tdest (cores_ctrl_m_axis_tdest),
    .m_axis_tuser (),

    .status_overflow(),
    .status_bad_frame(),
    .status_good_frame()
);

// -------------------------------------------------------------------//
// --------------------AXIL write and read back-----------------------//
// -------------------------------------------------------------------//
wire [AXIL_ADDR_WIDTH-1:0] axil_pcie_awaddr;
wire [2:0]                 axil_pcie_awprot;
wire                       axil_pcie_awvalid;
wire                       axil_pcie_awready;
wire [AXIL_DATA_WIDTH-1:0] axil_pcie_wdata;
wire [AXIL_STRB_WIDTH-1:0] axil_pcie_wstrb;
wire                       axil_pcie_wvalid;
wire                       axil_pcie_wready;
wire [1:0]                 axil_pcie_bresp;
wire                       axil_pcie_bvalid;
wire                       axil_pcie_bready;
wire [AXIL_ADDR_WIDTH-1:0] axil_pcie_araddr;
wire [2:0]                 axil_pcie_arprot;
wire                       axil_pcie_arvalid;
wire                       axil_pcie_arready;
wire [AXIL_DATA_WIDTH-1:0] axil_pcie_rdata;
wire [1:0]                 axil_pcie_rresp;
wire                       axil_pcie_rvalid;
wire                       axil_pcie_rready;

pcie_us_axil_master #(
    .AXIS_PCIE_DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .AXIS_PCIE_CQ_USER_WIDTH(AXIS_PCIE_CQ_USER_WIDTH),
    .AXIS_PCIE_CC_USER_WIDTH(AXIS_PCIE_CC_USER_WIDTH),
    .AXI_DATA_WIDTH(AXIL_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXIL_ADDR_WIDTH),
    .ENABLE_PARITY(0)
)
pcie_us_axil_master_inst (
    .clk(pcie_clk),
    .rst(pcie_rst),

    /*
     * AXI input (CQ)
     */
    .s_axis_cq_tdata(axis_cq_tdata_r),
    .s_axis_cq_tkeep(axis_cq_tkeep_r),
    .s_axis_cq_tvalid(axis_cq_tvalid_r),
    .s_axis_cq_tready(axis_cq_tready_r),
    .s_axis_cq_tlast(axis_cq_tlast_r),
    .s_axis_cq_tuser(axis_cq_tuser_r),

    /*
     * AXI output (CC)
     */
    .m_axis_cc_tdata(m_axis_cc_tdata),
    .m_axis_cc_tkeep(m_axis_cc_tkeep),
    .m_axis_cc_tvalid(m_axis_cc_tvalid),
    .m_axis_cc_tready(m_axis_cc_tready),
    .m_axis_cc_tlast(m_axis_cc_tlast),
    .m_axis_cc_tuser(m_axis_cc_tuser),

    /*
     * AXI Lite Master output
     */
    .m_axil_awaddr (axil_pcie_awaddr),
    .m_axil_awprot (axil_pcie_awprot),
    .m_axil_awvalid(axil_pcie_awvalid),
    .m_axil_awready(axil_pcie_awready),
    .m_axil_wdata  (axil_pcie_wdata),
    .m_axil_wstrb  (axil_pcie_wstrb),
    .m_axil_wvalid (axil_pcie_wvalid),
    .m_axil_wready (axil_pcie_wready),
    .m_axil_bresp  (axil_pcie_bresp),
    .m_axil_bvalid (axil_pcie_bvalid),
    .m_axil_bready (axil_pcie_bready),
    .m_axil_araddr (axil_pcie_araddr),
    .m_axil_arprot (axil_pcie_arprot),
    .m_axil_arvalid(axil_pcie_arvalid),
    .m_axil_arready(axil_pcie_arready),
    .m_axil_rdata  (axil_pcie_rdata),
    .m_axil_rresp  (axil_pcie_rresp),
    .m_axil_rvalid (axil_pcie_rvalid),
    .m_axil_rready (axil_pcie_rready),

    /*
     * Configuration
     */
    .completer_id({8'd0, 5'd0, 3'd0}),
    .completer_id_enable(1'b0),

    /*
     * Status
     */
    .status_error_cor(status_error_cor_int[0]),
    .status_error_uncor(status_error_uncor_int[0])
);

// -------------------------------------------------------------------//
// ------------ PCIE DMA and Read and Write sub modules --------------//
// -------------------------------------------------------------------//
wire [PCIE_ADDR_WIDTH-1:0]     pcie_dma_read_desc_pcie_addr;
wire [RAM_SEL_WIDTH-1:0]       pcie_dma_read_desc_ram_sel;
wire [RAM_ADDR_WIDTH-1:0]      pcie_dma_read_desc_ram_addr;  
wire [PCIE_DMA_LEN_WIDTH-1:0]  pcie_dma_read_desc_len;   
wire [PCIE_DMA_TAG_WIDTH-1:0]  pcie_dma_read_desc_tag;
wire                           pcie_dma_read_desc_valid;
wire                           pcie_dma_read_desc_ready;
wire [PCIE_DMA_TAG_WIDTH-1:0]  pcie_dma_read_desc_status_tag;
wire                           pcie_dma_read_desc_status_valid;
  
wire [PCIE_ADDR_WIDTH-1:0]     pcie_dma_write_desc_pcie_addr;
wire [RAM_SEL_WIDTH-1:0]       pcie_dma_write_desc_ram_sel;
wire [RAM_ADDR_WIDTH-1:0]      pcie_dma_write_desc_ram_addr;
wire [PCIE_DMA_LEN_WIDTH-1:0]  pcie_dma_write_desc_len;
wire [PCIE_DMA_TAG_WIDTH-1:0]  pcie_dma_write_desc_tag;
wire                           pcie_dma_write_desc_valid;
wire                           pcie_dma_write_desc_ready;     
wire [PCIE_DMA_TAG_WIDTH-1:0]  pcie_dma_write_desc_status_tag;
wire                           pcie_dma_write_desc_status_valid;
  
wire [SEG_COUNT*RAM_SEL_WIDTH-1:0]  dma_ram_wr_cmd_sel;
wire [SEG_COUNT*SEG_BE_WIDTH-1:0]   dma_ram_wr_cmd_be;
wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0] dma_ram_wr_cmd_addr;
wire [SEG_COUNT*SEG_DATA_WIDTH-1:0] dma_ram_wr_cmd_data;
wire [SEG_COUNT-1:0]                dma_ram_wr_cmd_valid;
wire [SEG_COUNT-1:0]                dma_ram_wr_cmd_ready;
wire [SEG_COUNT*RAM_SEL_WIDTH-1:0]  dma_ram_rd_cmd_sel;
wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0] dma_ram_rd_cmd_addr;
wire [SEG_COUNT-1:0]                dma_ram_rd_cmd_valid;
wire [SEG_COUNT-1:0]                dma_ram_rd_cmd_ready;
wire [SEG_COUNT*SEG_DATA_WIDTH-1:0] dma_ram_rd_resp_data;
wire [SEG_COUNT-1:0]                dma_ram_rd_resp_valid;
wire [SEG_COUNT-1:0]                dma_ram_rd_resp_ready;

dma_if_pcie_us #
(
    .AXIS_PCIE_DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .AXIS_PCIE_KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
    .AXIS_PCIE_RC_USER_WIDTH(AXIS_PCIE_RC_USER_WIDTH),
    .AXIS_PCIE_RQ_USER_WIDTH(AXIS_PCIE_RQ_USER_WIDTH),
    .SEG_COUNT(SEG_COUNT),
    .SEG_DATA_WIDTH(SEG_DATA_WIDTH),
    .SEG_ADDR_WIDTH(SEG_ADDR_WIDTH),
    .SEG_BE_WIDTH(SEG_BE_WIDTH),
    .RAM_SEL_WIDTH(RAM_SEL_WIDTH),
    .RAM_ADDR_WIDTH(RAM_ADDR_WIDTH),
    .PCIE_ADDR_WIDTH(PCIE_ADDR_WIDTH),
    .PCIE_TAG_COUNT(64),
    .PCIE_EXT_TAG_ENABLE(1),
    .LEN_WIDTH(PCIE_DMA_LEN_WIDTH),
    .TAG_WIDTH(PCIE_DMA_TAG_WIDTH)
)
dma_if_pcie_us_inst (
    .clk(pcie_clk),
    .rst(pcie_rst),

    /*
     * AXI input (RC)
     */
    .s_axis_rc_tdata(axis_rc_tdata_r),
    .s_axis_rc_tkeep(axis_rc_tkeep_r),
    .s_axis_rc_tvalid(axis_rc_tvalid_r),
    .s_axis_rc_tready(axis_rc_tready_r),
    .s_axis_rc_tlast(axis_rc_tlast_r),
    .s_axis_rc_tuser(axis_rc_tuser_r),

    /*
     * AXI output (RQ)
     */
    .m_axis_rq_tdata(m_axis_rq_tdata),
    .m_axis_rq_tkeep(m_axis_rq_tkeep),
    .m_axis_rq_tvalid(m_axis_rq_tvalid),
    .m_axis_rq_tready(m_axis_rq_tready),
    .m_axis_rq_tlast(m_axis_rq_tlast),
    .m_axis_rq_tuser(m_axis_rq_tuser),

    /*
     * AXI read descriptor input
     */
    .s_axis_read_desc_pcie_addr(pcie_dma_read_desc_pcie_addr),
    .s_axis_read_desc_ram_sel(pcie_dma_read_desc_ram_sel),
    .s_axis_read_desc_ram_addr(pcie_dma_read_desc_ram_addr),
    .s_axis_read_desc_len(pcie_dma_read_desc_len),
    .s_axis_read_desc_tag(pcie_dma_read_desc_tag),
    .s_axis_read_desc_valid(pcie_dma_read_desc_valid),
    .s_axis_read_desc_ready(pcie_dma_read_desc_ready),

    /*
     * AXI read descriptor status output
     */
    .m_axis_read_desc_status_tag(pcie_dma_read_desc_status_tag),
    .m_axis_read_desc_status_valid(pcie_dma_read_desc_status_valid),

    /*
     * AXI write descriptor input
     */
    .s_axis_write_desc_pcie_addr(pcie_dma_write_desc_pcie_addr),
    .s_axis_write_desc_ram_sel(pcie_dma_write_desc_ram_sel),
    .s_axis_write_desc_ram_addr(pcie_dma_write_desc_ram_addr),
    .s_axis_write_desc_len(pcie_dma_write_desc_len),
    .s_axis_write_desc_tag(pcie_dma_write_desc_tag),
    .s_axis_write_desc_valid(pcie_dma_write_desc_valid),
    .s_axis_write_desc_ready(pcie_dma_write_desc_ready),

    /*
     * AXI write descriptor status output
     */
    .m_axis_write_desc_status_tag(pcie_dma_write_desc_status_tag),
    .m_axis_write_desc_status_valid(pcie_dma_write_desc_status_valid),

    /*
     * RAM interface
     */
    .ram_wr_cmd_sel(dma_ram_wr_cmd_sel),
    .ram_wr_cmd_be(dma_ram_wr_cmd_be),
    .ram_wr_cmd_addr(dma_ram_wr_cmd_addr),
    .ram_wr_cmd_data(dma_ram_wr_cmd_data),
    .ram_wr_cmd_valid(dma_ram_wr_cmd_valid),
    .ram_wr_cmd_ready(dma_ram_wr_cmd_ready),
    .ram_rd_cmd_sel(dma_ram_rd_cmd_sel),
    .ram_rd_cmd_addr(dma_ram_rd_cmd_addr),
    .ram_rd_cmd_valid(dma_ram_rd_cmd_valid),
    .ram_rd_cmd_ready(dma_ram_rd_cmd_ready),
    .ram_rd_resp_data(dma_ram_rd_resp_data),
    .ram_rd_resp_valid(dma_ram_rd_resp_valid),
    .ram_rd_resp_ready(dma_ram_rd_resp_ready),

    /*
     * Configuration
     */
    .read_enable(pcie_dma_enable),
    .write_enable(pcie_dma_enable),
    .ext_tag_enable(ext_tag_enable),
    .requester_id({8'd0, 5'd0, 3'd0}),
    .requester_id_enable(1'b0),
    .max_read_request_size(cfg_max_read_req),
    .max_payload_size(cfg_max_payload),

    /*
     * Status
     */
    .status_error_cor(status_error_cor_int[1]),
    .status_error_uncor(status_error_uncor_int[1])
);

// Read and Write controllers for RISCV
wire [PCIE_ADDR_WIDTH-1:0]       cores_dma_read_desc_pcie_addr;
wire [IF_RAM_SEL_WIDTH-1:0]      cores_dma_read_desc_ram_sel;
wire [RAM_ADDR_WIDTH-1:0]        cores_dma_read_desc_ram_addr;  
wire [PCIE_DMA_LEN_WIDTH-1:0]    cores_dma_read_desc_len;   
wire [IF_PCIE_DMA_TAG_WIDTH-1:0] cores_dma_read_desc_tag;
wire                             cores_dma_read_desc_valid;
wire                             cores_dma_read_desc_ready;
wire [IF_PCIE_DMA_TAG_WIDTH-1:0] cores_dma_read_desc_status_tag;
wire                             cores_dma_read_desc_status_valid;
  
wire [PCIE_ADDR_WIDTH-1:0]       cores_dma_write_desc_pcie_addr;
wire [IF_RAM_SEL_WIDTH-1:0]      cores_dma_write_desc_ram_sel;
wire [RAM_ADDR_WIDTH-1:0]        cores_dma_write_desc_ram_addr;
wire [PCIE_DMA_LEN_WIDTH-1:0]    cores_dma_write_desc_len;
wire [IF_PCIE_DMA_TAG_WIDTH-1:0] cores_dma_write_desc_tag;
wire                             cores_dma_write_desc_valid;
wire                             cores_dma_write_desc_ready;     
wire [IF_PCIE_DMA_TAG_WIDTH-1:0] cores_dma_write_desc_status_tag;
wire                             cores_dma_write_desc_status_valid;
  
wire [SEG_COUNT*IF_RAM_SEL_WIDTH-1:0] cores_dma_ram_wr_cmd_sel;
wire [SEG_COUNT*SEG_BE_WIDTH-1:0]     cores_dma_ram_wr_cmd_be;
wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0]   cores_dma_ram_wr_cmd_addr;
wire [SEG_COUNT*SEG_DATA_WIDTH-1:0]   cores_dma_ram_wr_cmd_data;
wire [SEG_COUNT-1:0]                  cores_dma_ram_wr_cmd_valid;
wire [SEG_COUNT-1:0]                  cores_dma_ram_wr_cmd_ready;
wire [SEG_COUNT*IF_RAM_SEL_WIDTH-1:0] cores_dma_ram_rd_cmd_sel;
wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0]   cores_dma_ram_rd_cmd_addr;
wire [SEG_COUNT-1:0]                  cores_dma_ram_rd_cmd_valid;
wire [SEG_COUNT-1:0]                  cores_dma_ram_rd_cmd_ready;
wire [SEG_COUNT*SEG_DATA_WIDTH-1:0]   cores_dma_ram_rd_resp_data;
wire [SEG_COUNT-1:0]                  cores_dma_ram_rd_resp_valid;
wire [SEG_COUNT-1:0]                  cores_dma_ram_rd_resp_ready;

pcie_cont_read # (
    .HOST_DMA_TAG_WIDTH(HOST_DMA_TAG_WIDTH),
    .PCIE_ADDR_WIDTH(PCIE_ADDR_WIDTH),
    .PCIE_RAM_ADDR_WIDTH(PCIE_RAM_ADDR_WIDTH),
    .PCIE_SLOT_COUNT(PCIE_SLOT_COUNT),
    .PCIE_SLOT_WIDTH(PCIE_SLOT_WIDTH),
    .PCIE_DMA_TAG_WIDTH(IF_PCIE_DMA_TAG_WIDTH),
    .PCIE_DMA_LEN_WIDTH(PCIE_DMA_LEN_WIDTH),
    .SEG_COUNT(SEG_COUNT),
    .SEG_DATA_WIDTH(SEG_DATA_WIDTH),
    .SEG_ADDR_WIDTH(SEG_ADDR_WIDTH),
    .SEG_BE_WIDTH(SEG_BE_WIDTH),
    .RAM_ADDR_WIDTH(RAM_ADDR_WIDTH),
    .RAM_SIZE(TX_RX_RAM_SIZE),
    .RAM_PIPELINE(RAM_PIPELINE),
    .CORE_COUNT(CORE_COUNT),
    .CORE_WIDTH(CORE_WIDTH),
    .CORE_ADDR_WIDTH(CORE_ADDR_WIDTH),
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .AXIS_KEEP_WIDTH(AXIS_KEEP_WIDTH),
    .AXIS_TAG_WIDTH(AXIS_TAG_WIDTH)
) pcie_cont_read_inst( 
  .pcie_clk  (pcie_clk),
  .pcie_rst  (pcie_rst),
  .dma_enable(pcie_dma_enable),
                                                                            
  // Read descriptor request from host                                      
  .host_dma_read_desc_pcie_addr   (host_dma_read_desc_pcie_addr),
  .host_dma_read_desc_ram_addr    (host_dma_read_desc_ram_addr),
  .host_dma_read_desc_len         (host_dma_read_desc_len),
  .host_dma_read_desc_tag         (host_dma_read_desc_tag),
  .host_dma_read_desc_valid       (host_dma_read_desc_valid),
  .host_dma_read_desc_ready       (host_dma_read_desc_ready),
                                 
  .host_dma_read_desc_status_tag  (host_dma_read_desc_status_tag),
  .host_dma_read_desc_status_valid(host_dma_read_desc_status_valid),
                                                                            
  // Read request coming from cores                                         
  .cores_ctrl_s_tdata (cores_ctrl_s_tdata),
  .cores_ctrl_s_tvalid(cores_ctrl_s_tvalid),
  .cores_ctrl_s_tuser (cores_ctrl_s_tuser),
  .cores_ctrl_s_tready(cores_ctrl_s_tready),
                                                                          
  // Data to cores                                                          
  .cores_rx_tdata (cores_rx_tdata),
  .cores_rx_tkeep (cores_rx_tkeep),
  .cores_rx_tdest (cores_rx_tdest),
  .cores_rx_tvalid(cores_rx_tvalid), 
  .cores_rx_tready(cores_rx_tready),
  .cores_rx_tlast (cores_rx_tlast),
                                                                          
  // Read connection to PCIE DMA                                            
  .pcie_dma_read_desc_pcie_addr   (cores_dma_read_desc_pcie_addr),
  .pcie_dma_read_desc_ram_addr    (cores_dma_read_desc_ram_addr),
  .pcie_dma_read_desc_len         (cores_dma_read_desc_len),
  .pcie_dma_read_desc_tag         (cores_dma_read_desc_tag),
  .pcie_dma_read_desc_valid       (cores_dma_read_desc_valid),
  .pcie_dma_read_desc_ready       (cores_dma_read_desc_ready),

  .pcie_dma_read_desc_status_tag  (cores_dma_read_desc_status_tag),
  .pcie_dma_read_desc_status_valid(cores_dma_read_desc_status_valid),

  .dma_ram_wr_cmd_be   (cores_dma_ram_wr_cmd_be),
  .dma_ram_wr_cmd_addr (cores_dma_ram_wr_cmd_addr),
  .dma_ram_wr_cmd_data (cores_dma_ram_wr_cmd_data),
  .dma_ram_wr_cmd_valid(cores_dma_ram_wr_cmd_valid),
  .dma_ram_wr_cmd_ready(cores_dma_ram_wr_cmd_ready)                    
);

pcie_cont_write # (
    .HOST_DMA_TAG_WIDTH(HOST_DMA_TAG_WIDTH),
    .PCIE_ADDR_WIDTH(PCIE_ADDR_WIDTH),
    .PCIE_RAM_ADDR_WIDTH(PCIE_RAM_ADDR_WIDTH),
    .PCIE_SLOT_COUNT(PCIE_SLOT_COUNT),
    .PCIE_SLOT_WIDTH(PCIE_SLOT_WIDTH),
    .PCIE_DMA_TAG_WIDTH(IF_PCIE_DMA_TAG_WIDTH),
    .PCIE_DMA_LEN_WIDTH(PCIE_DMA_LEN_WIDTH),
    .SEG_COUNT(SEG_COUNT),
    .SEG_DATA_WIDTH(SEG_DATA_WIDTH),
    .SEG_ADDR_WIDTH(SEG_ADDR_WIDTH),
    .SEG_BE_WIDTH(SEG_BE_WIDTH),
    .RAM_ADDR_WIDTH(RAM_ADDR_WIDTH),
    .RAM_SIZE(TX_RX_RAM_SIZE),
    .RAM_PIPELINE(RAM_PIPELINE),
    .CORE_COUNT(CORE_COUNT),
    .CORE_WIDTH(CORE_WIDTH),
    .CORE_ADDR_WIDTH(CORE_ADDR_WIDTH),
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .AXIS_KEEP_WIDTH(AXIS_KEEP_WIDTH),
    .AXIS_TAG_WIDTH(AXIS_TAG_WIDTH)
) pcie_cont_write_inst ( 
  .pcie_clk  (pcie_clk),
  .pcie_rst  (pcie_rst),
  .dma_enable(pcie_dma_enable),
                                                                            
  // Read descriptor request from host                                      
  .host_dma_write_desc_pcie_addr   (host_dma_write_desc_pcie_addr),
  .host_dma_write_desc_ram_addr    (host_dma_write_desc_ram_addr),
  .host_dma_write_desc_len         (host_dma_write_desc_len),
  .host_dma_write_desc_tag         (host_dma_write_desc_tag),
  .host_dma_write_desc_valid       (host_dma_write_desc_valid),
  .host_dma_write_desc_ready       (host_dma_write_desc_ready),
                                 
  .host_dma_write_desc_status_tag  (host_dma_write_desc_status_tag),
  .host_dma_write_desc_status_valid(host_dma_write_desc_status_valid),
                                                                            
  // Read request asking from cores                                         
  .cores_ctrl_m_tdata (cores_ctrl_m_tdata),
  .cores_ctrl_m_tvalid(cores_ctrl_m_tvalid),
  .cores_ctrl_m_tdest (cores_ctrl_m_tdest),
  .cores_ctrl_m_tready(cores_ctrl_m_tready),
                                                                            
  // Data from cores                                                        
  .cores_tx_tdata (cores_tx_tdata),
  .cores_tx_tkeep (cores_tx_tkeep),
  .cores_tx_tuser (cores_tx_tuser),
  .cores_tx_tvalid(cores_tx_tvalid), 
  .cores_tx_tready(cores_tx_tready),
  .cores_tx_tlast (cores_tx_tlast),
                                                                            
  // Write connection to PCIE DMA                                           
  .pcie_dma_write_desc_pcie_addr   (cores_dma_write_desc_pcie_addr),
  .pcie_dma_write_desc_ram_addr    (cores_dma_write_desc_ram_addr),
  .pcie_dma_write_desc_len         (cores_dma_write_desc_len),
  .pcie_dma_write_desc_tag         (cores_dma_write_desc_tag),
  .pcie_dma_write_desc_valid       (cores_dma_write_desc_valid),
  .pcie_dma_write_desc_ready       (cores_dma_write_desc_ready),

  .pcie_dma_write_desc_status_tag  (cores_dma_write_desc_status_tag),
  .pcie_dma_write_desc_status_valid(cores_dma_write_desc_status_valid),

  .dma_ram_rd_cmd_addr  (cores_dma_ram_rd_cmd_addr),
  .dma_ram_rd_cmd_valid (cores_dma_ram_rd_cmd_valid),
  .dma_ram_rd_cmd_ready (cores_dma_ram_rd_cmd_ready),
  .dma_ram_rd_resp_data (cores_dma_ram_rd_resp_data),
  .dma_ram_rd_resp_valid(cores_dma_ram_rd_resp_valid),
  .dma_ram_rd_resp_ready(cores_dma_ram_rd_resp_ready)               
);

assign cores_dma_read_desc_ram_sel  = {IF_RAM_SEL_WIDTH{1'b0}}; //IF_COUNT << ($clog2(PORTS_PER_IF+1));
assign cores_dma_write_desc_ram_sel = {IF_RAM_SEL_WIDTH{1'b0}}; //IF_COUNT << ($clog2(PORTS_PER_IF+1));
    
genvar i;     

generate
  if (IF_COUNT==0) begin
    assign pcie_dma_read_desc_pcie_addr      = cores_dma_read_desc_pcie_addr;
    assign pcie_dma_read_desc_ram_sel        = cores_dma_read_desc_ram_sel;
    assign pcie_dma_read_desc_ram_addr       = cores_dma_read_desc_ram_addr;  
    assign pcie_dma_read_desc_len            = cores_dma_read_desc_len;   
    assign pcie_dma_read_desc_tag            = cores_dma_read_desc_tag;
    assign pcie_dma_read_desc_valid          = cores_dma_read_desc_valid;
    assign cores_dma_read_desc_ready         = pcie_dma_read_desc_ready;
    assign cores_dma_read_desc_status_tag    = pcie_dma_read_desc_status_tag;
    assign cores_dma_read_desc_status_valid  = pcie_dma_read_desc_status_valid;
    
    assign pcie_dma_write_desc_pcie_addr     = cores_dma_write_desc_pcie_addr;
    assign pcie_dma_write_desc_ram_sel       = cores_dma_write_desc_ram_sel;
    assign pcie_dma_write_desc_ram_addr      = cores_dma_write_desc_ram_addr;
    assign pcie_dma_write_desc_len           = cores_dma_write_desc_len;
    assign pcie_dma_write_desc_tag           = cores_dma_write_desc_tag;
    assign pcie_dma_write_desc_valid         = cores_dma_write_desc_valid;
    assign cores_dma_write_desc_ready        = pcie_dma_write_desc_ready;     
    assign cores_dma_write_desc_status_tag   = pcie_dma_write_desc_status_tag;
    assign cores_dma_write_desc_status_valid = pcie_dma_write_desc_status_valid;
      
    assign cores_dma_ram_wr_cmd_be     = dma_ram_wr_cmd_be;
    assign cores_dma_ram_wr_cmd_addr   = dma_ram_wr_cmd_addr;
    assign cores_dma_ram_wr_cmd_data   = dma_ram_wr_cmd_data;
    assign cores_dma_ram_wr_cmd_valid  = dma_ram_wr_cmd_valid;
    assign dma_ram_wr_cmd_ready        = cores_dma_ram_wr_cmd_ready;
  
    assign cores_dma_ram_rd_cmd_addr   = dma_ram_rd_cmd_addr;
    assign cores_dma_ram_rd_cmd_valid  = dma_ram_rd_cmd_valid;
    assign dma_ram_rd_cmd_ready        = cores_dma_ram_rd_cmd_ready;
    assign dma_ram_rd_resp_data        = cores_dma_ram_rd_resp_data;
    assign dma_ram_rd_resp_valid       = cores_dma_ram_rd_resp_valid;
    assign cores_dma_ram_rd_resp_ready = dma_ram_rd_resp_ready;
    
    assign axil_ctrl_awaddr  = axil_pcie_awaddr;
    assign axil_ctrl_awprot  = axil_pcie_awprot;
    assign axil_ctrl_awvalid = axil_pcie_awvalid;
    assign axil_pcie_awready = axil_ctrl_awready;
    assign axil_ctrl_wdata   = axil_pcie_wdata;
    assign axil_ctrl_wstrb   = axil_pcie_wstrb;
    assign axil_ctrl_wvalid  = axil_pcie_wvalid;
    assign axil_pcie_wready  = axil_ctrl_wready;
    assign axil_pcie_bresp   = axil_ctrl_bresp;
    assign axil_pcie_bvalid  = axil_ctrl_bvalid;
    assign axil_ctrl_bready  = axil_pcie_bready;
    assign axil_ctrl_araddr  = axil_pcie_araddr;
    assign axil_ctrl_arprot  = axil_pcie_arprot;
    assign axil_ctrl_arvalid = axil_pcie_arvalid;
    assign axil_pcie_arready = axil_ctrl_arready;
    assign axil_pcie_rdata   = axil_ctrl_rdata;
    assign axil_pcie_rresp   = axil_ctrl_rresp;
    assign axil_pcie_rvalid  = axil_ctrl_rvalid;
    assign axil_ctrl_rready  = axil_pcie_rready; 
    
    assign tx_axis_tdata  = {AXIS_DATA_WIDTH{1'b0}};
    assign tx_axis_tkeep  = {AXIS_KEEP_WIDTH{1'b0}};
    assign tx_axis_tvalid = 1'b0;
    assign tx_axis_tlast  = 1'b0;
    assign tx_axis_tuser  = 1'b0;
    assign rx_axis_tready = 1'b0;
    assign msi_irq        = 32'd0;
  
  end else begin
      
    wire [IF_COUNT*PCIE_ADDR_WIDTH-1:0]            if_pcie_dma_read_desc_pcie_addr;
    wire [IF_COUNT*IF_RAM_SEL_WIDTH-1:0]           if_pcie_dma_read_desc_ram_sel;
    wire [IF_COUNT*RAM_ADDR_WIDTH-1:0]             if_pcie_dma_read_desc_ram_addr;
    wire [IF_COUNT*PCIE_DMA_LEN_WIDTH-1:0]         if_pcie_dma_read_desc_len;
    wire [IF_COUNT*IF_PCIE_DMA_TAG_WIDTH-1:0]      if_pcie_dma_read_desc_tag;
    wire [IF_COUNT-1:0]                            if_pcie_dma_read_desc_valid;
    wire [IF_COUNT-1:0]                            if_pcie_dma_read_desc_ready;
    
    wire [IF_COUNT*IF_PCIE_DMA_TAG_WIDTH-1:0]      if_pcie_dma_read_desc_status_tag;
    wire [IF_COUNT-1:0]                            if_pcie_dma_read_desc_status_valid;
    
    wire [IF_COUNT*PCIE_ADDR_WIDTH-1:0]            if_pcie_dma_write_desc_pcie_addr;
    wire [IF_COUNT*IF_RAM_SEL_WIDTH-1:0]           if_pcie_dma_write_desc_ram_sel;
    wire [IF_COUNT*RAM_ADDR_WIDTH-1:0]             if_pcie_dma_write_desc_ram_addr;
    wire [IF_COUNT*PCIE_DMA_LEN_WIDTH-1:0]         if_pcie_dma_write_desc_len;
    wire [IF_COUNT*IF_PCIE_DMA_TAG_WIDTH-1:0]      if_pcie_dma_write_desc_tag;
    wire [IF_COUNT-1:0]                            if_pcie_dma_write_desc_valid;
    wire [IF_COUNT-1:0]                            if_pcie_dma_write_desc_ready;
    
    wire [IF_COUNT*IF_PCIE_DMA_TAG_WIDTH-1:0]      if_pcie_dma_write_desc_status_tag;
    wire [IF_COUNT-1:0]                            if_pcie_dma_write_desc_status_valid;
    
    wire [IF_COUNT*SEG_COUNT*IF_RAM_SEL_WIDTH-1:0] if_dma_ram_wr_cmd_sel;
    wire [IF_COUNT*SEG_COUNT*SEG_BE_WIDTH-1:0]     if_dma_ram_wr_cmd_be;
    wire [IF_COUNT*SEG_COUNT*SEG_ADDR_WIDTH-1:0]   if_dma_ram_wr_cmd_addr;
    wire [IF_COUNT*SEG_COUNT*SEG_DATA_WIDTH-1:0]   if_dma_ram_wr_cmd_data;
    wire [IF_COUNT*SEG_COUNT-1:0]                  if_dma_ram_wr_cmd_valid;
    wire [IF_COUNT*SEG_COUNT-1:0]                  if_dma_ram_wr_cmd_ready;
    
    wire [IF_COUNT*SEG_COUNT*IF_RAM_SEL_WIDTH-1:0] if_dma_ram_rd_cmd_sel;
    wire [IF_COUNT*SEG_COUNT*SEG_ADDR_WIDTH-1:0]   if_dma_ram_rd_cmd_addr;
    wire [IF_COUNT*SEG_COUNT-1:0]                  if_dma_ram_rd_cmd_valid;
    wire [IF_COUNT*SEG_COUNT-1:0]                  if_dma_ram_rd_cmd_ready;
    wire [IF_COUNT*SEG_COUNT*SEG_DATA_WIDTH-1:0]   if_dma_ram_rd_resp_data;
    wire [IF_COUNT*SEG_COUNT-1:0]                  if_dma_ram_rd_resp_valid;
    wire [IF_COUNT*SEG_COUNT-1:0]                  if_dma_ram_rd_resp_ready;
  
    wire [PORT_COUNT*256-1:0] if_tx_axis_tdata;
    wire [PORT_COUNT*32-1:0]  if_tx_axis_tkeep;
    wire [PORT_COUNT-1:0]     if_tx_axis_tvalid;
    wire [PORT_COUNT-1:0]     if_tx_axis_tready;
    wire [PORT_COUNT-1:0]     if_tx_axis_tlast;
    wire [PORT_COUNT-1:0]     if_tx_axis_tuser;
  
    wire [PORT_COUNT*256-1:0] if_rx_axis_tdata;
    wire [PORT_COUNT*32-1:0]  if_rx_axis_tkeep;
    wire [PORT_COUNT-1:0]     if_rx_axis_tvalid;
    wire [PORT_COUNT-1:0]     if_rx_axis_tready;
    wire [PORT_COUNT-1:0]     if_rx_axis_tlast;
    wire [PORT_COUNT-1:0]     if_rx_axis_tuser;
    
    dma_if_mux #
    (
        .PORTS(IF_COUNT+1),
        .SEG_COUNT(SEG_COUNT),
        .SEG_DATA_WIDTH(SEG_DATA_WIDTH),
        .SEG_ADDR_WIDTH(SEG_ADDR_WIDTH),
        .SEG_BE_WIDTH(SEG_BE_WIDTH),
        .S_RAM_SEL_WIDTH(IF_RAM_SEL_WIDTH),
        .M_RAM_SEL_WIDTH(RAM_SEL_WIDTH),
        .RAM_ADDR_WIDTH(RAM_ADDR_WIDTH),
        .DMA_ADDR_WIDTH(PCIE_ADDR_WIDTH),
        .LEN_WIDTH(PCIE_DMA_LEN_WIDTH),
        .S_TAG_WIDTH(IF_PCIE_DMA_TAG_WIDTH),
        .M_TAG_WIDTH(PCIE_DMA_TAG_WIDTH),
        .ARB_TYPE("ROUND_ROBIN"),
        .LSB_PRIORITY("HIGH")
    )
    dma_if_mux_inst (
        .clk(pcie_clk),
        .rst(pcie_rst),
    
        /*
         * Read descriptor output (to DMA interface)
         */
        .m_axis_read_desc_dma_addr(pcie_dma_read_desc_pcie_addr),
        .m_axis_read_desc_ram_sel(pcie_dma_read_desc_ram_sel),
        .m_axis_read_desc_ram_addr(pcie_dma_read_desc_ram_addr),
        .m_axis_read_desc_len(pcie_dma_read_desc_len),
        .m_axis_read_desc_tag(pcie_dma_read_desc_tag),
        .m_axis_read_desc_valid(pcie_dma_read_desc_valid),
        .m_axis_read_desc_ready(pcie_dma_read_desc_ready),
    
        /*
         * Read descriptor status input (from DMA interface)
         */
        .s_axis_read_desc_status_tag(pcie_dma_read_desc_status_tag),
        .s_axis_read_desc_status_valid(pcie_dma_read_desc_status_valid),
    
        /*
         * Read descriptor input
         */
        .s_axis_read_desc_dma_addr({cores_dma_read_desc_pcie_addr, if_pcie_dma_read_desc_pcie_addr}),
        .s_axis_read_desc_ram_sel ({cores_dma_read_desc_ram_sel,   if_pcie_dma_read_desc_ram_sel  }),
        .s_axis_read_desc_ram_addr({cores_dma_read_desc_ram_addr,  if_pcie_dma_read_desc_ram_addr }),
        .s_axis_read_desc_len     ({cores_dma_read_desc_len,       if_pcie_dma_read_desc_len      }),
        .s_axis_read_desc_tag     ({cores_dma_read_desc_tag,       if_pcie_dma_read_desc_tag      }),
        .s_axis_read_desc_valid   ({cores_dma_read_desc_valid,     if_pcie_dma_read_desc_valid    }),
        .s_axis_read_desc_ready   ({cores_dma_read_desc_ready,     if_pcie_dma_read_desc_ready    }),
    
        /*
         * Read descriptor status output
         */
        .m_axis_read_desc_status_tag({cores_dma_read_desc_status_tag, if_pcie_dma_read_desc_status_tag}),
        .m_axis_read_desc_status_valid({cores_dma_read_desc_status_valid, if_pcie_dma_read_desc_status_valid}),
    
        /*
         * Write descriptor output (to DMA interface)
         */
        .m_axis_write_desc_dma_addr(pcie_dma_write_desc_pcie_addr),
        .m_axis_write_desc_ram_sel(pcie_dma_write_desc_ram_sel),
        .m_axis_write_desc_ram_addr(pcie_dma_write_desc_ram_addr),
        .m_axis_write_desc_len(pcie_dma_write_desc_len),
        .m_axis_write_desc_tag(pcie_dma_write_desc_tag),
        .m_axis_write_desc_valid(pcie_dma_write_desc_valid),
        .m_axis_write_desc_ready(pcie_dma_write_desc_ready),
    
        /*
         * Write descriptor status input (from DMA interface)
         */
        .s_axis_write_desc_status_tag(pcie_dma_write_desc_status_tag),
        .s_axis_write_desc_status_valid(pcie_dma_write_desc_status_valid),
    
        /*
         * Write descriptor input
         */
        .s_axis_write_desc_dma_addr({cores_dma_write_desc_pcie_addr, if_pcie_dma_write_desc_pcie_addr}),
        .s_axis_write_desc_ram_sel ({cores_dma_write_desc_ram_sel,   if_pcie_dma_write_desc_ram_sel}),
        .s_axis_write_desc_ram_addr({cores_dma_write_desc_ram_addr,  if_pcie_dma_write_desc_ram_addr}),
        .s_axis_write_desc_len     ({cores_dma_write_desc_len,       if_pcie_dma_write_desc_len}),
        .s_axis_write_desc_tag     ({cores_dma_write_desc_tag,       if_pcie_dma_write_desc_tag}),
        .s_axis_write_desc_valid   ({cores_dma_write_desc_valid,     if_pcie_dma_write_desc_valid}),
        .s_axis_write_desc_ready   ({cores_dma_write_desc_ready,     if_pcie_dma_write_desc_ready}),
    
        /*
         * Write descriptor status output
         */
        .m_axis_write_desc_status_tag({cores_dma_write_desc_status_tag, if_pcie_dma_write_desc_status_tag}),
        .m_axis_write_desc_status_valid({cores_dma_write_desc_status_valid, if_pcie_dma_write_desc_status_valid}),
    
        /*
         * RAM interface (from DMA interface)
         */
        .if_ram_wr_cmd_sel(dma_ram_wr_cmd_sel),
        .if_ram_wr_cmd_be(dma_ram_wr_cmd_be),
        .if_ram_wr_cmd_addr(dma_ram_wr_cmd_addr),
        .if_ram_wr_cmd_data(dma_ram_wr_cmd_data),
        .if_ram_wr_cmd_valid(dma_ram_wr_cmd_valid),
        .if_ram_wr_cmd_ready(dma_ram_wr_cmd_ready),
        .if_ram_rd_cmd_sel(dma_ram_rd_cmd_sel),
        .if_ram_rd_cmd_addr(dma_ram_rd_cmd_addr),
        .if_ram_rd_cmd_valid(dma_ram_rd_cmd_valid),
        .if_ram_rd_cmd_ready(dma_ram_rd_cmd_ready),
        .if_ram_rd_resp_data(dma_ram_rd_resp_data),
        .if_ram_rd_resp_valid(dma_ram_rd_resp_valid),
        .if_ram_rd_resp_ready(dma_ram_rd_resp_ready),
    
        /*
         * RAM interface
         */
        .ram_wr_cmd_sel   ({cores_dma_ram_wr_cmd_sel,    if_dma_ram_wr_cmd_sel}),
        .ram_wr_cmd_be    ({cores_dma_ram_wr_cmd_be,     if_dma_ram_wr_cmd_be}),
        .ram_wr_cmd_addr  ({cores_dma_ram_wr_cmd_addr,   if_dma_ram_wr_cmd_addr}),
        .ram_wr_cmd_data  ({cores_dma_ram_wr_cmd_data,   if_dma_ram_wr_cmd_data}),
        .ram_wr_cmd_valid ({cores_dma_ram_wr_cmd_valid,  if_dma_ram_wr_cmd_valid}),
        .ram_wr_cmd_ready ({cores_dma_ram_wr_cmd_ready,  if_dma_ram_wr_cmd_ready}),
        .ram_rd_cmd_sel   ({cores_dma_ram_rd_cmd_sel,    if_dma_ram_rd_cmd_sel}),
        .ram_rd_cmd_addr  ({cores_dma_ram_rd_cmd_addr,   if_dma_ram_rd_cmd_addr}),
        .ram_rd_cmd_valid ({cores_dma_ram_rd_cmd_valid,  if_dma_ram_rd_cmd_valid}),
        .ram_rd_cmd_ready ({cores_dma_ram_rd_cmd_ready,  if_dma_ram_rd_cmd_ready}),
        .ram_rd_resp_data ({cores_dma_ram_rd_resp_data,  if_dma_ram_rd_resp_data}),
        .ram_rd_resp_valid({cores_dma_ram_rd_resp_valid, if_dma_ram_rd_resp_valid}),
        .ram_rd_resp_ready({cores_dma_ram_rd_resp_ready, if_dma_ram_rd_resp_ready})
    );
  
    corundum # (
        .IF_COUNT(IF_COUNT),
        .PORTS_PER_IF(PORTS_PER_IF),
        .AXIL_DATA_WIDTH(AXIL_DATA_WIDTH),
        .AXIL_STRB_WIDTH(AXIL_STRB_WIDTH),
        .AXIL_ADDR_WIDTH(AXIL_ADDR_WIDTH),
        .IF_AXIL_ADDR_WIDTH(IF_AXIL_ADDR_WIDTH),
        .AXIL_CSR_ADDR_WIDTH(AXIL_CSR_ADDR_WIDTH),
        .AXIS_DATA_WIDTH(256),
        .AXIS_KEEP_WIDTH(256/8),
        .HOST_DMA_TAG_WIDTH(HOST_DMA_TAG_WIDTH),
        .PCIE_ADDR_WIDTH(PCIE_ADDR_WIDTH),
        .PCIE_DMA_TAG_WIDTH(PCIE_DMA_TAG_WIDTH),
        .PCIE_DMA_LEN_WIDTH(PCIE_DMA_LEN_WIDTH),
        .SEG_COUNT(SEG_COUNT),
        .SEG_DATA_WIDTH(SEG_DATA_WIDTH),
        .SEG_ADDR_WIDTH(SEG_ADDR_WIDTH),
        .SEG_BE_WIDTH(SEG_BE_WIDTH),
        .RAM_ADDR_WIDTH(RAM_ADDR_WIDTH),
        .RAM_SEL_WIDTH(RAM_SEL_WIDTH),
        .RAM_PIPELINE(RAM_PIPELINE),
        .IF_RAM_SEL_WIDTH(IF_RAM_SEL_WIDTH),
        .IF_PCIE_DMA_TAG_WIDTH(IF_PCIE_DMA_TAG_WIDTH)
    ) corundum_inst (
        .pcie_clk(pcie_clk),
        .pcie_rst(pcie_rst),
    
        .if_pcie_dma_read_desc_pcie_addr    (if_pcie_dma_read_desc_pcie_addr),
        .if_pcie_dma_read_desc_ram_sel      (if_pcie_dma_read_desc_ram_sel),
        .if_pcie_dma_read_desc_ram_addr     (if_pcie_dma_read_desc_ram_addr),
        .if_pcie_dma_read_desc_len          (if_pcie_dma_read_desc_len),
        .if_pcie_dma_read_desc_tag          (if_pcie_dma_read_desc_tag),
        .if_pcie_dma_read_desc_valid        (if_pcie_dma_read_desc_valid),
        .if_pcie_dma_read_desc_ready        (if_pcie_dma_read_desc_ready),
    
        .if_pcie_dma_read_desc_status_tag   (if_pcie_dma_read_desc_status_tag),
        .if_pcie_dma_read_desc_status_valid (if_pcie_dma_read_desc_status_valid),
    
        .if_pcie_dma_write_desc_pcie_addr   (if_pcie_dma_write_desc_pcie_addr),
        .if_pcie_dma_write_desc_ram_sel     (if_pcie_dma_write_desc_ram_sel),
        .if_pcie_dma_write_desc_ram_addr    (if_pcie_dma_write_desc_ram_addr),
        .if_pcie_dma_write_desc_len         (if_pcie_dma_write_desc_len),
        .if_pcie_dma_write_desc_tag         (if_pcie_dma_write_desc_tag),
        .if_pcie_dma_write_desc_valid       (if_pcie_dma_write_desc_valid),
        .if_pcie_dma_write_desc_ready       (if_pcie_dma_write_desc_ready),
    
        .if_pcie_dma_write_desc_status_tag  (if_pcie_dma_write_desc_status_tag),
        .if_pcie_dma_write_desc_status_valid(if_pcie_dma_write_desc_status_valid),
    
        .if_dma_ram_wr_cmd_sel   (if_dma_ram_wr_cmd_sel),
        .if_dma_ram_wr_cmd_be    (if_dma_ram_wr_cmd_be),
        .if_dma_ram_wr_cmd_addr  (if_dma_ram_wr_cmd_addr),
        .if_dma_ram_wr_cmd_data  (if_dma_ram_wr_cmd_data),
        .if_dma_ram_wr_cmd_valid (if_dma_ram_wr_cmd_valid),
        .if_dma_ram_wr_cmd_ready (if_dma_ram_wr_cmd_ready),
     
        .if_dma_ram_rd_cmd_sel   (if_dma_ram_rd_cmd_sel),
        .if_dma_ram_rd_cmd_addr  (if_dma_ram_rd_cmd_addr),
        .if_dma_ram_rd_cmd_valid (if_dma_ram_rd_cmd_valid),
        .if_dma_ram_rd_cmd_ready (if_dma_ram_rd_cmd_ready),
        .if_dma_ram_rd_resp_data (if_dma_ram_rd_resp_data),
        .if_dma_ram_rd_resp_valid(if_dma_ram_rd_resp_valid),
        .if_dma_ram_rd_resp_ready(if_dma_ram_rd_resp_ready),
    
        .tx_axis_tdata(if_tx_axis_tdata),
        .tx_axis_tkeep(if_tx_axis_tkeep),
        .tx_axis_tvalid(if_tx_axis_tvalid),
        .tx_axis_tready(if_tx_axis_tready),
        .tx_axis_tlast(if_tx_axis_tlast),
        .tx_axis_tuser(if_tx_axis_tuser),
    
        .rx_axis_tdata(if_rx_axis_tdata),
        .rx_axis_tkeep(if_rx_axis_tkeep),
        .rx_axis_tvalid(if_rx_axis_tvalid),
        .rx_axis_tready(if_rx_axis_tready),
        .rx_axis_tlast(if_rx_axis_tlast),
        .rx_axis_tuser(if_rx_axis_tuser),
    
        .axil_pcie_awaddr (axil_pcie_awaddr),
        .axil_pcie_awprot (axil_pcie_awprot),
        .axil_pcie_awvalid(axil_pcie_awvalid),
        .axil_pcie_awready(axil_pcie_awready),
        .axil_pcie_wdata  (axil_pcie_wdata),
        .axil_pcie_wstrb  (axil_pcie_wstrb),
        .axil_pcie_wvalid (axil_pcie_wvalid),
        .axil_pcie_wready (axil_pcie_wready),
        .axil_pcie_bresp  (axil_pcie_bresp),
        .axil_pcie_bvalid (axil_pcie_bvalid),
        .axil_pcie_bready (axil_pcie_bready),
        .axil_pcie_araddr (axil_pcie_araddr),
        .axil_pcie_arprot (axil_pcie_arprot),
        .axil_pcie_arvalid(axil_pcie_arvalid),
        .axil_pcie_arready(axil_pcie_arready),
        .axil_pcie_rdata  (axil_pcie_rdata),
        .axil_pcie_rresp  (axil_pcie_rresp),
        .axil_pcie_rvalid (axil_pcie_rvalid),
        .axil_pcie_rready (axil_pcie_rready),
    
        .axil_ctrl_awaddr (axil_ctrl_awaddr[AXIL_CSR_ADDR_WIDTH-1:0]),
        .axil_ctrl_awprot (axil_ctrl_awprot),
        .axil_ctrl_awvalid(axil_ctrl_awvalid),
        .axil_ctrl_awready(axil_ctrl_awready),
        .axil_ctrl_wdata  (axil_ctrl_wdata),
        .axil_ctrl_wstrb  (axil_ctrl_wstrb),
        .axil_ctrl_wvalid (axil_ctrl_wvalid),
        .axil_ctrl_wready (axil_ctrl_wready),
        .axil_ctrl_bresp  (axil_ctrl_bresp),
        .axil_ctrl_bvalid (axil_ctrl_bvalid),
        .axil_ctrl_bready (axil_ctrl_bready),
        .axil_ctrl_araddr (axil_ctrl_araddr[AXIL_CSR_ADDR_WIDTH-1:0]),
        .axil_ctrl_arprot (axil_ctrl_arprot),
        .axil_ctrl_arvalid(axil_ctrl_arvalid),
        .axil_ctrl_arready(axil_ctrl_arready),
        .axil_ctrl_rdata  (axil_ctrl_rdata),
        .axil_ctrl_rresp  (axil_ctrl_rresp),
        .axil_ctrl_rvalid (axil_ctrl_rvalid),
        .axil_ctrl_rready (axil_ctrl_rready),
    
        .msi_irq(msi_irq)
    );
    
    assign axil_ctrl_awaddr[AXIL_ADDR_WIDTH-1:AXIL_CSR_ADDR_WIDTH] = 
                           {(AXIL_ADDR_WIDTH-AXIL_CSR_ADDR_WIDTH){1'b0}};
    assign axil_ctrl_araddr[AXIL_ADDR_WIDTH-1:AXIL_CSR_ADDR_WIDTH] = 
                           {(AXIL_ADDR_WIDTH-AXIL_CSR_ADDR_WIDTH){1'b0}};
 
    for (i=0;i<PORT_COUNT;i=i+1) begin : mac_async_fifoes
      axis_async_fifo_adapter # (
          .DEPTH(MAC_ASYNC_FIFO_SIZE),
          .S_DATA_WIDTH(256),
          .S_KEEP_ENABLE(1), 
          .S_KEEP_WIDTH(32),
          .M_DATA_WIDTH(AXIS_DATA_WIDTH),
          .M_KEEP_ENABLE(1),
          .M_KEEP_WIDTH(AXIS_KEEP_WIDTH),
          .ID_ENABLE(0),
          .DEST_ENABLE(0),
          .USER_ENABLE(1),
          .USER_WIDTH(1),
          .FRAME_FIFO(0)
      ) tx_async_fifo_inst (
          .s_clk(pcie_clk),
          .s_rst(pcie_rst),
          .s_axis_tdata (if_tx_axis_tdata[i*256 +: 256]),
          .s_axis_tkeep (if_tx_axis_tkeep[i*32 +: 32]),
          .s_axis_tvalid(if_tx_axis_tvalid[i]),
          .s_axis_tready(if_tx_axis_tready[i]),
          .s_axis_tlast (if_tx_axis_tlast[i]),
          .s_axis_tid   (8'd0),
          .s_axis_tdest (8'd0),
          .s_axis_tuser (if_tx_axis_tuser[i]),
      
          .m_clk(sys_clk),
          .m_rst(sys_rst),
          .m_axis_tdata (tx_axis_tdata[i*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
          .m_axis_tkeep (tx_axis_tkeep[i*AXIS_KEEP_WIDTH +: AXIS_KEEP_WIDTH]),
          .m_axis_tvalid(tx_axis_tvalid[i]),
          .m_axis_tready(tx_axis_tready[i]),
          .m_axis_tlast (tx_axis_tlast[i]),
          .m_axis_tid   (),
          .m_axis_tdest (),
          .m_axis_tuser (tx_axis_tuser[i]),
      
          .s_status_overflow(),
          .s_status_bad_frame(),
          .s_status_good_frame(),
          .m_status_overflow(),
          .m_status_bad_frame(),
          .m_status_good_frame()
      );
      
      axis_async_fifo_adapter # (
          .DEPTH(MAC_ASYNC_FIFO_SIZE),
          .S_DATA_WIDTH(AXIS_DATA_WIDTH),
          .S_KEEP_ENABLE(1),
          .S_KEEP_WIDTH(AXIS_KEEP_WIDTH),
          .M_DATA_WIDTH(256),
          .M_KEEP_ENABLE(1), 
          .M_KEEP_WIDTH(32),
          .ID_ENABLE(0),
          .DEST_ENABLE(0),
          .USER_ENABLE(1),
          .USER_WIDTH(1),
          .FRAME_FIFO(0)
      ) rx_async_fifo_inst (
          .s_clk(sys_clk),
          .s_rst(sys_rst),
          .s_axis_tdata (rx_axis_tdata[i*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
          .s_axis_tkeep (rx_axis_tkeep[i*AXIS_KEEP_WIDTH +: AXIS_KEEP_WIDTH]),
          .s_axis_tvalid(rx_axis_tvalid[i]),
          .s_axis_tready(rx_axis_tready[i]),
          .s_axis_tlast (rx_axis_tlast[i]),
          .s_axis_tid   (8'd0),
          .s_axis_tdest (8'd0),
          .s_axis_tuser (rx_axis_tuser[i]),
      
          .m_clk(pcie_clk),
          .m_rst(pcie_rst),
          .m_axis_tdata (if_rx_axis_tdata[i*256 +: 256]),
          .m_axis_tkeep (if_rx_axis_tkeep[i*32 +: 32]),
          .m_axis_tvalid(if_rx_axis_tvalid[i]),
          .m_axis_tready(if_rx_axis_tready[i]),
          .m_axis_tlast (if_rx_axis_tlast[i]),
          .m_axis_tid   (),
          .m_axis_tdest (),
          .m_axis_tuser (if_rx_axis_tuser[i]),
      
          .s_status_overflow(),
          .s_status_bad_frame(),
          .s_status_good_frame(),
          .m_status_overflow(),
          .m_status_bad_frame(),
          .m_status_good_frame()
      );
    end   
  end
endgenerate 

endmodule

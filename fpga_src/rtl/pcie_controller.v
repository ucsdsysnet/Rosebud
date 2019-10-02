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
  parameter AXIS_PCIE_DATA_WIDTH = 256,
  parameter AXIS_PCIE_KEEP_WIDTH = (AXIS_PCIE_DATA_WIDTH/32),
  parameter AXIS_DATA_WIDTH      = 128, 
  parameter AXIS_KEEP_WIDTH      = 16, 
  parameter AXIS_TAG_WIDTH       = 9, 
  parameter CORE_DESC_WIDTH      = 128,
  parameter CORE_COUNT           = 16,
  parameter CORE_WIDTH           = $clog2(CORE_COUNT), 
  parameter CORE_ADDR_WIDTH      = 16, 
  parameter CORES_ADDR_WIDTH     = CORE_WIDTH+CORE_ADDR_WIDTH, 
  parameter PCIE_SLOT_COUNT      = 16,
  parameter PCIE_SLOT_WIDTH      = $clog2(PCIE_SLOT_COUNT) 
) (
  input  wire                            sys_clk,
  input  wire                            sys_rst,
  input  wire                            pcie_clk,
  input  wire                            pcie_rst,

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
  
  // Cores data
  input  wire [AXIS_DATA_WIDTH-1:0]      cores_tx_axis_tdata,
  input  wire [AXIS_KEEP_WIDTH-1:0]      cores_tx_axis_tkeep,
  input  wire [AXIS_TAG_WIDTH-1:0]       cores_tx_axis_tuser,
  input  wire                            cores_tx_axis_tvalid, 
  output wire                            cores_tx_axis_tready, 
  input  wire                            cores_tx_axis_tlast,
  
  output wire [AXIS_DATA_WIDTH-1:0]      cores_rx_axis_tdata,
  output wire [AXIS_KEEP_WIDTH-1:0]      cores_rx_axis_tkeep,
  output wire [AXIS_TAG_WIDTH-1:0]       cores_rx_axis_tdest,
  output wire                            cores_rx_axis_tvalid, 
  input  wire                            cores_rx_axis_tready, 
  output wire                            cores_rx_axis_tlast,
  
  // Cores DRAM requests
  input  wire [CORE_DESC_WIDTH-1:0]      cores_ctrl_s_axis_tdata,
  input  wire                            cores_ctrl_s_axis_tvalid,
  output wire                            cores_ctrl_s_axis_tready,
  input  wire                            cores_ctrl_s_axis_tlast,
  input  wire [CORE_WIDTH-1:0]           cores_ctrl_s_axis_tuser,
  
  output wire [CORE_DESC_WIDTH-1:0]      cores_ctrl_m_axis_tdata,
  output wire                            cores_ctrl_m_axis_tvalid,
  input  wire                            cores_ctrl_m_axis_tready,
  output wire                            cores_ctrl_m_axis_tlast,
  output wire [CORE_WIDTH-1:0]           cores_ctrl_m_axis_tdest
);

parameter PCIE_ADDR_WIDTH = 64;
parameter PCIE_AXI_ADDR_WIDTH = 32;

// AXI lite interface parameters
parameter AXIL_DATA_WIDTH = 32;
parameter AXIL_STRB_WIDTH = (AXIL_DATA_WIDTH/8);
parameter AXIL_ADDR_WIDTH = 32;

// AXI interface parameters
parameter AXI_ID_WIDTH = 8;
parameter AXI_DATA_WIDTH = AXIS_PCIE_DATA_WIDTH;
parameter AXI_STRB_WIDTH = (AXI_DATA_WIDTH/8);
parameter AXI_ADDR_WIDTH = 16;
parameter AXI_LEN_WIDTH  = 16;

// PCIe DMA parameters
parameter PCIE_DMA_LEN_WIDTH = AXI_LEN_WIDTH;
parameter HOST_DMA_TAG_WIDTH = 32;
parameter PCIE_DMA_TAG_WIDTH = PCIE_SLOT_WIDTH;

// AXI lite connections
wire [AXIL_ADDR_WIDTH-1:0] axil_ctrl_awaddr;
wire [2:0]                 axil_ctrl_awprot;
wire                       axil_ctrl_awvalid;
wire                       axil_ctrl_awready;
wire [AXIL_DATA_WIDTH-1:0] axil_ctrl_wdata;
wire [AXIL_STRB_WIDTH-1:0] axil_ctrl_wstrb;
wire                       axil_ctrl_wvalid;
wire                       axil_ctrl_wready;
wire [1:0]                 axil_ctrl_bresp;
wire                       axil_ctrl_bvalid;
wire                       axil_ctrl_bready;
wire [AXIL_ADDR_WIDTH-1:0] axil_ctrl_araddr;
wire [2:0]                 axil_ctrl_arprot;
wire                       axil_ctrl_arvalid;
wire                       axil_ctrl_arready;
wire [AXIL_DATA_WIDTH-1:0] axil_ctrl_rdata;
wire [1:0]                 axil_ctrl_rresp;
wire                       axil_ctrl_rvalid;
wire                       axil_ctrl_rready;

// AXI DMA connections
wire [AXI_ID_WIDTH-1:0]    axi_dma_awid;
wire [AXI_ADDR_WIDTH-1:0]  axi_dma_awaddr;
wire [7:0]                 axi_dma_awlen;
wire [2:0]                 axi_dma_awsize;
wire [1:0]                 axi_dma_awburst;
wire                       axi_dma_awlock;
wire [3:0]                 axi_dma_awcache;
wire [2:0]                 axi_dma_awprot;
wire                       axi_dma_awvalid;
wire                       axi_dma_awready;
wire [AXI_DATA_WIDTH-1:0]  axi_dma_wdata;
wire [AXI_STRB_WIDTH-1:0]  axi_dma_wstrb;
wire                       axi_dma_wlast;
wire                       axi_dma_wvalid;
wire                       axi_dma_wready;
wire [AXI_ID_WIDTH-1:0]    axi_dma_bid;
wire [1:0]                 axi_dma_bresp;
wire                       axi_dma_bvalid;
wire                       axi_dma_bready;
wire [AXI_ID_WIDTH-1:0]    axi_dma_arid;
wire [AXI_ADDR_WIDTH-1:0]  axi_dma_araddr;
wire [7:0]                 axi_dma_arlen;
wire [2:0]                 axi_dma_arsize;
wire [1:0]                 axi_dma_arburst;
wire                       axi_dma_arlock;
wire [3:0]                 axi_dma_arcache;
wire [2:0]                 axi_dma_arprot;
wire                       axi_dma_arvalid;
wire                       axi_dma_arready;
wire [AXI_ID_WIDTH-1:0]    axi_dma_rid;
wire [AXI_DATA_WIDTH-1:0]  axi_dma_rdata;
wire [1:0]                 axi_dma_rresp;
wire                       axi_dma_rlast;
wire                       axi_dma_rvalid;
wire                       axi_dma_rready;

// AXI PCIe DMA connections
wire [AXI_ID_WIDTH-1:0]    axi_pcie_dma_awid;
wire [AXI_ADDR_WIDTH-1:0]  axi_pcie_dma_awaddr;
wire [7:0]                 axi_pcie_dma_awlen;
wire [2:0]                 axi_pcie_dma_awsize;
wire [1:0]                 axi_pcie_dma_awburst;
wire                       axi_pcie_dma_awlock;
wire [3:0]                 axi_pcie_dma_awcache;
wire [2:0]                 axi_pcie_dma_awprot;
wire                       axi_pcie_dma_awvalid;
wire                       axi_pcie_dma_awready;
wire [AXI_DATA_WIDTH-1:0]  axi_pcie_dma_wdata;
wire [AXI_STRB_WIDTH-1:0]  axi_pcie_dma_wstrb;
wire                       axi_pcie_dma_wlast;
wire                       axi_pcie_dma_wvalid;
wire                       axi_pcie_dma_wready;
wire [AXI_ID_WIDTH-1:0]    axi_pcie_dma_bid;
wire [1:0]                 axi_pcie_dma_bresp;
wire                       axi_pcie_dma_bvalid;
wire                       axi_pcie_dma_bready;
wire [AXI_ID_WIDTH-1:0]    axi_pcie_dma_arid;
wire [AXI_ADDR_WIDTH-1:0]  axi_pcie_dma_araddr;
wire [7:0]                 axi_pcie_dma_arlen;
wire [2:0]                 axi_pcie_dma_arsize;
wire [1:0]                 axi_pcie_dma_arburst;
wire                       axi_pcie_dma_arlock;
wire [3:0]                 axi_pcie_dma_arcache;
wire [2:0]                 axi_pcie_dma_arprot;
wire                       axi_pcie_dma_arvalid;
wire                       axi_pcie_dma_arready;
wire [AXI_ID_WIDTH-1:0]    axi_pcie_dma_rid;
wire [AXI_DATA_WIDTH-1:0]  axi_pcie_dma_rdata;
wire [1:0]                 axi_pcie_dma_rresp;
wire                       axi_pcie_dma_rlast;
wire                       axi_pcie_dma_rvalid;
wire                       axi_pcie_dma_rready;

// AXI RAM connections
wire [AXI_ID_WIDTH-1:0]    axi_ram_awid;
wire [AXI_ADDR_WIDTH-1:0]  axi_ram_awaddr;
wire [7:0]                 axi_ram_awlen;
wire [2:0]                 axi_ram_awsize;
wire [1:0]                 axi_ram_awburst;
wire                       axi_ram_awlock;
wire [3:0]                 axi_ram_awcache;
wire [2:0]                 axi_ram_awprot;
wire                       axi_ram_awvalid;
wire                       axi_ram_awready;
wire [AXI_DATA_WIDTH-1:0]  axi_ram_wdata;
wire [AXI_STRB_WIDTH-1:0]  axi_ram_wstrb;
wire                       axi_ram_wlast;
wire                       axi_ram_wvalid;
wire                       axi_ram_wready;
wire [AXI_ID_WIDTH-1:0]    axi_ram_bid;
wire [1:0]                 axi_ram_bresp;
wire                       axi_ram_bvalid;
wire                       axi_ram_bready;
wire [AXI_ID_WIDTH-1:0]    axi_ram_arid;
wire [AXI_ADDR_WIDTH-1:0]  axi_ram_araddr;
wire [7:0]                 axi_ram_arlen;
wire [2:0]                 axi_ram_arsize;
wire [1:0]                 axi_ram_arburst;
wire                       axi_ram_arlock;
wire [3:0]                 axi_ram_arcache;
wire [2:0]                 axi_ram_arprot;
wire                       axi_ram_arvalid;
wire                       axi_ram_arready;
wire [AXI_ID_WIDTH-1:0]    axi_ram_rid;
wire [AXI_DATA_WIDTH-1:0]  axi_ram_rdata;
wire [1:0]                 axi_ram_rresp;
wire                       axi_ram_rlast;
wire                       axi_ram_rvalid;
wire                       axi_ram_rready;

// AXIS data and desc connections
reg  [AXI_ADDR_WIDTH-1:0]  axis_read_desc_addr;
reg  [AXI_LEN_WIDTH-1:0]   axis_read_desc_len;
reg  [PCIE_SLOT_WIDTH-1:0] axis_read_desc_tag;
reg  [AXIS_TAG_WIDTH-1:0]  axis_read_desc_dest;
reg  [CORE_ADDR_WIDTH-1:0] axis_read_desc_user;
reg                        axis_read_desc_valid;
wire                       axis_read_desc_ready;
wire [PCIE_SLOT_WIDTH-1:0] axis_read_desc_status_tag;
wire                       axis_read_desc_status_valid;

wire [AXI_ADDR_WIDTH-1:0]  axis_read_desc_addr_f;
wire [AXI_LEN_WIDTH-1:0]   axis_read_desc_len_f;
wire [PCIE_SLOT_WIDTH-1:0] axis_read_desc_tag_f;
wire [AXIS_TAG_WIDTH-1:0]  axis_read_desc_dest_f;
wire [CORE_ADDR_WIDTH-1:0] axis_read_desc_user_f;
wire                       axis_read_desc_valid_f;
wire                       axis_read_desc_ready_f;

wire [AXI_ADDR_WIDTH-1:0]  axis_write_desc_addr;
wire [AXI_LEN_WIDTH-1:0]   axis_write_desc_len;
wire [PCIE_SLOT_WIDTH-1:0] axis_write_desc_tag;
wire                       axis_write_desc_valid;
wire                       axis_write_desc_ready;
wire [AXI_LEN_WIDTH-1:0]   axis_write_desc_status_len;
wire [PCIE_SLOT_WIDTH-1:0] axis_write_desc_status_tag;
wire [AXIS_TAG_WIDTH-1:0]  axis_write_desc_status_user;
wire                       axis_write_desc_status_valid;

wire [AXI_DATA_WIDTH-1:0]  axis_read_data_tdata;
wire [AXI_STRB_WIDTH-1:0]  axis_read_data_tkeep;
wire                       axis_read_data_tvalid;
wire                       axis_read_data_tready;
wire                       axis_read_data_tlast;
wire [AXIS_TAG_WIDTH-1:0]  axis_read_data_tdest;
wire [CORE_ADDR_WIDTH-1:0] axis_read_data_tuser;

wire [AXI_DATA_WIDTH-1:0]  axis_write_data_tdata;
wire [AXI_STRB_WIDTH-1:0]  axis_write_data_tkeep;
wire                       axis_write_data_tvalid;
wire                       axis_write_data_tready;
wire                       axis_write_data_tlast;
wire [AXIS_TAG_WIDTH-1:0]  axis_write_data_tuser;

// PCIe DMA control
reg  [PCIE_ADDR_WIDTH-1:0]     pcie_dma_read_desc_pcie_addr;
reg  [AXI_ADDR_WIDTH-1:0]      pcie_dma_read_desc_axi_addr;
reg  [PCIE_DMA_LEN_WIDTH-1:0]  pcie_dma_read_desc_len;
reg  [PCIE_DMA_TAG_WIDTH-1:0]  pcie_dma_read_desc_tag;
reg                            pcie_dma_read_desc_valid;
wire                           pcie_dma_read_desc_ready;

wire [PCIE_ADDR_WIDTH-1:0]     pcie_dma_read_desc_pcie_addr_f;
wire [AXI_ADDR_WIDTH-1:0]      pcie_dma_read_desc_axi_addr_f;
wire [PCIE_DMA_LEN_WIDTH-1:0]  pcie_dma_read_desc_len_f;
wire [PCIE_DMA_TAG_WIDTH-1:0]  pcie_dma_read_desc_tag_f;
wire                           pcie_dma_read_desc_valid_f;
wire                           pcie_dma_read_desc_ready_f;


wire [PCIE_DMA_TAG_WIDTH-1:0]  pcie_dma_read_desc_status_tag;
wire                           pcie_dma_read_desc_status_valid;
wire                           pcie_dma_read_desc_status_ready;

reg  [PCIE_ADDR_WIDTH-1:0]     pcie_dma_write_desc_pcie_addr;
reg  [AXI_ADDR_WIDTH-1:0]      pcie_dma_write_desc_axi_addr;
reg  [PCIE_DMA_LEN_WIDTH-1:0]  pcie_dma_write_desc_len;
reg  [PCIE_DMA_TAG_WIDTH-1:0]  pcie_dma_write_desc_tag;
reg                            pcie_dma_write_desc_valid;
wire                           pcie_dma_write_desc_ready;

wire [PCIE_ADDR_WIDTH-1:0]     pcie_dma_write_desc_pcie_addr_f;
wire [AXI_ADDR_WIDTH-1:0]      pcie_dma_write_desc_axi_addr_f;
wire [PCIE_DMA_LEN_WIDTH-1:0]  pcie_dma_write_desc_len_f;
wire [PCIE_DMA_TAG_WIDTH-1:0]  pcie_dma_write_desc_tag_f;
wire                           pcie_dma_write_desc_valid_f;
wire                           pcie_dma_write_desc_ready_f;


wire [PCIE_DMA_TAG_WIDTH-1:0]  pcie_dma_write_desc_status_tag;
wire                           pcie_dma_write_desc_status_valid;
wire                           pcie_dma_write_desc_status_ready;

wire                           pcie_dma_enable;

// DMA requests from Host
wire [PCIE_ADDR_WIDTH-1:0]     host_dma_read_desc_pcie_addr;
wire [PCIE_AXI_ADDR_WIDTH-1:0] host_dma_read_desc_axi_addr;
wire [PCIE_DMA_LEN_WIDTH-1:0]  host_dma_read_desc_len;
wire [HOST_DMA_TAG_WIDTH-1:0]  host_dma_read_desc_tag;
wire                           host_dma_read_desc_valid;
wire                           host_dma_read_desc_ready;

wire [PCIE_ADDR_WIDTH-1:0]     host_dma_read_desc_pcie_addr_f;
wire [PCIE_AXI_ADDR_WIDTH-1:0] host_dma_read_desc_axi_addr_f;
wire [PCIE_DMA_LEN_WIDTH-1:0]  host_dma_read_desc_len_f;
wire [HOST_DMA_TAG_WIDTH-1:0]  host_dma_read_desc_tag_f;
wire                           host_dma_read_desc_valid_f;
wire                           host_dma_read_desc_ready_f;

reg  [HOST_DMA_TAG_WIDTH-1:0]  host_dma_read_desc_status_tag;
reg                            host_dma_read_desc_status_valid;
wire                           host_dma_read_desc_status_ready;

wire [PCIE_ADDR_WIDTH-1:0]     host_dma_write_desc_pcie_addr;
wire [PCIE_AXI_ADDR_WIDTH-1:0] host_dma_write_desc_axi_addr;
wire [PCIE_DMA_LEN_WIDTH-1:0]  host_dma_write_desc_len;
wire [HOST_DMA_TAG_WIDTH-1:0]  host_dma_write_desc_tag;
wire                           host_dma_write_desc_valid;
wire                           host_dma_write_desc_ready;

wire [PCIE_ADDR_WIDTH-1:0]     host_dma_write_desc_pcie_addr_f;
wire [PCIE_AXI_ADDR_WIDTH-1:0] host_dma_write_desc_axi_addr_f;
wire [PCIE_DMA_LEN_WIDTH-1:0]  host_dma_write_desc_len_f;
wire [HOST_DMA_TAG_WIDTH-1:0]  host_dma_write_desc_tag_f;
wire                           host_dma_write_desc_valid_f;
wire                           host_dma_write_desc_ready_f;

reg  [HOST_DMA_TAG_WIDTH-1:0]  host_dma_write_desc_status_tag;
reg                            host_dma_write_desc_status_valid;
wire                           host_dma_write_desc_status_ready;


// -------------------------------------------------------------------//
// -------- Register axis input from PCIe, and error handling --------//
// -------------------------------------------------------------------//

wire [AXIS_PCIE_DATA_WIDTH-1:0] axis_rc_tdata_r;
wire [AXIS_PCIE_KEEP_WIDTH-1:0] axis_rc_tkeep_r;
wire                            axis_rc_tlast_r;
wire                            axis_rc_tready_r;
wire [74:0]                     axis_rc_tuser_r;
wire                            axis_rc_tvalid_r;

axis_register #(
    .DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(75)
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

wire [AXIS_PCIE_DATA_WIDTH-1:0] axis_cq_tdata_r;
wire [AXIS_PCIE_KEEP_WIDTH-1:0] axis_cq_tkeep_r;
wire                            axis_cq_tlast_r;
wire                            axis_cq_tready_r;
wire [84:0]                     axis_cq_tuser_r;
wire                            axis_cq_tvalid_r;

axis_register #(
    .DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(85)
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

// AXIS width convert and cross time domain
wire [AXI_DATA_WIDTH-1:0] cores_tx_tdata;
wire [AXI_STRB_WIDTH-1:0] cores_tx_tkeep;
wire [AXIS_TAG_WIDTH-1:0] cores_tx_tuser;
wire                      cores_tx_tvalid; 
wire                      cores_tx_tready; 
wire                      cores_tx_tlast;

axis_async_fifo_adapter # (
    .DEPTH(1024),
    .S_DATA_WIDTH(AXIS_DATA_WIDTH),
    .S_KEEP_ENABLE(1), 
    .S_KEEP_WIDTH(AXIS_KEEP_WIDTH),
    .M_DATA_WIDTH(AXI_DATA_WIDTH),
    .M_KEEP_ENABLE(1),
    .M_KEEP_WIDTH(AXI_STRB_WIDTH),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(AXIS_TAG_WIDTH),
    .FRAME_FIFO(0)
) cores_tx_axis_data_async_fifo (
    .s_clk(sys_clk),
    .s_rst(sys_rst),
    .s_axis_tdata (cores_tx_axis_tdata),
    .s_axis_tkeep (cores_tx_axis_tkeep),
    .s_axis_tvalid(cores_tx_axis_tvalid),
    .s_axis_tready(cores_tx_axis_tready),
    .s_axis_tlast (cores_tx_axis_tlast),
    .s_axis_tid   (8'd0),
    .s_axis_tdest (8'd0),
    .s_axis_tuser (cores_tx_axis_tuser),

    .m_clk(pcie_clk),
    .m_rst(pcie_rst),
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

wire [AXI_DATA_WIDTH-1:0] cores_rx_tdata;
wire [AXI_STRB_WIDTH-1:0] cores_rx_tkeep;
wire [AXIS_TAG_WIDTH-1:0] cores_rx_tdest;
wire                      cores_rx_tvalid; 
wire                      cores_rx_tready; 
wire                      cores_rx_tlast;

axis_async_fifo_adapter # (
    .DEPTH(1024),
    .S_DATA_WIDTH(AXI_DATA_WIDTH),
    .S_KEEP_ENABLE(1), 
    .S_KEEP_WIDTH(AXI_STRB_WIDTH),
    .M_DATA_WIDTH(AXIS_DATA_WIDTH),
    .M_KEEP_ENABLE(1),
    .M_KEEP_WIDTH(AXIS_KEEP_WIDTH),
    .ID_ENABLE(0),
    .DEST_ENABLE(1),
    .DEST_WIDTH(AXIS_TAG_WIDTH),
    .USER_ENABLE(0),
    .FRAME_FIFO(0)
) cores_rx_axis_data_async_fifo (
    .s_clk(pcie_clk),
    .s_rst(pcie_rst),
    .s_axis_tdata (cores_rx_tdata), 
    .s_axis_tkeep (cores_rx_tkeep), 
    .s_axis_tvalid(cores_rx_tvalid),
    .s_axis_tready(cores_rx_tready),
    .s_axis_tlast (cores_rx_tlast), 
    .s_axis_tid   (8'd0),
    .s_axis_tdest (cores_rx_tdest),
    .s_axis_tuser (1'b0),

    .m_clk(sys_clk),
    .m_rst(sys_rst),
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
 
axis_async_fifo_adapter # (
    .DEPTH(1024),
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
    .s_clk(sys_clk),
    .s_rst(sys_rst),
    .s_axis_tdata (cores_ctrl_s_axis_tdata),
    .s_axis_tkeep ({CORE_DESC_STRB_WIDTH{1'b1}}),
    .s_axis_tvalid(cores_ctrl_s_axis_tvalid),
    .s_axis_tready(cores_ctrl_s_axis_tready),
    .s_axis_tlast (cores_ctrl_s_axis_tlast),
    .s_axis_tid   (8'd0),
    .s_axis_tdest (8'd0),
    .s_axis_tuser (cores_ctrl_s_axis_tuser),

    .m_clk(pcie_clk),
    .m_rst(pcie_rst),
    .m_axis_tdata (cores_ctrl_s_tdata),
    .m_axis_tkeep (),
    .m_axis_tvalid(cores_ctrl_s_tvalid),
    .m_axis_tready(cores_ctrl_s_tready),
    .m_axis_tlast (),
    .m_axis_tid   (),
    .m_axis_tdest (),
    .m_axis_tuser (cores_ctrl_s_tuser),

    .s_status_overflow(),
    .s_status_bad_frame(),
    .s_status_good_frame(),
    .m_status_overflow(),
    .m_status_bad_frame(),
    .m_status_good_frame()
);

reg  [127:0]          cores_ctrl_m_tdata;
reg                   cores_ctrl_m_tvalid;
wire                  cores_ctrl_m_tready;
reg  [CORE_WIDTH-1:0] cores_ctrl_m_tdest;

axis_async_fifo_adapter # (
    .DEPTH(1024),
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
    .s_clk(pcie_clk),
    .s_rst(pcie_rst),
    .s_axis_tdata (cores_ctrl_m_tdata),
    .s_axis_tkeep ({16{1'b1}}),
    .s_axis_tvalid(cores_ctrl_m_tvalid),
    .s_axis_tready(cores_ctrl_m_tready),
    .s_axis_tlast (1'b1),
    .s_axis_tid   (8'd0),
    .s_axis_tdest (cores_ctrl_m_tdest),
    .s_axis_tuser (1'b0),

    .m_clk(sys_clk),
    .m_rst(sys_rst),
    .m_axis_tdata (cores_ctrl_m_axis_tdata),
    .m_axis_tkeep (),
    .m_axis_tvalid(cores_ctrl_m_axis_tvalid),
    .m_axis_tready(cores_ctrl_m_axis_tready),
    .m_axis_tlast (cores_ctrl_m_axis_tlast),
    .m_axis_tid   (),
    .m_axis_tdest (cores_ctrl_m_axis_tdest),
    .m_axis_tuser (),

    .s_status_overflow(),
    .s_status_bad_frame(),
    .s_status_good_frame(),
    .m_status_overflow(),
    .m_status_bad_frame(),
    .m_status_good_frame()
);

// control registers
reg axil_ctrl_awready_reg = 1'b0, axil_ctrl_awready_next;
reg axil_ctrl_wready_reg = 1'b0, axil_ctrl_wready_next;
reg [1:0] axil_ctrl_bresp_reg = 2'b00, axil_ctrl_bresp_next;
reg axil_ctrl_bvalid_reg = 1'b0, axil_ctrl_bvalid_next;
reg axil_ctrl_arready_reg = 1'b0, axil_ctrl_arready_next;
reg [AXIL_DATA_WIDTH-1:0] axil_ctrl_rdata_reg = {AXIL_DATA_WIDTH{1'b0}}, axil_ctrl_rdata_next;
reg [1:0] axil_ctrl_rresp_reg = 2'b00, axil_ctrl_rresp_next;
reg axil_ctrl_rvalid_reg = 1'b0, axil_ctrl_rvalid_next;

reg [PCIE_ADDR_WIDTH-1:0] host_dma_read_desc_pcie_addr_reg = 0, host_dma_read_desc_pcie_addr_next;
reg [PCIE_AXI_ADDR_WIDTH-1:0] host_dma_read_desc_axi_addr_reg = 0, host_dma_read_desc_axi_addr_next;
reg [15:0] host_dma_read_desc_len_reg = 0, host_dma_read_desc_len_next;
reg [HOST_DMA_TAG_WIDTH-1:0] host_dma_read_desc_tag_reg = 0, host_dma_read_desc_tag_next;
reg host_dma_read_desc_valid_reg = 0, host_dma_read_desc_valid_next;

reg host_dma_read_desc_status_ready_reg = 0, host_dma_read_desc_status_ready_next;

reg [PCIE_ADDR_WIDTH-1:0] host_dma_write_desc_pcie_addr_reg = 0, host_dma_write_desc_pcie_addr_next;
reg [PCIE_AXI_ADDR_WIDTH-1:0] host_dma_write_desc_axi_addr_reg = 0, host_dma_write_desc_axi_addr_next;
reg [15:0] host_dma_write_desc_len_reg = 0, host_dma_write_desc_len_next;
reg [HOST_DMA_TAG_WIDTH-1:0] host_dma_write_desc_tag_reg = 0, host_dma_write_desc_tag_next;
reg host_dma_write_desc_valid_reg = 0, host_dma_write_desc_valid_next;

reg host_dma_write_desc_status_ready_reg = 0, host_dma_write_desc_status_ready_next;

reg pcie_dma_enable_reg = 0, pcie_dma_enable_next;

reg [31:0] pcie_rq_count_reg = 0;
reg [31:0] pcie_rc_count_reg = 0;
reg [31:0] pcie_cq_count_reg = 0;
reg [31:0] pcie_cc_count_reg = 0;

assign axil_ctrl_awready = axil_ctrl_awready_reg;
assign axil_ctrl_wready = axil_ctrl_wready_reg;
assign axil_ctrl_bresp = axil_ctrl_bresp_reg;
assign axil_ctrl_bvalid = axil_ctrl_bvalid_reg;
assign axil_ctrl_arready = axil_ctrl_arready_reg;
assign axil_ctrl_rdata = axil_ctrl_rdata_reg;
assign axil_ctrl_rresp = axil_ctrl_rresp_reg;
assign axil_ctrl_rvalid = axil_ctrl_rvalid_reg;

assign host_dma_read_desc_pcie_addr = host_dma_read_desc_pcie_addr_reg;
assign host_dma_read_desc_axi_addr = host_dma_read_desc_axi_addr_reg;
assign host_dma_read_desc_len = host_dma_read_desc_len_reg;
assign host_dma_read_desc_tag = host_dma_read_desc_tag_reg;
assign host_dma_read_desc_valid = host_dma_read_desc_valid_reg;
assign host_dma_read_desc_status_ready = host_dma_read_desc_status_ready_reg;
assign host_dma_write_desc_pcie_addr = host_dma_write_desc_pcie_addr_reg;
assign host_dma_write_desc_axi_addr = host_dma_write_desc_axi_addr_reg;
assign host_dma_write_desc_len = host_dma_write_desc_len_reg;
assign host_dma_write_desc_tag = host_dma_write_desc_tag_reg;
assign host_dma_write_desc_valid = host_dma_write_desc_valid_reg;
assign host_dma_write_desc_status_ready = host_dma_write_desc_status_ready_reg;
assign pcie_dma_enable = pcie_dma_enable_reg;

assign msi_irq[0] = host_dma_read_desc_status_valid || host_dma_write_desc_status_valid;
assign msi_irq[31:1] = 0;

always @* begin
    axil_ctrl_awready_next = 1'b0;
    axil_ctrl_wready_next = 1'b0;
    axil_ctrl_bresp_next = 2'b00;
    axil_ctrl_bvalid_next = axil_ctrl_bvalid_reg && !axil_ctrl_bready;
    axil_ctrl_arready_next = 1'b0;
    axil_ctrl_rdata_next = {AXIL_DATA_WIDTH{1'b0}};
    axil_ctrl_rresp_next = 2'b00;
    axil_ctrl_rvalid_next = axil_ctrl_rvalid_reg && !axil_ctrl_rready;

    host_dma_read_desc_pcie_addr_next = host_dma_read_desc_pcie_addr_reg;
    host_dma_read_desc_axi_addr_next = host_dma_read_desc_axi_addr_reg;
    host_dma_read_desc_len_next = host_dma_read_desc_len_reg;
    host_dma_read_desc_tag_next = host_dma_read_desc_tag_reg;
    host_dma_read_desc_valid_next = host_dma_read_desc_valid_reg && !host_dma_read_desc_ready;
    host_dma_read_desc_status_ready_next = 1'b0;

    host_dma_write_desc_pcie_addr_next = host_dma_write_desc_pcie_addr_reg;
    host_dma_write_desc_axi_addr_next = host_dma_write_desc_axi_addr_reg;
    host_dma_write_desc_len_next = host_dma_write_desc_len_reg;
    host_dma_write_desc_tag_next = host_dma_write_desc_tag_reg;
    host_dma_write_desc_valid_next = host_dma_write_desc_valid_reg && !host_dma_read_desc_ready;
    host_dma_write_desc_status_ready_next = 1'b0;

    pcie_dma_enable_next = pcie_dma_enable_reg;

    if (axil_ctrl_awvalid && axil_ctrl_wvalid && !axil_ctrl_bvalid) begin
        // write operation
        axil_ctrl_awready_next = 1'b1;
        axil_ctrl_wready_next = 1'b1;
        axil_ctrl_bresp_next = 2'b00;
        axil_ctrl_bvalid_next = 1'b1;

        case ({axil_ctrl_awaddr[15:2], 2'b00})
            16'h0000: pcie_dma_enable_next = axil_ctrl_wdata;
            16'h0100: host_dma_read_desc_pcie_addr_next[31:0] = axil_ctrl_wdata;
            16'h0104: host_dma_read_desc_pcie_addr_next[63:32] = axil_ctrl_wdata;
            16'h0108: host_dma_read_desc_axi_addr_next[31:0] = axil_ctrl_wdata;
            //16'h010C: host_dma_read_desc_axi_addr_next[63:32] = axil_ctrl_wdata;
            16'h0110: host_dma_read_desc_len_next = axil_ctrl_wdata;
            16'h0114: begin
                host_dma_read_desc_tag_next = axil_ctrl_wdata;
                host_dma_read_desc_valid_next = 1'b1;
            end
            16'h0200: host_dma_write_desc_pcie_addr_next[31:0] = axil_ctrl_wdata;
            16'h0204: host_dma_write_desc_pcie_addr_next[63:32] = axil_ctrl_wdata;
            16'h0208: host_dma_write_desc_axi_addr_next[31:0] = axil_ctrl_wdata;
            //16'h020C: host_dma_write_desc_axi_addr_next[63:32] = axil_ctrl_wdata;
            16'h0210: host_dma_write_desc_len_next = axil_ctrl_wdata;
            16'h0214: begin
                host_dma_write_desc_tag_next = axil_ctrl_wdata;
                host_dma_write_desc_valid_next = 1'b1;
            end
        endcase
    end

    if (axil_ctrl_arvalid && !axil_ctrl_rvalid) begin
        // read operation
        axil_ctrl_arready_next = 1'b1;
        axil_ctrl_rresp_next = 2'b00;
        axil_ctrl_rvalid_next = 1'b1;

        case ({axil_ctrl_araddr[15:2], 2'b00})
            16'h0000: axil_ctrl_rdata_next = pcie_dma_enable_reg;
            16'h0118: begin
                axil_ctrl_rdata_next = host_dma_read_desc_status_tag | (host_dma_read_desc_status_valid ? 32'h80000000 : 32'd0);
                host_dma_read_desc_status_ready_next = host_dma_read_desc_status_valid;
            end
            16'h0218: begin
                axil_ctrl_rdata_next = host_dma_write_desc_status_tag | (host_dma_write_desc_status_valid ? 32'h80000000 : 32'd0);
                host_dma_write_desc_status_ready_next = host_dma_write_desc_status_valid;
            end
            16'h0400: axil_ctrl_rdata_next = pcie_rq_count_reg;
            16'h0404: axil_ctrl_rdata_next = pcie_rc_count_reg;
            16'h0408: axil_ctrl_rdata_next = pcie_cq_count_reg;
            16'h040C: axil_ctrl_rdata_next = pcie_cc_count_reg;
        endcase
    end
end

always @(posedge pcie_clk) begin
    if (pcie_rst) begin
        axil_ctrl_awready_reg <= 1'b0;
        axil_ctrl_wready_reg <= 1'b0;
        axil_ctrl_bvalid_reg <= 1'b0;
        axil_ctrl_arready_reg <= 1'b0;
        axil_ctrl_rvalid_reg <= 1'b0;

        host_dma_read_desc_valid_reg <= 1'b0;
        host_dma_read_desc_status_ready_reg <= 1'b0;
        host_dma_write_desc_valid_reg <= 1'b0;
        host_dma_write_desc_status_ready_reg <= 1'b0;
        pcie_dma_enable_reg <= 1'b0;

        pcie_rq_count_reg <= 0;
        pcie_rc_count_reg <= 0;
        pcie_cq_count_reg <= 0;
        pcie_cc_count_reg <= 0;
    end else begin
        axil_ctrl_awready_reg <= axil_ctrl_awready_next;
        axil_ctrl_wready_reg <= axil_ctrl_wready_next;
        axil_ctrl_bvalid_reg <= axil_ctrl_bvalid_next;
        axil_ctrl_arready_reg <= axil_ctrl_arready_next;
        axil_ctrl_rvalid_reg <= axil_ctrl_rvalid_next;

        host_dma_read_desc_valid_reg <= host_dma_read_desc_valid_next;
        host_dma_read_desc_status_ready_reg <= host_dma_read_desc_status_ready_next;
        host_dma_write_desc_valid_reg <= host_dma_write_desc_valid_next;
        host_dma_write_desc_status_ready_reg <= host_dma_write_desc_status_ready_next;
        pcie_dma_enable_reg <= pcie_dma_enable_next;

        if (m_axis_rq_tready && m_axis_rq_tvalid && m_axis_rq_tlast) begin
            pcie_rq_count_reg <= pcie_rq_count_reg + 1;
        end

        if (s_axis_rc_tready && s_axis_rc_tvalid && s_axis_rc_tlast) begin
            pcie_rc_count_reg <= pcie_rc_count_reg + 1;
        end

        if (s_axis_cq_tready && s_axis_cq_tvalid && s_axis_cq_tlast) begin
            pcie_cq_count_reg <= pcie_cq_count_reg + 1;
        end

        if (m_axis_cc_tready && m_axis_cc_tvalid && m_axis_cc_tlast) begin
            pcie_cc_count_reg <= pcie_cc_count_reg + 1;
        end
    end

    axil_ctrl_bresp_reg <= axil_ctrl_bresp_next;
    axil_ctrl_rdata_reg <= axil_ctrl_rdata_next;
    axil_ctrl_rresp_reg <= axil_ctrl_rresp_next;

    host_dma_read_desc_pcie_addr_reg <= host_dma_read_desc_pcie_addr_next;
    host_dma_read_desc_axi_addr_reg <= host_dma_read_desc_axi_addr_next;
    host_dma_read_desc_len_reg <= host_dma_read_desc_len_next;
    host_dma_read_desc_tag_reg <= host_dma_read_desc_tag_next;
    host_dma_write_desc_pcie_addr_reg <= host_dma_write_desc_pcie_addr_next;
    host_dma_write_desc_axi_addr_reg <= host_dma_write_desc_axi_addr_next;
    host_dma_write_desc_len_reg <= host_dma_write_desc_len_next;
    host_dma_write_desc_tag_reg <= host_dma_write_desc_tag_next;
end

pcie_us_axil_master #(
    .AXIS_PCIE_DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
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
    .m_axil_awaddr(axil_ctrl_awaddr),
    .m_axil_awprot(axil_ctrl_awprot),
    .m_axil_awvalid(axil_ctrl_awvalid),
    .m_axil_awready(axil_ctrl_awready),
    .m_axil_wdata(axil_ctrl_wdata),
    .m_axil_wstrb(axil_ctrl_wstrb),
    .m_axil_wvalid(axil_ctrl_wvalid),
    .m_axil_wready(axil_ctrl_wready),
    .m_axil_bresp(axil_ctrl_bresp),
    .m_axil_bvalid(axil_ctrl_bvalid),
    .m_axil_bready(axil_ctrl_bready),
    .m_axil_araddr(axil_ctrl_araddr),
    .m_axil_arprot(axil_ctrl_arprot),
    .m_axil_arvalid(axil_ctrl_arvalid),
    .m_axil_arready(axil_ctrl_arready),
    .m_axil_rdata(axil_ctrl_rdata),
    .m_axil_rresp(axil_ctrl_rresp),
    .m_axil_rvalid(axil_ctrl_rvalid),
    .m_axil_rready(axil_ctrl_rready),

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

pcie_us_axi_dma #(
    .AXIS_PCIE_DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .AXIS_PCIE_KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .AXI_STRB_WIDTH(AXI_STRB_WIDTH),
    .AXI_ID_WIDTH(AXI_ID_WIDTH),
    .AXI_MAX_BURST_LEN(256),
    .PCIE_ADDR_WIDTH(PCIE_ADDR_WIDTH),
    .PCIE_CLIENT_TAG(1),
    .PCIE_TAG_COUNT(64),
    .PCIE_EXT_TAG_ENABLE(1),
    .LEN_WIDTH(PCIE_DMA_LEN_WIDTH),
    .TAG_WIDTH(PCIE_DMA_TAG_WIDTH)
)
pcie_us_axi_dma_inst (
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
     * Tag input
     */
    .s_axis_pcie_rq_tag(6'd0),
    .s_axis_pcie_rq_tag_valid(1'b0),

    /*
     * AXI read descriptor input
     */
    .s_axis_read_desc_pcie_addr(pcie_dma_read_desc_pcie_addr_f),
    .s_axis_read_desc_axi_addr(pcie_dma_read_desc_axi_addr_f),
    .s_axis_read_desc_len(pcie_dma_read_desc_len_f),
    .s_axis_read_desc_tag(pcie_dma_read_desc_tag_f),
    .s_axis_read_desc_valid(pcie_dma_read_desc_valid_f),
    .s_axis_read_desc_ready(pcie_dma_read_desc_ready_f),

    /*
     * AXI read descriptor status output
     */
    .m_axis_read_desc_status_tag(pcie_dma_read_desc_status_tag),
    .m_axis_read_desc_status_valid(pcie_dma_read_desc_status_valid),

    /*
     * AXI write descriptor input
     */
    .s_axis_write_desc_pcie_addr(pcie_dma_write_desc_pcie_addr_f),
    .s_axis_write_desc_axi_addr(pcie_dma_write_desc_axi_addr_f),
    .s_axis_write_desc_len(pcie_dma_write_desc_len_f),
    .s_axis_write_desc_tag(pcie_dma_write_desc_tag_f),
    .s_axis_write_desc_valid(pcie_dma_write_desc_valid_f),
    .s_axis_write_desc_ready(pcie_dma_write_desc_ready_f),

    /*
     * AXI write descriptor status output
     */
    .m_axis_write_desc_status_tag(pcie_dma_write_desc_status_tag),
    .m_axis_write_desc_status_valid(pcie_dma_write_desc_status_valid),

    /*
     * AXI Master output
     */
    .m_axi_awid(axi_pcie_dma_awid),
    .m_axi_awaddr(axi_pcie_dma_awaddr),
    .m_axi_awlen(axi_pcie_dma_awlen),
    .m_axi_awsize(axi_pcie_dma_awsize),
    .m_axi_awburst(axi_pcie_dma_awburst),
    .m_axi_awlock(axi_pcie_dma_awlock),
    .m_axi_awcache(axi_pcie_dma_awcache),
    .m_axi_awprot(axi_pcie_dma_awprot),
    .m_axi_awvalid(axi_pcie_dma_awvalid),
    .m_axi_awready(axi_pcie_dma_awready),
    .m_axi_wdata(axi_pcie_dma_wdata),
    .m_axi_wstrb(axi_pcie_dma_wstrb),
    .m_axi_wlast(axi_pcie_dma_wlast),
    .m_axi_wvalid(axi_pcie_dma_wvalid),
    .m_axi_wready(axi_pcie_dma_wready),
    .m_axi_bid(axi_pcie_dma_bid),
    .m_axi_bresp(axi_pcie_dma_bresp),
    .m_axi_bvalid(axi_pcie_dma_bvalid),
    .m_axi_bready(axi_pcie_dma_bready),
    .m_axi_arid(axi_pcie_dma_arid),
    .m_axi_araddr(axi_pcie_dma_araddr),
    .m_axi_arlen(axi_pcie_dma_arlen),
    .m_axi_arsize(axi_pcie_dma_arsize),
    .m_axi_arburst(axi_pcie_dma_arburst),
    .m_axi_arlock(axi_pcie_dma_arlock),
    .m_axi_arcache(axi_pcie_dma_arcache),
    .m_axi_arprot(axi_pcie_dma_arprot),
    .m_axi_arvalid(axi_pcie_dma_arvalid),
    .m_axi_arready(axi_pcie_dma_arready),
    .m_axi_rid(axi_pcie_dma_rid),
    .m_axi_rdata(axi_pcie_dma_rdata),
    .m_axi_rresp(axi_pcie_dma_rresp),
    .m_axi_rlast(axi_pcie_dma_rlast),
    .m_axi_rvalid(axi_pcie_dma_rvalid),
    .m_axi_rready(axi_pcie_dma_rready),

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


axi_dma # (
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .AXI_STRB_WIDTH(AXI_STRB_WIDTH),
    .AXI_ID_WIDTH(AXI_ID_WIDTH),
    .AXI_MAX_BURST_LEN(256),
    .AXIS_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXIS_KEEP_ENABLE(1), 
    .AXIS_KEEP_WIDTH(AXI_STRB_WIDTH),
    .AXIS_LAST_ENABLE(1),
    .AXIS_ID_ENABLE(0),
    .AXIS_DEST_ENABLE(1),
    .AXIS_DEST_WIDTH(AXIS_TAG_WIDTH),
    .AXIS_USER_ENABLE(1),
    .AXIS_USER_WIDTH(CORE_ADDR_WIDTH), // send addr as tuser for read desc
    .LEN_WIDTH(AXI_LEN_WIDTH),
    .TAG_WIDTH(PCIE_SLOT_WIDTH),
    .ENABLE_UNALIGNED(0)
) axi_dma_inst (
    .clk(pcie_clk),
    .rst(pcie_rst),

    /*
     * AXI Stream descriptors
     */
    .s_axis_read_desc_addr        (axis_read_desc_addr_f),
    .s_axis_read_desc_len         (axis_read_desc_len_f),
    .s_axis_read_desc_tag         (axis_read_desc_tag_f),
    .s_axis_read_desc_id          (8'd0),
    .s_axis_read_desc_dest        (axis_read_desc_dest_f),
    .s_axis_read_desc_user        (axis_read_desc_user_f), 
    .s_axis_read_desc_valid       (axis_read_desc_valid_f),
    .s_axis_read_desc_ready       (axis_read_desc_ready_f),
    .m_axis_read_desc_status_tag  (axis_read_desc_status_tag),
    .m_axis_read_desc_status_valid(axis_read_desc_status_valid),

    .s_axis_write_desc_addr        (axis_write_desc_addr),
    .s_axis_write_desc_len         (axis_write_desc_len),
    .s_axis_write_desc_tag         (axis_write_desc_tag),
    .s_axis_write_desc_valid       (axis_write_desc_valid),
    .s_axis_write_desc_ready       (axis_write_desc_ready),
    .m_axis_write_desc_status_len  (axis_write_desc_status_len),
    .m_axis_write_desc_status_tag  (axis_write_desc_status_tag),
    .m_axis_write_desc_status_id   (),
    .m_axis_write_desc_status_dest (),
    .m_axis_write_desc_status_user (axis_write_desc_status_user),
    .m_axis_write_desc_status_valid(axis_write_desc_status_valid),

    /*
     * AXI Stream data
     */
    .m_axis_read_data_tdata (axis_read_data_tdata),
    .m_axis_read_data_tkeep (axis_read_data_tkeep),
    .m_axis_read_data_tvalid(axis_read_data_tvalid),
    .m_axis_read_data_tready(axis_read_data_tready),
    .m_axis_read_data_tlast (axis_read_data_tlast),
    .m_axis_read_data_tid   (),
    .m_axis_read_data_tdest (axis_read_data_tdest),
    .m_axis_read_data_tuser (axis_read_data_tuser), 

    .s_axis_write_data_tdata (axis_write_data_tdata),
    .s_axis_write_data_tkeep (axis_write_data_tkeep),
    .s_axis_write_data_tvalid(axis_write_data_tvalid),
    .s_axis_write_data_tready(axis_write_data_tready),
    .s_axis_write_data_tlast (axis_write_data_tlast),
    .s_axis_write_data_tid   (),
    .s_axis_write_data_tdest ({AXIS_TAG_WIDTH{1'b0}}),
    .s_axis_write_data_tuser ({{(CORE_ADDR_WIDTH-AXIS_TAG_WIDTH){1'b0}},axis_write_data_tuser}), 

    /*
     * AXI Master output
     */
    .m_axi_awid(axi_dma_awid),
    .m_axi_awaddr(axi_dma_awaddr),
    .m_axi_awlen(axi_dma_awlen),
    .m_axi_awsize(axi_dma_awsize),
    .m_axi_awburst(axi_dma_awburst),
    .m_axi_awlock(axi_dma_awlock),
    .m_axi_awcache(axi_dma_awcache),
    .m_axi_awprot(axi_dma_awprot),
    .m_axi_awvalid(axi_dma_awvalid),
    .m_axi_awready(axi_dma_awready),
    .m_axi_wdata(axi_dma_wdata),
    .m_axi_wstrb(axi_dma_wstrb),
    .m_axi_wlast(axi_dma_wlast),
    .m_axi_wvalid(axi_dma_wvalid),
    .m_axi_wready(axi_dma_wready),
    .m_axi_bid(axi_dma_bid),
    .m_axi_bresp(axi_dma_bresp),
    .m_axi_bvalid(axi_dma_bvalid),
    .m_axi_bready(axi_dma_bready),
    .m_axi_arid(axi_dma_arid),
    .m_axi_araddr(axi_dma_araddr),
    .m_axi_arlen(axi_dma_arlen),
    .m_axi_arsize(axi_dma_arsize),
    .m_axi_arburst(axi_dma_arburst),
    .m_axi_arlock(axi_dma_arlock),
    .m_axi_arcache(axi_dma_arcache),
    .m_axi_arprot(axi_dma_arprot),
    .m_axi_arvalid(axi_dma_arvalid),
    .m_axi_arready(axi_dma_arready),
    .m_axi_rid(axi_dma_rid),
    .m_axi_rdata(axi_dma_rdata),
    .m_axi_rresp(axi_dma_rresp),
    .m_axi_rlast(axi_dma_rlast),
    .m_axi_rvalid(axi_dma_rvalid),
    .m_axi_rready(axi_dma_rready),
    
    .read_enable(pcie_dma_enable),
    .write_enable(pcie_dma_enable),
    .write_abort(1'b0)
);

axi_interconnect # (
// axi_crossbar # (
    .S_COUNT(2),
    .M_COUNT(1),
    .DATA_WIDTH(AXI_DATA_WIDTH),
    .ADDR_WIDTH(AXI_ADDR_WIDTH),
    .STRB_WIDTH(AXI_STRB_WIDTH),
    .ID_WIDTH(AXI_ID_WIDTH),
    .M_BASE_ADDR(0),
    .M_ADDR_WIDTH(AXI_ADDR_WIDTH)
) axi_interconnect_inst (

    .clk(pcie_clk),
    .rst(pcie_rst),

    /*
     * AXI slave interfaces
     */
    .s_axi_awid   ({axi_dma_awid   , axi_pcie_dma_awid   }),
    .s_axi_awaddr ({axi_dma_awaddr , axi_pcie_dma_awaddr }),
    .s_axi_awlen  ({axi_dma_awlen  , axi_pcie_dma_awlen  }),
    .s_axi_awsize ({axi_dma_awsize , axi_pcie_dma_awsize }),
    .s_axi_awburst({axi_dma_awburst, axi_pcie_dma_awburst}),
    .s_axi_awlock ({axi_dma_awlock , axi_pcie_dma_awlock }),
    .s_axi_awcache({axi_dma_awcache, axi_pcie_dma_awcache}),
    .s_axi_awprot ({axi_dma_awprot , axi_pcie_dma_awprot }),
    .s_axi_awqos(8'd0),
    .s_axi_awuser(2'd0),
    .s_axi_awvalid({axi_dma_awvalid, axi_pcie_dma_awvalid}),
    .s_axi_awready({axi_dma_awready, axi_pcie_dma_awready}),
    .s_axi_wdata  ({axi_dma_wdata  , axi_pcie_dma_wdata  }),
    .s_axi_wstrb  ({axi_dma_wstrb  , axi_pcie_dma_wstrb  }),
    .s_axi_wlast  ({axi_dma_wlast  , axi_pcie_dma_wlast  }),
    .s_axi_wuser(2'd0),
    .s_axi_wvalid ({axi_dma_wvalid , axi_pcie_dma_wvalid }),
    .s_axi_wready ({axi_dma_wready , axi_pcie_dma_wready }),
    .s_axi_bid    ({axi_dma_bid    , axi_pcie_dma_bid    }),
    .s_axi_bresp  ({axi_dma_bresp  , axi_pcie_dma_bresp  }),
    .s_axi_buser(),
    .s_axi_bvalid ({axi_dma_bvalid , axi_pcie_dma_bvalid }),
    .s_axi_bready ({axi_dma_bready , axi_pcie_dma_bready }),
    .s_axi_arid   ({axi_dma_arid   , axi_pcie_dma_arid   }),
    .s_axi_araddr ({axi_dma_araddr , axi_pcie_dma_araddr }),
    .s_axi_arlen  ({axi_dma_arlen  , axi_pcie_dma_arlen  }),
    .s_axi_arsize ({axi_dma_arsize , axi_pcie_dma_arsize }),
    .s_axi_arburst({axi_dma_arburst, axi_pcie_dma_arburst}),
    .s_axi_arlock ({axi_dma_arlock , axi_pcie_dma_arlock }),
    .s_axi_arcache({axi_dma_arcache, axi_pcie_dma_arcache}),
    .s_axi_arprot ({axi_dma_arprot , axi_pcie_dma_arprot }),
    .s_axi_arqos(8'd0),
    .s_axi_aruser(2'd0),
    .s_axi_arvalid({axi_dma_arvalid, axi_pcie_dma_arvalid}),
    .s_axi_arready({axi_dma_arready, axi_pcie_dma_arready}),
    .s_axi_rid    ({axi_dma_rid    , axi_pcie_dma_rid    }),
    .s_axi_rdata  ({axi_dma_rdata  , axi_pcie_dma_rdata  }),
    .s_axi_rresp  ({axi_dma_rresp  , axi_pcie_dma_rresp  }),
    .s_axi_rlast  ({axi_dma_rlast  , axi_pcie_dma_rlast  }),
    .s_axi_ruser(),
    .s_axi_rvalid ({axi_dma_rvalid , axi_pcie_dma_rvalid }),
    .s_axi_rready ({axi_dma_rready , axi_pcie_dma_rready }),
    
    .m_axi_awid(axi_ram_awid),
    .m_axi_awaddr(axi_ram_awaddr),
    .m_axi_awlen(axi_ram_awlen),
    .m_axi_awsize(axi_ram_awsize),
    .m_axi_awburst(axi_ram_awburst),
    .m_axi_awlock(axi_ram_awlock),
    .m_axi_awcache(axi_ram_awcache),
    .m_axi_awprot(axi_ram_awprot),
    .m_axi_awqos(),
    .m_axi_awregion(),
    .m_axi_awuser(),
    .m_axi_awvalid(axi_ram_awvalid),
    .m_axi_awready(axi_ram_awready),
    .m_axi_wdata(axi_ram_wdata),
    .m_axi_wstrb(axi_ram_wstrb),
    .m_axi_wlast(axi_ram_wlast),
    .m_axi_wuser(),
    .m_axi_wvalid(axi_ram_wvalid),
    .m_axi_wready(axi_ram_wready),
    .m_axi_bid(axi_ram_bid),
    .m_axi_bresp(axi_ram_bresp),
    .m_axi_buser(1'b0),
    .m_axi_bvalid(axi_ram_bvalid),
    .m_axi_bready(axi_ram_bready),
    .m_axi_arid(axi_ram_arid),
    .m_axi_araddr(axi_ram_araddr),
    .m_axi_arlen(axi_ram_arlen),
    .m_axi_arsize(axi_ram_arsize),
    .m_axi_arburst(axi_ram_arburst),
    .m_axi_arlock(axi_ram_arlock),
    .m_axi_arcache(axi_ram_arcache),
    .m_axi_arprot(axi_ram_arprot),
    .m_axi_arqos(),
    .m_axi_arregion(),
    .m_axi_aruser(),
    .m_axi_arvalid(axi_ram_arvalid),
    .m_axi_arready(axi_ram_arready),
    .m_axi_rid(axi_ram_rid),
    .m_axi_rdata(axi_ram_rdata),
    .m_axi_rresp(axi_ram_rresp),
    .m_axi_rlast(axi_ram_rlast),
    .m_axi_ruser(1'b0),
    .m_axi_rvalid(axi_ram_rvalid),
    .m_axi_rready(axi_ram_rready)
);

axi_ram #(
    .DATA_WIDTH(AXI_DATA_WIDTH),
    .ADDR_WIDTH(AXI_ADDR_WIDTH),
    .ID_WIDTH(AXI_ID_WIDTH),
    .PIPELINE_OUTPUT(1)
)
axi_ram_inst (
    .clk(pcie_clk),
    .rst(pcie_rst),
    .s_axi_awid(axi_ram_awid),
    .s_axi_awaddr(axi_ram_awaddr),
    .s_axi_awlen(axi_ram_awlen),
    .s_axi_awsize(axi_ram_awsize),
    .s_axi_awburst(axi_ram_awburst),
    .s_axi_awlock(axi_ram_awlock),
    .s_axi_awcache(axi_ram_awcache),
    .s_axi_awprot(axi_ram_awprot),
    .s_axi_awvalid(axi_ram_awvalid),
    .s_axi_awready(axi_ram_awready),
    .s_axi_wdata(axi_ram_wdata),
    .s_axi_wstrb(axi_ram_wstrb),
    .s_axi_wlast(axi_ram_wlast),
    .s_axi_wvalid(axi_ram_wvalid),
    .s_axi_wready(axi_ram_wready),
    .s_axi_bid(axi_ram_bid),
    .s_axi_bresp(axi_ram_bresp),
    .s_axi_bvalid(axi_ram_bvalid),
    .s_axi_bready(axi_ram_bready),
    .s_axi_arid(axi_ram_arid),
    .s_axi_araddr(axi_ram_araddr),
    .s_axi_arlen(axi_ram_arlen),
    .s_axi_arsize(axi_ram_arsize),
    .s_axi_arburst(axi_ram_arburst),
    .s_axi_arlock(axi_ram_arlock),
    .s_axi_arcache(axi_ram_arcache),
    .s_axi_arprot(axi_ram_arprot),
    .s_axi_arvalid(axi_ram_arvalid),
    .s_axi_arready(axi_ram_arready),
    .s_axi_rid(axi_ram_rid),
    .s_axi_rdata(axi_ram_rdata),
    .s_axi_rresp(axi_ram_rresp),
    .s_axi_rlast(axi_ram_rlast),
    .s_axi_rvalid(axi_ram_rvalid),
    .s_axi_rready(axi_ram_rready)
);

// Data to cores management 
reg [AXI_LEN_WIDTH-1:0]      rx_len       [0:PCIE_SLOT_COUNT-1];
reg [CORE_ADDR_WIDTH-1:0]    rx_core_addr [0:PCIE_SLOT_COUNT-1];
reg [AXIS_TAG_WIDTH-1:0]     rx_core_tag  [0:PCIE_SLOT_COUNT-1];
reg [HOST_DMA_TAG_WIDTH-1:0] rx_pcie_tag  [0:PCIE_SLOT_COUNT-1];

reg  [PCIE_SLOT_COUNT-1:0] rx_slot;
wire [PCIE_SLOT_WIDTH-1:0] selected_rx_slot;
wire [PCIE_SLOT_COUNT-1:0] selected_rx_slot_1hot;
wire                       selected_rx_slot_v;

penc # (.IN_WIDTH(PCIE_SLOT_COUNT)) rx_penc (
  .to_select(rx_slot),.selected(selected_rx_slot),
  .selected_1hot (selected_rx_slot_1hot),.valid(selected_rx_slot_v));
    
always @ (posedge pcie_clk) begin
  if (host_dma_read_desc_valid && host_dma_read_desc_ready) begin 
    // Save request info for rx slot
    rx_len      [selected_rx_slot] <= host_dma_read_desc_len;
    rx_core_addr[selected_rx_slot] <= host_dma_read_desc_axi_addr[CORE_ADDR_WIDTH-1:0];
    rx_core_tag [selected_rx_slot] <= {host_dma_read_desc_axi_addr[CORE_ADDR_WIDTH +: CORE_WIDTH], 
                                       {(AXIS_TAG_WIDTH-CORE_WIDTH){1'b0}}};
    rx_pcie_tag [selected_rx_slot] <= host_dma_read_desc_tag;

    // Make pcie_dma descriptor, it goes to FIFO
    pcie_dma_read_desc_pcie_addr   <= host_dma_read_desc_pcie_addr;
    pcie_dma_read_desc_axi_addr    <= {selected_rx_slot,11'd0}; 
    pcie_dma_read_desc_len         <= host_dma_read_desc_len;
    pcie_dma_read_desc_tag         <= selected_rx_slot; 
    pcie_dma_read_desc_valid       <= 1'b1;
  end else if (cores_ctrl_s_tvalid && cores_ctrl_s_tready) begin
    rx_len      [selected_rx_slot] <= cores_ctrl_s_tdata[AXI_LEN_WIDTH-1:0];
    rx_core_addr[selected_rx_slot] <= cores_ctrl_s_tdata[CORE_ADDR_WIDTH+31:32];
    rx_core_tag [selected_rx_slot] <= {cores_ctrl_s_tuser, 
                                       cores_ctrl_s_tdata[(AXIS_TAG_WIDTH-CORE_WIDTH)+15:16]};
    rx_pcie_tag [selected_rx_slot] <= {HOST_DMA_TAG_WIDTH{1'b0}};

    pcie_dma_read_desc_pcie_addr   <= cores_ctrl_s_tdata[127:64];
    pcie_dma_read_desc_axi_addr    <= {selected_rx_slot,11'd0}; 
    pcie_dma_read_desc_len         <= cores_ctrl_s_tdata[AXI_LEN_WIDTH-1:0];
    pcie_dma_read_desc_tag         <= selected_rx_slot; 
    pcie_dma_read_desc_valid       <= 1'b1;
  end else begin // valid gets deasserted when ready is asserted
    pcie_dma_read_desc_valid       <= 1'b0;
  end

  // There is FIFO afterwards and since there is a fifo for requests in first place 
  // That would limit the number of status valid and this FIFO does not overflow
  if (pcie_dma_read_desc_status_valid) begin
    axis_read_desc_addr  <= {pcie_dma_read_desc_status_tag,11'd0};
    axis_read_desc_len   <= rx_len[pcie_dma_read_desc_status_tag];
    axis_read_desc_tag   <= pcie_dma_read_desc_status_tag;
    axis_read_desc_dest  <= rx_core_tag[pcie_dma_read_desc_status_tag];
    axis_read_desc_valid <= 1'b1;
    axis_read_desc_user  <= rx_core_addr[pcie_dma_read_desc_status_tag];
  end else begin
    axis_read_desc_valid <= 1'b0;
  end

  // Output status is also 1 cycle, so no need for FIFO
  if (axis_read_desc_status_valid && (rx_pcie_tag [axis_read_desc_status_tag]!=0)) begin
    host_dma_read_desc_status_tag   <= rx_pcie_tag [axis_read_desc_status_tag];
    host_dma_read_desc_status_valid <= 1'b1;
  end else begin
    host_dma_read_desc_status_valid <= 1'b0;
  end
  
  if (((host_dma_read_desc_valid && host_dma_read_desc_ready)||
      (cores_ctrl_s_tvalid && cores_ctrl_s_tready)) && axis_read_desc_status_valid) 
    rx_slot <= (rx_slot & (~selected_rx_slot_1hot)) 
                | ({{(PCIE_SLOT_COUNT-1){1'b0}},1'b1} << axis_read_desc_status_tag);
  else if ((host_dma_read_desc_valid && host_dma_read_desc_ready)|| 
           (cores_ctrl_s_tvalid && cores_ctrl_s_tready))
    rx_slot <= rx_slot & (~selected_rx_slot_1hot);
  if (axis_read_desc_status_valid)
    rx_slot <= rx_slot | ({{(PCIE_SLOT_COUNT-1){1'b0}},1'b1} << axis_read_desc_status_tag);

  if (pcie_rst) begin
    rx_slot                         <= {PCIE_SLOT_COUNT{1'b1}};
    pcie_dma_read_desc_valid        <= 1'b0;
    axis_read_desc_valid            <= 1'b0;
    host_dma_read_desc_status_valid <= 1'b0;
  end
end

// If there is space in FIFO and some slot available we can accept the host dma request
// Similar for core requests, but it has lower priority than host_dma_read request
assign host_dma_read_desc_ready = pcie_dma_read_desc_ready && selected_rx_slot_v;
assign cores_ctrl_s_tready      = pcie_dma_read_desc_ready && selected_rx_slot_v && 
                                  !host_dma_read_desc_valid;

// Descriptor FIFOs and header adder
simple_fifo # (
  .ADDR_WIDTH(PCIE_SLOT_WIDTH),
  .DATA_WIDTH(PCIE_ADDR_WIDTH+AXI_ADDR_WIDTH+
              PCIE_DMA_LEN_WIDTH+PCIE_DMA_TAG_WIDTH)
) pcie_dma_read_desc_fifo (
  .clk(pcie_clk),
  .rst(pcie_rst),
  .clear(1'b0),

  .din_valid(pcie_dma_read_desc_valid),
  .din(     {pcie_dma_read_desc_pcie_addr,
             pcie_dma_read_desc_axi_addr,
             pcie_dma_read_desc_len,
             pcie_dma_read_desc_tag}),
  .din_ready(pcie_dma_read_desc_ready),
 
  .dout_valid(pcie_dma_read_desc_valid_f),
  .dout(     {pcie_dma_read_desc_pcie_addr_f,
              pcie_dma_read_desc_axi_addr_f,
              pcie_dma_read_desc_len_f,
              pcie_dma_read_desc_tag_f}),
  .dout_ready(pcie_dma_read_desc_ready_f),

  .item_count(),
  .full(),
  .empty()
);

simple_fifo # (
  .ADDR_WIDTH(PCIE_SLOT_WIDTH),
  .DATA_WIDTH(AXI_ADDR_WIDTH+AXI_LEN_WIDTH+PCIE_SLOT_WIDTH+
              AXIS_TAG_WIDTH+CORE_ADDR_WIDTH)
) axis_read_desc_fifo (
  .clk(pcie_clk),
  .rst(pcie_rst),
  .clear(1'b0),

  .din_valid(axis_read_desc_valid),
  .din(     {axis_read_desc_addr,
             axis_read_desc_len,
             axis_read_desc_tag,
             axis_read_desc_dest,
             axis_read_desc_user}),
  .din_ready(axis_read_desc_ready),
 
  .dout_valid(axis_read_desc_valid_f),
  .dout(     {axis_read_desc_addr_f,
              axis_read_desc_len_f,
              axis_read_desc_tag_f,
              axis_read_desc_dest_f,
              axis_read_desc_user_f}),
  .dout_ready(axis_read_desc_ready_f),

  .item_count(),
  .full(),
  .empty()
);
 
header_adder # (
  .DATA_WIDTH(AXI_DATA_WIDTH),
  .HDR_WIDTH(64),
  .DEST_WIDTH(AXIS_TAG_WIDTH)
) rx_header_adder (
  .clk(pcie_clk),
  .rst(pcie_rst),

  .s_axis_tdata (axis_read_data_tdata),
  .s_axis_tkeep (axis_read_data_tkeep),
  .s_axis_tdest (axis_read_data_tdest),
  .s_axis_tuser (8'd0), 
  .s_axis_tlast (axis_read_data_tlast),
  .s_axis_tvalid(axis_read_data_tvalid),
  .s_axis_tready(axis_read_data_tready),

  .header({{(32-CORE_ADDR_WIDTH){1'b0}},axis_read_data_tuser,32'd0}),
  .header_valid(axis_read_data_tvalid),
  .header_ready(), 

  .m_axis_tdata (cores_rx_tdata),
  .m_axis_tkeep (cores_rx_tkeep),
  .m_axis_tdest (cores_rx_tdest),
  .m_axis_tuser (),
  .m_axis_tlast (cores_rx_tlast),
  .m_axis_tvalid(cores_rx_tvalid),
  .m_axis_tready(cores_rx_tready)
);

// Data from cores management
wire [63:0] tx_header;

header_remover # (
  .DATA_WIDTH(AXI_DATA_WIDTH),
  .HDR_WIDTH(64),
  .USER_WIDTH(AXIS_TAG_WIDTH)
) tx_header_remover (
  .clk(pcie_clk),
  .rst(pcie_rst),

  .s_axis_tdata (cores_tx_tdata),
  .s_axis_tkeep (cores_tx_tkeep),
  .s_axis_tdest (8'd0),
  .s_axis_tuser (cores_tx_tuser),
  .s_axis_tlast (cores_tx_tlast),
  .s_axis_tvalid(cores_tx_tvalid),
  .s_axis_tready(cores_tx_tready),

  .header(tx_header), 

  .m_axis_tdata (axis_write_data_tdata),
  .m_axis_tkeep (axis_write_data_tkeep),
  .m_axis_tdest (),
  .m_axis_tuser (axis_write_data_tuser), 
  .m_axis_tlast (axis_write_data_tlast),
  .m_axis_tvalid(axis_write_data_tvalid),
  .m_axis_tready(axis_write_data_tready)

);

reg [HOST_DMA_TAG_WIDTH-1:0] tx_pcie_tag [0:CORE_COUNT-1];
reg [CORE_COUNT-1:0]         tx_pcie_tag_v;

reg [PCIE_ADDR_WIDTH-1:0] tx_pcie_addr [0:PCIE_SLOT_COUNT-1];
reg [AXIS_TAG_WIDTH-1:0]  tx_core_tag  [0:PCIE_SLOT_COUNT-1];
// reg [AXI_LEN_WIDTH-1:0]   tx_len       [0:PCIE_SLOT_COUNT-1];

reg  [PCIE_SLOT_COUNT-1:0] tx_slot;
wire [PCIE_SLOT_WIDTH-1:0] selected_tx_slot;
wire [PCIE_SLOT_COUNT-1:0] selected_tx_slot_1hot;
wire                       selected_tx_slot_v;
reg  [PCIE_SLOT_WIDTH-1:0] last_tx_slot;
reg                        last_tx_slot_v;

wire [CORE_WIDTH-1:0] host_wr_dest_core = 
    host_dma_write_desc_axi_addr[CORE_ADDR_WIDTH +: CORE_WIDTH];

wire [CORE_WIDTH-1:0]                tx_done_core_id = 
    tx_core_tag[pcie_dma_write_desc_status_tag][AXIS_TAG_WIDTH-1:AXIS_TAG_WIDTH-CORE_WIDTH];

wire [AXIS_TAG_WIDTH-CORE_WIDTH-1:0] tx_done_core_tag = 
    tx_core_tag[pcie_dma_write_desc_status_tag][AXIS_TAG_WIDTH-CORE_WIDTH-1:0]; 


penc # (.IN_WIDTH(PCIE_SLOT_COUNT)) tx_penc (
  .to_select(tx_slot),.selected(selected_tx_slot),
  .selected_1hot (selected_tx_slot_1hot),.valid(selected_tx_slot_v));

  assign axis_write_desc_addr  = {selected_tx_slot,11'd0};
  assign axis_write_desc_len   = 16'd2048;
  assign axis_write_desc_tag   = selected_tx_slot;
  assign axis_write_desc_valid = selected_tx_slot_v;

  
always @ (posedge pcie_clk) begin

  // Forwarding host write request to the corresponding core, and saving PCIe tag per core
  if (host_dma_write_desc_valid && host_dma_write_desc_ready) begin
    // PORT field in descriptor gets overriden by core wrapper, and TAG field is 0
    cores_ctrl_m_tdata                        <= 128'd0;
    cores_ctrl_m_tdata[127:64]                <= host_dma_write_desc_pcie_addr;
    cores_ctrl_m_tdata[31+CORE_ADDR_WIDTH:32] <= host_dma_write_desc_axi_addr[CORE_ADDR_WIDTH-1:0];
    cores_ctrl_m_tdata[AXI_LEN_WIDTH-1:0]     <= host_dma_write_desc_len;
    cores_ctrl_m_tdest                        <= host_wr_dest_core;
    cores_ctrl_m_tvalid                       <= 1'b1;
    tx_pcie_tag[host_wr_dest_core]            <= host_dma_write_desc_tag;
    tx_pcie_tag_v[host_wr_dest_core]          <= 1'b1; 
  end else begin
    cores_ctrl_m_tvalid <= 1'b0;
  end

  if (axis_write_desc_valid && axis_write_desc_ready) begin
    last_tx_slot          <= selected_tx_slot;
    last_tx_slot_v        <= 1'b1;
  end

  if (last_tx_slot_v && axis_write_data_tvalid) begin
    tx_pcie_addr[last_tx_slot] <= tx_header;
    last_tx_slot_v             <= 1'b0;
  end

  // No need to check pcie_dma_write_desc_ready since we have enough space in FIFO,
  // limited by slot count from previous step
  if (axis_write_desc_status_valid) begin
    pcie_dma_write_desc_pcie_addr           <= tx_pcie_addr[axis_write_desc_status_tag];
    pcie_dma_write_desc_axi_addr            <= {axis_write_desc_status_tag,11'd0};
    pcie_dma_write_desc_len                 <= axis_write_desc_status_len;
    pcie_dma_write_desc_tag                 <= axis_write_desc_status_tag;
    pcie_dma_write_desc_valid               <= 1'b1;
    tx_core_tag[axis_write_desc_status_tag] <= axis_write_desc_status_user;
  end else begin
    pcie_dma_write_desc_valid               <= 1'b0;
  end
  
  if (pcie_dma_write_desc_status_valid && (tx_done_core_tag==0)) begin
    host_dma_write_desc_status_tag   <= tx_pcie_tag[tx_done_core_id]; 
    host_dma_write_desc_status_valid <= tx_pcie_tag_v[tx_done_core_id];
    tx_pcie_tag_v[tx_done_core_id]   <= 1'b0;
  end

  // tx_done_core_tag can be used to notify the core with ID of tx_done_core_id
  
  if ((axis_write_desc_valid && axis_write_desc_ready) && pcie_dma_write_desc_status_valid)
    tx_slot <= (tx_slot & (~selected_tx_slot_1hot))
                | ({{(PCIE_SLOT_COUNT-1){1'b0}},1'b1} << pcie_dma_write_desc_status_tag);
  if (axis_write_desc_valid && axis_write_desc_ready) 
    tx_slot <= tx_slot & (~selected_tx_slot_1hot);
  else if (pcie_dma_write_desc_status_valid) 
    tx_slot <= tx_slot | ({{(PCIE_SLOT_COUNT-1){1'b0}},1'b1} << pcie_dma_write_desc_status_tag);

  if (pcie_rst) begin
    tx_slot                   <= {PCIE_SLOT_COUNT{1'b1}};
    tx_pcie_tag_v             <= {CORE_COUNT{1'b0}};
    cores_ctrl_m_tvalid       <= 1'b0;
    last_tx_slot_v            <= 1'b0;
    pcie_dma_write_desc_valid <= 1'b0;
  end
end

// We can accept one read out per core (at least for now). 
assign host_dma_write_desc_ready = cores_ctrl_m_tready && (tx_pcie_tag_v[host_wr_dest_core]==1'b0);

simple_fifo # (
  .ADDR_WIDTH(PCIE_SLOT_WIDTH),
  .DATA_WIDTH(PCIE_ADDR_WIDTH+AXI_ADDR_WIDTH+
              PCIE_DMA_LEN_WIDTH+PCIE_DMA_TAG_WIDTH)
) pcie_dma_write_desc_fifo (
  .clk(pcie_clk),
  .rst(pcie_rst),
  .clear(1'b0),

  .din_valid(pcie_dma_write_desc_valid),
  .din(     {pcie_dma_write_desc_pcie_addr,
             pcie_dma_write_desc_axi_addr,
             pcie_dma_write_desc_len,
             pcie_dma_write_desc_tag}),
  .din_ready(pcie_dma_write_desc_ready),
 
  .dout_valid(pcie_dma_write_desc_valid_f),
  .dout(     {pcie_dma_write_desc_pcie_addr_f,
              pcie_dma_write_desc_axi_addr_f,
              pcie_dma_write_desc_len_f,
              pcie_dma_write_desc_tag_f}),
  .dout_ready(pcie_dma_write_desc_ready_f),

  .item_count(),
  .full(),
  .empty()
);
  
endmodule

module penc # (
  parameter IN_WIDTH=4,
  parameter OUT_WIDTH=$clog2(IN_WIDTH)
)(
    input  [IN_WIDTH-1:0]  to_select,
    
    output reg  [IN_WIDTH-1:0]  selected_1hot,
    output reg  [OUT_WIDTH-1:0] selected,
    output wire                 valid
);

    integer i;
    
    always@(*) begin
      selected      = {OUT_WIDTH{1'b0}};
      selected_1hot = {IN_WIDTH{1'b0}};
      for (i=IN_WIDTH-1;i>=0;i=i-1)
        if (to_select[i]) begin
          selected = i;
          selected_1hot = 1 << i;
        end
    end
    
    assign valid = |to_select;

endmodule



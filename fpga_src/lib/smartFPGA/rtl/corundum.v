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
module corundum #
(
    parameter IF_COUNT            = 2,
    parameter PORTS_PER_IF        = 1,
    parameter AXIL_DATA_WIDTH     = 32,
    parameter AXIL_STRB_WIDTH     = (AXIL_DATA_WIDTH/8),
    parameter AXIL_ADDR_WIDTH     = 24,
    parameter IF_AXIL_ADDR_WIDTH  = AXIL_ADDR_WIDTH-$clog2(IF_COUNT),
    parameter AXIL_CSR_ADDR_WIDTH = IF_AXIL_ADDR_WIDTH-5-$clog2((PORTS_PER_IF+3)/8),
    parameter AXIS_DATA_WIDTH     = 256,
    parameter AXIS_KEEP_WIDTH     = AXIS_DATA_WIDTH/8,
    parameter HOST_DMA_TAG_WIDTH  = 32,
    parameter PCIE_ADDR_WIDTH     = 64,
    parameter PCIE_DMA_TAG_WIDTH  = 16,
    parameter PCIE_DMA_LEN_WIDTH  = 16,
    // RAM parameters, default for PCI_AXIS_WIDTH of 256
    parameter SEG_COUNT           = 4,
    parameter SEG_DATA_WIDTH      = 128,
    parameter SEG_ADDR_WIDTH      = 12,
    parameter SEG_BE_WIDTH        = SEG_DATA_WIDTH/8,
    parameter RAM_ADDR_WIDTH      = SEG_ADDR_WIDTH+$clog2(SEG_COUNT)
                                    +$clog2(SEG_BE_WIDTH),
    parameter RAM_SEL_WIDTH       = $clog2(IF_COUNT)+$clog2(PORTS_PER_IF+1),
    parameter RAM_PIPELINE        = 4,
    parameter IF_RAM_SEL_WIDTH    = $clog2(PORTS_PER_IF+1),
    parameter IF_PCIE_DMA_TAG_WIDTH = PCIE_DMA_TAG_WIDTH-$clog2(IF_COUNT)
)
(
    input  wire                                             pcie_clk,
    input  wire                                             pcie_rst,

    // DMA descriptors
    output wire [IF_COUNT*PCIE_ADDR_WIDTH-1:0]              if_pcie_dma_read_desc_pcie_addr,
    output wire [IF_COUNT*IF_RAM_SEL_WIDTH-1:0]             if_pcie_dma_read_desc_ram_sel,
    output wire [IF_COUNT*RAM_ADDR_WIDTH-1:0]               if_pcie_dma_read_desc_ram_addr,
    output wire [IF_COUNT*PCIE_DMA_LEN_WIDTH-1:0]           if_pcie_dma_read_desc_len,
    output wire [IF_COUNT*IF_PCIE_DMA_TAG_WIDTH-1:0]        if_pcie_dma_read_desc_tag,
    output wire [IF_COUNT-1:0]                              if_pcie_dma_read_desc_valid,
    input  wire [IF_COUNT-1:0]                              if_pcie_dma_read_desc_ready,
    
    input  wire [IF_COUNT*IF_PCIE_DMA_TAG_WIDTH-1:0]        if_pcie_dma_read_desc_status_tag,
    input  wire [IF_COUNT-1:0]                              if_pcie_dma_read_desc_status_valid,

    output wire [IF_COUNT*PCIE_ADDR_WIDTH-1:0]              if_pcie_dma_write_desc_pcie_addr,
    output wire [IF_COUNT*IF_RAM_SEL_WIDTH-1:0]             if_pcie_dma_write_desc_ram_sel,
    output wire [IF_COUNT*RAM_ADDR_WIDTH-1:0]               if_pcie_dma_write_desc_ram_addr,
    output wire [IF_COUNT*PCIE_DMA_LEN_WIDTH-1:0]           if_pcie_dma_write_desc_len,
    output wire [IF_COUNT*IF_PCIE_DMA_TAG_WIDTH-1:0]        if_pcie_dma_write_desc_tag,
    output wire [IF_COUNT-1:0]                              if_pcie_dma_write_desc_valid,
    input  wire [IF_COUNT-1:0]                              if_pcie_dma_write_desc_ready,
    
    input  wire [IF_COUNT*IF_PCIE_DMA_TAG_WIDTH-1:0]        if_pcie_dma_write_desc_status_tag,
    input  wire [IF_COUNT-1:0]                              if_pcie_dma_write_desc_status_valid,
    
    // Memory ports
    input  wire [IF_COUNT*SEG_COUNT*IF_RAM_SEL_WIDTH-1:0]   if_dma_ram_wr_cmd_sel,
    input  wire [IF_COUNT*SEG_COUNT*SEG_BE_WIDTH-1:0]       if_dma_ram_wr_cmd_be,
    input  wire [IF_COUNT*SEG_COUNT*SEG_ADDR_WIDTH-1:0]     if_dma_ram_wr_cmd_addr,
    input  wire [IF_COUNT*SEG_COUNT*SEG_DATA_WIDTH-1:0]     if_dma_ram_wr_cmd_data,
    input  wire [IF_COUNT*SEG_COUNT-1:0]                    if_dma_ram_wr_cmd_valid,
    output wire [IF_COUNT*SEG_COUNT-1:0]                    if_dma_ram_wr_cmd_ready,
    
    input  wire [IF_COUNT*SEG_COUNT*IF_RAM_SEL_WIDTH-1:0]   if_dma_ram_rd_cmd_sel,
    input  wire [IF_COUNT*SEG_COUNT*SEG_ADDR_WIDTH-1:0]     if_dma_ram_rd_cmd_addr,
    input  wire [IF_COUNT*SEG_COUNT-1:0]                    if_dma_ram_rd_cmd_valid,
    output wire [IF_COUNT*SEG_COUNT-1:0]                    if_dma_ram_rd_cmd_ready,
    output wire [IF_COUNT*SEG_COUNT*SEG_DATA_WIDTH-1:0]     if_dma_ram_rd_resp_data,
    output wire [IF_COUNT*SEG_COUNT-1:0]                    if_dma_ram_rd_resp_valid,
    input  wire [IF_COUNT*SEG_COUNT-1:0]                    if_dma_ram_rd_resp_ready,
        
    // Virtual MACs
    output wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0] tx_axis_tdata,
    output wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0] tx_axis_tkeep,
    output wire [IF_COUNT*PORTS_PER_IF-1:0]                 tx_axis_tvalid,
    input  wire [IF_COUNT*PORTS_PER_IF-1:0]                 tx_axis_tready,
    output wire [IF_COUNT*PORTS_PER_IF-1:0]                 tx_axis_tlast,
    output wire [IF_COUNT*PORTS_PER_IF-1:0]                 tx_axis_tuser,

    input  wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0] rx_axis_tdata,
    input  wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0] rx_axis_tkeep,
    input  wire [IF_COUNT*PORTS_PER_IF-1:0]                 rx_axis_tvalid,
    output wire [IF_COUNT*PORTS_PER_IF-1:0]                 rx_axis_tready,
    input  wire [IF_COUNT*PORTS_PER_IF-1:0]                 rx_axis_tlast,
    input  wire [IF_COUNT*PORTS_PER_IF-1:0]                 rx_axis_tuser,

    // AXI lite input
    input  wire [AXIL_ADDR_WIDTH-1:0]                       axil_pcie_awaddr,
    input  wire [2:0]                                       axil_pcie_awprot,
    input  wire                                             axil_pcie_awvalid,
    output wire                                             axil_pcie_awready,
    input  wire [AXIL_DATA_WIDTH-1:0]                       axil_pcie_wdata,
    input  wire [AXIL_STRB_WIDTH-1:0]                       axil_pcie_wstrb,
    input  wire                                             axil_pcie_wvalid,
    output wire                                             axil_pcie_wready,
    output wire [1:0]                                       axil_pcie_bresp,
    output wire                                             axil_pcie_bvalid,
    input  wire                                             axil_pcie_bready,
    input  wire [AXIL_ADDR_WIDTH-1:0]                       axil_pcie_araddr,
    input  wire [2:0]                                       axil_pcie_arprot,
    input  wire                                             axil_pcie_arvalid,
    output wire                                             axil_pcie_arready,
    output wire [AXIL_DATA_WIDTH-1:0]                       axil_pcie_rdata,
    output wire [1:0]                                       axil_pcie_rresp,
    output wire                                             axil_pcie_rvalid,
    input  wire                                             axil_pcie_rready,

    // AXI lite output
    output wire [AXIL_CSR_ADDR_WIDTH-1:0]                   axil_ctrl_awaddr,
    output wire [2:0]                                       axil_ctrl_awprot,
    output wire                                             axil_ctrl_awvalid,
    input  wire                                             axil_ctrl_awready,
    output wire [AXIL_DATA_WIDTH-1:0]                       axil_ctrl_wdata,
    output wire [AXIL_STRB_WIDTH-1:0]                       axil_ctrl_wstrb,
    output wire                                             axil_ctrl_wvalid,
    input  wire                                             axil_ctrl_wready,
    input  wire [1:0]                                       axil_ctrl_bresp,
    input  wire                                             axil_ctrl_bvalid,
    output wire                                             axil_ctrl_bready,
    output wire [AXIL_CSR_ADDR_WIDTH-1:0]                   axil_ctrl_araddr,
    output wire [2:0]                                       axil_ctrl_arprot,
    output wire                                             axil_ctrl_arvalid,
    input  wire                                             axil_ctrl_arready,
    input  wire [AXIL_DATA_WIDTH-1:0]                       axil_ctrl_rdata,
    input  wire [1:0]                                       axil_ctrl_rresp,
    input  wire                                             axil_ctrl_rvalid,
    output wire                                             axil_ctrl_rready,

    output wire [31:0]                                      msi_irq
);

// Queue manager parameters (interface)
parameter EVENT_QUEUE_OP_TABLE_SIZE = 32;
parameter TX_QUEUE_OP_TABLE_SIZE = 32;
parameter RX_QUEUE_OP_TABLE_SIZE = 32;
parameter TX_CPL_QUEUE_OP_TABLE_SIZE = 32;
parameter RX_CPL_QUEUE_OP_TABLE_SIZE = 32;
parameter TX_QUEUE_INDEX_WIDTH = 8;
parameter RX_QUEUE_INDEX_WIDTH = 8;
parameter TX_CPL_QUEUE_INDEX_WIDTH = 8;
parameter RX_CPL_QUEUE_INDEX_WIDTH = 8;

// TX and RX engine parameters (port)
parameter TX_DESC_TABLE_SIZE = 32;
parameter TX_PKT_TABLE_SIZE = 8;
parameter RX_DESC_TABLE_SIZE = 32;
parameter RX_PKT_TABLE_SIZE = 8;

// Scheduler parameters (port)
parameter TX_SCHEDULER = "RR";
parameter TX_SCHEDULER_OP_TABLE_SIZE = 32;
parameter TDMA_INDEX_WIDTH = 6;

// Interface parameters (port)
parameter TX_CHECKSUM_ENABLE = 1;
parameter RX_CHECKSUM_ENABLE = 1;
parameter ENABLE_PADDING = 1;
parameter ENABLE_DIC = 1;
parameter MIN_FRAME_LENGTH = 64;
parameter MAX_TX_SIZE = 2048;
parameter MAX_RX_SIZE = 2048;

// PCIe DMA parameters
parameter TX_RAM_SIZE = TX_PKT_TABLE_SIZE*MAX_TX_SIZE;
parameter RX_RAM_SIZE = RX_PKT_TABLE_SIZE*MAX_RX_SIZE;

// parameter sizing helpers
function [31:0] w_32(input [31:0] val);
    w_32 = val;
endfunction

// AXIL distribution and aggregation among interfaces
wire [IF_COUNT*AXIL_ADDR_WIDTH-1:0] axil_if_awaddr;
wire [IF_COUNT*3-1:0]               axil_if_awprot;
wire [IF_COUNT-1:0]                 axil_if_awvalid;
wire [IF_COUNT-1:0]                 axil_if_awready;
wire [IF_COUNT*AXIL_DATA_WIDTH-1:0] axil_if_wdata;
wire [IF_COUNT*AXIL_STRB_WIDTH-1:0] axil_if_wstrb;
wire [IF_COUNT-1:0]                 axil_if_wvalid;
wire [IF_COUNT-1:0]                 axil_if_wready;
wire [IF_COUNT*2-1:0]               axil_if_bresp;
wire [IF_COUNT-1:0]                 axil_if_bvalid;
wire [IF_COUNT-1:0]                 axil_if_bready;
wire [IF_COUNT*AXIL_ADDR_WIDTH-1:0] axil_if_araddr;
wire [IF_COUNT*3-1:0]               axil_if_arprot;
wire [IF_COUNT-1:0]                 axil_if_arvalid;
wire [IF_COUNT-1:0]                 axil_if_arready;
wire [IF_COUNT*AXIL_DATA_WIDTH-1:0] axil_if_rdata;
wire [IF_COUNT*2-1:0]               axil_if_rresp;
wire [IF_COUNT-1:0]                 axil_if_rvalid;
wire [IF_COUNT-1:0]                 axil_if_rready;

wire [IF_COUNT*AXIL_CSR_ADDR_WIDTH-1:0] axil_if_csr_awaddr;
wire [IF_COUNT*3-1:0]                   axil_if_csr_awprot;
wire [IF_COUNT-1:0]                     axil_if_csr_awvalid;
wire [IF_COUNT-1:0]                     axil_if_csr_awready;
wire [IF_COUNT*AXIL_DATA_WIDTH-1:0]     axil_if_csr_wdata;
wire [IF_COUNT*AXIL_STRB_WIDTH-1:0]     axil_if_csr_wstrb;
wire [IF_COUNT-1:0]                     axil_if_csr_wvalid;
wire [IF_COUNT-1:0]                     axil_if_csr_wready;
wire [IF_COUNT*2-1:0]                   axil_if_csr_bresp;
wire [IF_COUNT-1:0]                     axil_if_csr_bvalid;
wire [IF_COUNT-1:0]                     axil_if_csr_bready;
wire [IF_COUNT*AXIL_CSR_ADDR_WIDTH-1:0] axil_if_csr_araddr;
wire [IF_COUNT*3-1:0]                   axil_if_csr_arprot;
wire [IF_COUNT-1:0]                     axil_if_csr_arvalid;
wire [IF_COUNT-1:0]                     axil_if_csr_arready;
wire [IF_COUNT*AXIL_DATA_WIDTH-1:0]     axil_if_csr_rdata;
wire [IF_COUNT*2-1:0]                   axil_if_csr_rresp;
wire [IF_COUNT-1:0]                     axil_if_csr_rvalid;
wire [IF_COUNT-1:0]                     axil_if_csr_rready;

axil_interconnect #(
    .DATA_WIDTH(AXIL_DATA_WIDTH),
    .ADDR_WIDTH(AXIL_ADDR_WIDTH),
    .S_COUNT(1),
    .M_COUNT(IF_COUNT),
    .M_BASE_ADDR(0),
    .M_ADDR_WIDTH({IF_COUNT{w_32(IF_AXIL_ADDR_WIDTH)}}),
    .M_CONNECT_READ({IF_COUNT{1'b1}}),
    .M_CONNECT_WRITE({IF_COUNT{1'b1}})
)
axil_interconnect_inst (
    .clk(pcie_clk),
    .rst(pcie_rst),
    .s_axil_awaddr(axil_pcie_awaddr),
    .s_axil_awprot(axil_pcie_awprot),
    .s_axil_awvalid(axil_pcie_awvalid),
    .s_axil_awready(axil_pcie_awready),
    .s_axil_wdata(axil_pcie_wdata),
    .s_axil_wstrb(axil_pcie_wstrb),
    .s_axil_wvalid(axil_pcie_wvalid),
    .s_axil_wready(axil_pcie_wready),
    .s_axil_bresp(axil_pcie_bresp),
    .s_axil_bvalid(axil_pcie_bvalid),
    .s_axil_bready(axil_pcie_bready),
    .s_axil_araddr(axil_pcie_araddr),
    .s_axil_arprot(axil_pcie_arprot),
    .s_axil_arvalid(axil_pcie_arvalid),
    .s_axil_arready(axil_pcie_arready),
    .s_axil_rdata(axil_pcie_rdata),
    .s_axil_rresp(axil_pcie_rresp),
    .s_axil_rvalid(axil_pcie_rvalid),
    .s_axil_rready(axil_pcie_rready),
    .m_axil_awaddr(axil_if_awaddr),
    .m_axil_awprot(axil_if_awprot),
    .m_axil_awvalid(axil_if_awvalid),
    .m_axil_awready(axil_if_awready),
    .m_axil_wdata(axil_if_wdata),
    .m_axil_wstrb(axil_if_wstrb),
    .m_axil_wvalid(axil_if_wvalid),
    .m_axil_wready(axil_if_wready),
    .m_axil_bresp(axil_if_bresp),
    .m_axil_bvalid(axil_if_bvalid),
    .m_axil_bready(axil_if_bready),
    .m_axil_araddr(axil_if_araddr),
    .m_axil_arprot(axil_if_arprot),
    .m_axil_arvalid(axil_if_arvalid),
    .m_axil_arready(axil_if_arready),
    .m_axil_rdata(axil_if_rdata),
    .m_axil_rresp(axil_if_rresp),
    .m_axil_rvalid(axil_if_rvalid),
    .m_axil_rready(axil_if_rready)
);

axil_interconnect #(
    .DATA_WIDTH(AXIL_DATA_WIDTH),
    .ADDR_WIDTH(AXIL_CSR_ADDR_WIDTH),
    .S_COUNT(IF_COUNT),
    .M_COUNT(1),
    .M_BASE_ADDR(0),
    .M_ADDR_WIDTH({w_32(AXIL_CSR_ADDR_WIDTH-1)}),
    .M_CONNECT_READ({1{{IF_COUNT{1'b1}}}}),
    .M_CONNECT_WRITE({1{{IF_COUNT{1'b1}}}})
)
axil_ctrl_interconnect_inst (
    .clk(pcie_clk),
    .rst(pcie_rst),
    .s_axil_awaddr(axil_if_csr_awaddr),
    .s_axil_awprot(axil_if_csr_awprot),
    .s_axil_awvalid(axil_if_csr_awvalid),
    .s_axil_awready(axil_if_csr_awready),
    .s_axil_wdata(axil_if_csr_wdata),
    .s_axil_wstrb(axil_if_csr_wstrb),
    .s_axil_wvalid(axil_if_csr_wvalid),
    .s_axil_wready(axil_if_csr_wready),
    .s_axil_bresp(axil_if_csr_bresp),
    .s_axil_bvalid(axil_if_csr_bvalid),
    .s_axil_bready(axil_if_csr_bready),
    .s_axil_araddr(axil_if_csr_araddr),
    .s_axil_arprot(axil_if_csr_arprot),
    .s_axil_arvalid(axil_if_csr_arvalid),
    .s_axil_arready(axil_if_csr_arready),
    .s_axil_rdata(axil_if_csr_rdata),
    .s_axil_rresp(axil_if_csr_rresp),
    .s_axil_rvalid(axil_if_csr_rvalid),
    .s_axil_rready(axil_if_csr_rready),
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
    .m_axil_rready(axil_ctrl_rready)
);

// DMA connections
wire [SEG_COUNT*RAM_SEL_WIDTH-1:0]   dma_ram_wr_cmd_sel;
wire [SEG_COUNT*SEG_BE_WIDTH-1:0]    dma_ram_wr_cmd_be;
wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0]  dma_ram_wr_cmd_addr;
wire [SEG_COUNT*SEG_DATA_WIDTH-1:0]  dma_ram_wr_cmd_data;
wire [SEG_COUNT-1:0]                 dma_ram_wr_cmd_valid;
wire [SEG_COUNT-1:0]                 dma_ram_wr_cmd_ready;
wire [SEG_COUNT*RAM_SEL_WIDTH-1:0]   dma_ram_rd_cmd_sel;
wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0]  dma_ram_rd_cmd_addr;
wire [SEG_COUNT-1:0]                 dma_ram_rd_cmd_valid;
wire [SEG_COUNT-1:0]                 dma_ram_rd_cmd_ready;
wire [SEG_COUNT*SEG_DATA_WIDTH-1:0]  dma_ram_rd_resp_data;
wire [SEG_COUNT-1:0]                 dma_ram_rd_resp_valid;
wire [SEG_COUNT-1:0]                 dma_ram_rd_resp_ready;

// PCIe DMA control
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

wire [IF_COUNT*32-1:0] if_msi_irq;

generate
    genvar m, n;
    
    case (IF_COUNT)
        1: assign msi_irq = if_msi_irq[0*32+:32];
        2: assign msi_irq = if_msi_irq[0*32+:32] | if_msi_irq[1*32+:32];
        3: assign msi_irq = if_msi_irq[0*32+:32] | if_msi_irq[1*32+:32] | if_msi_irq[2*32+:32];
        4: assign msi_irq = if_msi_irq[0*32+:32] | if_msi_irq[1*32+:32] | if_msi_irq[2*32+:32] | 
                            if_msi_irq[3*32+:32];
        5: assign msi_irq = if_msi_irq[0*32+:32] | if_msi_irq[1*32+:32] | if_msi_irq[2*32+:32] | 
                            if_msi_irq[3*32+:32] | if_msi_irq[4*32+:32];
        6: assign msi_irq = if_msi_irq[0*32+:32] | if_msi_irq[1*32+:32] | if_msi_irq[2*32+:32] | 
                            if_msi_irq[3*32+:32] | if_msi_irq[4*32+:32] | if_msi_irq[5*32+:32];
        7: assign msi_irq = if_msi_irq[0*32+:32] | if_msi_irq[1*32+:32] | if_msi_irq[2*32+:32] | 
                            if_msi_irq[3*32+:32] | if_msi_irq[4*32+:32] | if_msi_irq[5*32+:32] | 
                            if_msi_irq[6*32+:32];
        8: assign msi_irq = if_msi_irq[0*32+:32] | if_msi_irq[1*32+:32] | if_msi_irq[2*32+:32] | 
                            if_msi_irq[3*32+:32] | if_msi_irq[4*32+:32] | if_msi_irq[5*32+:32] | 
                            if_msi_irq[6*32+:32] | if_msi_irq[7*32+:32];
    endcase

    for (n = 0; n < IF_COUNT; n = n + 1) begin : iface

        interface #(
            .PORTS(PORTS_PER_IF),
            .DMA_ADDR_WIDTH(PCIE_ADDR_WIDTH),
            .DMA_LEN_WIDTH(PCIE_DMA_LEN_WIDTH),
            .DMA_TAG_WIDTH(IF_PCIE_DMA_TAG_WIDTH),
            .EVENT_QUEUE_OP_TABLE_SIZE(EVENT_QUEUE_OP_TABLE_SIZE),
            .TX_QUEUE_OP_TABLE_SIZE(TX_QUEUE_OP_TABLE_SIZE),
            .RX_QUEUE_OP_TABLE_SIZE(RX_QUEUE_OP_TABLE_SIZE),
            .TX_CPL_QUEUE_OP_TABLE_SIZE(TX_CPL_QUEUE_OP_TABLE_SIZE),
            .RX_CPL_QUEUE_OP_TABLE_SIZE(RX_CPL_QUEUE_OP_TABLE_SIZE),
            .TX_QUEUE_INDEX_WIDTH(TX_QUEUE_INDEX_WIDTH),
            .RX_QUEUE_INDEX_WIDTH(RX_QUEUE_INDEX_WIDTH),
            .TX_CPL_QUEUE_INDEX_WIDTH(TX_CPL_QUEUE_INDEX_WIDTH),
            .RX_CPL_QUEUE_INDEX_WIDTH(RX_CPL_QUEUE_INDEX_WIDTH),
            .TX_DESC_TABLE_SIZE(TX_DESC_TABLE_SIZE),
            .TX_PKT_TABLE_SIZE(TX_PKT_TABLE_SIZE),
            .RX_DESC_TABLE_SIZE(RX_DESC_TABLE_SIZE),
            .RX_PKT_TABLE_SIZE(RX_PKT_TABLE_SIZE),
            .TX_SCHEDULER(TX_SCHEDULER),
            .TX_SCHEDULER_OP_TABLE_SIZE(TX_SCHEDULER_OP_TABLE_SIZE),
            .TDMA_INDEX_WIDTH(TDMA_INDEX_WIDTH),
            .INT_WIDTH(8),
            .QUEUE_PTR_WIDTH(16),
            .QUEUE_LOG_SIZE_WIDTH(4),
            .PTP_TS_ENABLE(0),
            .PTP_TS_WIDTH(96),
            .TX_CHECKSUM_ENABLE(TX_CHECKSUM_ENABLE),
            .RX_CHECKSUM_ENABLE(RX_CHECKSUM_ENABLE),
            .AXIL_DATA_WIDTH(AXIL_DATA_WIDTH),
            .AXIL_ADDR_WIDTH(IF_AXIL_ADDR_WIDTH),
            .AXIL_STRB_WIDTH(AXIL_STRB_WIDTH),
            .SEG_COUNT(SEG_COUNT),
            .SEG_DATA_WIDTH(SEG_DATA_WIDTH),
            .SEG_ADDR_WIDTH(SEG_ADDR_WIDTH),
            .SEG_BE_WIDTH(SEG_BE_WIDTH),
            .RAM_SEL_WIDTH(IF_RAM_SEL_WIDTH),
            .RAM_ADDR_WIDTH(RAM_ADDR_WIDTH),
            .RAM_PIPELINE(RAM_PIPELINE),
            .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
            .AXIS_KEEP_WIDTH(AXIS_KEEP_WIDTH),
            .MAX_TX_SIZE(MAX_TX_SIZE),
            .MAX_RX_SIZE(MAX_RX_SIZE),
            .TX_RAM_SIZE(TX_RAM_SIZE),
            .RX_RAM_SIZE(RX_RAM_SIZE)
        )
        interface_inst (
            .clk(pcie_clk),
            .rst(pcie_rst),

            /*
             * DMA read descriptor output
             */
            .m_axis_dma_read_desc_dma_addr(if_pcie_dma_read_desc_pcie_addr[n*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]),
            .m_axis_dma_read_desc_ram_sel(if_pcie_dma_read_desc_ram_sel[n*IF_RAM_SEL_WIDTH +: IF_RAM_SEL_WIDTH]),
            .m_axis_dma_read_desc_ram_addr(if_pcie_dma_read_desc_ram_addr[n*RAM_ADDR_WIDTH +: RAM_ADDR_WIDTH]),
            .m_axis_dma_read_desc_len(if_pcie_dma_read_desc_len[n*PCIE_DMA_LEN_WIDTH +: PCIE_DMA_LEN_WIDTH]),
            .m_axis_dma_read_desc_tag(if_pcie_dma_read_desc_tag[n*IF_PCIE_DMA_TAG_WIDTH +: IF_PCIE_DMA_TAG_WIDTH]),
            .m_axis_dma_read_desc_valid(if_pcie_dma_read_desc_valid[n]),
            .m_axis_dma_read_desc_ready(if_pcie_dma_read_desc_ready[n]),

            /*
             * DMA read descriptor status input
             */
            .s_axis_dma_read_desc_status_tag(if_pcie_dma_read_desc_status_tag[n*IF_PCIE_DMA_TAG_WIDTH +: IF_PCIE_DMA_TAG_WIDTH]),
            .s_axis_dma_read_desc_status_valid(if_pcie_dma_read_desc_status_valid[n]),

            /*
             * DMA write descriptor output
             */
            .m_axis_dma_write_desc_dma_addr(if_pcie_dma_write_desc_pcie_addr[n*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]),
            .m_axis_dma_write_desc_ram_sel(if_pcie_dma_write_desc_ram_sel[n*IF_RAM_SEL_WIDTH +: IF_RAM_SEL_WIDTH]),
            .m_axis_dma_write_desc_ram_addr(if_pcie_dma_write_desc_ram_addr[n*RAM_ADDR_WIDTH +: RAM_ADDR_WIDTH]),
            .m_axis_dma_write_desc_len(if_pcie_dma_write_desc_len[n*PCIE_DMA_LEN_WIDTH +: PCIE_DMA_LEN_WIDTH]),
            .m_axis_dma_write_desc_tag(if_pcie_dma_write_desc_tag[n*IF_PCIE_DMA_TAG_WIDTH +: IF_PCIE_DMA_TAG_WIDTH]),
            .m_axis_dma_write_desc_valid(if_pcie_dma_write_desc_valid[n]),
            .m_axis_dma_write_desc_ready(if_pcie_dma_write_desc_ready[n]),

            /*
             * DMA write descriptor status input
             */
            .s_axis_dma_write_desc_status_tag(if_pcie_dma_write_desc_status_tag[n*IF_PCIE_DMA_TAG_WIDTH +: IF_PCIE_DMA_TAG_WIDTH]),
            .s_axis_dma_write_desc_status_valid(if_pcie_dma_write_desc_status_valid[n]),

            /*
             * AXI-Lite slave interface
             */
            .s_axil_awaddr(axil_if_awaddr[n*AXIL_ADDR_WIDTH +: AXIL_ADDR_WIDTH]),
            .s_axil_awprot(axil_if_awprot[n*3 +: 3]),
            .s_axil_awvalid(axil_if_awvalid[n]),
            .s_axil_awready(axil_if_awready[n]),
            .s_axil_wdata(axil_if_wdata[n*AXIL_DATA_WIDTH +: AXIL_DATA_WIDTH]),
            .s_axil_wstrb(axil_if_wstrb[n*AXIL_STRB_WIDTH +: AXIL_STRB_WIDTH]),
            .s_axil_wvalid(axil_if_wvalid[n]),
            .s_axil_wready(axil_if_wready[n]),
            .s_axil_bresp(axil_if_bresp[n*2 +: 2]),
            .s_axil_bvalid(axil_if_bvalid[n]),
            .s_axil_bready(axil_if_bready[n]),
            .s_axil_araddr(axil_if_araddr[n*AXIL_ADDR_WIDTH +: AXIL_ADDR_WIDTH]),
            .s_axil_arprot(axil_if_arprot[n*3 +: 3]),
            .s_axil_arvalid(axil_if_arvalid[n]),
            .s_axil_arready(axil_if_arready[n]),
            .s_axil_rdata(axil_if_rdata[n*AXIL_DATA_WIDTH +: AXIL_DATA_WIDTH]),
            .s_axil_rresp(axil_if_rresp[n*2 +: 2]),
            .s_axil_rvalid(axil_if_rvalid[n]),
            .s_axil_rready(axil_if_rready[n]),

            /*
             * AXI-Lite master interface (passthrough for NIC control and status)
             */
            .m_axil_csr_awaddr(axil_if_csr_awaddr[n*AXIL_CSR_ADDR_WIDTH +: AXIL_CSR_ADDR_WIDTH]),
            .m_axil_csr_awprot(axil_if_csr_awprot[n*3 +: 3]),
            .m_axil_csr_awvalid(axil_if_csr_awvalid[n]),
            .m_axil_csr_awready(axil_if_csr_awready[n]),
            .m_axil_csr_wdata(axil_if_csr_wdata[n*AXIL_DATA_WIDTH +: AXIL_DATA_WIDTH]),
            .m_axil_csr_wstrb(axil_if_csr_wstrb[n*AXIL_STRB_WIDTH +: AXIL_STRB_WIDTH]),
            .m_axil_csr_wvalid(axil_if_csr_wvalid[n]),
            .m_axil_csr_wready(axil_if_csr_wready[n]),
            .m_axil_csr_bresp(axil_if_csr_bresp[n*2 +: 2]),
            .m_axil_csr_bvalid(axil_if_csr_bvalid[n]),
            .m_axil_csr_bready(axil_if_csr_bready[n]),
            .m_axil_csr_araddr(axil_if_csr_araddr[n*AXIL_CSR_ADDR_WIDTH +: AXIL_CSR_ADDR_WIDTH]),
            .m_axil_csr_arprot(axil_if_csr_arprot[n*3 +: 3]),
            .m_axil_csr_arvalid(axil_if_csr_arvalid[n]),
            .m_axil_csr_arready(axil_if_csr_arready[n]),
            .m_axil_csr_rdata(axil_if_csr_rdata[n*AXIL_DATA_WIDTH +: AXIL_DATA_WIDTH]),
            .m_axil_csr_rresp(axil_if_csr_rresp[n*2 +: 2]),
            .m_axil_csr_rvalid(axil_if_csr_rvalid[n]),
            .m_axil_csr_rready(axil_if_csr_rready[n]),

            /*
             * RAM interface
             */
            .dma_ram_wr_cmd_sel(if_dma_ram_wr_cmd_sel[SEG_COUNT*IF_RAM_SEL_WIDTH*n +: SEG_COUNT*IF_RAM_SEL_WIDTH]),
            .dma_ram_wr_cmd_be(if_dma_ram_wr_cmd_be[SEG_COUNT*SEG_BE_WIDTH*n +: SEG_COUNT*SEG_BE_WIDTH]),
            .dma_ram_wr_cmd_addr(if_dma_ram_wr_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH*n +: SEG_COUNT*SEG_ADDR_WIDTH]),
            .dma_ram_wr_cmd_data(if_dma_ram_wr_cmd_data[SEG_COUNT*SEG_DATA_WIDTH*n +: SEG_COUNT*SEG_DATA_WIDTH]),
            .dma_ram_wr_cmd_valid(if_dma_ram_wr_cmd_valid[SEG_COUNT*n +: SEG_COUNT]),
            .dma_ram_wr_cmd_ready(if_dma_ram_wr_cmd_ready[SEG_COUNT*n +: SEG_COUNT]),
            .dma_ram_rd_cmd_sel(if_dma_ram_rd_cmd_sel[SEG_COUNT*IF_RAM_SEL_WIDTH*n +: SEG_COUNT*IF_RAM_SEL_WIDTH]),
            .dma_ram_rd_cmd_addr(if_dma_ram_rd_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH*n +: SEG_COUNT*SEG_ADDR_WIDTH]),
            .dma_ram_rd_cmd_valid(if_dma_ram_rd_cmd_valid[SEG_COUNT*n +: SEG_COUNT]),
            .dma_ram_rd_cmd_ready(if_dma_ram_rd_cmd_ready[SEG_COUNT*n +: SEG_COUNT]),
            .dma_ram_rd_resp_data(if_dma_ram_rd_resp_data[SEG_COUNT*SEG_DATA_WIDTH*n +: SEG_COUNT*SEG_DATA_WIDTH]),
            .dma_ram_rd_resp_valid(if_dma_ram_rd_resp_valid[SEG_COUNT*n +: SEG_COUNT]),
            .dma_ram_rd_resp_ready(if_dma_ram_rd_resp_ready[SEG_COUNT*n +: SEG_COUNT]),

            /*
             * Transmit data output
             */
            .tx_axis_tdata(tx_axis_tdata[PORTS_PER_IF*AXIS_DATA_WIDTH*n +: PORTS_PER_IF*AXIS_DATA_WIDTH]),
            .tx_axis_tkeep(tx_axis_tkeep[PORTS_PER_IF*AXIS_KEEP_WIDTH*n +: PORTS_PER_IF*AXIS_KEEP_WIDTH]),
            .tx_axis_tvalid(tx_axis_tvalid[PORTS_PER_IF*n +: PORTS_PER_IF]),
            .tx_axis_tready(tx_axis_tready[PORTS_PER_IF*n +: PORTS_PER_IF]),
            .tx_axis_tlast(tx_axis_tlast[PORTS_PER_IF*n +: PORTS_PER_IF]),
            .tx_axis_tuser(tx_axis_tuser[PORTS_PER_IF*n +: PORTS_PER_IF]),

            /*
             * Transmit timestamp input
             */
            .s_axis_tx_ptp_ts_96(96'd0), 
            .s_axis_tx_ptp_ts_valid(1'b0), 
            .s_axis_tx_ptp_ts_ready(), 

            /*
             * Receive data input
             */
            .rx_axis_tdata(rx_axis_tdata[PORTS_PER_IF*AXIS_DATA_WIDTH*n +: PORTS_PER_IF*AXIS_DATA_WIDTH]),
            .rx_axis_tkeep(rx_axis_tkeep[PORTS_PER_IF*AXIS_KEEP_WIDTH*n +: PORTS_PER_IF*AXIS_KEEP_WIDTH]),
            .rx_axis_tvalid(rx_axis_tvalid[PORTS_PER_IF*n +: PORTS_PER_IF]),
            .rx_axis_tready(rx_axis_tready[PORTS_PER_IF*n +: PORTS_PER_IF]),
            .rx_axis_tlast(rx_axis_tlast[PORTS_PER_IF*n +: PORTS_PER_IF]),
            .rx_axis_tuser(rx_axis_tuser[PORTS_PER_IF*n +: PORTS_PER_IF]),

            /*
             * Receive timestamp input
             */
            .s_axis_rx_ptp_ts_96(96'd0), 
            .s_axis_rx_ptp_ts_valid(1'b0), 
            .s_axis_rx_ptp_ts_ready(), 

            /*
             * PTP clock
             */
            .ptp_ts_96(96'd0),
            .ptp_ts_step(1'b0),

            /*
             * MSI interrupts
             */
            .msi_irq(if_msi_irq[n*32 +: 32])
        );

    end

endgenerate

endmodule

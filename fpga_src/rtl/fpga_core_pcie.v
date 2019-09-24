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
     * Clock: 156.25 MHz, 250 MHz
     * Synchronous reset
     */
    input  wire                            clk_250mhz,
    input  wire                            rst_250mhz,
    input  wire                            clk_200mhz,
    input  wire                            rst_200mhz,
    input  wire                            core_clk_i,
    input  wire                            core_rst_i,

    /*
     * GPIO
     */
    output wire [1:0]                      sma_led,

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

    input  wire [1:0]                      pcie_tfc_nph_av,
    input  wire [1:0]                      pcie_tfc_npd_av,

    input  wire [2:0]                      cfg_max_payload,
    input  wire [2:0]                      cfg_max_read_req,

    output wire [18:0]                     cfg_mgmt_addr,
    output wire                            cfg_mgmt_write,
    output wire [31:0]                     cfg_mgmt_write_data,
    output wire [3:0]                      cfg_mgmt_byte_enable,
    output wire                            cfg_mgmt_read,
    input  wire [31:0]                     cfg_mgmt_read_data,
    input  wire                            cfg_mgmt_read_write_done,

    input  wire [3:0]                      cfg_interrupt_msi_enable,
    input  wire [7:0]                      cfg_interrupt_msi_vf_enable,
    input  wire [11:0]                     cfg_interrupt_msi_mmenable,
    input  wire                            cfg_interrupt_msi_mask_update,
    input  wire [31:0]                     cfg_interrupt_msi_data,
    output wire [3:0]                      cfg_interrupt_msi_select,
    output wire [31:0]                     cfg_interrupt_msi_int,
    output wire [31:0]                     cfg_interrupt_msi_pending_status,
    output wire                            cfg_interrupt_msi_pending_status_data_enable,
    output wire [3:0]                      cfg_interrupt_msi_pending_status_function_num,
    input  wire                            cfg_interrupt_msi_sent,
    input  wire                            cfg_interrupt_msi_fail,
    output wire [2:0]                      cfg_interrupt_msi_attr,
    output wire                            cfg_interrupt_msi_tph_present,
    output wire [1:0]                      cfg_interrupt_msi_tph_type,
    output wire [8:0]                      cfg_interrupt_msi_tph_st_tag,
    output wire [3:0]                      cfg_interrupt_msi_function_number,

    output wire                            status_error_cor,
    output wire                            status_error_uncor,

    /*
     * Ethernet: SFP+
     */
    input  wire                            sfp_1_tx_clk,
    input  wire                            sfp_1_tx_rst,
    output wire [63:0]                     sfp_1_txd,
    output wire [7:0]                      sfp_1_txc,
    input  wire                            sfp_1_rx_clk,
    input  wire                            sfp_1_rx_rst,
    input  wire [63:0]                     sfp_1_rxd,
    input  wire [7:0]                      sfp_1_rxc,
    input  wire                            sfp_2_tx_clk,
    input  wire                            sfp_2_tx_rst,
    output wire [63:0]                     sfp_2_txd,
    output wire [7:0]                      sfp_2_txc,
    input  wire                            sfp_2_rx_clk,
    input  wire                            sfp_2_rx_rst,
    input  wire [63:0]                     sfp_2_rxd,
    input  wire [7:0]                      sfp_2_rxc
);

parameter PCIE_ADDR_WIDTH = 64;

// AXI lite interface parameters
parameter AXIL_DATA_WIDTH = 32;
parameter AXIL_STRB_WIDTH = (AXIL_DATA_WIDTH/8);
parameter AXIL_ADDR_WIDTH = 32;

// AXI interface parameters
parameter AXI_ID_WIDTH = 8;
parameter AXI_DATA_WIDTH = AXIS_PCIE_DATA_WIDTH;
parameter AXI_STRB_WIDTH = (AXI_DATA_WIDTH/8);
parameter AXI_ADDR_WIDTH = 32;
// AXI stream interface parameters
parameter AXIS_DATA_WIDTH = AXI_DATA_WIDTH;
parameter AXIS_KEEP_WIDTH = AXI_STRB_WIDTH;

// PCIe DMA parameters
parameter PCIE_DMA_LEN_WIDTH = 16;
parameter PCIE_DMA_TAG_WIDTH = 16;

// MAC parameters
parameter TX_FIFO_DEPTH    = 32768;
parameter RX_FIFO_DEPTH    = 32768;

parameter ILA_EN = 0;

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

// Error handling
wire [1:0] status_error_uncor_int;
wire [1:0] status_error_cor_int;

wire [31:0] msi_irq;

wire ext_tag_enable;

// PCIe DMA control
wire [PCIE_ADDR_WIDTH-1:0]     pcie_dma_read_desc_pcie_addr;
wire [AXI_ADDR_WIDTH-1:0]      pcie_dma_read_desc_axi_addr;
wire [PCIE_DMA_LEN_WIDTH-1:0]  pcie_dma_read_desc_len;
wire [PCIE_DMA_TAG_WIDTH-1:0]  pcie_dma_read_desc_tag;
wire                           pcie_dma_read_desc_valid;
wire                           pcie_dma_read_desc_ready;

wire [PCIE_DMA_TAG_WIDTH-1:0]  pcie_dma_read_desc_status_tag;
wire                           pcie_dma_read_desc_status_valid;
wire                           pcie_dma_read_desc_status_ready;

wire [PCIE_ADDR_WIDTH-1:0]     pcie_dma_write_desc_pcie_addr;
wire [AXI_ADDR_WIDTH-1:0]      pcie_dma_write_desc_axi_addr;
wire [PCIE_DMA_LEN_WIDTH-1:0]  pcie_dma_write_desc_len;
wire [PCIE_DMA_TAG_WIDTH-1:0]  pcie_dma_write_desc_tag;
wire                           pcie_dma_write_desc_valid;
wire                           pcie_dma_write_desc_ready;

wire [PCIE_DMA_TAG_WIDTH-1:0]  pcie_dma_write_desc_status_tag;
wire                           pcie_dma_write_desc_status_valid;
wire                           pcie_dma_write_desc_status_ready;

wire                           pcie_dma_enable;

// Register axis input from PCIe
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
    .clk(clk_250mhz),
    .rst(rst_250mhz),

    /*
     * AXI input
     */
    .s_axis_tdata(s_axis_rc_tdata),
    .s_axis_tkeep(s_axis_rc_tkeep),
    .s_axis_tvalid(s_axis_rc_tvalid),
    .s_axis_tready(s_axis_rc_tready),
    .s_axis_tlast(s_axis_rc_tlast),
    .s_axis_tid(0),
    .s_axis_tdest(0),
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
    .clk(clk_250mhz),
    .rst(rst_250mhz),

    /*
     * AXI input
     */
    .s_axis_tdata(s_axis_cq_tdata),
    .s_axis_tkeep(s_axis_cq_tkeep),
    .s_axis_tvalid(s_axis_cq_tvalid),
    .s_axis_tready(s_axis_cq_tready),
    .s_axis_tlast(s_axis_cq_tlast),
    .s_axis_tid(0),
    .s_axis_tdest(0),
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

// control registers
reg axil_ctrl_awready_reg = 1'b0, axil_ctrl_awready_next;
reg axil_ctrl_wready_reg = 1'b0, axil_ctrl_wready_next;
reg [1:0] axil_ctrl_bresp_reg = 2'b00, axil_ctrl_bresp_next;
reg axil_ctrl_bvalid_reg = 1'b0, axil_ctrl_bvalid_next;
reg axil_ctrl_arready_reg = 1'b0, axil_ctrl_arready_next;
reg [AXIL_DATA_WIDTH-1:0] axil_ctrl_rdata_reg = {AXIL_DATA_WIDTH{1'b0}}, axil_ctrl_rdata_next;
reg [1:0] axil_ctrl_rresp_reg = 2'b00, axil_ctrl_rresp_next;
reg axil_ctrl_rvalid_reg = 1'b0, axil_ctrl_rvalid_next;

reg [PCIE_ADDR_WIDTH-1:0] pcie_dma_read_desc_pcie_addr_reg = 0, pcie_dma_read_desc_pcie_addr_next;
reg [AXI_ADDR_WIDTH-1:0] pcie_dma_read_desc_axi_addr_reg = 0, pcie_dma_read_desc_axi_addr_next;
reg [15:0] pcie_dma_read_desc_len_reg = 0, pcie_dma_read_desc_len_next;
reg [PCIE_DMA_TAG_WIDTH-1:0] pcie_dma_read_desc_tag_reg = 0, pcie_dma_read_desc_tag_next;
reg pcie_dma_read_desc_valid_reg = 0, pcie_dma_read_desc_valid_next;

reg pcie_dma_read_desc_status_ready_reg = 0, pcie_dma_read_desc_status_ready_next;

reg [PCIE_ADDR_WIDTH-1:0] pcie_dma_write_desc_pcie_addr_reg = 0, pcie_dma_write_desc_pcie_addr_next;
reg [AXI_ADDR_WIDTH-1:0] pcie_dma_write_desc_axi_addr_reg = 0, pcie_dma_write_desc_axi_addr_next;
reg [15:0] pcie_dma_write_desc_len_reg = 0, pcie_dma_write_desc_len_next;
reg [PCIE_DMA_TAG_WIDTH-1:0] pcie_dma_write_desc_tag_reg = 0, pcie_dma_write_desc_tag_next;
reg pcie_dma_write_desc_valid_reg = 0, pcie_dma_write_desc_valid_next;

reg pcie_dma_write_desc_status_ready_reg = 0, pcie_dma_write_desc_status_ready_next;

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

assign pcie_dma_read_desc_pcie_addr = pcie_dma_read_desc_pcie_addr_reg;
assign pcie_dma_read_desc_axi_addr = pcie_dma_read_desc_axi_addr_reg;
assign pcie_dma_read_desc_len = pcie_dma_read_desc_len_reg;
assign pcie_dma_read_desc_tag = pcie_dma_read_desc_tag_reg;
assign pcie_dma_read_desc_valid = pcie_dma_read_desc_valid_reg;
assign pcie_dma_read_desc_status_ready = pcie_dma_read_desc_status_ready_reg;
assign pcie_dma_write_desc_pcie_addr = pcie_dma_write_desc_pcie_addr_reg;
assign pcie_dma_write_desc_axi_addr = pcie_dma_write_desc_axi_addr_reg;
assign pcie_dma_write_desc_len = pcie_dma_write_desc_len_reg;
assign pcie_dma_write_desc_tag = pcie_dma_write_desc_tag_reg;
assign pcie_dma_write_desc_valid = pcie_dma_write_desc_valid_reg;
assign pcie_dma_write_desc_status_ready = pcie_dma_write_desc_status_ready_reg;
assign pcie_dma_enable = pcie_dma_enable_reg;

assign msi_irq[0] = pcie_dma_read_desc_status_valid || pcie_dma_write_desc_status_valid;
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

    pcie_dma_read_desc_pcie_addr_next = pcie_dma_read_desc_pcie_addr_reg;
    pcie_dma_read_desc_axi_addr_next = pcie_dma_read_desc_axi_addr_reg;
    pcie_dma_read_desc_len_next = pcie_dma_read_desc_len_reg;
    pcie_dma_read_desc_tag_next = pcie_dma_read_desc_tag_reg;
    pcie_dma_read_desc_valid_next = pcie_dma_read_desc_valid_reg && !pcie_dma_read_desc_ready;
    pcie_dma_read_desc_status_ready_next = 1'b0;

    pcie_dma_write_desc_pcie_addr_next = pcie_dma_write_desc_pcie_addr_reg;
    pcie_dma_write_desc_axi_addr_next = pcie_dma_write_desc_axi_addr_reg;
    pcie_dma_write_desc_len_next = pcie_dma_write_desc_len_reg;
    pcie_dma_write_desc_tag_next = pcie_dma_write_desc_tag_reg;
    pcie_dma_write_desc_valid_next = pcie_dma_write_desc_valid_reg && !pcie_dma_read_desc_ready;
    pcie_dma_write_desc_status_ready_next = 1'b0;

    pcie_dma_enable_next = pcie_dma_enable_reg;

    if (axil_ctrl_awvalid && axil_ctrl_wvalid && !axil_ctrl_bvalid) begin
        // write operation
        axil_ctrl_awready_next = 1'b1;
        axil_ctrl_wready_next = 1'b1;
        axil_ctrl_bresp_next = 2'b00;
        axil_ctrl_bvalid_next = 1'b1;

        case ({axil_ctrl_awaddr[15:2], 2'b00})
            16'h0000: pcie_dma_enable_next = axil_ctrl_wdata;
            16'h0100: pcie_dma_read_desc_pcie_addr_next[31:0] = axil_ctrl_wdata;
            16'h0104: pcie_dma_read_desc_pcie_addr_next[63:32] = axil_ctrl_wdata;
            16'h0108: pcie_dma_read_desc_axi_addr_next[31:0] = axil_ctrl_wdata;
            //16'h010C: pcie_dma_read_desc_axi_addr_next[63:32] = axil_ctrl_wdata;
            16'h0110: pcie_dma_read_desc_len_next = axil_ctrl_wdata;
            16'h0114: begin
                pcie_dma_read_desc_tag_next = axil_ctrl_wdata;
                pcie_dma_read_desc_valid_next = 1'b1;
            end
            16'h0200: pcie_dma_write_desc_pcie_addr_next[31:0] = axil_ctrl_wdata;
            16'h0204: pcie_dma_write_desc_pcie_addr_next[63:32] = axil_ctrl_wdata;
            16'h0208: pcie_dma_write_desc_axi_addr_next[31:0] = axil_ctrl_wdata;
            //16'h020C: pcie_dma_write_desc_axi_addr_next[63:32] = axil_ctrl_wdata;
            16'h0210: pcie_dma_write_desc_len_next = axil_ctrl_wdata;
            16'h0214: begin
                pcie_dma_write_desc_tag_next = axil_ctrl_wdata;
                pcie_dma_write_desc_valid_next = 1'b1;
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
                axil_ctrl_rdata_next = pcie_dma_read_desc_status_tag | (pcie_dma_read_desc_status_valid ? 32'h80000000 : 32'd0);
                pcie_dma_read_desc_status_ready_next = pcie_dma_read_desc_status_valid;
            end
            16'h0218: begin
                axil_ctrl_rdata_next = pcie_dma_write_desc_status_tag | (pcie_dma_write_desc_status_valid ? 32'h80000000 : 32'd0);
                pcie_dma_write_desc_status_ready_next = pcie_dma_write_desc_status_valid;
            end
            16'h0400: axil_ctrl_rdata_next = pcie_rq_count_reg;
            16'h0404: axil_ctrl_rdata_next = pcie_rc_count_reg;
            16'h0408: axil_ctrl_rdata_next = pcie_cq_count_reg;
            16'h040C: axil_ctrl_rdata_next = pcie_cc_count_reg;
        endcase
    end
end

always @(posedge clk_250mhz) begin
    if (rst_250mhz) begin
        axil_ctrl_awready_reg <= 1'b0;
        axil_ctrl_wready_reg <= 1'b0;
        axil_ctrl_bvalid_reg <= 1'b0;
        axil_ctrl_arready_reg <= 1'b0;
        axil_ctrl_rvalid_reg <= 1'b0;

        pcie_dma_read_desc_valid_reg <= 1'b0;
        pcie_dma_read_desc_status_ready_reg <= 1'b0;
        pcie_dma_write_desc_valid_reg <= 1'b0;
        pcie_dma_write_desc_status_ready_reg <= 1'b0;
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

        pcie_dma_read_desc_valid_reg <= pcie_dma_read_desc_valid_next;
        pcie_dma_read_desc_status_ready_reg <= pcie_dma_read_desc_status_ready_next;
        pcie_dma_write_desc_valid_reg <= pcie_dma_write_desc_valid_next;
        pcie_dma_write_desc_status_ready_reg <= pcie_dma_write_desc_status_ready_next;
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

    pcie_dma_read_desc_pcie_addr_reg <= pcie_dma_read_desc_pcie_addr_next;
    pcie_dma_read_desc_axi_addr_reg <= pcie_dma_read_desc_axi_addr_next;
    pcie_dma_read_desc_len_reg <= pcie_dma_read_desc_len_next;
    pcie_dma_read_desc_tag_reg <= pcie_dma_read_desc_tag_next;
    pcie_dma_write_desc_pcie_addr_reg <= pcie_dma_write_desc_pcie_addr_next;
    pcie_dma_write_desc_axi_addr_reg <= pcie_dma_write_desc_axi_addr_next;
    pcie_dma_write_desc_len_reg <= pcie_dma_write_desc_len_next;
    pcie_dma_write_desc_tag_reg <= pcie_dma_write_desc_tag_next;
end

assign sma_led = 2'b00;

pcie_us_cfg #(
    .PF_COUNT(1),
    .VF_COUNT(0),
    .VF_OFFSET(64),
    .PCIE_CAP_OFFSET(12'h0C0)
)
pcie_us_cfg_inst (
    .clk(clk_250mhz),
    .rst(rst_250mhz),

    /*
     * Configuration outputs
     */
    .ext_tag_enable(ext_tag_enable),
    .max_read_request_size(),
    .max_payload_size(),

    /*
     * Interface to Ultrascale PCIe IP core
     */
    .cfg_mgmt_addr(cfg_mgmt_addr[9:0]),
    .cfg_mgmt_function_number(cfg_mgmt_addr[17:10]),
    .cfg_mgmt_write(cfg_mgmt_write),
    .cfg_mgmt_write_data(cfg_mgmt_write_data),
    .cfg_mgmt_byte_enable(cfg_mgmt_byte_enable),
    .cfg_mgmt_read(cfg_mgmt_read),
    .cfg_mgmt_read_data(cfg_mgmt_read_data),
    .cfg_mgmt_read_write_done(cfg_mgmt_read_write_done)
);

assign cfg_mgmt_addr[18] = 1'b0;

pcie_us_axil_master #(
    .AXIS_PCIE_DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .AXI_DATA_WIDTH(AXIL_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXIL_ADDR_WIDTH),
    .ENABLE_PARITY(0)
)
pcie_us_axil_master_inst (
    .clk(clk_250mhz),
    .rst(rst_250mhz),

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
    .clk(clk_250mhz),
    .rst(rst_250mhz),

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
    .s_axis_pcie_rq_tag(0),
    .s_axis_pcie_rq_tag_valid(0),

    /*
     * AXI read descriptor input
     */
    .s_axis_read_desc_pcie_addr(pcie_dma_read_desc_pcie_addr),
    .s_axis_read_desc_axi_addr(pcie_dma_read_desc_axi_addr),
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
    .s_axis_write_desc_axi_addr(pcie_dma_write_desc_axi_addr),
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

axi_ram #(
    .DATA_WIDTH(AXI_DATA_WIDTH),
    .ADDR_WIDTH(16),
    .ID_WIDTH(AXI_ID_WIDTH),
    .PIPELINE_OUTPUT(1)
)
axi_dma_ram_inst (
    .clk(clk_250mhz),
    .rst(rst_250mhz),
    .s_axi_awid(axi_pcie_dma_awid),
    .s_axi_awaddr(axi_pcie_dma_awaddr),
    .s_axi_awlen(axi_pcie_dma_awlen),
    .s_axi_awsize(axi_pcie_dma_awsize),
    .s_axi_awburst(axi_pcie_dma_awburst),
    .s_axi_awlock(axi_pcie_dma_awlock),
    .s_axi_awcache(axi_pcie_dma_awcache),
    .s_axi_awprot(axi_pcie_dma_awprot),
    .s_axi_awvalid(axi_pcie_dma_awvalid),
    .s_axi_awready(axi_pcie_dma_awready),
    .s_axi_wdata(axi_pcie_dma_wdata),
    .s_axi_wstrb(axi_pcie_dma_wstrb),
    .s_axi_wlast(axi_pcie_dma_wlast),
    .s_axi_wvalid(axi_pcie_dma_wvalid),
    .s_axi_wready(axi_pcie_dma_wready),
    .s_axi_bid(axi_pcie_dma_bid),
    .s_axi_bresp(axi_pcie_dma_bresp),
    .s_axi_bvalid(axi_pcie_dma_bvalid),
    .s_axi_bready(axi_pcie_dma_bready),
    .s_axi_arid(axi_pcie_dma_arid),
    .s_axi_araddr(axi_pcie_dma_araddr),
    .s_axi_arlen(axi_pcie_dma_arlen),
    .s_axi_arsize(axi_pcie_dma_arsize),
    .s_axi_arburst(axi_pcie_dma_arburst),
    .s_axi_arlock(axi_pcie_dma_arlock),
    .s_axi_arcache(axi_pcie_dma_arcache),
    .s_axi_arprot(axi_pcie_dma_arprot),
    .s_axi_arvalid(axi_pcie_dma_arvalid),
    .s_axi_arready(axi_pcie_dma_arready),
    .s_axi_rid(axi_pcie_dma_rid),
    .s_axi_rdata(axi_pcie_dma_rdata),
    .s_axi_rresp(axi_pcie_dma_rresp),
    .s_axi_rlast(axi_pcie_dma_rlast),
    .s_axi_rvalid(axi_pcie_dma_rvalid),
    .s_axi_rready(axi_pcie_dma_rready)
);

pulse_merge #(
    .INPUT_WIDTH(2),
    .COUNT_WIDTH(4)
)
status_error_cor_pm_inst (
    .clk(clk_250mhz),
    .rst(rst_250mhz),

    .pulse_in(status_error_cor_int),
    .count_out(),
    .pulse_out(status_error_cor)
);

pulse_merge #(
    .INPUT_WIDTH(2),
    .COUNT_WIDTH(4)
)
status_error_uncor_pm_inst (
    .clk(clk_250mhz),
    .rst(rst_250mhz),

    .pulse_in(status_error_uncor_int),
    .count_out(),
    .pulse_out(status_error_uncor)
);

pcie_us_msi #(
    .MSI_COUNT(32)
)
pcie_us_msi_inst (
    .clk(clk_250mhz),
    .rst(rst_250mhz),

    .msi_irq(msi_irq),

    .cfg_interrupt_msi_enable(cfg_interrupt_msi_enable),
    .cfg_interrupt_msi_vf_enable(cfg_interrupt_msi_vf_enable),
    .cfg_interrupt_msi_mmenable(cfg_interrupt_msi_mmenable),
    .cfg_interrupt_msi_mask_update(cfg_interrupt_msi_mask_update),
    .cfg_interrupt_msi_data(cfg_interrupt_msi_data),
    .cfg_interrupt_msi_select(cfg_interrupt_msi_select),
    .cfg_interrupt_msi_int(cfg_interrupt_msi_int),
    .cfg_interrupt_msi_pending_status(cfg_interrupt_msi_pending_status),
    .cfg_interrupt_msi_pending_status_data_enable(cfg_interrupt_msi_pending_status_data_enable),
    .cfg_interrupt_msi_pending_status_function_num(cfg_interrupt_msi_pending_status_function_num),
    .cfg_interrupt_msi_sent(cfg_interrupt_msi_sent),
    .cfg_interrupt_msi_fail(cfg_interrupt_msi_fail),
    .cfg_interrupt_msi_attr(cfg_interrupt_msi_attr),
    .cfg_interrupt_msi_tph_present(cfg_interrupt_msi_tph_present),
    .cfg_interrupt_msi_tph_type(cfg_interrupt_msi_tph_type),
    .cfg_interrupt_msi_tph_st_tag(cfg_interrupt_msi_tph_st_tag),
    .cfg_interrupt_msi_function_number(cfg_interrupt_msi_function_number)
);

// MAC modules
parameter PORT_COUNT = 2;

wire [PORT_COUNT-1:0] port_xgmii_tx_clk = {sfp_2_tx_clk, sfp_1_tx_clk};
wire [PORT_COUNT-1:0] port_xgmii_tx_rst = {sfp_2_tx_rst, sfp_1_tx_rst};
wire [PORT_COUNT-1:0] port_xgmii_rx_clk = {sfp_2_rx_clk, sfp_1_rx_clk};
wire [PORT_COUNT-1:0] port_xgmii_rx_rst = {sfp_2_rx_rst, sfp_1_rx_rst};
wire [PORT_COUNT*64-1:0] port_xgmii_txd;
wire [PORT_COUNT*8-1:0] port_xgmii_txc;
wire [PORT_COUNT*64-1:0] port_xgmii_rxd = {sfp_2_rxd, sfp_1_rxd};
wire [PORT_COUNT*8-1:0] port_xgmii_rxc = {sfp_2_rxc, sfp_1_rxc};

assign {sfp_2_txd, sfp_1_txd} = port_xgmii_txd;
assign {sfp_2_txc, sfp_1_txc} = port_xgmii_txc;

wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0] mac_tx_axis_tdata;
wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0] mac_tx_axis_tkeep;
wire [PORT_COUNT-1:0] mac_tx_axis_tvalid;
wire [PORT_COUNT-1:0] mac_tx_axis_tready;
wire [PORT_COUNT-1:0] mac_tx_axis_tlast;
wire [PORT_COUNT-1:0] mac_tx_axis_tuser;

wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0] mac_rx_axis_tdata;
wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0] mac_rx_axis_tkeep;
wire [PORT_COUNT-1:0] mac_rx_axis_tvalid;
wire [PORT_COUNT-1:0] mac_rx_axis_tready;
wire [PORT_COUNT-1:0] mac_rx_axis_tlast;
wire [PORT_COUNT-1:0] mac_rx_axis_tuser;

genvar n;

generate
    for (n = 0; n < PORT_COUNT; n = n + 1) begin : iface
        eth_mac_10g_fifo #(
            .DATA_WIDTH(64),
            .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
            .AXIS_KEEP_ENABLE(AXIS_KEEP_WIDTH > 1),
            .AXIS_KEEP_WIDTH(AXIS_KEEP_WIDTH),
            .ENABLE_PADDING(1),
            .ENABLE_DIC(1),
            .TX_FIFO_DEPTH(TX_FIFO_DEPTH),
            .RX_FIFO_DEPTH(RX_FIFO_DEPTH)
        )
        eth_mac_inst (
            .rx_clk(port_xgmii_rx_clk[n]),
            .rx_rst(port_xgmii_rx_rst[n]),
            .tx_clk(port_xgmii_tx_clk[n]),
            .tx_rst(port_xgmii_tx_rst[n]),
            .logic_clk(clk_200mhz),
            .logic_rst(rst_200mhz),
            .ptp_sample_clk(1'b0),

            .tx_axis_tdata(mac_tx_axis_tdata[n*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
            .tx_axis_tkeep(mac_tx_axis_tkeep[n*AXIS_KEEP_WIDTH +: AXIS_KEEP_WIDTH]),
            .tx_axis_tvalid(mac_tx_axis_tvalid[n]),
            .tx_axis_tready(mac_tx_axis_tready[n]),
            .tx_axis_tlast(mac_tx_axis_tlast[n]),
            .tx_axis_tuser(mac_tx_axis_tuser[n]),

            .s_axis_tx_ptp_ts_tag(16'd0),
            .s_axis_tx_ptp_ts_valid(1'b0),
            .s_axis_tx_ptp_ts_ready(),

            .m_axis_tx_ptp_ts_96(),
            .m_axis_tx_ptp_ts_tag(),
            .m_axis_tx_ptp_ts_valid(), 
            .m_axis_tx_ptp_ts_ready(1'b1), 

            .rx_axis_tdata(mac_rx_axis_tdata[n*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
            .rx_axis_tkeep(mac_rx_axis_tkeep[n*AXIS_KEEP_WIDTH +: AXIS_KEEP_WIDTH]),
            .rx_axis_tvalid(mac_rx_axis_tvalid[n]),
            .rx_axis_tready(mac_rx_axis_tready[n]),
            .rx_axis_tlast(mac_rx_axis_tlast[n]),
            .rx_axis_tuser(mac_rx_axis_tuser[n]),

            .m_axis_rx_ptp_ts_96(), 
            .m_axis_rx_ptp_ts_valid(), 
            .m_axis_rx_ptp_ts_ready(1'b0),

            .xgmii_rxd(port_xgmii_rxd[n*64 +: 64]),
            .xgmii_rxc(port_xgmii_rxc[n*8 +: 8]),
            .xgmii_txd(port_xgmii_txd[n*64 +: 64]),
            .xgmii_txc(port_xgmii_txc[n*8 +: 8]),

            .tx_error_underflow(),
            .tx_fifo_overflow(),
            .tx_fifo_bad_frame(),
            .tx_fifo_good_frame(),
            .rx_error_bad_frame(),
            .rx_error_bad_fcs(),
            .rx_fifo_overflow(),
            .rx_fifo_bad_frame(),
            .rx_fifo_good_frame(),

            .ptp_ts_96(96'd0),

            .ifg_delay(8'd12)
        );
    end
endgenerate

pkt_processing # (
    .LVL1_DATA_WIDTH(AXIS_DATA_WIDTH),
    .LVL1_STRB_WIDTH(AXIS_KEEP_WIDTH),
    .INTERFACE_COUNT(2)
) riscv_sys_0 (
    .sys_clk(clk_200mhz),
    .sys_rst(rst_200mhz),
    .core_clk_i(core_clk_i),
    .core_rst_i(core_rst_i),

    .tx_axis_tdata (mac_tx_axis_tdata ),
    .tx_axis_tkeep (mac_tx_axis_tkeep ),
    .tx_axis_tvalid(mac_tx_axis_tvalid),
    .tx_axis_tready(mac_tx_axis_tready),
    .tx_axis_tlast (mac_tx_axis_tlast ),
                                      
    .rx_axis_tdata (mac_rx_axis_tdata ),
    .rx_axis_tkeep (mac_rx_axis_tkeep ),
    .rx_axis_tvalid(mac_rx_axis_tvalid), 
    .rx_axis_tready(mac_rx_axis_tready), 
    .rx_axis_tlast (mac_rx_axis_tlast )
);

assign mac_tx_axis_tuser     = 0; 
assign fifoed_rx_axis_tuser  = 0; 
 
endmodule

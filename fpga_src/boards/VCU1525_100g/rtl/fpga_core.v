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
    parameter AXIS_PCIE_DATA_WIDTH = 512,
    parameter AXIS_PCIE_KEEP_WIDTH = (AXIS_PCIE_DATA_WIDTH/32),
    parameter AXIS_PCIE_RC_USER_WIDTH = 161,
    parameter AXIS_PCIE_RQ_USER_WIDTH = 137,
    parameter AXIS_PCIE_CQ_USER_WIDTH = 183,
    parameter AXIS_PCIE_CC_USER_WIDTH = 81,
    parameter RQ_SEQ_NUM_WIDTH        = 6,
    parameter BAR0_APERTURE           = 24,
    parameter AXIS_ETH_DATA_WIDTH     = 512,
    parameter AXIS_ETH_KEEP_WIDTH     = AXIS_ETH_DATA_WIDTH/8,
    parameter SEPARATE_CLOCKS         = 1
)
(
    /*
     * Clock: 200MHz, 250MHz, 178MHz
     * Synchronous reset
     */
    input  wire                               sys_clk,
    input  wire                               sys_rst,
    input  wire                               pcie_clk,
    input  wire                               pcie_rst,
    input  wire                               core_clk,
    input  wire                               core_rst,

    /*
     * GPIO
     */
    input  wire [3:0]                         sw,
    output wire [2:0]                         led,

    /*
     * I2C
     */
    input  wire                               i2c_scl_i,
    output wire                               i2c_scl_o,
    output wire                               i2c_scl_t,
    input  wire                               i2c_sda_i,
    output wire                               i2c_sda_o,
    output wire                               i2c_sda_t,

    /*
     * PCIe
     */
    output wire [AXIS_PCIE_DATA_WIDTH-1:0]    m_axis_rq_tdata,
    output wire [AXIS_PCIE_KEEP_WIDTH-1:0]    m_axis_rq_tkeep,
    output wire                               m_axis_rq_tlast,
    input  wire                               m_axis_rq_tready,
    output wire [AXIS_PCIE_RQ_USER_WIDTH-1:0] m_axis_rq_tuser,
    output wire                               m_axis_rq_tvalid,

    input  wire [AXIS_PCIE_DATA_WIDTH-1:0]    s_axis_rc_tdata,
    input  wire [AXIS_PCIE_KEEP_WIDTH-1:0]    s_axis_rc_tkeep,
    input  wire                               s_axis_rc_tlast,
    output wire                               s_axis_rc_tready,
    input  wire [AXIS_PCIE_RC_USER_WIDTH-1:0] s_axis_rc_tuser,
    input  wire                               s_axis_rc_tvalid,

    input  wire [AXIS_PCIE_DATA_WIDTH-1:0]    s_axis_cq_tdata,
    input  wire [AXIS_PCIE_KEEP_WIDTH-1:0]    s_axis_cq_tkeep,
    input  wire                               s_axis_cq_tlast,
    output wire                               s_axis_cq_tready,
    input  wire [AXIS_PCIE_CQ_USER_WIDTH-1:0] s_axis_cq_tuser,
    input  wire                               s_axis_cq_tvalid,

    output wire [AXIS_PCIE_DATA_WIDTH-1:0]    m_axis_cc_tdata,
    output wire [AXIS_PCIE_KEEP_WIDTH-1:0]    m_axis_cc_tkeep,
    output wire                               m_axis_cc_tlast,
    input  wire                               m_axis_cc_tready,
    output wire [AXIS_PCIE_CC_USER_WIDTH-1:0] m_axis_cc_tuser,
    output wire                               m_axis_cc_tvalid,

    input  wire [RQ_SEQ_NUM_WIDTH-1:0]        s_axis_rq_seq_num_0,
    input  wire                               s_axis_rq_seq_num_valid_0,
    input  wire [RQ_SEQ_NUM_WIDTH-1:0]        s_axis_rq_seq_num_1,
    input  wire                               s_axis_rq_seq_num_valid_1,

    input  wire [7:0]                         pcie_tx_fc_nph_av,
    input  wire [7:0]                         pcie_tx_fc_ph_av,
    input  wire [11:0]                        pcie_tx_fc_pd_av,

    input  wire [2:0]                         cfg_max_payload,
    input  wire [2:0]                         cfg_max_read_req,
    input  wire                               ext_tag_enable,

    output wire [31:0]                        msi_irq,
    output wire                               status_error_cor,
    output wire                               status_error_uncor,

    /*
     * Ethernet: QSFP28
     */
    input  wire                               qsfp0_tx_clk,
    input  wire                               qsfp0_tx_rst,

    output wire [AXIS_ETH_DATA_WIDTH-1:0]     qsfp0_tx_axis_tdata,
    output wire [AXIS_ETH_KEEP_WIDTH-1:0]     qsfp0_tx_axis_tkeep,
    output wire                               qsfp0_tx_axis_tvalid,
    input  wire                               qsfp0_tx_axis_tready,
    output wire                               qsfp0_tx_axis_tlast,
    output wire                               qsfp0_tx_axis_tuser,

    input  wire                               qsfp0_rx_clk,
    input  wire                               qsfp0_rx_rst,

    input  wire [AXIS_ETH_DATA_WIDTH-1:0]     qsfp0_rx_axis_tdata,
    input  wire [AXIS_ETH_KEEP_WIDTH-1:0]     qsfp0_rx_axis_tkeep,
    input  wire                               qsfp0_rx_axis_tvalid,
    input  wire                               qsfp0_rx_axis_tlast,
    input  wire                               qsfp0_rx_axis_tuser,

    output wire                               qsfp0_modsell,
    output wire                               qsfp0_resetl,
    input  wire                               qsfp0_modprsl,
    input  wire                               qsfp0_intl,
    output wire                               qsfp0_lpmode,

    input  wire                               qsfp1_tx_clk,
    input  wire                               qsfp1_tx_rst,

    output wire [AXIS_ETH_DATA_WIDTH-1:0]     qsfp1_tx_axis_tdata,
    output wire [AXIS_ETH_KEEP_WIDTH-1:0]     qsfp1_tx_axis_tkeep,
    output wire                               qsfp1_tx_axis_tvalid,
    input  wire                               qsfp1_tx_axis_tready,
    output wire                               qsfp1_tx_axis_tlast,
    output wire                               qsfp1_tx_axis_tuser,

    input  wire                               qsfp1_rx_clk,
    input  wire                               qsfp1_rx_rst,

    input  wire [AXIS_ETH_DATA_WIDTH-1:0]     qsfp1_rx_axis_tdata,
    input  wire [AXIS_ETH_KEEP_WIDTH-1:0]     qsfp1_rx_axis_tkeep,
    input  wire                               qsfp1_rx_axis_tvalid,
    input  wire                               qsfp1_rx_axis_tlast,
    input  wire                               qsfp1_rx_axis_tuser,

    output wire                               qsfp1_modsell,
    output wire                               qsfp1_resetl,
    input  wire                               qsfp1_modprsl,
    input  wire                               qsfp1_intl,
    output wire                               qsfp1_lpmode
);

`define PR_ENABLE

parameter CORE_COUNT        = 16;

parameter INTERFACE_COUNT   = 2;
parameter V_IF_COUNT        = 1;
parameter PORTS_PER_V_IF    = 1;
parameter LB_PORT_COUNT     = 1;

parameter V_PORT_COUNT      = V_IF_COUNT * PORTS_PER_V_IF;
parameter FIRST_LB_PORT     = INTERFACE_COUNT+V_PORT_COUNT+1-1;
parameter PORT_COUNT        = INTERFACE_COUNT+V_PORT_COUNT+LB_PORT_COUNT+1;

parameter IF_COUNT_WIDTH    = $clog2(INTERFACE_COUNT+V_PORT_COUNT);
parameter BYTE_COUNT_WIDTH  = 32;
parameter FRAME_COUNT_WIDTH = 32;
parameter MAX_PKT_HDR_SIZE  = 128;
parameter ENABLE_CORES_ILA  = 0;
parameter ENABLE_SCHED_ILA  = 0;

// MAC and switching system parameters
parameter LVL1_DATA_WIDTH  = AXIS_ETH_DATA_WIDTH;
parameter LVL1_STRB_WIDTH  = AXIS_ETH_KEEP_WIDTH;
parameter CTRL_WIDTH       = 32+4; //DON'T CHANGE
parameter LVL1_DRAM_WIDTH  = 64; //DRAM CONTROL
parameter LVL2_DRAM_WIDTH  = 64; //DON'T CHANGE
parameter RX_ASYNC_DEPTH   = 2048;
parameter RX_FIFO_DEPTH    = 8*32768;
parameter RX_ALMOST_FULL   = 7*32768;
parameter TX_FIFO_DEPTH    = 32768;
parameter RX_STG_F_DEPTH   = 8*32768;
parameter TX_STG_F_DEPTH   = 2*32768;
parameter STG_F_CTRL_DEPTH = 64; // TKEEP is not enabled, so 64 words
parameter STG_F_DRAM_DEPTH = 2048;
parameter V_MAC_FIFO_SIZE  = 1024;
parameter CLUSTER_COUNT    = 4;
parameter BC_MSG_CLUSTERS  = 4;
parameter SW_OUTPUT_PIPE   = 2;

// PCIe parameters
parameter PCIE_SLOT_COUNT     = 8;
parameter PCIE_ADDR_WIDTH     = 64;
parameter PCIE_RAM_ADDR_WIDTH = 32;
parameter TX_RX_RAM_SIZE      = 2**15;
parameter PCIE_DMA_LEN_WIDTH  = 16;
parameter HOST_DMA_TAG_WIDTH  = 32;
parameter RAM_PIPELINE        = 4;
parameter AXIL_DATA_WIDTH     = 32;
parameter AXIL_STRB_WIDTH     = (AXIL_DATA_WIDTH/8);
parameter AXIL_ADDR_WIDTH     = BAR0_APERTURE;

// RISCV parameters, should match riscv_block
parameter CORE_WIDTH      = $clog2(CORE_COUNT);
parameter PORT_WIDTH      = $clog2(PORT_COUNT);
parameter DRAM_PORT       = PORT_COUNT-1;
parameter SLOT_COUNT      = 16;
parameter SLOT_WIDTH      = $clog2(SLOT_COUNT+1);
parameter TAG_WIDTH       = (SLOT_WIDTH>5)? SLOT_WIDTH:5;

parameter IMEM_SIZE       = 65536;
parameter PMEM_SIZE       = 1048576;
parameter DMEM_SIZE       = 32768;
parameter BC_REGION_SIZE  = 8192;
parameter SLOW_M_B_LINES  = 4096;
parameter FAST_M_B_LINES  = 1024;

parameter LVL2_DATA_WIDTH = 128;
parameter LVL2_STRB_WIDTH = LVL2_DATA_WIDTH/8;
parameter ID_TAG_WIDTH    = CORE_WIDTH+TAG_WIDTH;
parameter BC_START_ADDR   = 32'h00800000+DMEM_SIZE-BC_REGION_SIZE;
parameter CORE_MSG_WIDTH  = 32+4+$clog2(BC_REGION_SIZE)-2;

parameter RECV_DESC_DEPTH = SLOT_COUNT;
parameter SEND_DESC_DEPTH = SLOT_COUNT;
parameter DRAM_DESC_DEPTH = 8;
parameter MSG_FIFO_DEPTH  = 16;
parameter SLOT_START_ADDR = 16'h0;
parameter SLOT_ADDR_STEP  = 22'h004000;
parameter HDR_START_ADDR  = 22'h104000;

// FW and board IDs
parameter FW_ID     = 32'd0;
parameter FW_VER    = {16'd0, 16'd1};
parameter BOARD_ID  = {16'h10ee, 16'h95f5};
parameter BOARD_VER = {16'd0, 16'd1};
parameter FPGA_ID   = 32'h4B31093;

// Separating reset per block and keeping it in sync with rest of the system
(* KEEP = "TRUE" *) reg [CORE_COUNT-1:0] block_reset;
(* KEEP = "TRUE" *) reg core_rst_r;
(* KEEP = "TRUE" *) reg sys_rst_r;

integer j;
always @ (posedge core_clk) begin
  core_rst_r      <= core_rst;
  sys_rst_r       <= sys_rst;
  for (j=0; j<CORE_COUNT; j=j+1)
    block_reset[j] <= core_rst;
end

wire stat_rst_r, int_rst_r;
sync_reset sync_sys_rst_inst (
  .clk(sys_clk),
  .rst(sys_rst_r),
  .out(stat_rst_r)
);
sync_reset sync_int_rst_inst (
  .clk(sys_clk),
  .rst(sys_rst_r),
  .out(int_rst_r)
);

// Unused outputs
assign led   = 3'd0;

// ETH interfaces renaming
localparam QSFP0_IND = 0;
localparam QSFP1_IND = 1;

wire [INTERFACE_COUNT-1:0] port_tx_clk;
wire [INTERFACE_COUNT-1:0] port_tx_rst;
wire [INTERFACE_COUNT*AXIS_ETH_DATA_WIDTH-1:0] port_tx_axis_tdata;
wire [INTERFACE_COUNT*AXIS_ETH_KEEP_WIDTH-1:0] port_tx_axis_tkeep;
wire [INTERFACE_COUNT-1:0] port_tx_axis_tvalid;
wire [INTERFACE_COUNT-1:0] port_tx_axis_tready;
wire [INTERFACE_COUNT-1:0] port_tx_axis_tlast;
wire [INTERFACE_COUNT-1:0] port_tx_axis_tuser = {INTERFACE_COUNT{1'b0}};

wire [INTERFACE_COUNT-1:0] port_rx_clk;
wire [INTERFACE_COUNT-1:0] port_rx_rst;
wire [INTERFACE_COUNT*AXIS_ETH_DATA_WIDTH-1:0] port_rx_axis_tdata;
wire [INTERFACE_COUNT*AXIS_ETH_KEEP_WIDTH-1:0] port_rx_axis_tkeep;
wire [INTERFACE_COUNT-1:0] port_rx_axis_tvalid;
wire [INTERFACE_COUNT-1:0] port_rx_axis_tlast;
wire [INTERFACE_COUNT-1:0] port_rx_axis_tuser;

wire [INTERFACE_COUNT*AXIS_ETH_DATA_WIDTH-1:0] port_rx_axis_tdata_f;
wire [INTERFACE_COUNT*AXIS_ETH_KEEP_WIDTH-1:0] port_rx_axis_tkeep_f;
wire [INTERFACE_COUNT-1:0] port_rx_axis_tvalid_f;
wire [INTERFACE_COUNT-1:0] port_rx_axis_tready_f;
wire [INTERFACE_COUNT-1:0] port_rx_axis_tlast_f;

wire [INTERFACE_COUNT*AXIS_ETH_DATA_WIDTH-1:0] port_tx_axis_tdata_n;
wire [INTERFACE_COUNT*AXIS_ETH_KEEP_WIDTH-1:0] port_tx_axis_tkeep_n;
wire [INTERFACE_COUNT-1:0] port_tx_axis_tvalid_n;
wire [INTERFACE_COUNT-1:0] port_tx_axis_tready_n;
wire [INTERFACE_COUNT-1:0] port_tx_axis_tlast_n;

wire [INTERFACE_COUNT*AXIS_ETH_DATA_WIDTH-1:0] port_rx_axis_tdata_r;
wire [INTERFACE_COUNT*AXIS_ETH_KEEP_WIDTH-1:0] port_rx_axis_tkeep_r;
wire [INTERFACE_COUNT-1:0] port_rx_axis_tvalid_r;
wire [INTERFACE_COUNT-1:0] port_rx_axis_tready_r;
wire [INTERFACE_COUNT-1:0] port_rx_axis_tlast_r;
wire [INTERFACE_COUNT-1:0] port_rx_axis_overflow_r;
wire [INTERFACE_COUNT-1:0] port_rx_axis_almost_full_r;
wire [INTERFACE_COUNT-1:0] port_rx_axis_bad_frame_r;

if (QSFP0_IND >= 0 && QSFP0_IND < INTERFACE_COUNT) begin
    assign port_tx_clk[QSFP0_IND] = qsfp0_tx_clk;
    assign port_tx_rst[QSFP0_IND] = qsfp0_tx_rst;
    assign qsfp0_tx_axis_tdata = port_tx_axis_tdata[QSFP0_IND*AXIS_ETH_DATA_WIDTH +: AXIS_ETH_DATA_WIDTH];
    assign qsfp0_tx_axis_tkeep = port_tx_axis_tkeep[QSFP0_IND*AXIS_ETH_KEEP_WIDTH +: AXIS_ETH_KEEP_WIDTH];
    assign qsfp0_tx_axis_tvalid = port_tx_axis_tvalid[QSFP0_IND];
    assign port_tx_axis_tready[QSFP0_IND] = qsfp0_tx_axis_tready;
    assign qsfp0_tx_axis_tlast = port_tx_axis_tlast[QSFP0_IND];
    assign qsfp0_tx_axis_tuser = port_tx_axis_tuser[QSFP0_IND];

    assign port_rx_clk[QSFP0_IND] = qsfp0_rx_clk;
    assign port_rx_rst[QSFP0_IND] = qsfp0_rx_rst;
    assign port_rx_axis_tdata[QSFP0_IND*AXIS_ETH_DATA_WIDTH +: AXIS_ETH_DATA_WIDTH] = qsfp0_rx_axis_tdata;
    assign port_rx_axis_tkeep[QSFP0_IND*AXIS_ETH_KEEP_WIDTH +: AXIS_ETH_KEEP_WIDTH] = qsfp0_rx_axis_tkeep;
    assign port_rx_axis_tvalid[QSFP0_IND] = qsfp0_rx_axis_tvalid;
    assign port_rx_axis_tlast[QSFP0_IND] = qsfp0_rx_axis_tlast;
    assign port_rx_axis_tuser[QSFP0_IND] = qsfp0_rx_axis_tuser;
end else begin
    assign qsfp0_tx_axis_tdata = {AXIS_ETH_DATA_WIDTH{1'b0}};
    assign qsfp0_tx_axis_tkeep = {AXIS_ETH_KEEP_WIDTH{1'b0}};
    assign qsfp0_tx_axis_tvalid = 1'b0;
    assign qsfp0_tx_axis_tlast = 1'b0;
    assign qsfp0_tx_axis_tuser = 1'b0;
end

if (QSFP1_IND >= 0 && QSFP1_IND < INTERFACE_COUNT) begin
    assign port_tx_clk[QSFP1_IND] = qsfp1_tx_clk;
    assign port_tx_rst[QSFP1_IND] = qsfp1_tx_rst;
    assign qsfp1_tx_axis_tdata = port_tx_axis_tdata[QSFP1_IND*AXIS_ETH_DATA_WIDTH +: AXIS_ETH_DATA_WIDTH];
    assign qsfp1_tx_axis_tkeep = port_tx_axis_tkeep[QSFP1_IND*AXIS_ETH_KEEP_WIDTH +: AXIS_ETH_KEEP_WIDTH];
    assign qsfp1_tx_axis_tvalid = port_tx_axis_tvalid[QSFP1_IND];
    assign port_tx_axis_tready[QSFP1_IND] = qsfp1_tx_axis_tready;
    assign qsfp1_tx_axis_tlast = port_tx_axis_tlast[QSFP1_IND];
    assign qsfp1_tx_axis_tuser = port_tx_axis_tuser[QSFP1_IND];

    assign port_rx_clk[QSFP1_IND] = qsfp1_rx_clk;
    assign port_rx_rst[QSFP1_IND] = qsfp1_rx_rst;
    assign port_rx_axis_tdata[QSFP1_IND*AXIS_ETH_DATA_WIDTH +: AXIS_ETH_DATA_WIDTH] = qsfp1_rx_axis_tdata;
    assign port_rx_axis_tkeep[QSFP1_IND*AXIS_ETH_KEEP_WIDTH +: AXIS_ETH_KEEP_WIDTH] = qsfp1_rx_axis_tkeep;
    assign port_rx_axis_tvalid[QSFP1_IND] = qsfp1_rx_axis_tvalid;
    assign port_rx_axis_tlast[QSFP1_IND] = qsfp1_rx_axis_tlast;
    assign port_rx_axis_tuser[QSFP1_IND] = qsfp1_rx_axis_tuser;
end else begin
    assign qsfp1_tx_axis_tdata = {AXIS_ETH_DATA_WIDTH{1'b0}};
    assign qsfp1_tx_axis_tkeep = {AXIS_ETH_KEEP_WIDTH{1'b0}};
    assign qsfp1_tx_axis_tvalid = 1'b0;
    assign qsfp1_tx_axis_tlast = 1'b0;
    assign qsfp1_tx_axis_tuser = 1'b0;
end

// Clock crossing for MAC
wire [(INTERFACE_COUNT+V_PORT_COUNT)*LVL1_DATA_WIDTH-1:0] tx_axis_tdata;
wire [(INTERFACE_COUNT+V_PORT_COUNT)*LVL1_STRB_WIDTH-1:0] tx_axis_tkeep;
wire [(INTERFACE_COUNT+V_PORT_COUNT)-1:0] tx_axis_tvalid, tx_axis_tready, tx_axis_tlast;

wire [(INTERFACE_COUNT+V_PORT_COUNT)*LVL1_DATA_WIDTH-1:0] rx_axis_tdata;
wire [(INTERFACE_COUNT+V_PORT_COUNT)*LVL1_STRB_WIDTH-1:0] rx_axis_tkeep;
wire [(INTERFACE_COUNT+V_PORT_COUNT)-1:0] rx_axis_tvalid, rx_axis_tready, rx_axis_tlast;

(* KEEP = "TRUE" *) reg [INTERFACE_COUNT-1:0] rx_drop, rx_drop_r;
(* KEEP = "TRUE" *) reg [INTERFACE_COUNT-1:0] rx_almost_full,
                            rx_almost_full_r, rx_almost_full_rr;

genvar m;
generate
    for (m=0;m<INTERFACE_COUNT;m=m+1) begin: MAC_async_FIFO
        axis_pipeline_register # (
            .DATA_WIDTH(LVL1_DATA_WIDTH),
            .KEEP_ENABLE(LVL1_STRB_WIDTH > 1),
            .KEEP_WIDTH(LVL1_STRB_WIDTH),
            .LAST_ENABLE(1),
            .ID_ENABLE(0),
            .DEST_ENABLE(0),
            .USER_ENABLE(0),
            .REG_TYPE(2),
            .LENGTH(2)
        ) mac_tx_pipeline (
            .clk(sys_clk),
            .rst(int_rst_r),

            .s_axis_tdata(tx_axis_tdata[m*LVL1_DATA_WIDTH +: LVL1_DATA_WIDTH]),
            .s_axis_tkeep(tx_axis_tkeep[m*LVL1_STRB_WIDTH +: LVL1_STRB_WIDTH]),
            .s_axis_tvalid(tx_axis_tvalid[m +: 1]),
            .s_axis_tready(tx_axis_tready[m +: 1]),
            .s_axis_tlast(tx_axis_tlast[m +: 1]),
            .s_axis_tid(8'd0),
            .s_axis_tdest(8'd0),
            .s_axis_tuser(1'b0),

            .m_axis_tdata(port_tx_axis_tdata_n[m*LVL1_DATA_WIDTH +: LVL1_DATA_WIDTH]),
            .m_axis_tkeep(port_tx_axis_tkeep_n[m*LVL1_STRB_WIDTH +: LVL1_STRB_WIDTH]),
            .m_axis_tvalid(port_tx_axis_tvalid_n[m +: 1]),
            .m_axis_tready(port_tx_axis_tready_n[m +: 1]),
            .m_axis_tlast(port_tx_axis_tlast_n[m +: 1]),
            .m_axis_tid(),
            .m_axis_tdest(),
            .m_axis_tuser()
        );

        axis_async_fifo #(
            .DEPTH(TX_FIFO_DEPTH),
            .DATA_WIDTH(AXIS_ETH_DATA_WIDTH),
            .KEEP_ENABLE(AXIS_ETH_KEEP_WIDTH > 1),
            .KEEP_WIDTH(AXIS_ETH_KEEP_WIDTH),
            .LAST_ENABLE(1),
            .ID_ENABLE(0),
            .DEST_ENABLE(0),
            .USER_ENABLE(0),
            .PIPELINE_OUTPUT(2),
            .FRAME_FIFO(1),
            .USER_BAD_FRAME_VALUE(1'b1),
            .USER_BAD_FRAME_MASK(1'b1),
            .DROP_BAD_FRAME(1),
            .DROP_WHEN_FULL(0)
        ) mac_tx_async_fifo_inst (
            // Common reset
            .async_rst(int_rst_r | port_tx_rst[m]),
            // AXI input
            .s_clk(sys_clk),
            .s_axis_tdata(port_tx_axis_tdata_n[m*LVL1_DATA_WIDTH +: LVL1_DATA_WIDTH]),
            .s_axis_tkeep(port_tx_axis_tkeep_n[m*LVL1_STRB_WIDTH +: LVL1_STRB_WIDTH]),
            .s_axis_tvalid(port_tx_axis_tvalid_n[m]),
            .s_axis_tready(port_tx_axis_tready_n[m]),
            .s_axis_tlast(port_tx_axis_tlast_n[m]),
            .s_axis_tid(8'd0),
            .s_axis_tdest(8'd0),
            .s_axis_tuser(1'b0),
            // AXI output
            .m_clk(port_tx_clk[m]),
            .m_axis_tdata(port_tx_axis_tdata[m*AXIS_ETH_DATA_WIDTH +: AXIS_ETH_DATA_WIDTH]),
            .m_axis_tkeep(port_tx_axis_tkeep[m*AXIS_ETH_KEEP_WIDTH +: AXIS_ETH_KEEP_WIDTH]),
            .m_axis_tvalid(port_tx_axis_tvalid[m]),
            .m_axis_tready(port_tx_axis_tready[m]),
            .m_axis_tlast(port_tx_axis_tlast[m]),
            .m_axis_tid(),
            .m_axis_tdest(),
            .m_axis_tuser(),
            // Status
            .s_status_overflow(),
            .s_status_bad_frame(),
            .s_status_good_frame(),
            .m_status_overflow(),
            .m_status_bad_frame(),
            .m_status_good_frame()
        );

        axis_async_fifo #(
            .DEPTH(RX_ASYNC_DEPTH),
            .DATA_WIDTH(AXIS_ETH_DATA_WIDTH),
            .KEEP_ENABLE(AXIS_ETH_KEEP_WIDTH > 1),
            .KEEP_WIDTH(AXIS_ETH_KEEP_WIDTH),
            .LAST_ENABLE(1),
            .ID_ENABLE(0),
            .DEST_ENABLE(0),
            .USER_ENABLE(0),
            .PIPELINE_OUTPUT(2),
            .FRAME_FIFO(0)
        ) mac_rx_async_fifo_inst (
            // Common reset
            .async_rst(port_rx_rst[m] | int_rst_r),
            // AXI input
            .s_clk(port_rx_clk[m]),
            .s_axis_tdata(port_rx_axis_tdata[m*AXIS_ETH_DATA_WIDTH +: AXIS_ETH_DATA_WIDTH]),
            .s_axis_tkeep(port_rx_axis_tkeep[m*AXIS_ETH_KEEP_WIDTH +: AXIS_ETH_KEEP_WIDTH]),
            .s_axis_tvalid(port_rx_axis_tvalid[m]),
            .s_axis_tready(),
            .s_axis_tlast(port_rx_axis_tlast[m]),
            .s_axis_tid(8'd0),
            .s_axis_tdest(8'd0),
            .s_axis_tuser(1'b0),
            // AXI output
            .m_clk(sys_clk),
            .m_axis_tdata(port_rx_axis_tdata_f[m*AXIS_ETH_DATA_WIDTH +: AXIS_ETH_DATA_WIDTH]),
            .m_axis_tkeep(port_rx_axis_tkeep_f[m*AXIS_ETH_KEEP_WIDTH +: AXIS_ETH_KEEP_WIDTH]),
            .m_axis_tvalid(port_rx_axis_tvalid_f[m]),
            .m_axis_tready(port_rx_axis_tready_f[m]),
            .m_axis_tlast(port_rx_axis_tlast_f[m]),
            .m_axis_tid(),
            .m_axis_tdest(),
            .m_axis_tuser(),
            // Status
            .s_status_overflow(),
            .s_status_bad_frame(),
            .s_status_good_frame(),
            .m_status_overflow(),
            .m_status_bad_frame(),
            .m_status_good_frame()
        );

        axis_fifo #(
            .DEPTH(RX_FIFO_DEPTH),
            .DATA_WIDTH(AXIS_ETH_DATA_WIDTH),
            .KEEP_ENABLE(AXIS_ETH_KEEP_WIDTH > 1),
            .KEEP_WIDTH(AXIS_ETH_KEEP_WIDTH),
            .LAST_ENABLE(1),
            .ID_ENABLE(0),
            .DEST_ENABLE(0),
            .USER_ENABLE(0),
            .PIPELINE_OUTPUT(2),
            .FRAME_FIFO(1),
            .USER_BAD_FRAME_VALUE(1'b1),
            .USER_BAD_FRAME_MASK(1'b1),
            .DROP_BAD_FRAME(1),
            .DROP_WHEN_FULL(1),
            .ALMOST_FULL_LVL(RX_ALMOST_FULL)
        ) mac_rx_fifo_inst (
            .clk(sys_clk),
            .rst(int_rst_r),

            .s_axis_tdata(port_rx_axis_tdata_f[m*AXIS_ETH_DATA_WIDTH +: AXIS_ETH_DATA_WIDTH]),
            .s_axis_tkeep(port_rx_axis_tkeep_f[m*AXIS_ETH_KEEP_WIDTH +: AXIS_ETH_KEEP_WIDTH]),
            .s_axis_tvalid(port_rx_axis_tvalid_f[m]),
            .s_axis_tready(port_rx_axis_tready_f[m]),
            .s_axis_tlast(port_rx_axis_tlast_f[m]),
            .s_axis_tid(8'd0),
            .s_axis_tdest(8'd0),
            .s_axis_tuser(1'b0),

            .m_axis_tdata(port_rx_axis_tdata_r[m*LVL1_DATA_WIDTH +: LVL1_DATA_WIDTH]),
            .m_axis_tkeep(port_rx_axis_tkeep_r[m*LVL1_STRB_WIDTH +: LVL1_STRB_WIDTH]),
            .m_axis_tvalid(port_rx_axis_tvalid_r[m]),
            .m_axis_tready(port_rx_axis_tready_r[m]),
            .m_axis_tlast(port_rx_axis_tlast_r[m]),
            .m_axis_tid(),
            .m_axis_tdest(),
            .m_axis_tuser(),

            .status_overflow(port_rx_axis_overflow_r[m]),
            .status_bad_frame(port_rx_axis_bad_frame_r[m]),
            .status_good_frame(),
            .status_almost_full(port_rx_axis_almost_full_r[m]),
            .status_almost_empty()
        );

        axis_pipeline_register # (
            .DATA_WIDTH(LVL1_DATA_WIDTH),
            .KEEP_ENABLE(LVL1_STRB_WIDTH > 1),
            .KEEP_WIDTH(LVL1_STRB_WIDTH),
            .LAST_ENABLE(1),
            .ID_ENABLE(0),
            .DEST_ENABLE(0),
            .USER_ENABLE(0),
            .REG_TYPE(2),
            .LENGTH(2)
        ) mac_rx_pipeline (
            .clk(sys_clk),
            .rst(int_rst_r),

            .s_axis_tdata(port_rx_axis_tdata_r[m*LVL1_DATA_WIDTH +: LVL1_DATA_WIDTH]),
            .s_axis_tkeep(port_rx_axis_tkeep_r[m*LVL1_STRB_WIDTH +: LVL1_STRB_WIDTH]),
            .s_axis_tvalid(port_rx_axis_tvalid_r[m]),
            .s_axis_tready(port_rx_axis_tready_r[m]),
            .s_axis_tlast(port_rx_axis_tlast_r[m]),
            .s_axis_tid(8'd0),
            .s_axis_tdest(8'd0),
            .s_axis_tuser(1'b0),

            .m_axis_tdata(rx_axis_tdata[m*LVL1_DATA_WIDTH +: LVL1_DATA_WIDTH]),
            .m_axis_tkeep(rx_axis_tkeep[m*LVL1_STRB_WIDTH +: LVL1_STRB_WIDTH]),
            .m_axis_tvalid(rx_axis_tvalid[m]),
            .m_axis_tready(rx_axis_tready[m]),
            .m_axis_tlast(rx_axis_tlast[m]),
            .m_axis_tid(),
            .m_axis_tdest(),
            .m_axis_tuser()
        );

    end

    always @ (posedge sys_clk)
        if (int_rst_r) begin
            rx_drop           <= {INTERFACE_COUNT{1'b0}};
            rx_drop_r         <= {INTERFACE_COUNT{1'b0}};
            rx_almost_full    <= {INTERFACE_COUNT{1'b0}};
            rx_almost_full_r  <= {INTERFACE_COUNT{1'b0}};
            rx_almost_full_rr <= {INTERFACE_COUNT{1'b0}};
        end else begin
            rx_drop           <= port_rx_axis_overflow_r | port_rx_axis_bad_frame_r;
            rx_drop_r         <= rx_drop;
            rx_almost_full    <= port_rx_axis_almost_full_r;
            rx_almost_full_r  <= rx_almost_full;
            rx_almost_full_rr <= rx_almost_full_r;
        end
endgenerate

// PCIE and DRAM controller

// DRAM DMA controller data
wire [LVL1_DATA_WIDTH-1:0] dram_tx_axis_tdata;
wire [LVL1_STRB_WIDTH-1:0] dram_tx_axis_tkeep;
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

// pcie_config connections
wire [31:0]                host_cmd;
wire [31:0]                host_cmd_wr_data;
reg  [31:0]                host_cmd_rd_data;
wire                       host_cmd_valid;

wire                       pcie_dma_enable;
wire [31:0]                vif_irq;


// AXI lite connections
wire [AXIL_ADDR_WIDTH-1:0]         axil_ctrl_awaddr;
wire [2:0]                         axil_ctrl_awprot;
wire                               axil_ctrl_awvalid;
wire                               axil_ctrl_awready;
wire [AXIL_DATA_WIDTH-1:0]         axil_ctrl_wdata;
wire [AXIL_STRB_WIDTH-1:0]         axil_ctrl_wstrb;
wire                               axil_ctrl_wvalid;
wire                               axil_ctrl_wready;
wire [1:0]                         axil_ctrl_bresp;
wire                               axil_ctrl_bvalid;
wire                               axil_ctrl_bready;
wire [AXIL_ADDR_WIDTH-1:0]         axil_ctrl_araddr;
wire [2:0]                         axil_ctrl_arprot;
wire                               axil_ctrl_arvalid;
wire                               axil_ctrl_arready;
wire [AXIL_DATA_WIDTH-1:0]         axil_ctrl_rdata;
wire [1:0]                         axil_ctrl_rresp;
wire                               axil_ctrl_rvalid;
wire                               axil_ctrl_rready;

// DMA requests from Host
wire [PCIE_ADDR_WIDTH-1:0]     host_dma_read_desc_pcie_addr;
wire [PCIE_RAM_ADDR_WIDTH-1:0] host_dma_read_desc_ram_addr;
wire [PCIE_DMA_LEN_WIDTH-1:0]  host_dma_read_desc_len;
wire [HOST_DMA_TAG_WIDTH-1:0]  host_dma_read_desc_tag;
wire                           host_dma_read_desc_valid;
wire                           host_dma_read_desc_ready;
wire [HOST_DMA_TAG_WIDTH-1:0]  host_dma_read_desc_status_tag;
wire                           host_dma_read_desc_status_valid;

wire [PCIE_ADDR_WIDTH-1:0]     host_dma_write_desc_pcie_addr;
wire [PCIE_RAM_ADDR_WIDTH-1:0] host_dma_write_desc_ram_addr;
wire [PCIE_DMA_LEN_WIDTH-1:0]  host_dma_write_desc_len;
wire [HOST_DMA_TAG_WIDTH-1:0]  host_dma_write_desc_tag;
wire                           host_dma_write_desc_valid;
wire                           host_dma_write_desc_ready;
wire [HOST_DMA_TAG_WIDTH-1:0]  host_dma_write_desc_status_tag;
wire                           host_dma_write_desc_status_valid;

// Virtual MAC ports
parameter V_PORT_COUNT_MIN1 = (V_PORT_COUNT>0) ? V_PORT_COUNT:1;

wire [V_PORT_COUNT_MIN1*LVL1_DATA_WIDTH-1:0] v_tx_axis_tdata;
wire [V_PORT_COUNT_MIN1*LVL1_STRB_WIDTH-1:0] v_tx_axis_tkeep;
wire [V_PORT_COUNT_MIN1-1:0] v_tx_axis_tvalid, v_tx_axis_tready,
                             v_tx_axis_tlast,  v_tx_axis_tuser;

wire [V_PORT_COUNT_MIN1*LVL1_DATA_WIDTH-1:0] v_rx_axis_tdata;
wire [V_PORT_COUNT_MIN1*LVL1_STRB_WIDTH-1:0] v_rx_axis_tkeep;
wire [V_PORT_COUNT_MIN1-1:0] v_rx_axis_tvalid, v_rx_axis_tready,
                             v_rx_axis_tlast;

pcie_config # (
  .PCIE_ADDR_WIDTH(PCIE_ADDR_WIDTH),
  .PCIE_RAM_ADDR_WIDTH(PCIE_RAM_ADDR_WIDTH),
  .PCIE_DMA_LEN_WIDTH(PCIE_DMA_LEN_WIDTH),
  .HOST_DMA_TAG_WIDTH(HOST_DMA_TAG_WIDTH),
  .AXIL_DATA_WIDTH(AXIL_DATA_WIDTH),
  .AXIL_STRB_WIDTH(AXIL_STRB_WIDTH),
  .AXIL_ADDR_WIDTH(AXIL_ADDR_WIDTH),
  .CORE_COUNT(CORE_COUNT),
  .CORE_SLOT_WIDTH(SLOT_WIDTH),
  .ID_TAG_WIDTH(ID_TAG_WIDTH),
  .INTERFACE_WIDTH(IF_COUNT_WIDTH),
  .IF_COUNT(V_IF_COUNT),
  .PORTS_PER_IF(PORTS_PER_V_IF),
  .FW_ID(FW_ID),
  .FW_VER(FW_VER),
  .BOARD_ID(BOARD_ID),
  .BOARD_VER(BOARD_VER),
  .FPGA_ID(FPGA_ID),
  .SEPARATE_CLOCKS(SEPARATE_CLOCKS)
) pcie_config_inst (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst_r),
  .pcie_clk(pcie_clk),
  .pcie_rst(pcie_rst),

  // AXI lite
  .axil_ctrl_awaddr(axil_ctrl_awaddr),
  .axil_ctrl_awprot(axil_ctrl_awprot),
  .axil_ctrl_awvalid(axil_ctrl_awvalid),
  .axil_ctrl_awready(axil_ctrl_awready),
  .axil_ctrl_wdata(axil_ctrl_wdata),
  .axil_ctrl_wstrb(axil_ctrl_wstrb),
  .axil_ctrl_wvalid(axil_ctrl_wvalid),
  .axil_ctrl_wready(axil_ctrl_wready),
  .axil_ctrl_bresp(axil_ctrl_bresp),
  .axil_ctrl_bvalid(axil_ctrl_bvalid),
  .axil_ctrl_bready(axil_ctrl_bready),
  .axil_ctrl_araddr(axil_ctrl_araddr),
  .axil_ctrl_arprot(axil_ctrl_arprot),
  .axil_ctrl_arvalid(axil_ctrl_arvalid),
  .axil_ctrl_arready(axil_ctrl_arready),
  .axil_ctrl_rdata(axil_ctrl_rdata),
  .axil_ctrl_rresp(axil_ctrl_rresp),
  .axil_ctrl_rvalid(axil_ctrl_rvalid),
  .axil_ctrl_rready(axil_ctrl_rready),

  // DMA requests from Host through AXIL
  .host_dma_read_desc_pcie_addr   (host_dma_read_desc_pcie_addr),
  .host_dma_read_desc_ram_addr    (host_dma_read_desc_ram_addr),
  .host_dma_read_desc_len         (host_dma_read_desc_len),
  .host_dma_read_desc_tag         (host_dma_read_desc_tag),
  .host_dma_read_desc_valid       (host_dma_read_desc_valid),
  .host_dma_read_desc_ready       (host_dma_read_desc_ready),
  .host_dma_read_desc_status_tag  (host_dma_read_desc_status_tag),
  .host_dma_read_desc_status_valid(host_dma_read_desc_status_valid),

  .host_dma_write_desc_pcie_addr   (host_dma_write_desc_pcie_addr),
  .host_dma_write_desc_ram_addr    (host_dma_write_desc_ram_addr),
  .host_dma_write_desc_len         (host_dma_write_desc_len),
  .host_dma_write_desc_tag         (host_dma_write_desc_tag),
  .host_dma_write_desc_valid       (host_dma_write_desc_valid),
  .host_dma_write_desc_ready       (host_dma_write_desc_ready),
  .host_dma_write_desc_status_tag  (host_dma_write_desc_status_tag),
  .host_dma_write_desc_status_valid(host_dma_write_desc_status_valid),

  // I2C and config
  .i2c_scl_i(i2c_scl_i),
  .i2c_scl_o(i2c_scl_o),
  .i2c_scl_t(i2c_scl_t),
  .i2c_sda_i(i2c_sda_i),
  .i2c_sda_o(i2c_sda_o),
  .i2c_sda_t(i2c_sda_t),

  .qsfp0_modsell(qsfp0_modsell),
  .qsfp0_resetl(qsfp0_resetl),
  .qsfp0_modprsl(qsfp0_modprsl),
  .qsfp0_intl(qsfp0_intl),
  .qsfp0_lpmode(qsfp0_lpmode),

  .qsfp1_modsell(qsfp1_modsell),
  .qsfp1_resetl(qsfp1_resetl),
  .qsfp1_modprsl(qsfp1_modprsl),
  .qsfp1_intl(qsfp1_intl),
  .qsfp1_lpmode(qsfp1_lpmode),

  // Host commands to cores
  .host_cmd        (host_cmd),
  .host_cmd_wr_data(host_cmd_wr_data),
  .host_cmd_rd_data(host_cmd_rd_data),
  .host_cmd_valid  (host_cmd_valid),

  .pcie_dma_enable    (pcie_dma_enable),
  .corundum_loopback  (),
  .if_msi_irq         (vif_irq),
  .msi_irq            (msi_irq)
);

// Host command read from stat readers and mux with scheduler read
reg  [31:0]             core_stat_data_muxed;
wire [31:0]             core_stat_data_muxed_r;
wire [CORE_WIDTH+4-1:0] core_select;

if (SEPARATE_CLOCKS) begin
  simple_sync_sig # (.RST_VAL(1'b0),.WIDTH(CORE_WIDTH+4)) host_cmd_sync_reg (
    .dst_clk(core_clk),
    .dst_rst(core_rst_r),
    .in(host_cmd[CORE_WIDTH+4-1:0]),
    .out(core_select)
  );

  simple_sync_sig # (.RST_VAL(1'b0),.WIDTH(32)) core_stat_data_sync_reg (
    .dst_clk(sys_clk),
    .dst_rst(stat_rst_r),
    .in(core_stat_data_muxed),
    .out(core_stat_data_muxed_r)
  );
end else begin //syncers as pipe registers
  simple_sync_sig # (.RST_VAL(1'b0),.WIDTH(CORE_WIDTH+4)) host_cmd_sync_reg (
    .dst_clk(pcie_clk),
    .dst_rst(pcie_rst),
    .in(host_cmd[CORE_WIDTH+4-1:0]),
    .out(core_select)
  );

  simple_sync_sig # (.RST_VAL(1'b0),.WIDTH(32)) core_stat_data_sync_reg (
    .dst_clk(pcie_clk),
    .dst_rst(pcie_rst),
    .in(core_stat_data_muxed),
    .out(core_stat_data_muxed_r)
  );
  // (* KEEP = "TRUE" *) reg [31:0]             core_stat_data_muxed_r;
  // (* KEEP = "TRUE" *) reg [CORE_WIDTH+4-1:0] core_select;
  // always @ (posedge sys_clk) begin
  //   core_select            <= host_cmd[CORE_WIDTH+4-1:0];
  //   core_stat_data_muxed_r <= core_stat_data_muxed;
  // end
end

wire [31:0] interface_in_stat_data;
wire [31:0] interface_out_stat_data;
wire [31:0] host_rd_sched_data;

wire [1:0]                 interface_reg_sel;
wire                       interface_dir;
wire [IF_COUNT_WIDTH-1:0]  interface_sel;
wire [2:0]                 host_cmd_type;

assign interface_reg_sel = host_cmd[1:0];
assign interface_sel     = host_cmd[3 +: IF_COUNT_WIDTH];
assign interface_dir     = host_cmd[2];
assign host_cmd_type     = host_cmd[31:29];

always @ (posedge sys_clk)
  casex (host_cmd_type)
    3'b000: host_cmd_rd_data <= core_stat_data_muxed_r;
    3'b001: host_cmd_rd_data <= interface_dir ? interface_out_stat_data :
                                                interface_in_stat_data  ;
    3'b01?: host_cmd_rd_data <= host_rd_sched_data;
    3'b1??: host_cmd_rd_data <= 32'hffffffff; // wr command
  endcase

if (V_PORT_COUNT==0) begin: no_veth

  assign v_rx_axis_tready = 1'b0;
  assign v_tx_axis_tdata  = {LVL1_DATA_WIDTH{1'b0}};
  assign v_tx_axis_tkeep  = {LVL1_STRB_WIDTH{1'b0}};
  assign v_tx_axis_tvalid = 1'b0;
  assign v_tx_axis_tlast  = 1'b0;
  assign v_tx_axis_tuser  = 1'b0;

end else begin: virtual_eth_connections

  assign rx_axis_tdata[INTERFACE_COUNT*LVL1_DATA_WIDTH +: V_PORT_COUNT*LVL1_DATA_WIDTH] = v_rx_axis_tdata;
  assign rx_axis_tkeep[INTERFACE_COUNT*LVL1_STRB_WIDTH +: V_PORT_COUNT*LVL1_STRB_WIDTH] = v_rx_axis_tkeep;
  assign rx_axis_tvalid[INTERFACE_COUNT +: V_PORT_COUNT]                                = v_rx_axis_tvalid;
  assign rx_axis_tlast[INTERFACE_COUNT +: V_PORT_COUNT]                                 = v_rx_axis_tlast;
  assign v_rx_axis_tready = rx_axis_tready[INTERFACE_COUNT +: V_PORT_COUNT];

  assign v_tx_axis_tdata  = tx_axis_tdata[INTERFACE_COUNT*LVL1_DATA_WIDTH +: V_PORT_COUNT*LVL1_DATA_WIDTH];
  assign v_tx_axis_tkeep  = tx_axis_tkeep[INTERFACE_COUNT*LVL1_STRB_WIDTH +: V_PORT_COUNT*LVL1_STRB_WIDTH];
  assign v_tx_axis_tvalid = tx_axis_tvalid[INTERFACE_COUNT +: V_PORT_COUNT];
  assign v_tx_axis_tlast  = tx_axis_tlast[INTERFACE_COUNT +: V_PORT_COUNT];
  assign v_tx_axis_tuser  = {V_PORT_COUNT{1'b0}};
  assign tx_axis_tready[INTERFACE_COUNT +: V_PORT_COUNT] = v_tx_axis_tready;
end

(* keep_hierarchy = "soft" *)
pcie_controller #
(
  .AXIS_PCIE_DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
  .AXIS_PCIE_KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
  .AXIS_PCIE_RC_USER_WIDTH(AXIS_PCIE_RC_USER_WIDTH),
  .AXIS_PCIE_RQ_USER_WIDTH(AXIS_PCIE_RQ_USER_WIDTH),
  .AXIS_PCIE_CC_USER_WIDTH(AXIS_PCIE_CC_USER_WIDTH),
  .AXIS_PCIE_CQ_USER_WIDTH(AXIS_PCIE_CQ_USER_WIDTH),
  .RQ_SEQ_NUM_WIDTH(RQ_SEQ_NUM_WIDTH),
  .PCIE_ADDR_WIDTH(PCIE_ADDR_WIDTH),
  .PCIE_RAM_ADDR_WIDTH(PCIE_RAM_ADDR_WIDTH),
  .TX_RX_RAM_SIZE(TX_RX_RAM_SIZE),
  .MAC_ASYNC_FIFO_SIZE(V_MAC_FIFO_SIZE),
  .PCIE_DMA_LEN_WIDTH(PCIE_DMA_LEN_WIDTH),
  .HOST_DMA_TAG_WIDTH(HOST_DMA_TAG_WIDTH),
  .AXIL_DATA_WIDTH(AXIL_DATA_WIDTH),
  .AXIL_STRB_WIDTH(AXIL_STRB_WIDTH),
  .AXIL_ADDR_WIDTH(AXIL_ADDR_WIDTH),
  .AXIS_DATA_WIDTH(LVL1_DATA_WIDTH),
  .AXIS_KEEP_WIDTH(LVL1_STRB_WIDTH),
  .AXIS_TAG_WIDTH(ID_TAG_WIDTH),
  .CORE_SLOT_WIDTH(SLOT_WIDTH),
  .CORE_DESC_WIDTH(LVL1_DRAM_WIDTH),
  .CORE_COUNT(CORE_COUNT),
  .CORE_ADDR_WIDTH(26),
  .PCIE_SLOT_COUNT(PCIE_SLOT_COUNT),
  .IF_COUNT(V_IF_COUNT),
  .PORTS_PER_IF(PORTS_PER_V_IF),
  .RAM_PIPELINE(RAM_PIPELINE),
  .CORE_REQ_PCIE_CLK(1),
  .AXIS_PIPE_LENGTH(2)
) pcie_controller_inst (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst_r),
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

  .s_axis_rq_seq_num_0(s_axis_rq_seq_num_0),
  .s_axis_rq_seq_num_valid_0(s_axis_rq_seq_num_valid_0),
  .s_axis_rq_seq_num_1(s_axis_rq_seq_num_1),
  .s_axis_rq_seq_num_valid_1(s_axis_rq_seq_num_valid_1),

  .pcie_tx_fc_nph_av(pcie_tx_fc_nph_av),
  .pcie_tx_fc_ph_av(pcie_tx_fc_ph_av),
  .pcie_tx_fc_pd_av(pcie_tx_fc_pd_av),

  .cfg_max_payload   (cfg_max_payload),
  .cfg_max_read_req  (cfg_max_read_req),
  .ext_tag_enable    (ext_tag_enable),
  .pcie_dma_enable   (pcie_dma_enable),

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
  .cores_ctrl_m_axis_tdest (dram_ctrl_s_axis_tdest),

  // DMA requests from Host through AXIL
  .host_dma_read_desc_pcie_addr   (host_dma_read_desc_pcie_addr),
  .host_dma_read_desc_ram_addr    (host_dma_read_desc_ram_addr),
  .host_dma_read_desc_len         (host_dma_read_desc_len),
  .host_dma_read_desc_tag         (host_dma_read_desc_tag),
  .host_dma_read_desc_valid       (host_dma_read_desc_valid),
  .host_dma_read_desc_ready       (host_dma_read_desc_ready),
  .host_dma_read_desc_status_tag  (host_dma_read_desc_status_tag),
  .host_dma_read_desc_status_valid(host_dma_read_desc_status_valid),

  .host_dma_write_desc_pcie_addr   (host_dma_write_desc_pcie_addr),
  .host_dma_write_desc_ram_addr    (host_dma_write_desc_ram_addr),
  .host_dma_write_desc_len         (host_dma_write_desc_len),
  .host_dma_write_desc_tag         (host_dma_write_desc_tag),
  .host_dma_write_desc_valid       (host_dma_write_desc_valid),
  .host_dma_write_desc_ready       (host_dma_write_desc_ready),
  .host_dma_write_desc_status_tag  (host_dma_write_desc_status_tag),
  .host_dma_write_desc_status_valid(host_dma_write_desc_status_valid),

  // AXI lite
  .axil_ctrl_awaddr(axil_ctrl_awaddr),
  .axil_ctrl_awprot(axil_ctrl_awprot),
  .axil_ctrl_awvalid(axil_ctrl_awvalid),
  .axil_ctrl_awready(axil_ctrl_awready),
  .axil_ctrl_wdata(axil_ctrl_wdata),
  .axil_ctrl_wstrb(axil_ctrl_wstrb),
  .axil_ctrl_wvalid(axil_ctrl_wvalid),
  .axil_ctrl_wready(axil_ctrl_wready),
  .axil_ctrl_bresp(axil_ctrl_bresp),
  .axil_ctrl_bvalid(axil_ctrl_bvalid),
  .axil_ctrl_bready(axil_ctrl_bready),
  .axil_ctrl_araddr(axil_ctrl_araddr),
  .axil_ctrl_arprot(axil_ctrl_arprot),
  .axil_ctrl_arvalid(axil_ctrl_arvalid),
  .axil_ctrl_arready(axil_ctrl_arready),
  .axil_ctrl_rdata(axil_ctrl_rdata),
  .axil_ctrl_rresp(axil_ctrl_rresp),
  .axil_ctrl_rvalid(axil_ctrl_rvalid),
  .axil_ctrl_rready(axil_ctrl_rready),

  // Virtual ports
  .tx_axis_tdata(v_rx_axis_tdata),
  .tx_axis_tkeep(v_rx_axis_tkeep),
  .tx_axis_tvalid(v_rx_axis_tvalid),
  .tx_axis_tready(v_rx_axis_tready),
  .tx_axis_tlast(v_rx_axis_tlast),
  .tx_axis_tuser(),

  .rx_axis_tdata(v_tx_axis_tdata),
  .rx_axis_tkeep(v_tx_axis_tkeep),
  .rx_axis_tvalid(v_tx_axis_tvalid),
  .rx_axis_tready(v_tx_axis_tready),
  .rx_axis_tlast(v_tx_axis_tlast),
  .rx_axis_tuser(v_tx_axis_tuser),

  .msi_irq (vif_irq)

);

assign dram_rx_axis_tuser = DRAM_PORT;

// Loopback inter core message FIFO
wire [LB_PORT_COUNT*LVL1_DATA_WIDTH-1:0] loopback_tx_axis_tdata;
wire [LB_PORT_COUNT*LVL1_STRB_WIDTH-1:0] loopback_tx_axis_tkeep;
wire [LB_PORT_COUNT*ID_TAG_WIDTH-1:0]    loopback_tx_axis_tuser;
wire [LB_PORT_COUNT-1:0]                 loopback_tx_axis_tvalid,
                                         loopback_tx_axis_tready,
                                         loopback_tx_axis_tlast;

wire [LB_PORT_COUNT*LVL1_DATA_WIDTH-1:0] loopback_rx_axis_tdata;
wire [LB_PORT_COUNT*LVL1_STRB_WIDTH-1:0] loopback_rx_axis_tkeep;
wire [LB_PORT_COUNT*ID_TAG_WIDTH-1:0]    loopback_rx_axis_tdest;
wire [LB_PORT_COUNT*PORT_WIDTH-1:0]      loopback_rx_axis_tuser;
wire [LB_PORT_COUNT-1:0]                 loopback_rx_axis_tvalid,
                                         loopback_rx_axis_tready,
                                         loopback_rx_axis_tlast;

loopback_msg_fifo # (
  .DATA_WIDTH(LVL1_DATA_WIDTH),
  .STRB_WIDTH(LVL1_STRB_WIDTH),
  .PORT_WIDTH(PORT_WIDTH),
  .CORE_WIDTH(CORE_WIDTH),
  .SLOT_WIDTH(SLOT_WIDTH),
  .PORT_COUNT(LB_PORT_COUNT),
  .FIRST_PORT(FIRST_LB_PORT),
  .ID_TAG_WIDTH(ID_TAG_WIDTH)
) loopback_msg_fifo_inst (
    .clk(sys_clk),
    .rst(sys_rst_r),

    .s_axis_tdata (loopback_tx_axis_tdata),
    .s_axis_tkeep (loopback_tx_axis_tkeep),
    .s_axis_tvalid(loopback_tx_axis_tvalid),
    .s_axis_tready(loopback_tx_axis_tready),
    .s_axis_tlast (loopback_tx_axis_tlast),
    .s_axis_tuser (loopback_tx_axis_tuser),

    .m_axis_tdata (loopback_rx_axis_tdata),
    .m_axis_tkeep (loopback_rx_axis_tkeep),
    .m_axis_tvalid(loopback_rx_axis_tvalid),
    .m_axis_tready(loopback_rx_axis_tready),
    .m_axis_tlast (loopback_rx_axis_tlast),
    .m_axis_tdest (loopback_rx_axis_tdest),
    .m_axis_tuser (loopback_rx_axis_tuser)
);


// Scheduler
wire [(INTERFACE_COUNT+V_PORT_COUNT)*LVL1_DATA_WIDTH-1:0] sched_tx_axis_tdata;
wire [(INTERFACE_COUNT+V_PORT_COUNT)*LVL1_STRB_WIDTH-1:0] sched_tx_axis_tkeep;
wire [(INTERFACE_COUNT+V_PORT_COUNT)*ID_TAG_WIDTH-1:0]    sched_tx_axis_tuser;
wire [(INTERFACE_COUNT+V_PORT_COUNT)-1:0]                 sched_tx_axis_tvalid,
                                                          sched_tx_axis_tready,
                                                          sched_tx_axis_tlast;

wire [(INTERFACE_COUNT+V_PORT_COUNT)*LVL1_DATA_WIDTH-1:0] sched_rx_axis_tdata;
wire [(INTERFACE_COUNT+V_PORT_COUNT)*LVL1_STRB_WIDTH-1:0] sched_rx_axis_tkeep;
wire [(INTERFACE_COUNT+V_PORT_COUNT)*ID_TAG_WIDTH-1:0]    sched_rx_axis_tdest;
wire [(INTERFACE_COUNT+V_PORT_COUNT)*PORT_WIDTH-1:0]      sched_rx_axis_tuser;
wire [(INTERFACE_COUNT+V_PORT_COUNT)-1:0]                 sched_rx_axis_tvalid,
                                                          sched_rx_axis_tready,
                                                          sched_rx_axis_tlast;

wire [CTRL_WIDTH-1:0] sched_ctrl_m_axis_tdata;
wire                  sched_ctrl_m_axis_tvalid;
wire                  sched_ctrl_m_axis_tready;
wire [CORE_WIDTH-1:0] sched_ctrl_m_axis_tdest;

wire [CTRL_WIDTH-1:0] sched_ctrl_s_axis_tdata;
wire                  sched_ctrl_s_axis_tvalid;
wire                  sched_ctrl_s_axis_tready;
wire [CORE_WIDTH-1:0] sched_ctrl_s_axis_tuser;

wire sched_trig_in, sched_trig_out, sched_trig_in_ack, sched_trig_out_ack;

`ifndef PR_ENABLE
  scheduler # (
    .PORT_COUNT(PORT_COUNT),
    .INTERFACE_COUNT(INTERFACE_COUNT+V_PORT_COUNT),
    .CORE_COUNT(CORE_COUNT),
    .SLOT_COUNT(SLOT_COUNT),
    .DATA_WIDTH(LVL1_DATA_WIDTH),
    .CTRL_WIDTH(CTRL_WIDTH),
    .CLUSTER_COUNT(CLUSTER_COUNT),
    .LOOPBACK_PORT(FIRST_LB_PORT),
    .LOOPBACK_COUNT(LB_PORT_COUNT),
    .DATA_REG_TYPE(2),
    .CTRL_REG_TYPE(2),
    .ENABLE_ILA(ENABLE_SCHED_ILA)
  ) scheduler_inst (
`else
  scheduler_PR # (
  ) scheduler_PR_inst (
`endif
    .clk(sys_clk),
    .rst(sys_rst_r),

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

    .rx_axis_almost_full({{V_PORT_COUNT{1'b0}},rx_almost_full_rr}),

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
    .data_s_axis_tuser(sched_tx_axis_tuser),
    .data_s_axis_tvalid(sched_tx_axis_tvalid),
    .data_s_axis_tready(sched_tx_axis_tready),
    .data_s_axis_tlast(sched_tx_axis_tlast),

    // Control lines to/from cores
    .ctrl_m_axis_tdata(sched_ctrl_m_axis_tdata),
    .ctrl_m_axis_tvalid(sched_ctrl_m_axis_tvalid),
    .ctrl_m_axis_tready(sched_ctrl_m_axis_tready),
    .ctrl_m_axis_tdest(sched_ctrl_m_axis_tdest),

    .ctrl_s_axis_tdata(sched_ctrl_s_axis_tdata),
    .ctrl_s_axis_tvalid(sched_ctrl_s_axis_tvalid),
    .ctrl_s_axis_tready(sched_ctrl_s_axis_tready),
    .ctrl_s_axis_tuser(sched_ctrl_s_axis_tuser),

    // Host wr/rd commands
    .host_cmd         (host_cmd),
    .host_cmd_wr_data (host_cmd_wr_data),
    .host_cmd_rd_data (host_rd_sched_data),
    .host_cmd_valid   (host_cmd_valid),

    // Triggers for ILA if any
    .trig_in     (sched_trig_in),
    .trig_in_ack (sched_trig_in_ack),
    .trig_out    (sched_trig_out),
    .trig_out_ack(sched_trig_out_ack)
  );

// Switches
wire [CORE_COUNT*LVL2_DATA_WIDTH-1:0] data_s_axis_tdata;
wire [CORE_COUNT*LVL2_STRB_WIDTH-1:0] data_s_axis_tkeep;
wire [CORE_COUNT*TAG_WIDTH-1:0]       data_s_axis_tdest;
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

wire [CORE_COUNT*CTRL_WIDTH-1:0]      ctrl_s_axis_tdata;
wire [CORE_COUNT-1:0]                 ctrl_s_axis_tvalid,
                                      ctrl_s_axis_tready;

wire [CORE_COUNT*CTRL_WIDTH-1:0]      ctrl_m_axis_tdata;
wire [CORE_COUNT*CORE_WIDTH-1:0]      ctrl_m_axis_tuser;
wire [CORE_COUNT-1:0]                 ctrl_m_axis_tvalid,
                                      ctrl_m_axis_tready;

wire [CORE_COUNT*LVL2_DRAM_WIDTH-1:0] dram_s_axis_tdata;
wire [CORE_COUNT-1:0]                 dram_s_axis_tvalid,
                                      dram_s_axis_tready,
                                      dram_s_axis_tlast;

wire [CORE_COUNT*LVL2_DRAM_WIDTH-1:0] dram_m_axis_tdata;
wire [CORE_COUNT*CORE_WIDTH-1:0]      dram_m_axis_tuser;
wire [CORE_COUNT-1:0]                 dram_m_axis_tvalid,
                                      dram_m_axis_tready,
                                      dram_m_axis_tlast;

axis_switch_2lvl # (
    .S_COUNT         (PORT_COUNT),
    .M_COUNT         (CORE_COUNT),
    .S_DATA_WIDTH    (LVL1_DATA_WIDTH),
    .S_KEEP_WIDTH    (LVL1_STRB_WIDTH),
    .S_DEST_WIDTH    (ID_TAG_WIDTH),
    .M_DATA_WIDTH    (LVL2_DATA_WIDTH),
    .M_KEEP_WIDTH    (LVL2_STRB_WIDTH),
    .M_DEST_ENABLE   (1),
    .M_DEST_WIDTH    (TAG_WIDTH),
    .ID_ENABLE       (0),
    .USER_ENABLE     (1),
    .USER_WIDTH      (PORT_WIDTH),
    .S_REG_TYPE      (2),
    .M_REG_TYPE      (2),
    .CLUSTER_COUNT   (CLUSTER_COUNT),
    .STAGE_FIFO_DEPTH(RX_STG_F_DEPTH),
    .FRAME_FIFO      (0),
    .SEPARATE_CLOCKS (SEPARATE_CLOCKS),
    .USE_SIMPLE_SW   (0),
    .PIPELINE_OUTPUT (SW_OUTPUT_PIPE)
) data_in_sw (
    .s_clk(sys_clk),
    .s_rst(sys_rst_r),
    .s_axis_tdata( {dram_rx_axis_tdata, loopback_rx_axis_tdata, sched_rx_axis_tdata}),
    .s_axis_tkeep( {dram_rx_axis_tkeep, loopback_rx_axis_tkeep, sched_rx_axis_tkeep}),
    .s_axis_tvalid({dram_rx_axis_tvalid,loopback_rx_axis_tvalid,sched_rx_axis_tvalid}),
    .s_axis_tready({dram_rx_axis_tready,loopback_rx_axis_tready,sched_rx_axis_tready}),
    .s_axis_tlast( {dram_rx_axis_tlast, loopback_rx_axis_tlast, sched_rx_axis_tlast}),
    .s_axis_tid({PORT_COUNT{1'b0}}),
    .s_axis_tdest( {dram_rx_axis_tdest, loopback_rx_axis_tdest, sched_rx_axis_tdest}),
    .s_axis_tuser( {dram_rx_axis_tuser, loopback_rx_axis_tuser, sched_rx_axis_tuser}),

    .m_clk(core_clk),
    .m_rst(core_rst_r),
    .m_axis_tdata (data_s_axis_tdata),
    .m_axis_tkeep (data_s_axis_tkeep),
    .m_axis_tvalid(data_s_axis_tvalid),
    .m_axis_tready(data_s_axis_tready),
    .m_axis_tlast (data_s_axis_tlast),
    .m_axis_tid   (),
    .m_axis_tdest (data_s_axis_tdest),
    .m_axis_tuser (data_s_axis_tuser)
);

stat_reader # (
  .KEEP_WIDTH(LVL1_STRB_WIDTH),
  .PORT_COUNT(INTERFACE_COUNT+V_PORT_COUNT),
  .BYTE_COUNT_WIDTH(BYTE_COUNT_WIDTH),
  .FRAME_COUNT_WIDTH(FRAME_COUNT_WIDTH),
  .PORT_WIDTH(IF_COUNT_WIDTH),
  .PORT_CLUSTERS(2)
) interface_incoming_stat (
  .clk(sys_clk),
  .port_rst({INTERFACE_COUNT+V_PORT_COUNT{stat_rst_r}}),
  .port_clear({INTERFACE_COUNT+V_PORT_COUNT{1'b0}}),

  .monitor_axis_tkeep(sched_rx_axis_tkeep),
  .monitor_axis_tvalid(sched_rx_axis_tvalid),
  .monitor_axis_tready(sched_rx_axis_tready),
  .monitor_axis_tlast(sched_rx_axis_tlast),
  .monitor_drop_pulse({{V_PORT_COUNT{1'b0}},rx_drop_r}),

  .port_select(interface_sel),
  .stat_addr(interface_reg_sel),
  .stat_data(interface_in_stat_data)
);

axis_switch_2lvl # (
    .S_COUNT         (CORE_COUNT),
    .M_COUNT         (PORT_COUNT),
    .S_DATA_WIDTH    (LVL2_DATA_WIDTH),
    .S_KEEP_WIDTH    (LVL2_STRB_WIDTH),
    .S_DEST_WIDTH    (PORT_WIDTH),
    .M_DATA_WIDTH    (LVL1_DATA_WIDTH),
    .M_KEEP_WIDTH    (LVL1_STRB_WIDTH),
    .M_DEST_ENABLE   (0),
    .ID_ENABLE       (0),
    .USER_ENABLE     (1),
    .USER_WIDTH      (ID_TAG_WIDTH),
    .S_REG_TYPE      (2),
    .M_REG_TYPE      (2),
    .CLUSTER_COUNT   (CLUSTER_COUNT),
    .STAGE_FIFO_DEPTH(TX_STG_F_DEPTH),
    .FRAME_FIFO      (1),
    .SEPARATE_CLOCKS (SEPARATE_CLOCKS),
    .USE_SIMPLE_SW   (0),
    .PIPELINE_OUTPUT (SW_OUTPUT_PIPE)
) data_out_sw (
    /*
     * AXI Stream inputs
     */
    .s_clk(core_clk),
    .s_rst(core_rst_r),
    .s_axis_tdata(data_m_axis_tdata),
    .s_axis_tkeep(data_m_axis_tkeep),
    .s_axis_tvalid(data_m_axis_tvalid),
    .s_axis_tready(data_m_axis_tready),
    .s_axis_tlast(data_m_axis_tlast),
    .s_axis_tid({CORE_COUNT{1'b0}}),
    .s_axis_tdest(data_m_axis_tdest),
    .s_axis_tuser(data_m_axis_tuser),

    /*
     * AXI Stream outputs
     */
    .m_clk(sys_clk),
    .m_rst(sys_rst_r),
    .m_axis_tdata( {dram_tx_axis_tdata, loopback_tx_axis_tdata, sched_tx_axis_tdata}),
    .m_axis_tkeep( {dram_tx_axis_tkeep, loopback_tx_axis_tkeep, sched_tx_axis_tkeep}),
    .m_axis_tvalid({dram_tx_axis_tvalid,loopback_tx_axis_tvalid,sched_tx_axis_tvalid}),
    .m_axis_tready({dram_tx_axis_tready,loopback_tx_axis_tready,sched_tx_axis_tready}),
    .m_axis_tlast( {dram_tx_axis_tlast, loopback_tx_axis_tlast, sched_tx_axis_tlast}),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser( {dram_tx_axis_tuser, loopback_tx_axis_tuser, sched_tx_axis_tuser})

);

stat_reader # (
  .KEEP_WIDTH(LVL1_STRB_WIDTH),
  .PORT_COUNT(INTERFACE_COUNT+V_PORT_COUNT),
  .BYTE_COUNT_WIDTH(BYTE_COUNT_WIDTH),
  .FRAME_COUNT_WIDTH(FRAME_COUNT_WIDTH),
  .PORT_WIDTH(IF_COUNT_WIDTH),
  .PORT_CLUSTERS(2)
) interface_outgoing_stat (
  .clk(sys_clk),
  .port_rst({INTERFACE_COUNT+V_PORT_COUNT{stat_rst_r}}),
  .port_clear({INTERFACE_COUNT+V_PORT_COUNT{1'b0}}),

  .monitor_axis_tkeep(sched_tx_axis_tkeep),
  .monitor_axis_tvalid(sched_tx_axis_tvalid),
  .monitor_axis_tready(sched_tx_axis_tready),
  .monitor_axis_tlast(sched_tx_axis_tlast),
  .monitor_drop_pulse({INTERFACE_COUNT+V_PORT_COUNT{1'b0}}),

  .port_select(interface_sel),
  .stat_addr(interface_reg_sel),
  .stat_data(interface_out_stat_data)
);

axis_switch_2lvl # (
    .S_COUNT         (1),
    .M_COUNT         (CORE_COUNT),
    .S_DATA_WIDTH    (CTRL_WIDTH),
    .S_KEEP_ENABLE   (0),
    .S_DEST_WIDTH    (CORE_WIDTH),
    .M_DATA_WIDTH    (CTRL_WIDTH),
    .M_KEEP_ENABLE   (0),
    .M_DEST_ENABLE   (0),
    .ID_ENABLE       (0),
    .USER_ENABLE     (0),
    .S_REG_TYPE      (2),
    .M_REG_TYPE      (2),
    .CLUSTER_COUNT   (CLUSTER_COUNT),
    .STAGE_FIFO_DEPTH(STG_F_CTRL_DEPTH),
    .FRAME_FIFO      (0),
    .SEPARATE_CLOCKS (SEPARATE_CLOCKS),
    .USE_SIMPLE_SW   (1),
    .PIPELINE_OUTPUT (1)
) ctrl_in_sw
(
    /*
     * AXI Stream inputs
     */
    .s_clk(sys_clk),
    .s_rst(sys_rst_r),
    .s_axis_tdata(sched_ctrl_m_axis_tdata),
    .s_axis_tkeep(1'b0),
    .s_axis_tvalid(sched_ctrl_m_axis_tvalid),
    .s_axis_tready(sched_ctrl_m_axis_tready),
    .s_axis_tlast(sched_ctrl_m_axis_tvalid),
    .s_axis_tid(1'b0),
    .s_axis_tdest(sched_ctrl_m_axis_tdest),
    .s_axis_tuser(1'b0),

    /*
     * AXI Stream outputs
     */
    .m_clk(core_clk),
    .m_rst(core_rst_r),
    .m_axis_tdata(ctrl_s_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tvalid(ctrl_s_axis_tvalid),
    .m_axis_tready(ctrl_s_axis_tready),
    .m_axis_tlast(),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser()
);

axis_simple_arb_2lvl # (
    .S_COUNT         (CORE_COUNT),
    .DATA_WIDTH      (CTRL_WIDTH),
    .USER_ENABLE     (1),
    .USER_WIDTH      (CORE_WIDTH),
    .CLUSTER_COUNT   (CLUSTER_COUNT),
    .STAGE_FIFO_DEPTH(STG_F_CTRL_DEPTH)
) ctrl_out_sw (

    .clk(core_clk),
    .rst(core_rst_r),

    .s_axis_tdata(ctrl_m_axis_tdata),
    .s_axis_tvalid(ctrl_m_axis_tvalid),
    .s_axis_tready(ctrl_m_axis_tready),
    .s_axis_tuser(ctrl_m_axis_tuser),

    .m_axis_tdata(sched_ctrl_s_axis_tdata),
    .m_axis_tvalid(sched_ctrl_s_axis_tvalid),
    .m_axis_tready(sched_ctrl_s_axis_tready),
    .m_axis_tuser(sched_ctrl_s_axis_tuser)
);

axis_switch_2lvl # (
    .S_COUNT         (1),
    .M_COUNT         (CORE_COUNT),
    .S_DATA_WIDTH    (LVL1_DRAM_WIDTH),
    .S_KEEP_ENABLE   (0),
    .S_DEST_WIDTH    (CORE_WIDTH),
    .M_DATA_WIDTH    (LVL2_DRAM_WIDTH),
    .M_KEEP_ENABLE   (0),
    .M_DEST_ENABLE   (0),
    .ID_ENABLE       (0),
    .USER_ENABLE     (0),
    .S_REG_TYPE      (2),
    .M_REG_TYPE      (2),
    .CLUSTER_COUNT   (CLUSTER_COUNT),
    .STAGE_FIFO_DEPTH(STG_F_DRAM_DEPTH),
    .FRAME_FIFO      (0),
    .SEPARATE_CLOCKS (SEPARATE_CLOCKS),
    .USE_SIMPLE_SW   (1),
    .PIPELINE_OUTPUT (SW_OUTPUT_PIPE)
) dram_ctrl_in_sw
(
    /*
     * AXI Stream inputs
     */
    .s_clk(sys_clk),
    .s_rst(sys_rst_r),
    .s_axis_tdata(dram_ctrl_s_axis_tdata),
    .s_axis_tkeep(1'b0),
    .s_axis_tvalid(dram_ctrl_s_axis_tvalid),
    .s_axis_tready(dram_ctrl_s_axis_tready),
    .s_axis_tlast(dram_ctrl_s_axis_tlast),
    .s_axis_tid(1'b0),
    .s_axis_tdest(dram_ctrl_s_axis_tdest),
    .s_axis_tuser(1'b0),

    /*
     * AXI Stream outputs
     */
    .m_clk(core_clk),
    .m_rst(core_rst_r),
    .m_axis_tdata(dram_s_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tvalid(dram_s_axis_tvalid),
    .m_axis_tready(dram_s_axis_tready),
    .m_axis_tlast(dram_s_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser()
);

axis_switch_2lvl # (
    .S_COUNT         (CORE_COUNT),
    .M_COUNT         (1),
    .S_DATA_WIDTH    (LVL2_DRAM_WIDTH),
    .S_KEEP_ENABLE   (0),
    .M_DATA_WIDTH    (LVL1_DRAM_WIDTH),
    .M_KEEP_ENABLE   (0),
    .M_DEST_ENABLE   (0),
    .ID_ENABLE       (0),
    .USER_ENABLE     (1),
    .USER_WIDTH      (CORE_WIDTH),
    .S_REG_TYPE      (2),
    .M_REG_TYPE      (2),
    .CLUSTER_COUNT   (CLUSTER_COUNT),
    .STAGE_FIFO_DEPTH(STG_F_DRAM_DEPTH),
    .FRAME_FIFO      (0),
    .SEPARATE_CLOCKS (SEPARATE_CLOCKS),
    .USE_SIMPLE_SW   (1),
    .PIPELINE_OUTPUT (SW_OUTPUT_PIPE)
) dram_ctrl_out_sw
(
    /*
     * AXI Stream inputs
     */
    .s_clk(core_clk),
    .s_rst(core_rst_r),
    .s_axis_tdata(dram_m_axis_tdata),
    .s_axis_tkeep({CORE_COUNT{1'b0}}),
    .s_axis_tvalid(dram_m_axis_tvalid),
    .s_axis_tready(dram_m_axis_tready),
    .s_axis_tlast(dram_m_axis_tlast),
    .s_axis_tid({CORE_COUNT{1'b0}}),
    .s_axis_tdest({CORE_COUNT{1'b0}}),
    .s_axis_tuser(dram_m_axis_tuser),

    /*
     * AXI Stream output
     */
    .m_clk(sys_clk),
    .m_rst(sys_rst_r),
    .m_axis_tdata(dram_ctrl_m_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tvalid(dram_ctrl_m_axis_tvalid),
    .m_axis_tready(dram_ctrl_m_axis_tready),
    .m_axis_tlast(dram_ctrl_m_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(dram_ctrl_m_axis_tuser)
);

// Core internal messaging
wire [CORE_COUNT*CORE_MSG_WIDTH-1:0] core_msg_out_data;
wire [CORE_COUNT-1:0]                core_msg_out_valid;
wire [CORE_COUNT-1:0]                core_msg_out_ready;

// // Register core message outputs
// wire [CORE_COUNT*CORE_MSG_WIDTH-1:0] core_msg_out_data_r;
// wire [CORE_COUNT*CORE_WIDTH-1:0]     core_msg_out_user_r;
// wire [CORE_COUNT-1:0]                core_msg_out_valid_r;
// wire [CORE_COUNT-1:0]                core_msg_out_ready_r;
//
// genvar n;
// generate
//   for (n=0; n<CORE_COUNT; n=n+1) begin: bc_msg_out_regs
//     axis_pipeline_register # (
//       .DATA_WIDTH(CORE_MSG_WIDTH),
//       .KEEP_ENABLE(0),
//       .KEEP_WIDTH(1),
//       .LAST_ENABLE(0),
//       .DEST_ENABLE(0),
//       .USER_ENABLE(1),
//       .USER_WIDTH(CORE_WIDTH),
//       .ID_ENABLE(0),
//       .REG_TYPE(2),
//       .LENGTH(1)
//     ) bc_msg_out_register (
//       .clk(core_clk),
//       .rst(core_rst_r),
//
//       .s_axis_tdata(core_msg_out_data[n*CORE_MSG_WIDTH +: CORE_MSG_WIDTH]),
//       .s_axis_tkeep(1'b0),
//       .s_axis_tvalid(core_msg_out_valid[n]),
//       .s_axis_tready(core_msg_out_ready[n]),
//       .s_axis_tlast(1'b0),
//       .s_axis_tid(8'd0),
//       .s_axis_tdest(8'd0),
//       .s_axis_tuser(ctrl_m_axis_tuser[n*CORE_WIDTH +: CORE_WIDTH]),
//
//       .m_axis_tdata(core_msg_out_data_r[n*CORE_MSG_WIDTH +: CORE_MSG_WIDTH]),
//       .m_axis_tkeep(),
//       .m_axis_tvalid(core_msg_out_valid_r[n]),
//       .m_axis_tready(core_msg_out_ready_r[n]),
//       .m_axis_tlast(),
//       .m_axis_tid(),
//       .m_axis_tdest(),
//       .m_axis_tuser(core_msg_out_user_r[n*CORE_WIDTH +: CORE_WIDTH])
//     );
//   end
// endgenerate

// Merge the boradcast messages
wire [CORE_MSG_WIDTH-1:0]            core_msg_merged_data;
wire [CORE_WIDTH-1:0]                core_msg_merged_user;
wire                                 core_msg_merged_valid;
wire                                 core_msg_merged_ready;

axis_simple_arb_2lvl # (
    .S_COUNT         (CORE_COUNT),
    .DATA_WIDTH      (CORE_MSG_WIDTH),
    .USER_ENABLE     (1),
    .USER_WIDTH      (CORE_WIDTH),
    .CLUSTER_COUNT   (BC_MSG_CLUSTERS),
    .STAGE_FIFO_DEPTH(16)
) cores_to_broadcaster (

    .clk(core_clk),
    .rst(core_rst_r),

    .s_axis_tdata(core_msg_out_data),
    .s_axis_tvalid(core_msg_out_valid),
    .s_axis_tready(core_msg_out_ready),
    .s_axis_tuser(ctrl_m_axis_tuser),

    .m_axis_tdata(core_msg_merged_data),
    .m_axis_tvalid(core_msg_merged_valid),
    .m_axis_tready(core_msg_merged_ready),
    .m_axis_tuser(core_msg_merged_user)
);

(* KEEP = "TRUE" *) reg [BC_MSG_CLUSTERS*CORE_MSG_WIDTH-1:0] core_msg_merged_data_r;
(* KEEP = "TRUE" *) reg [BC_MSG_CLUSTERS*CORE_WIDTH-1:0]     core_msg_merged_user_r;
(* KEEP = "TRUE" *) reg [BC_MSG_CLUSTERS-1:0]                core_msg_merged_valid_r;

always @ (posedge core_clk) begin
    core_msg_merged_data_r  <= {BC_MSG_CLUSTERS{core_msg_merged_data}};
    core_msg_merged_user_r  <= {BC_MSG_CLUSTERS{core_msg_merged_user}};
    core_msg_merged_valid_r <= {BC_MSG_CLUSTERS{core_msg_merged_valid}};
    if (core_rst_r)
      core_msg_merged_valid_r <= {BC_MSG_CLUSTERS{1'b0}};
end

assign core_msg_merged_ready = 1'b1;

// Broadcast the arbitted core messages.
(* KEEP = "TRUE" *) reg [CORE_COUNT*CORE_MSG_WIDTH-1:0] core_msg_in_data;
(* KEEP = "TRUE" *) reg [CORE_COUNT*CORE_WIDTH-1:0]     core_msg_in_user;
(* KEEP = "TRUE" *) reg [CORE_COUNT-1:0]                core_msg_in_valid;

localparam CORES_PER_CLUSTER = CORE_COUNT / BC_MSG_CLUSTERS;

always @ (posedge core_clk) begin
    core_msg_in_data  <= {CORES_PER_CLUSTER{core_msg_merged_data_r}};
    core_msg_in_user  <= {CORES_PER_CLUSTER{core_msg_merged_user_r}};
    core_msg_in_valid <= {CORES_PER_CLUSTER{core_msg_merged_valid_r}};
    if (core_rst_r)
        core_msg_in_valid <= {CORE_COUNT{1'b0}};
end

// Additional register level.
(* KEEP = "TRUE" *) reg [CORE_COUNT*CORE_MSG_WIDTH-1:0] core_msg_in_data_r;
(* KEEP = "TRUE" *) reg [CORE_COUNT*CORE_WIDTH-1:0]     core_msg_in_user_r;
(* KEEP = "TRUE" *) reg [CORE_COUNT-1:0]                core_msg_in_valid_r;

always @ (posedge core_clk) begin
    core_msg_in_data_r  <= core_msg_in_data;
    core_msg_in_user_r  <= core_msg_in_user;
    core_msg_in_valid_r <= core_msg_in_valid;
    if (core_rst_r)
        core_msg_in_valid_r <= {CORE_COUNT{1'b0}};
end

// Selecting core for stat readback
localparam LAST_SEL_BITS = CORE_WIDTH+4-$clog2(BC_MSG_CLUSTERS);

(* KEEP = "TRUE" *) reg  [CORE_COUNT*4-1:0] core_stat_addr;
wire [CORE_COUNT*32-1:0] core_stat_data;

(* KEEP = "TRUE" *) reg [CORE_WIDTH+4-1:0] core_select_r;
(* KEEP = "TRUE" *) reg [BC_MSG_CLUSTERS*LAST_SEL_BITS-1:0] core_select_rr;
(* KEEP = "TRUE" *) reg [CORE_COUNT*32-1:0] core_stat_data_r;
reg [BC_MSG_CLUSTERS*32-1:0] core_stat_data_rr;

always @ (posedge core_clk) begin
  core_select_r    <= core_select;
  core_select_rr   <= {BC_MSG_CLUSTERS{core_select_r[LAST_SEL_BITS-1:0]}};
  core_stat_data_r <= core_stat_data;
end

genvar p;
generate
  for (p=0; p<BC_MSG_CLUSTERS; p=p+1) begin : in_cluster_stat_sel

    wire [$clog2(CORES_PER_CLUSTER)-1:0] cluster_core_sel =
      core_select_rr[p*LAST_SEL_BITS+4+:$clog2(CORES_PER_CLUSTER)];


    wire [CORES_PER_CLUSTER*32-1:0]  cluster_stat_data =
                        core_stat_data_r[p*CORES_PER_CLUSTER*32
                                        +: CORES_PER_CLUSTER*32];
    always @ (posedge core_clk) begin
      core_stat_data_rr [p*32 +: 32] <=
          cluster_stat_data [cluster_core_sel*32 +: 32];

    core_stat_addr[p*CORES_PER_CLUSTER*4 +: 4*CORES_PER_CLUSTER] <=
      {CORES_PER_CLUSTER{core_select_rr[p*LAST_SEL_BITS +: 4]}};
    end

  end
endgenerate

if (BC_MSG_CLUSTERS == 1) begin: single_cluster
  always @ (posedge core_clk)
    core_stat_data_muxed <= core_stat_data_rr;
end else begin: cluster_stat_sel
  always @ (posedge core_clk)
    core_stat_data_muxed <=
      core_stat_data_rr[core_select_r[CORE_WIDTH+4-1:LAST_SEL_BITS]*32  +: 32];
end

// Instantiating riscv core wrappers
genvar i;
generate
    for (i=0; i<CORE_COUNT; i=i+1) begin: riscv_cores
        wire [CORE_WIDTH-1:0]      core_id = i;
        wire                       core_reset;
        wire                       evict_int;
        wire                       evict_int_ack;
        wire                       poke_int;
        wire                       poke_int_ack;

        wire                       dma_cmd_wr_en;
        wire [25:0]                dma_cmd_wr_addr;
        wire                       dma_cmd_hdr_wr_en;
        wire [23:0]                dma_cmd_hdr_wr_addr;
        wire [LVL2_DATA_WIDTH-1:0] dma_cmd_wr_data;
        wire [LVL2_STRB_WIDTH-1:0] dma_cmd_wr_strb;
        wire                       dma_cmd_wr_last;
        wire                       dma_cmd_wr_ready;
        wire                       dma_cmd_rd_en;
        wire [25:0]                dma_cmd_rd_addr;
        wire                       dma_cmd_rd_last;
        wire                       dma_cmd_rd_ready;
        wire                       dma_rd_resp_valid;
        wire [LVL2_DATA_WIDTH-1:0] dma_rd_resp_data;
        wire                       dma_rd_resp_ready;

        wire [63:0]                in_desc;
        wire                       in_desc_valid;
        wire                       in_desc_taken;
        wire [63:0]                out_desc;
        wire [63:0]                out_desc_dram_addr;
        wire                       out_desc_valid;
        wire                       out_desc_ready;

        wire [4:0]                 recv_dram_tag;
        wire                       recv_dram_tag_valid;

        wire [CORE_MSG_WIDTH-1:0]  bc_msg_out;
        wire                       bc_msg_out_valid;
        wire                       bc_msg_out_ready;

        wire [CORE_MSG_WIDTH-1:0]  bc_msg_in;
        wire                       bc_msg_in_valid;

        wire [31:0]                wrapper_status_data;
        wire [1:0]                 wrapper_status_addr;
        wire                       wrapper_status_valid;
        wire                       wrapper_status_ready;

        wire [31:0]                core_status_data;
        wire [1:0]                 core_status_addr;
        wire                       core_status_valid;
        wire                       core_status_ready;

        // (* keep_hierarchy = "soft" *)
        riscv_axis_wrapper #(
            .DATA_WIDTH(LVL2_DATA_WIDTH),
            .SLOT_COUNT(SLOT_COUNT),
            .RECV_DESC_DEPTH(RECV_DESC_DEPTH),
            .SEND_DESC_DEPTH(SEND_DESC_DEPTH),
            .DRAM_DESC_DEPTH(DRAM_DESC_DEPTH),
            .MSG_FIFO_DEPTH(MSG_FIFO_DEPTH),
            .PORT_WIDTH(PORT_WIDTH),
            .CORE_ID_WIDTH(CORE_WIDTH),
            .BC_REGION_SIZE(BC_REGION_SIZE),
            .MSG_WIDTH(CORE_MSG_WIDTH),
            .MAX_PKT_HDR_SIZE(MAX_PKT_HDR_SIZE),
            .SLOT_START_ADDR(SLOT_START_ADDR),
            .SLOT_ADDR_STEP(SLOT_ADDR_STEP),
            .HDR_START_ADDR(HDR_START_ADDR),
            .DRAM_PORT(DRAM_PORT),
            .DATA_S_REG_TYPE(2),
            .DATA_M_REG_TYPE(2),
            .DRAM_M_REG_TYPE(2)
        ) core_wrapper (
            .clk(core_clk),
            .rst(block_reset[i]),

            .core_id(core_id),
            // ---------------- DATA CHANNEL --------------- //
            // Incoming data
            .data_s_axis_tdata(data_s_axis_tdata[LVL2_DATA_WIDTH*i +: LVL2_DATA_WIDTH]),
            .data_s_axis_tkeep(data_s_axis_tkeep[LVL2_STRB_WIDTH*i +: LVL2_STRB_WIDTH]),
            .data_s_axis_tvalid(data_s_axis_tvalid[i]),
            .data_s_axis_tready(data_s_axis_tready[i]),
            .data_s_axis_tlast(data_s_axis_tlast[i]),
            .data_s_axis_tdest(data_s_axis_tdest[TAG_WIDTH*i +: TAG_WIDTH]),
            .data_s_axis_tuser(data_s_axis_tuser[PORT_WIDTH*i +: PORT_WIDTH]),

            // Outgoing data
            .data_m_axis_tdata(data_m_axis_tdata[LVL2_DATA_WIDTH*i +: LVL2_DATA_WIDTH]),
            .data_m_axis_tkeep(data_m_axis_tkeep[LVL2_STRB_WIDTH*i +: LVL2_STRB_WIDTH]),
            .data_m_axis_tvalid(data_m_axis_tvalid[i]),
            .data_m_axis_tready(data_m_axis_tready[i]),
            .data_m_axis_tlast(data_m_axis_tlast[i]),
            .data_m_axis_tdest(data_m_axis_tdest[PORT_WIDTH*i +: PORT_WIDTH]),
            .data_m_axis_tuser(data_m_axis_tuser[ID_TAG_WIDTH*i +: TAG_WIDTH]),

            // ---------------- CTRL CHANNEL --------------- //
            // Incoming control
            .ctrl_s_axis_tdata(ctrl_s_axis_tdata[CTRL_WIDTH*i +: CTRL_WIDTH]),
            .ctrl_s_axis_tvalid(ctrl_s_axis_tvalid[i]),
            .ctrl_s_axis_tready(ctrl_s_axis_tready[i]),

            // Outgoing control
            .ctrl_m_axis_tdata(ctrl_m_axis_tdata[CTRL_WIDTH*i +: CTRL_WIDTH]),
            .ctrl_m_axis_tvalid(ctrl_m_axis_tvalid[i]),
            .ctrl_m_axis_tready(ctrl_m_axis_tready[i]),

            // ------------ DRAM RD REQ CHANNEL ------------- //
            // Incoming DRAM request
            .dram_s_axis_tdata(dram_s_axis_tdata[LVL2_DRAM_WIDTH*i +: LVL2_DRAM_WIDTH]),
            .dram_s_axis_tvalid(dram_s_axis_tvalid[i]),
            .dram_s_axis_tready(dram_s_axis_tready[i]),
            .dram_s_axis_tlast(dram_s_axis_tlast[i]),

            // Outgoing DRAM request
            .dram_m_axis_tdata(dram_m_axis_tdata[LVL2_DRAM_WIDTH*i +: LVL2_DRAM_WIDTH]),
            .dram_m_axis_tvalid(dram_m_axis_tvalid[i]),
            .dram_m_axis_tready(dram_m_axis_tready[i]),
            .dram_m_axis_tlast(dram_m_axis_tlast[i]),

            // ------------- CORE MSG CHANNEL -------------- //
            // Core messages output
            .core_msg_out(core_msg_out_data[CORE_MSG_WIDTH*i +: CORE_MSG_WIDTH]),
            .core_msg_out_valid(core_msg_out_valid[i]),
            .core_msg_out_ready(core_msg_out_ready[i]),

            // Core messages input
            .core_msg_in(core_msg_in_data_r[CORE_MSG_WIDTH*i +: CORE_MSG_WIDTH]),
            .core_msg_in_user(core_msg_in_user_r[CORE_WIDTH*i +: CORE_WIDTH]),
            .core_msg_in_valid(core_msg_in_valid_r[i]),

            // ---------- STATUS READBACK CHANNEL ---------- //
            .stat_addr(core_stat_addr[4*i +: 4]),
            .stat_data(core_stat_data[32*i +: 32]),

            // --------------------------------------------- //
            // ------- CONNECTION TO RISCV_BLOCK ----------- //
            // --------------------------------------------- //

            .core_reset(core_reset),
            .evict_int(evict_int),
            .evict_int_ack(evict_int_ack),
            .poke_int(poke_int),
            .poke_int_ack(poke_int_ack),

            .dma_cmd_wr_en(dma_cmd_wr_en),
            .dma_cmd_wr_addr(dma_cmd_wr_addr),
            .dma_cmd_hdr_wr_en(dma_cmd_hdr_wr_en),
            .dma_cmd_hdr_wr_addr(dma_cmd_hdr_wr_addr),
            .dma_cmd_wr_data(dma_cmd_wr_data),
            .dma_cmd_wr_strb(dma_cmd_wr_strb),
            .dma_cmd_wr_last(dma_cmd_wr_last),
            .dma_cmd_wr_ready(dma_cmd_wr_ready),
            .dma_cmd_rd_en(dma_cmd_rd_en),
            .dma_cmd_rd_addr(dma_cmd_rd_addr),
            .dma_cmd_rd_last(dma_cmd_rd_last),
            .dma_cmd_rd_ready(dma_cmd_rd_ready),
            .dma_rd_resp_valid(dma_rd_resp_valid),
            .dma_rd_resp_data(dma_rd_resp_data),
            .dma_rd_resp_ready(dma_rd_resp_ready),

            .in_desc(in_desc),
            .in_desc_valid(in_desc_valid),
            .in_desc_taken(in_desc_taken),
            .out_desc(out_desc),
            .out_desc_dram_addr(out_desc_dram_addr),
            .out_desc_valid(out_desc_valid),
            .out_desc_ready(out_desc_ready),

            .recv_dram_tag(recv_dram_tag),
            .recv_dram_tag_valid(recv_dram_tag_valid),

            .bc_msg_out(bc_msg_out),
            .bc_msg_out_valid(bc_msg_out_valid),
            .bc_msg_out_ready(bc_msg_out_ready),
            .bc_msg_in(bc_msg_in),
            .bc_msg_in_user(),
            .bc_msg_in_valid(bc_msg_in_valid),

            .wrapper_status_data(wrapper_status_data),
            .wrapper_status_addr(wrapper_status_addr),
            .wrapper_status_valid(wrapper_status_valid),
            .wrapper_status_ready(wrapper_status_ready),
            .core_status_data(core_status_data),
            .core_status_addr(core_status_addr),
            .core_status_valid(core_status_valid),
            .core_status_ready(core_status_ready)
        );

    `ifndef PR_ENABLE
        riscv_block # (
            .DATA_WIDTH(LVL2_DATA_WIDTH),
            .STRB_WIDTH(LVL2_STRB_WIDTH),
            .IMEM_SIZE(IMEM_SIZE),
            .PMEM_SIZE(PMEM_SIZE),
            .DMEM_SIZE(DMEM_SIZE),
            .SLOW_M_B_LINES(SLOW_M_B_LINES),
            .FAST_M_B_LINES(FAST_M_B_LINES),
            .BC_REGION_SIZE(BC_REGION_SIZE),
            .BC_START_ADDR(BC_START_ADDR),
            .MSG_WIDTH(CORE_MSG_WIDTH),
            .CORE_ID_WIDTH(CORE_WIDTH)
        ) riscv_block_inst (
    `else
        riscv_block_PR # (
        ) pr_wrapper (
    `endif
            .clk(core_clk),
            .rst(block_reset[i]),
            .core_rst(core_reset),

            .evict_int(evict_int),
            .evict_int_ack(evict_int_ack),
            .poke_int(poke_int),
            .poke_int_ack(poke_int_ack),

            .dma_cmd_wr_en(dma_cmd_wr_en),
            .dma_cmd_wr_addr(dma_cmd_wr_addr),
            .dma_cmd_hdr_wr_en(dma_cmd_hdr_wr_en),
            .dma_cmd_hdr_wr_addr(dma_cmd_hdr_wr_addr),
            .dma_cmd_wr_data(dma_cmd_wr_data),
            .dma_cmd_wr_strb(dma_cmd_wr_strb),
            .dma_cmd_wr_last(dma_cmd_wr_last),
            .dma_cmd_wr_ready(dma_cmd_wr_ready),
            .dma_cmd_rd_en(dma_cmd_rd_en),
            .dma_cmd_rd_addr(dma_cmd_rd_addr),
            .dma_cmd_rd_last(dma_cmd_rd_last),
            .dma_cmd_rd_ready(dma_cmd_rd_ready),
            .dma_rd_resp_valid(dma_rd_resp_valid),
            .dma_rd_resp_data(dma_rd_resp_data),
            .dma_rd_resp_ready(dma_rd_resp_ready),

            .in_desc(in_desc),
            .in_desc_valid(in_desc_valid),
            .in_desc_taken(in_desc_taken),
            .out_desc(out_desc),
            .out_desc_dram_addr(out_desc_dram_addr),
            .out_desc_valid(out_desc_valid),
            .out_desc_ready(out_desc_ready),

            .recv_dram_tag(recv_dram_tag),
            .recv_dram_tag_valid(recv_dram_tag_valid),

            .bc_msg_out(bc_msg_out),
            .bc_msg_out_valid(bc_msg_out_valid),
            .bc_msg_out_ready(bc_msg_out_ready),
            .bc_msg_in(bc_msg_in),
            .bc_msg_in_valid(bc_msg_in_valid),

            .wrapper_status_data(wrapper_status_data),
            .wrapper_status_addr(wrapper_status_addr),
            .wrapper_status_valid(wrapper_status_valid),
            .wrapper_status_ready(wrapper_status_ready),
            .core_status_data(core_status_data),
            .core_status_addr(core_status_addr),
            .core_status_valid(core_status_valid),
            .core_status_ready(core_status_ready)
        );

        assign dram_m_axis_tuser[CORE_WIDTH*i +: CORE_WIDTH]               = i;
        assign ctrl_m_axis_tuser[CORE_WIDTH*i +: CORE_WIDTH]               = i;
        assign data_m_axis_tuser[(ID_TAG_WIDTH*i)+TAG_WIDTH +: CORE_WIDTH] = i;

    end

endgenerate

// ILA
if (ENABLE_CORES_ILA) begin: ILA_inst
  reg [63:0] data_s_slot;
  reg [63:0] data_m_slot;
  integer k;
  always @ (posedge sys_clk)
    // CORE_COUNT=16 and SLOT_WIDTH=4, so data_s_slot and data_m_slot become 64 bits
    // ctrl msg type and slot are also 4 bits, and considered 4 bits for port to make it 64 bits
    for (k=0; k<CORE_COUNT; k=k+1) begin
      data_s_slot [k*SLOT_WIDTH +: SLOT_WIDTH] <= data_s_axis_tdest[TAG_WIDTH*k +: SLOT_WIDTH];
      data_m_slot [k*SLOT_WIDTH +: SLOT_WIDTH] <= data_m_axis_tuser[ID_TAG_WIDTH*k +: SLOT_WIDTH];
    end

  reg [CORE_COUNT-1:0] data_m_axis_tvalid_r;
  reg [CORE_COUNT-1:0] data_m_axis_tready_r;
  reg [CORE_COUNT-1:0] data_m_axis_tlast_r;
  reg [CORE_COUNT-1:0] data_s_axis_tvalid_r;
  reg [CORE_COUNT-1:0] data_s_axis_tready_r;
  reg [CORE_COUNT-1:0] data_s_axis_tlast_r;

  // PORT_WIDTH=3, so each of size 48 bits
  reg [CORE_COUNT*PORT_WIDTH-1:0] data_m_axis_tdest_r;
  reg [CORE_COUNT*PORT_WIDTH-1:0] data_s_axis_tuser_r;

  always @ (posedge sys_clk) begin
    data_m_axis_tvalid_r <= data_m_axis_tvalid;
    data_m_axis_tready_r <= data_m_axis_tready;
    data_m_axis_tdest_r  <= data_m_axis_tdest;
    data_m_axis_tlast_r  <= data_m_axis_tlast;
    data_s_axis_tvalid_r <= data_s_axis_tvalid;
    data_s_axis_tready_r <= data_s_axis_tready;
    data_s_axis_tuser_r  <= data_s_axis_tuser;
    data_s_axis_tlast_r  <= data_s_axis_tlast;
  end

  ila_5x64 core_data_debugger (
    .clk    (sys_clk),

    .trig_out(sched_trig_in),
    .trig_out_ack(sched_trig_in_ack),
    .trig_in (sched_trig_out),
    .trig_in_ack(sched_trig_out_ack),

    .probe0({data_s_axis_tvalid_r,
             data_s_axis_tready_r,
             data_m_axis_tvalid_r,
             data_m_axis_tready_r}),

    .probe1(data_s_slot),
    .probe2({data_s_axis_tuser_r,
             data_s_axis_tlast_r}),

    .probe3(data_m_slot),
    .probe4({data_m_axis_tdest_r,
             data_m_axis_tlast_r})
  );

end else begin: no_ILA
  assign sched_trig_in      = 1'b0;
  assign sched_trig_out_ack = 1'b0;
end

endmodule

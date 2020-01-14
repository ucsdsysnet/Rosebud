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
 * Testbench for fpga_core
 */
module test_fpga_core;

// Parameters
parameter AXIS_PCIE_DATA_WIDTH = 256;
parameter AXIS_PCIE_KEEP_WIDTH = (AXIS_PCIE_DATA_WIDTH/32);
parameter AXIS_PCIE_RC_USER_WIDTH = 75;
parameter AXIS_PCIE_RQ_USER_WIDTH = 60;
parameter AXIS_PCIE_CQ_USER_WIDTH = 85;
parameter AXIS_PCIE_CC_USER_WIDTH = 33;
parameter BAR0_APERTURE = 24;

parameter TB_LOG = 0;
// Inputs
reg pcie_clk   = 0;
reg pcie_rst   = 0;
reg sys_clk    = 0;
reg sys_rst    = 0;
reg core_clk   = 0;
reg core_rst   = 0;
reg [7:0] current_test = 0;
reg m_axis_rq_tready = 0;
reg [AXIS_PCIE_DATA_WIDTH-1:0] s_axis_rc_tdata = 0;
reg [AXIS_PCIE_KEEP_WIDTH-1:0] s_axis_rc_tkeep = 0;
reg s_axis_rc_tlast = 0;
reg [AXIS_PCIE_RC_USER_WIDTH-1:0] s_axis_rc_tuser = 0;
reg s_axis_rc_tvalid = 0;
reg [AXIS_PCIE_DATA_WIDTH-1:0] s_axis_cq_tdata = 0;
reg [AXIS_PCIE_KEEP_WIDTH-1:0] s_axis_cq_tkeep = 0;
reg s_axis_cq_tlast = 0;
reg [AXIS_PCIE_CQ_USER_WIDTH-1:0] s_axis_cq_tuser = 0;
reg s_axis_cq_tvalid = 0;
reg m_axis_cc_tready = 0;
reg [1:0] pcie_tfc_nph_av = 0;
reg [1:0] pcie_tfc_npd_av = 0;
reg [2:0] cfg_max_payload = 0;
reg [2:0] cfg_max_read_req = 0;
reg [31:0] cfg_mgmt_read_data = 0;
reg cfg_mgmt_read_write_done = 0;
reg [3:0] cfg_interrupt_msi_enable = 0;
reg [7:0] cfg_interrupt_msi_vf_enable = 0;
reg [11:0] cfg_interrupt_msi_mmenable = 0;
reg cfg_interrupt_msi_mask_update = 0;
reg [31:0] cfg_interrupt_msi_data = 0;
reg cfg_interrupt_msi_sent = 0;
reg cfg_interrupt_msi_fail = 0;
reg sfp_1_tx_clk = 0;
reg sfp_1_tx_rst = 0;
reg sfp_1_rx_clk = 0;
reg sfp_1_rx_rst = 0;
reg [63:0] sfp_1_rxd = 0;
reg [7:0] sfp_1_rxc = 0;
reg sfp_2_tx_clk = 0;
reg sfp_2_tx_rst = 0;
reg sfp_2_rx_clk = 0;
reg sfp_2_rx_rst = 0;
reg [63:0] sfp_2_rxd = 0;
reg [7:0]  sfp_2_rxc = 0;
reg sfp_i2c_scl_i = 1;
reg sfp_1_i2c_sda_i = 1;
reg sfp_2_i2c_sda_i = 1;
reg eeprom_i2c_scl_i = 1;
reg eeprom_i2c_sda_i = 1;
reg [15:0] flash_dq_i = 0;

// Outputs
wire [1:0] sma_led;
wire [AXIS_PCIE_DATA_WIDTH-1:0] m_axis_rq_tdata;
wire [AXIS_PCIE_KEEP_WIDTH-1:0] m_axis_rq_tkeep;
wire m_axis_rq_tlast;
wire [AXIS_PCIE_RQ_USER_WIDTH-1:0] m_axis_rq_tuser;
wire m_axis_rq_tvalid;
wire s_axis_rc_tready;
wire s_axis_cq_tready;
wire [AXIS_PCIE_DATA_WIDTH-1:0] m_axis_cc_tdata;
wire [AXIS_PCIE_KEEP_WIDTH-1:0] m_axis_cc_tkeep;
wire m_axis_cc_tlast;
wire [AXIS_PCIE_CC_USER_WIDTH-1:0] m_axis_cc_tuser;
wire m_axis_cc_tvalid;
wire [18:0] cfg_mgmt_addr;
wire cfg_mgmt_write;
wire [31:0] cfg_mgmt_write_data;
wire [3:0] cfg_mgmt_byte_enable;
wire cfg_mgmt_read;
wire [3:0] cfg_interrupt_msi_select;
wire [31:0] cfg_interrupt_msi_int;
wire [31:0] cfg_interrupt_msi_pending_status;
wire cfg_interrupt_msi_pending_status_data_enable;
wire [3:0] cfg_interrupt_msi_pending_status_function_num;
wire [2:0] cfg_interrupt_msi_attr;
wire cfg_interrupt_msi_tph_present;
wire [1:0] cfg_interrupt_msi_tph_type;
wire [8:0] cfg_interrupt_msi_tph_st_tag;
wire [3:0] cfg_interrupt_msi_function_number;
wire status_error_cor;
wire status_error_uncor;
wire [63:0] sfp_1_txd;
wire [7:0] sfp_1_txc;
wire [63:0] sfp_2_txd;
wire [7:0] sfp_2_txc;
wire sfp_i2c_scl_o;
wire sfp_i2c_scl_t;
wire sfp_1_i2c_sda_o;
wire sfp_1_i2c_sda_t;
wire sfp_2_i2c_sda_o;
wire sfp_2_i2c_sda_t;
wire eeprom_i2c_scl_o;
wire eeprom_i2c_scl_t;
wire eeprom_i2c_sda_o;
wire eeprom_i2c_sda_t;
wire [15:0] flash_dq_o;
wire flash_dq_oe;
wire [22:0] flash_addr;
wire flash_region;
wire flash_region_oe;
wire flash_ce_n;
wire flash_oe_n;
wire flash_we_n;
wire flash_adv_n;

initial begin
    // myhdl integration
    $from_myhdl(
        pcie_clk,
        pcie_rst,
        sys_clk,
        sys_rst,
        core_clk,
        core_rst,
        current_test,
        m_axis_rq_tready,
        s_axis_rc_tdata,
        s_axis_rc_tkeep,
        s_axis_rc_tlast,
        s_axis_rc_tuser,
        s_axis_rc_tvalid,
        s_axis_cq_tdata,
        s_axis_cq_tkeep,
        s_axis_cq_tlast,
        s_axis_cq_tuser,
        s_axis_cq_tvalid,
        m_axis_cc_tready,
        pcie_tfc_nph_av,
        pcie_tfc_npd_av,
        cfg_max_payload,
        cfg_max_read_req,
        cfg_mgmt_read_data,
        cfg_mgmt_read_write_done,
        cfg_interrupt_msi_enable,
        cfg_interrupt_msi_vf_enable,
        cfg_interrupt_msi_mmenable,
        cfg_interrupt_msi_mask_update,
        cfg_interrupt_msi_data,
        cfg_interrupt_msi_sent,
        cfg_interrupt_msi_fail,
        sfp_1_tx_clk,
        sfp_1_tx_rst,
        sfp_1_rx_clk,
        sfp_1_rx_rst,
        sfp_1_rxd,
        sfp_1_rxc,
        sfp_2_tx_clk,
        sfp_2_tx_rst,
        sfp_2_rx_clk,
        sfp_2_rx_rst,
        sfp_2_rxd,
        sfp_2_rxc,
        sfp_i2c_scl_i,
        sfp_1_i2c_sda_i,
        sfp_2_i2c_sda_i,
        eeprom_i2c_scl_i,
        eeprom_i2c_sda_i,
        flash_dq_i
    );
    $to_myhdl(
        sma_led,
        m_axis_rq_tdata,
        m_axis_rq_tkeep,
        m_axis_rq_tlast,
        m_axis_rq_tuser,
        m_axis_rq_tvalid,
        s_axis_rc_tready,
        s_axis_cq_tready,
        m_axis_cc_tdata,
        m_axis_cc_tkeep,
        m_axis_cc_tlast,
        m_axis_cc_tuser,
        m_axis_cc_tvalid,
        cfg_mgmt_addr,
        cfg_mgmt_write,
        cfg_mgmt_write_data,
        cfg_mgmt_byte_enable,
        cfg_mgmt_read,
        cfg_interrupt_msi_select,
        cfg_interrupt_msi_int,
        cfg_interrupt_msi_pending_status,
        cfg_interrupt_msi_pending_status_data_enable,
        cfg_interrupt_msi_pending_status_function_num,
        cfg_interrupt_msi_attr,
        cfg_interrupt_msi_tph_present,
        cfg_interrupt_msi_tph_type,
        cfg_interrupt_msi_tph_st_tag,
        cfg_interrupt_msi_function_number,
        status_error_cor,
        status_error_uncor,
        sfp_1_txd,
        sfp_1_txc,
        sfp_2_txd,
        sfp_2_txc,
        sfp_i2c_scl_o,
        sfp_i2c_scl_t,
        sfp_1_i2c_sda_o,
        sfp_1_i2c_sda_t,
        sfp_2_i2c_sda_o,
        sfp_2_i2c_sda_t,
        eeprom_i2c_scl_o,
        eeprom_i2c_scl_t,
        eeprom_i2c_sda_o,
        eeprom_i2c_sda_t,
        flash_dq_o,
        flash_dq_oe,
        flash_addr,
        flash_region,
        flash_region_oe,
        flash_ce_n,
        flash_oe_n,
        flash_we_n,
        flash_adv_n
    );

    // dump file
    $dumpfile("test_fpga_core.lxt");
    $dumpvars(0, test_fpga_core);
end

wire ext_tag_enable;

pcie_us_cfg #(
    .PF_COUNT(1),
    .VF_COUNT(0),
    .VF_OFFSET(64),
    .PCIE_CAP_OFFSET(12'h0C0)
)
pcie_us_cfg_inst (
    .clk(pcie_clk),
    .rst(pcie_reset),

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

wire [31:0] msi_irq;

pcie_us_msi #(
    .MSI_COUNT(32)
)
pcie_us_msi_inst (
    .clk(pcie_clk),
    .rst(pcie_reset),

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

fpga_core #(
    .AXIS_PCIE_DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .AXIS_PCIE_KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
    .AXIS_PCIE_RC_USER_WIDTH(AXIS_PCIE_RC_USER_WIDTH),
    .AXIS_PCIE_RQ_USER_WIDTH(AXIS_PCIE_RQ_USER_WIDTH),
    .AXIS_PCIE_CQ_USER_WIDTH(AXIS_PCIE_CQ_USER_WIDTH),
    .AXIS_PCIE_CC_USER_WIDTH(AXIS_PCIE_CC_USER_WIDTH),
    .BAR0_APERTURE(BAR0_APERTURE)
) UUT (
    .sys_clk(sys_clk),
    .sys_rst(sys_rst),
    .pcie_clk(pcie_clk),
    .pcie_rst(pcie_rst),
    .core_clk(core_clk),
    .core_rst(core_rst),
    .sma_led(sma_led),
    .m_axis_rq_tdata(m_axis_rq_tdata),
    .m_axis_rq_tkeep(m_axis_rq_tkeep),
    .m_axis_rq_tlast(m_axis_rq_tlast),
    .m_axis_rq_tready(m_axis_rq_tready),
    .m_axis_rq_tuser(m_axis_rq_tuser),
    .m_axis_rq_tvalid(m_axis_rq_tvalid),
    .s_axis_rc_tdata(s_axis_rc_tdata),
    .s_axis_rc_tkeep(s_axis_rc_tkeep),
    .s_axis_rc_tlast(s_axis_rc_tlast),
    .s_axis_rc_tready(s_axis_rc_tready),
    .s_axis_rc_tuser(s_axis_rc_tuser),
    .s_axis_rc_tvalid(s_axis_rc_tvalid),
    .s_axis_cq_tdata(s_axis_cq_tdata),
    .s_axis_cq_tkeep(s_axis_cq_tkeep),
    .s_axis_cq_tlast(s_axis_cq_tlast),
    .s_axis_cq_tready(s_axis_cq_tready),
    .s_axis_cq_tuser(s_axis_cq_tuser),
    .s_axis_cq_tvalid(s_axis_cq_tvalid),
    .m_axis_cc_tdata(m_axis_cc_tdata),
    .m_axis_cc_tkeep(m_axis_cc_tkeep),
    .m_axis_cc_tlast(m_axis_cc_tlast),
    .m_axis_cc_tready(m_axis_cc_tready),
    .m_axis_cc_tuser(m_axis_cc_tuser),
    .m_axis_cc_tvalid(m_axis_cc_tvalid),
    .cfg_max_payload(cfg_max_payload),
    .cfg_max_read_req(cfg_max_read_req),
    .ext_tag_enable(ext_tag_enable),
    .msi_irq(msi_irq),
    .status_error_cor(status_error_cor),
    .status_error_uncor(status_error_uncor),
    .sfp_1_tx_clk(sfp_1_tx_clk),
    .sfp_1_tx_rst(sfp_1_tx_rst),
    .sfp_1_txd(sfp_1_txd),
    .sfp_1_txc(sfp_1_txc),
    .sfp_1_rx_clk(sfp_1_rx_clk),
    .sfp_1_rx_rst(sfp_1_rx_rst),
    .sfp_1_rxd(sfp_1_rxd),
    .sfp_1_rxc(sfp_1_rxc),
    .sfp_2_tx_clk(sfp_2_tx_clk),
    .sfp_2_tx_rst(sfp_2_tx_rst),
    .sfp_2_txd(sfp_2_txd),
    .sfp_2_txc(sfp_2_txc),
    .sfp_2_rx_clk(sfp_2_rx_clk),
    .sfp_2_rx_rst(sfp_2_rx_rst),
    .sfp_2_rxd(sfp_2_rxd),
    .sfp_2_rxc(sfp_2_rxc),
    .sfp_i2c_scl_i(sfp_i2c_scl_i),
    .sfp_i2c_scl_o(sfp_i2c_scl_o),
    .sfp_i2c_scl_t(sfp_i2c_scl_t),
    .sfp_1_i2c_sda_i(sfp_1_i2c_sda_i),
    .sfp_1_i2c_sda_o(sfp_1_i2c_sda_o),
    .sfp_1_i2c_sda_t(sfp_1_i2c_sda_t),
    .sfp_2_i2c_sda_i(sfp_2_i2c_sda_i),
    .sfp_2_i2c_sda_o(sfp_2_i2c_sda_o),
    .sfp_2_i2c_sda_t(sfp_2_i2c_sda_t),
    .eeprom_i2c_scl_i(eeprom_i2c_scl_i),
    .eeprom_i2c_scl_o(eeprom_i2c_scl_o),
    .eeprom_i2c_scl_t(eeprom_i2c_scl_t),
    .eeprom_i2c_sda_i(eeprom_i2c_sda_i),
    .eeprom_i2c_sda_o(eeprom_i2c_sda_o),
    .eeprom_i2c_sda_t(eeprom_i2c_sda_t),
    .flash_dq_i(flash_dq_i),
    .flash_dq_o(flash_dq_o),
    .flash_dq_oe(flash_dq_oe),
    .flash_addr(flash_addr),
    .flash_region(flash_region),
    .flash_region_oe(flash_region_oe),
    .flash_ce_n(flash_ce_n),
    .flash_oe_n(flash_oe_n),
    .flash_we_n(flash_we_n),
    .flash_adv_n(flash_adv_n)
);

if (TB_LOG) begin
  integer f;
  
  initial begin
    f = $fopen("ctrl_log.txt","w"); 
    $timeformat(-9, 0, "ns", 8);
  end
  
  wire [3:0] ctrl_s_type      = UUT.scheduler.ctrl_s_axis_tdata[35:32];
  wire [3:0] ctrl_s_dest_core = UUT.scheduler.ctrl_s_axis_tdata[27:24];
  wire [3:0] ctrl_s_src_slot  = UUT.scheduler.ctrl_s_axis_tdata[19:16];
  wire [3:0] ctrl_s_src_core  = UUT.scheduler.ctrl_s_axis_tuser;
  
  always @ (posedge UUT.scheduler.clk) begin
    if (UUT.scheduler.ctrl_s_axis_tvalid && UUT.scheduler.ctrl_s_axis_tready)
      case (ctrl_s_type)
        4'd0: $fwrite(f,"%t %x,%x sent\n",  $time, ctrl_s_src_core, ctrl_s_src_slot);
        4'd1: $fwrite(f,"%t %x,%x ready\n", $time, ctrl_s_src_core, ctrl_s_src_slot);
        4'd2: $fwrite(f,"%t %x,%x -> %x \n", $time, ctrl_s_src_core, ctrl_s_src_slot, ctrl_s_dest_core);
        4'd3: $fwrite(f,"%t %x has %x slots\n", $time, ctrl_s_src_core, ctrl_s_src_slot);
      endcase
    if (UUT.scheduler.ctrl_m_axis_tvalid && UUT.scheduler.ctrl_m_axis_tready)
      $fwrite(f,"%t sent msg to   %x : 0x%x\n",$time, UUT.scheduler.ctrl_m_axis_tdest, UUT.scheduler.ctrl_m_axis_tdata);
  end
end

endmodule
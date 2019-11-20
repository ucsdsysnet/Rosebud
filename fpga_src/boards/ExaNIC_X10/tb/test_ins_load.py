#!/usr/bin/env python
"""

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

"""

from myhdl import *
import os
import random

import pcie
import pcie_us
import eth_ep
import xgmii_ep
import axis_ep

import struct

testbench = 'test_fpga_core'

srcs = []

srcs.append("../ip/ila_8x64_stub.v")
srcs.append("../ip/ila_4x64_stub.v")
srcs.append("../rtl/fpga_core.v")
srcs.append("../rtl/pcie_config.v")

srcs.append("../lib/smartFPGA/rtl/simple_fifo.v")
srcs.append("../lib/smartFPGA/rtl/max_finder_tree.v")
srcs.append("../lib/smartFPGA/rtl/slot_keeper.v")
srcs.append("../lib/smartFPGA/rtl/core_mems.v")
srcs.append("../lib/smartFPGA/rtl/axis_dma.v")
srcs.append("../lib/smartFPGA/rtl/VexRiscv.v")
srcs.append("../lib/smartFPGA/rtl/riscvcore.v")
srcs.append("../lib/smartFPGA/rtl/riscv_axis_wrapper.v")
srcs.append("../lib/smartFPGA/rtl/simple_scheduler.v")
srcs.append("../lib/smartFPGA/rtl/simple_sync_sig.v")
srcs.append("../lib/smartFPGA/rtl/axis_switch.v")
srcs.append("../lib/smartFPGA/rtl/axis_switch_2lvl.v")
srcs.append("../lib/smartFPGA/rtl/loopback_msg_fifo.v")
srcs.append("../lib/smartFPGA/rtl/header.v")
srcs.append("../lib/smartFPGA/rtl/pcie_controller.v")
srcs.append("../lib/smartFPGA/rtl/pcie_cont_read.v")
srcs.append("../lib/smartFPGA/rtl/pcie_cont_write.v")
srcs.append("../lib/smartFPGA/rtl/corundum.v")

srcs.append("../lib/eth/rtl/eth_mac_10g_fifo.v")
srcs.append("../lib/eth/rtl/eth_mac_10g.v")
srcs.append("../lib/eth/rtl/axis_xgmii_rx_64.v")
srcs.append("../lib/eth/rtl/axis_xgmii_tx_64.v")
srcs.append("../lib/eth/rtl/lfsr.v")

srcs.append("../lib/axis/rtl/arbiter.v")
srcs.append("../lib/axis/rtl/priority_encoder.v")
srcs.append("../lib/axis/rtl/axis_adapter.v")
srcs.append("../lib/axis/rtl/axis_arb_mux.v")
srcs.append("../lib/axis/rtl/axis_async_fifo.v")
srcs.append("../lib/axis/rtl/axis_async_fifo_adapter.v")
srcs.append("../lib/axis/rtl/axis_fifo.v")
srcs.append("../lib/axis/rtl/axis_fifo_adapter.v")
srcs.append("../lib/axis/rtl/axis_register.v")
srcs.append("../lib/axi/rtl/axil_interconnect.v")

srcs.append("../lib/pcie/rtl/pcie_us_axil_master.v")
srcs.append("../lib/pcie/rtl/dma_client_axis_sink.v")
srcs.append("../lib/pcie/rtl/dma_client_axis_source.v")
srcs.append("../lib/pcie/rtl/dma_if_pcie_us.v")
srcs.append("../lib/pcie/rtl/dma_if_pcie_us_rd.v")
srcs.append("../lib/pcie/rtl/dma_if_pcie_us_wr.v")
srcs.append("../lib/pcie/rtl/dma_if_mux.v")
srcs.append("../lib/pcie/rtl/dma_if_mux_rd.v")
srcs.append("../lib/pcie/rtl/dma_if_mux_wr.v")
srcs.append("../lib/pcie/rtl/dma_psdpram.v")
srcs.append("../lib/pcie/rtl/pcie_tag_manager.v")
srcs.append("../lib/pcie/rtl/pcie_us_cfg.v")
srcs.append("../lib/pcie/rtl/pcie_us_msi.v")
srcs.append("../lib/pcie/rtl/pulse_merge.v")
srcs.append("%s.v" % testbench)

srcs.append("../lib/corundum/rtl/interface.v")
srcs.append("../lib/corundum/rtl/port.v")
srcs.append("../lib/corundum/rtl/cpl_write.v")
srcs.append("../lib/corundum/rtl/cpl_op_mux.v")
srcs.append("../lib/corundum/rtl/desc_fetch.v")
srcs.append("../lib/corundum/rtl/desc_op_mux.v")
srcs.append("../lib/corundum/rtl/queue_manager.v")
srcs.append("../lib/corundum/rtl/cpl_queue_manager.v")
srcs.append("../lib/corundum/rtl/tx_engine.v")
srcs.append("../lib/corundum/rtl/rx_engine.v")
srcs.append("../lib/corundum/rtl/tx_checksum.v")
srcs.append("../lib/corundum/rtl/rx_checksum.v")
srcs.append("../lib/corundum/rtl/tx_scheduler_rr.v")
srcs.append("../lib/corundum/rtl/tdma_scheduler.v")
srcs.append("../lib/corundum/rtl/event_mux.v")

src = ' '.join(srcs)

build_cmd = "iverilog -o %s.vvp %s" % (testbench, src)

def bench():

    # Parameters
    AXIS_PCIE_DATA_WIDTH = 256
    AXIS_PCIE_KEEP_WIDTH = (AXIS_PCIE_DATA_WIDTH/32)
    AXIS_PCIE_RC_USER_WIDTH = 75
    AXIS_PCIE_RQ_USER_WIDTH = 60
    AXIS_PCIE_CQ_USER_WIDTH = 85
    AXIS_PCIE_CC_USER_WIDTH = 33
    BAR0_APERTURE = 24

    SEND_COUNT_0 = 50
    SEND_COUNT_1 = 50
    SIZE_0       = 500 - 18 
    SIZE_1       = 500 - 18
    CHECK_PKT    = True
    TEST_SFP     = True
    TEST_PCIE    = True
    UPDATE_INS   = True
    FIRMWARE     = "../../../../c_code/dram_test.bin"
    # FIRMWARE     = "../../../../c_code/inter_core.bin"

    # Inputs
    sys_clk  = Signal(bool(0))
    sys_rst  = Signal(bool(0))
    pcie_clk  = Signal(bool(0))
    pcie_rst  = Signal(bool(0))
    core_clk = Signal(bool(0))
    core_rst = Signal(bool(0))
    sys_clk_to_pcie=Signal(bool(0))
    sys_rst_to_pcie=Signal(bool(0))
    current_test = Signal(intbv(0)[8:])
    sfp_1_tx_clk = Signal(bool(0))
    sfp_1_tx_rst = Signal(bool(0))
    sfp_1_rx_clk = Signal(bool(0))
    sfp_1_rx_rst = Signal(bool(0))
    sfp_2_tx_clk = Signal(bool(0))
    sfp_2_tx_rst = Signal(bool(0))
    sfp_2_rx_clk = Signal(bool(0))
    sfp_2_rx_rst = Signal(bool(0))

    m_axis_rq_tready = Signal(bool(0))
    s_axis_rc_tdata = Signal(intbv(0)[AXIS_PCIE_DATA_WIDTH:])
    s_axis_rc_tkeep = Signal(intbv(0)[AXIS_PCIE_KEEP_WIDTH:])
    s_axis_rc_tlast = Signal(bool(0))
    s_axis_rc_tuser = Signal(intbv(0)[AXIS_PCIE_RC_USER_WIDTH:])
    s_axis_rc_tvalid = Signal(bool(0))
    s_axis_cq_tdata = Signal(intbv(0)[AXIS_PCIE_DATA_WIDTH:])
    s_axis_cq_tkeep = Signal(intbv(0)[AXIS_PCIE_KEEP_WIDTH:])
    s_axis_cq_tlast = Signal(bool(0))
    s_axis_cq_tuser = Signal(intbv(0)[AXIS_PCIE_CQ_USER_WIDTH:])
    s_axis_cq_tvalid = Signal(bool(0))
    m_axis_cc_tready = Signal(bool(0))
    pcie_tfc_nph_av = Signal(intbv(0)[2:])
    pcie_tfc_npd_av = Signal(intbv(0)[2:])
    cfg_max_payload = Signal(intbv(0)[3:])
    cfg_max_read_req = Signal(intbv(0)[3:])
    cfg_mgmt_read_data = Signal(intbv(0)[32:])
    cfg_mgmt_read_write_done = Signal(bool(0))
    cfg_interrupt_msi_enable = Signal(intbv(0)[4:])
    cfg_interrupt_msi_vf_enable = Signal(intbv(0)[8:])
    cfg_interrupt_msi_mmenable = Signal(intbv(0)[12:])
    cfg_interrupt_msi_mask_update = Signal(bool(0))
    cfg_interrupt_msi_data = Signal(intbv(0)[32:])
    cfg_interrupt_msi_sent = Signal(bool(0))
    cfg_interrupt_msi_fail = Signal(bool(0))
    sfp_1_tx_clk = Signal(bool(0))
    sfp_1_tx_rst = Signal(bool(0))
    sfp_1_rx_clk = Signal(bool(0))
    sfp_1_rx_rst = Signal(bool(0))
    sfp_1_rxd = Signal(intbv(0)[64:])
    sfp_1_rxc = Signal(intbv(0)[8:])
    sfp_2_tx_clk = Signal(bool(0))
    sfp_2_tx_rst = Signal(bool(0))
    sfp_2_rx_clk = Signal(bool(0))
    sfp_2_rx_rst = Signal(bool(0))
    sfp_2_rxd = Signal(intbv(0)[64:])
    sfp_2_rxc = Signal(intbv(0)[8:])
    sfp_i2c_scl_i = Signal(bool(1))
    sfp_1_i2c_sda_i = Signal(bool(1))
    sfp_2_i2c_sda_i = Signal(bool(1))
    eeprom_i2c_scl_i = Signal(bool(1))
    eeprom_i2c_sda_i = Signal(bool(1))
    flash_dq_i = Signal(intbv(0)[16:])

    # Outputs
    sma_led = Signal(intbv(0)[2:])
    m_axis_rq_tdata = Signal(intbv(0)[AXIS_PCIE_DATA_WIDTH:])
    m_axis_rq_tkeep = Signal(intbv(0)[AXIS_PCIE_KEEP_WIDTH:])
    m_axis_rq_tlast = Signal(bool(0))
    m_axis_rq_tuser = Signal(intbv(0)[AXIS_PCIE_RQ_USER_WIDTH:])
    m_axis_rq_tvalid = Signal(bool(0))
    s_axis_rc_tready = Signal(bool(0))
    s_axis_cq_tready = Signal(bool(0))
    m_axis_cc_tdata = Signal(intbv(0)[AXIS_PCIE_DATA_WIDTH:])
    m_axis_cc_tkeep = Signal(intbv(0)[AXIS_PCIE_KEEP_WIDTH:])
    m_axis_cc_tlast = Signal(bool(0))
    m_axis_cc_tuser = Signal(intbv(0)[AXIS_PCIE_CC_USER_WIDTH:])
    m_axis_cc_tvalid = Signal(bool(0))
    status_error_cor = Signal(bool(0))
    status_error_uncor = Signal(bool(0))
    cfg_mgmt_addr = Signal(intbv(0)[19:])
    cfg_mgmt_write = Signal(bool(0))
    cfg_mgmt_write_data = Signal(intbv(0)[32:])
    cfg_mgmt_byte_enable = Signal(intbv(0)[4:])
    cfg_mgmt_read = Signal(bool(0))
    cfg_interrupt_msi_int = Signal(intbv(0)[32:])
    cfg_interrupt_msi_pending_status = Signal(intbv(0)[32:])
    cfg_interrupt_msi_select = Signal(intbv(0)[4:])
    cfg_interrupt_msi_pending_status_function_num = Signal(intbv(0)[4:])
    cfg_interrupt_msi_pending_status_data_enable = Signal(bool(0))
    cfg_interrupt_msi_attr = Signal(intbv(0)[3:])
    cfg_interrupt_msi_tph_present = Signal(bool(0))
    cfg_interrupt_msi_tph_type = Signal(intbv(0)[2:])
    cfg_interrupt_msi_tph_st_tag = Signal(intbv(0)[9:])
    cfg_interrupt_msi_function_number = Signal(intbv(0)[4:])
    sfp_1_txd = Signal(intbv(0)[64:])
    sfp_1_txc = Signal(intbv(0)[8:])
    sfp_2_txd = Signal(intbv(0)[64:])
    sfp_2_txc = Signal(intbv(0)[8:])
    sfp_i2c_scl_o = Signal(bool(1))
    sfp_i2c_scl_t = Signal(bool(1))
    sfp_1_i2c_sda_o = Signal(bool(1))
    sfp_1_i2c_sda_t = Signal(bool(1))
    sfp_2_i2c_sda_o = Signal(bool(1))
    sfp_2_i2c_sda_t = Signal(bool(1))
    eeprom_i2c_scl_o = Signal(bool(1))
    eeprom_i2c_scl_t = Signal(bool(1))
    eeprom_i2c_sda_o = Signal(bool(1))
    eeprom_i2c_sda_t = Signal(bool(1))
    flash_dq_o = Signal(intbv(0)[16:])
    flash_dq_oe = Signal(bool(0))
    flash_addr = Signal(intbv(0)[23:])
    flash_region = Signal(bool(0))
    flash_region_oe = Signal(bool(0))
    flash_ce_n = Signal(bool(1))
    flash_oe_n = Signal(bool(1))
    flash_we_n = Signal(bool(1))
    flash_adv_n = Signal(bool(1))

    # sources and sinks
    xgmii_source_0 = xgmii_ep.XGMIISource()

    xgmii_source_logic_0 = xgmii_source_0.create_logic(
        clk=sfp_1_rx_clk,
        rst=sfp_1_rx_rst,
        txd=sfp_1_rxd,
        txc=sfp_1_rxc,
        name='xgmii_source_0'
    )

    xgmii_sink_0 = xgmii_ep.XGMIISink()

    xgmii_sink_logic_0 = xgmii_sink_0.create_logic(
        clk=sfp_1_tx_clk,
        rst=sfp_1_tx_rst,
        rxd=sfp_1_txd,
        rxc=sfp_1_txc,
        name='xgmii_sink_0'
    )
    
    xgmii_source_1 = xgmii_ep.XGMIISource()

    xgmii_source_logic_1 = xgmii_source_1.create_logic(
        clk=sfp_2_rx_clk,
        rst=sfp_2_rx_rst,
        txd=sfp_2_rxd,
        txc=sfp_2_rxc,
        name='xgmii_source_1'
    )

    xgmii_sink_1 = xgmii_ep.XGMIISink()

    xgmii_sink_logic_1 = xgmii_sink_1.create_logic(
        clk=sfp_2_tx_clk,
        rst=sfp_2_tx_rst,
        rxd=sfp_2_txd,
        rxc=sfp_2_txc,
        name='xgmii_sink_1'
    )
    
    # PCIe devices
    rc = pcie.RootComplex()

    mem_base, mem_data = rc.alloc_region(16*1024*1024)

    dev = pcie_us.UltrascalePCIe()

    dev.pcie_generation = 3
    dev.pcie_link_width = 8
    dev.user_clock_frequency = 256e6

    dev.functions[0].msi_multiple_message_capable = 5

    dev.functions[0].configure_bar(0, 2**BAR0_APERTURE)

    rc.make_port().connect(dev)

    pcie_logic = dev.create_logic(
        # Completer reQuest Interface
        m_axis_cq_tdata=s_axis_cq_tdata,
        m_axis_cq_tuser=s_axis_cq_tuser,
        m_axis_cq_tlast=s_axis_cq_tlast,
        m_axis_cq_tkeep=s_axis_cq_tkeep,
        m_axis_cq_tvalid=s_axis_cq_tvalid,
        m_axis_cq_tready=s_axis_cq_tready,
        #pcie_cq_np_req=pcie_cq_np_req,
        pcie_cq_np_req=Signal(bool(1)),
        #pcie_cq_np_req_count=pcie_cq_np_req_count,

        # Completer Completion Interface
        s_axis_cc_tdata=m_axis_cc_tdata,
        s_axis_cc_tuser=m_axis_cc_tuser,
        s_axis_cc_tlast=m_axis_cc_tlast,
        s_axis_cc_tkeep=m_axis_cc_tkeep,
        s_axis_cc_tvalid=m_axis_cc_tvalid,
        s_axis_cc_tready=m_axis_cc_tready,

        # Requester reQuest Interface
        s_axis_rq_tdata=m_axis_rq_tdata,
        s_axis_rq_tuser=m_axis_rq_tuser,
        s_axis_rq_tlast=m_axis_rq_tlast,
        s_axis_rq_tkeep=m_axis_rq_tkeep,
        s_axis_rq_tvalid=m_axis_rq_tvalid,
        s_axis_rq_tready=m_axis_rq_tready,
        #pcie_rq_seq_num=pcie_rq_seq_num,
        #pcie_rq_seq_num_vld=pcie_rq_seq_num_vld,
        #pcie_rq_tag=pcie_rq_tag,
        #pcie_rq_tag_vld=pcie_rq_tag_vld,

        # Requester Completion Interface
        m_axis_rc_tdata=s_axis_rc_tdata,
        m_axis_rc_tuser=s_axis_rc_tuser,
        m_axis_rc_tlast=s_axis_rc_tlast,
        m_axis_rc_tkeep=s_axis_rc_tkeep,
        m_axis_rc_tvalid=s_axis_rc_tvalid,
        m_axis_rc_tready=s_axis_rc_tready,

        # Transmit Flow Control Interface
        pcie_tfc_nph_av=pcie_tfc_nph_av,
        pcie_tfc_npd_av=pcie_tfc_npd_av,

        # Configuration Management Interface
        cfg_mgmt_addr=cfg_mgmt_addr,
        cfg_mgmt_write=cfg_mgmt_write,
        cfg_mgmt_write_data=cfg_mgmt_write_data,
        cfg_mgmt_byte_enable=cfg_mgmt_byte_enable,
        cfg_mgmt_read=cfg_mgmt_read,
        cfg_mgmt_read_data=cfg_mgmt_read_data,
        cfg_mgmt_read_write_done=cfg_mgmt_read_write_done,
        #cfg_mgmt_type1_cfg_reg_access=cfg_mgmt_type1_cfg_reg_access,

        # Configuration Status Interface
        #cfg_phy_link_down=cfg_phy_link_down,
        #cfg_phy_link_status=cfg_phy_link_status,
        #cfg_negotiated_width=cfg_negotiated_width,
        #cfg_current_speed=cfg_current_speed,
        cfg_max_payload=cfg_max_payload,
        cfg_max_read_req=cfg_max_read_req,
        #cfg_function_status=cfg_function_status,
        #cfg_vf_status=cfg_vf_status,
        #cfg_function_power_state=cfg_function_power_state,
        #cfg_vf_power_state=cfg_vf_power_state,
        #cfg_link_power_state=cfg_link_power_state,
        #cfg_err_cor_out=cfg_err_cor_out,
        #cfg_err_nonfatal_out=cfg_err_nonfatal_out,
        #cfg_err_fatal_out=cfg_err_fatal_out,
        #cfg_ltr_enable=cfg_ltr_enable,
        #cfg_ltssm_state=cfg_ltssm_state,
        #cfg_rcb_status=cfg_rcb_status,
        #cfg_dpa_substate_change=cfg_dpa_substate_change,
        #cfg_obff_enable=cfg_obff_enable,
        #cfg_pl_status_change=cfg_pl_status_change,
        #cfg_tph_requester_enable=cfg_tph_requester_enable,
        #cfg_tph_st_mode=cfg_tph_st_mode,
        #cfg_vf_tph_requester_enable=cfg_vf_tph_requester_enable,
        #cfg_vf_tph_st_mode=cfg_vf_tph_st_mode,

        # Configuration Received Message Interface
        #cfg_msg_received=cfg_msg_received,
        #cfg_msg_received_data=cfg_msg_received_data,
        #cfg_msg_received_type=cfg_msg_received_type,

        # Configuration Transmit Message Interface
        #cfg_msg_transmit=cfg_msg_transmit,
        #cfg_msg_transmit_type=cfg_msg_transmit_type,
        #cfg_msg_transmit_data=cfg_msg_transmit_data,
        #cfg_msg_transmit_done=cfg_msg_transmit_done,

        # Configuration Flow Control Interface
        #cfg_fc_ph=cfg_fc_ph,
        #cfg_fc_pd=cfg_fc_pd,
        #cfg_fc_nph=cfg_fc_nph,
        #cfg_fc_npd=cfg_fc_npd,
        #cfg_fc_cplh=cfg_fc_cplh,
        #cfg_fc_cpld=cfg_fc_cpld,
        #cfg_fc_sel=cfg_fc_sel,

        # Per-Function Status Interface
        #cfg_per_func_status_control=cfg_per_func_status_control,
        #cfg_per_func_status_data=cfg_per_func_status_data,

        # Configuration Control Interface
        #cfg_hot_reset_in=cfg_hot_reset_in,
        #cfg_hot_reset_out=cfg_hot_reset_out,
        #cfg_config_space_enable=cfg_config_space_enable,
        #cfg_per_function_update_done=cfg_per_function_update_done,
        #cfg_per_function_number=cfg_per_function_number,
        #cfg_per_function_output_request=cfg_per_function_output_request,
        #cfg_dsn=cfg_dsn,
        #cfg_ds_bus_number=cfg_ds_bus_number,
        #cfg_ds_device_number=cfg_ds_device_number,
        #cfg_ds_function_number=cfg_ds_function_number,
        #cfg_power_state_change_ack=cfg_power_state_change_ack,
        #cfg_power_state_change_interrupt=cfg_power_state_change_interrupt,
        cfg_err_cor_in=status_error_cor,
        cfg_err_uncor_in=status_error_uncor,
        #cfg_flr_done=cfg_flr_done,
        #cfg_vf_flr_done=cfg_vf_flr_done,
        #cfg_flr_in_process=cfg_flr_in_process,
        #cfg_vf_flr_in_process=cfg_vf_flr_in_process,
        #cfg_req_pm_transition_l23_ready=cfg_req_pm_transition_l23_ready,
        #cfg_link_training_enable=cfg_link_training_enable,

        # Configuration Interrupt Controller Interface
        #cfg_interrupt_int=cfg_interrupt_int,
        #cfg_interrupt_sent=cfg_interrupt_sent,
        #cfg_interrupt_pending=cfg_interrupt_pending,
        cfg_interrupt_msi_enable=cfg_interrupt_msi_enable,
        cfg_interrupt_msi_vf_enable=cfg_interrupt_msi_vf_enable,
        cfg_interrupt_msi_mmenable=cfg_interrupt_msi_mmenable,
        cfg_interrupt_msi_mask_update=cfg_interrupt_msi_mask_update,
        cfg_interrupt_msi_data=cfg_interrupt_msi_data,
        cfg_interrupt_msi_select=cfg_interrupt_msi_select,
        cfg_interrupt_msi_int=cfg_interrupt_msi_int,
        cfg_interrupt_msi_pending_status=cfg_interrupt_msi_pending_status,
        cfg_interrupt_msi_pending_status_data_enable=cfg_interrupt_msi_pending_status_data_enable,
        cfg_interrupt_msi_pending_status_function_num=cfg_interrupt_msi_pending_status_function_num,
        cfg_interrupt_msi_sent=cfg_interrupt_msi_sent,
        cfg_interrupt_msi_fail=cfg_interrupt_msi_fail,
        #cfg_interrupt_msix_enable=cfg_interrupt_msix_enable,
        #cfg_interrupt_msix_mask=cfg_interrupt_msix_mask,
        #cfg_interrupt_msix_vf_enable=cfg_interrupt_msix_vf_enable,
        #cfg_interrupt_msix_vf_mask=cfg_interrupt_msix_vf_mask,
        #cfg_interrupt_msix_address=cfg_interrupt_msix_address,
        #cfg_interrupt_msix_data=cfg_interrupt_msix_data,
        #cfg_interrupt_msix_int=cfg_interrupt_msix_int,
        #cfg_interrupt_msix_sent=cfg_interrupt_msix_sent,
        #cfg_interrupt_msix_fail=cfg_interrupt_msix_fail,
        cfg_interrupt_msi_attr=cfg_interrupt_msi_attr,
        cfg_interrupt_msi_tph_present=cfg_interrupt_msi_tph_present,
        cfg_interrupt_msi_tph_type=cfg_interrupt_msi_tph_type,
        cfg_interrupt_msi_tph_st_tag=cfg_interrupt_msi_tph_st_tag,
        cfg_interrupt_msi_function_number=cfg_interrupt_msi_function_number,

        # Configuration Extend Interface
        #cfg_ext_read_received=cfg_ext_read_received,
        #cfg_ext_write_received=cfg_ext_write_received,
        #cfg_ext_register_number=cfg_ext_register_number,
        #cfg_ext_function_number=cfg_ext_function_number,
        #cfg_ext_write_data=cfg_ext_write_data,
        #cfg_ext_write_byte_enable=cfg_ext_write_byte_enable,
        #cfg_ext_read_data=cfg_ext_read_data,
        #cfg_ext_read_data_valid=cfg_ext_read_data_valid,

        # Clock and Reset Interface
        user_clk=pcie_clk,
        user_reset=pcie_rst,
        sys_clk=sys_clk_to_pcie,
        sys_clk_gt=sys_clk_to_pcie,
        sys_reset=sys_rst_to_pcie,
        #pcie_perstn0_out=pcie_perstn0_out,
        #pcie_perstn1_in=pcie_perstn1_in,
        #pcie_perstn1_out=pcie_perstn1_out
    )

    # test frames
    test_frame_1 = eth_ep.EthFrame()
    test_frame_1.eth_dest_mac = 0xDAD1D2D3D4D5
    test_frame_1.eth_src_mac = 0x5A5152535455
    test_frame_1.eth_type = 0x8000
    test_frame_1.payload = bytes([0]+[x%256 for x in range(SIZE_0-1)])
    test_frame_1.update_fcs()
    axis_frame = test_frame_1.build_axis_fcs()
    start_data_1 = bytearray(b'\x55\x55\x55\x55\x55\x55\x55\xD5' + bytearray(axis_frame))

    test_frame_2 = eth_ep.EthFrame()
    test_frame_2.eth_dest_mac = 0x5A5152535455
    test_frame_2.eth_src_mac = 0xDAD1D2D3D4D5
    test_frame_2.eth_type = 0x8000
    test_frame_2.payload = bytes([0]+[x%256 for x in range(SIZE_1-1)])
    test_frame_2.update_fcs()
    axis_frame_2 = test_frame_2.build_axis_fcs()
    start_data_2 = bytearray(b'\x55\x55\x55\x55\x55\x55\x55\xD5' + bytearray(axis_frame_2))
 
    # DUT
    if os.system(build_cmd):
        raise Exception("Error running build command")

    dut = Cosimulation(
        "vvp -m myhdl %s.vvp -lxt2" % testbench,
        sys_clk=sys_clk,
        sys_rst=sys_rst,
        core_clk=core_clk,
        core_rst=core_rst,
        pcie_clk=pcie_clk,
        pcie_rst=pcie_rst,
        current_test=current_test,
        sfp_1_rx_clk=sfp_1_rx_clk,
        sfp_1_rx_rst=sfp_1_rx_rst,
        sfp_1_tx_clk=sfp_1_tx_clk,
        sfp_1_tx_rst=sfp_1_tx_rst,
        sfp_2_rx_clk=sfp_2_rx_clk,
        sfp_2_rx_rst=sfp_2_rx_rst,
        sfp_2_tx_clk=sfp_2_tx_clk,
        sfp_2_tx_rst=sfp_2_tx_rst,

        sfp_1_rxd=sfp_1_rxd,
        sfp_1_rxc=sfp_1_rxc,
        sfp_1_txd=sfp_1_txd,
        sfp_1_txc=sfp_1_txc,
        sfp_2_rxd=sfp_2_rxd,
        sfp_2_rxc=sfp_2_rxc,
        sfp_2_txd=sfp_2_txd,
        sfp_2_txc=sfp_2_txc,
        sma_led=sma_led,
        m_axis_rq_tdata=m_axis_rq_tdata,
        m_axis_rq_tkeep=m_axis_rq_tkeep,
        m_axis_rq_tlast=m_axis_rq_tlast,
        m_axis_rq_tready=m_axis_rq_tready,
        m_axis_rq_tuser=m_axis_rq_tuser,
        m_axis_rq_tvalid=m_axis_rq_tvalid,
        s_axis_rc_tdata=s_axis_rc_tdata,
        s_axis_rc_tkeep=s_axis_rc_tkeep,
        s_axis_rc_tlast=s_axis_rc_tlast,
        s_axis_rc_tready=s_axis_rc_tready,
        s_axis_rc_tuser=s_axis_rc_tuser,
        s_axis_rc_tvalid=s_axis_rc_tvalid,
        s_axis_cq_tdata=s_axis_cq_tdata,
        s_axis_cq_tkeep=s_axis_cq_tkeep,
        s_axis_cq_tlast=s_axis_cq_tlast,
        s_axis_cq_tready=s_axis_cq_tready,
        s_axis_cq_tuser=s_axis_cq_tuser,
        s_axis_cq_tvalid=s_axis_cq_tvalid,
        m_axis_cc_tdata=m_axis_cc_tdata,
        m_axis_cc_tkeep=m_axis_cc_tkeep,
        m_axis_cc_tlast=m_axis_cc_tlast,
        m_axis_cc_tready=m_axis_cc_tready,
        m_axis_cc_tuser=m_axis_cc_tuser,
        m_axis_cc_tvalid=m_axis_cc_tvalid,
        pcie_tfc_nph_av=pcie_tfc_nph_av,
        pcie_tfc_npd_av=pcie_tfc_npd_av,
        cfg_max_payload=cfg_max_payload,
        cfg_max_read_req=cfg_max_read_req,
        cfg_mgmt_addr=cfg_mgmt_addr,
        cfg_mgmt_write=cfg_mgmt_write,
        cfg_mgmt_write_data=cfg_mgmt_write_data,
        cfg_mgmt_byte_enable=cfg_mgmt_byte_enable,
        cfg_mgmt_read=cfg_mgmt_read,
        cfg_mgmt_read_data=cfg_mgmt_read_data,
        cfg_mgmt_read_write_done=cfg_mgmt_read_write_done,
        cfg_interrupt_msi_enable=cfg_interrupt_msi_enable,
        cfg_interrupt_msi_vf_enable=cfg_interrupt_msi_vf_enable,
        cfg_interrupt_msi_int=cfg_interrupt_msi_int,
        cfg_interrupt_msi_sent=cfg_interrupt_msi_sent,
        cfg_interrupt_msi_fail=cfg_interrupt_msi_fail,
        cfg_interrupt_msi_mmenable=cfg_interrupt_msi_mmenable,
        cfg_interrupt_msi_pending_status=cfg_interrupt_msi_pending_status,
        cfg_interrupt_msi_mask_update=cfg_interrupt_msi_mask_update,
        cfg_interrupt_msi_select=cfg_interrupt_msi_select,
        cfg_interrupt_msi_data=cfg_interrupt_msi_data,
        cfg_interrupt_msi_pending_status_function_num=cfg_interrupt_msi_pending_status_function_num,
        cfg_interrupt_msi_pending_status_data_enable=cfg_interrupt_msi_pending_status_data_enable,
        cfg_interrupt_msi_attr=cfg_interrupt_msi_attr,
        cfg_interrupt_msi_tph_present=cfg_interrupt_msi_tph_present,
        cfg_interrupt_msi_tph_type=cfg_interrupt_msi_tph_type,
        cfg_interrupt_msi_tph_st_tag=cfg_interrupt_msi_tph_st_tag,
        cfg_interrupt_msi_function_number=cfg_interrupt_msi_function_number,
        status_error_cor=status_error_cor,
        status_error_uncor=status_error_uncor,
        sfp_i2c_scl_i=sfp_i2c_scl_i,
        sfp_i2c_scl_o=sfp_i2c_scl_o,
        sfp_i2c_scl_t=sfp_i2c_scl_t,
        sfp_1_i2c_sda_i=sfp_1_i2c_sda_i,
        sfp_1_i2c_sda_o=sfp_1_i2c_sda_o,
        sfp_1_i2c_sda_t=sfp_1_i2c_sda_t,
        sfp_2_i2c_sda_i=sfp_2_i2c_sda_i,
        sfp_2_i2c_sda_o=sfp_2_i2c_sda_o,
        sfp_2_i2c_sda_t=sfp_2_i2c_sda_t,
        eeprom_i2c_scl_i=eeprom_i2c_scl_i,
        eeprom_i2c_scl_o=eeprom_i2c_scl_o,
        eeprom_i2c_scl_t=eeprom_i2c_scl_t,
        eeprom_i2c_sda_i=eeprom_i2c_sda_i,
        eeprom_i2c_sda_o=eeprom_i2c_sda_o,
        eeprom_i2c_sda_t=eeprom_i2c_sda_t,
        flash_dq_i=flash_dq_i,
        flash_dq_o=flash_dq_o,
        flash_dq_oe=flash_dq_oe,
        flash_addr=flash_addr,
        flash_region=flash_region,
        flash_region_oe=flash_region_oe,
        flash_ce_n=flash_ce_n,
        flash_oe_n=flash_oe_n,
        flash_we_n=flash_we_n,
        flash_adv_n=flash_adv_n
    )

    @always(delay(2)) #25
    def clkgen():
        sys_clk.next = not sys_clk
    
    @always(delay(3)) #27
    def clkgen3():
        core_clk.next = not core_clk

    @always(delay(3)) #32
    def clkgen2():
        sfp_1_tx_clk.next = not sfp_1_tx_clk
        sfp_1_rx_clk.next = not sfp_1_rx_clk
        sfp_2_tx_clk.next = not sfp_2_tx_clk
        sfp_2_rx_clk.next = not sfp_2_rx_clk
    
    @always_comb
    def clk_logic():
        sys_clk_to_pcie.next = sys_clk
        sys_rst_to_pcie.next = not sys_rst

    def port1():
        for i in range (0,SEND_COUNT_0):
          # test_frame_1.payload = bytes([x%256 for x in range(random.randrange(1980))])
          test_frame_1.payload = bytes([i%256] + [x%256 for x in range(SIZE_0-1)])
          test_frame_1.update_fcs()
          axis_frame = test_frame_1.build_axis_fcs()
          xgmii_source_0.send(b'\x55\x55\x55\x55\x55\x55\x55\xD5'+bytearray(axis_frame))
          # yield delay(random.randrange(128))
          yield sfp_1_rx_clk.posedge
          # yield sfp_1_rx_clk.posedge

    def port2():
        for i in range (0,SEND_COUNT_1):
          # test_frame_2.payload = bytes([x%256 for x in range(10,10+random.randrange(300))])
          # if (i%20==19):
          #   test_frame_2.payload = bytes([x%256 for x in range(78-14)])
          # else:
          test_frame_2.payload = bytes([i%256] + [x%256 for x in range(SIZE_1-1)])
          test_frame_2.update_fcs()
          axis_frame_2 = test_frame_2.build_axis_fcs()
          xgmii_source_1.send(b'\x55\x55\x55\x55\x55\x55\x55\xD5'+bytearray(axis_frame_2))
          # yield delay(random.randrange(128))
          yield sfp_2_rx_clk.posedge
          # yield sfp_2_rx_clk.posedge

    @instance
    def check():
        yield delay(1000)
        yield sys_clk.posedge
        sys_rst.next = 1
        yield core_clk.posedge
        core_rst.next = 1
        yield sfp_1_tx_clk.posedge
        yield sfp_1_rx_clk.posedge
        yield sfp_2_tx_clk.posedge
        yield sfp_2_rx_clk.posedge
        yield sys_clk.posedge
        sfp_1_tx_rst.next = 1
        sfp_1_rx_rst.next = 1
        sfp_2_tx_rst.next = 1
        sfp_2_rx_rst.next = 1
        yield sys_clk.posedge
        yield sys_clk.posedge
        sys_rst.next = 0
        yield core_clk.posedge
        core_rst.next = 0
        yield sys_clk.posedge
        yield sfp_1_tx_clk.posedge
        sfp_1_tx_rst.next = 0
        sfp_1_rx_rst.next = 0
        sfp_2_tx_rst.next = 0
        sfp_2_rx_rst.next = 0
        yield sfp_1_tx_clk.posedge
        yield delay(2000)
        yield sys_clk.posedge
        yield sys_clk.posedge
        
        print("PCIe enumeration")

        yield rc.enumerate(enable_bus_mastering=True, configure_msi=True)

        dev_pf0_bar0 = dev.functions[0].bar[0] & 0xfffffffc

        yield delay(100)

        yield pcie_clk.posedge

                # enable DMA
        yield rc.mem_write(dev_pf0_bar0+0x000400, struct.pack('<L', 1))
        
        if (UPDATE_INS):
          print("Firmware load")
          ins = bytearray(open(FIRMWARE, "rb").read())
          mem_data[0:len(ins)] = ins

          yield rc.mem_write(dev_pf0_bar0+0x00040C, struct.pack('<L', 0xffff))
          
          # Load instruction memories
          for i in range (0,16):
              yield rc.mem_write(dev_pf0_bar0+0x000404, struct.pack('<L', ((i<<1)+1)))
              yield delay(20)
              # write pcie read descriptor
              yield rc.mem_write(dev_pf0_bar0+0x000440, struct.pack('<L', (mem_base+0x0000) & 0xffffffff))
              yield rc.mem_write(dev_pf0_bar0+0x000444, struct.pack('<L', (mem_base+0x0000 >> 32) & 0xffffffff))
              yield rc.mem_write(dev_pf0_bar0+0x000448, struct.pack('<L', ((i<<16)+0x8000) & 0xffffffff))
              # yield rc.mem_write(dev_pf0_bar0+0x00044C, struct.pack('<L', (((i<<16)+0x8000) >> 32) & 0xffffffff))
              yield rc.mem_write(dev_pf0_bar0+0x000450, struct.pack('<L', 0x400))
              yield rc.mem_write(dev_pf0_bar0+0x000454, struct.pack('<L', 0xAA))
              yield delay(2000)
              yield rc.mem_write(dev_pf0_bar0+0x000404, struct.pack('<L', ((i<<1)+0)))
              yield delay(20)
          
          yield rc.mem_write(dev_pf0_bar0+0x00040C, struct.pack('<L', 0x0000))
        
        yield rc.mem_write(dev_pf0_bar0+0x000408, struct.pack('<L', 0x0f00))

        if (TEST_PCIE):
          print("PCIE tests")
          mem_data[48059:48200] = bytearray([(x+10)%256 for x in range(141)])

          # write pcie read descriptor
          yield rc.mem_write(dev_pf0_bar0+0x000440, struct.pack('<L', (mem_base+0x0000) & 0xffffffff))
          yield rc.mem_write(dev_pf0_bar0+0x000444, struct.pack('<L', (mem_base+0x0000 >> 32) & 0xffffffff))
          yield rc.mem_write(dev_pf0_bar0+0x000448, struct.pack('<L', ((4<<16)+0x0100) & 0xffffffff))
          # yield rc.mem_write(dev_pf0_bar0+0x00044C, struct.pack('<L', (((4<<16)+0x0100) >> 32) & 0xffffffff))
          yield rc.mem_write(dev_pf0_bar0+0x000450, struct.pack('<L', 0x400))
          yield rc.mem_write(dev_pf0_bar0+0x000454, struct.pack('<L', 0xAA))

          yield delay(2000)

          # read status
          val = yield from rc.mem_read(dev_pf0_bar0+0x000458, 4)
          print(val)

          # write pcie write descriptor
          yield rc.mem_write(dev_pf0_bar0+0x000460, struct.pack('<L', (mem_base+0x1000) & 0xffffffff))
          yield rc.mem_write(dev_pf0_bar0+0x000464, struct.pack('<L', (mem_base+0x1000 >> 32) & 0xffffffff))
          yield rc.mem_write(dev_pf0_bar0+0x000468, struct.pack('<L', (0x40100) & 0xffffffff))
          # yield rc.mem_write(dev_pf0_bar0+0x00046C, struct.pack('<L', (0x40100 >> 32) & 0xffffffff))
          yield rc.mem_write(dev_pf0_bar0+0x000470, struct.pack('<L', 0x400))
          yield rc.mem_write(dev_pf0_bar0+0x000474, struct.pack('<L', 0x55))

          yield delay(2000)

          # read status
          val = yield from rc.mem_read(dev_pf0_bar0+0x000478, 4)
          print(val)

          data = mem_data[0x1000:(0x1000)+1024]
          for i in range(0, len(data), 16):
              print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+16]))))

          print("core to host write data")
          data = mem_data[0xBCBB:(0xBCBB)+128]
          for i in range(0, len(data), 16):
              print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+16]))))

          assert mem_data[0:1024] == mem_data[0x1000:0x1000+1024]

        yield delay(1000)
       
        if (TEST_SFP):
          yield port1(),None
          yield port2(),None

          # yield delay(10000)
          # val = yield from rc.mem_read(dev_pf0_bar0+0x000410, 4)
          # print ("Moein read core 0 slot count:",val)
          # yield rc.mem_write(dev_pf0_bar0+0x00040C, struct.pack('<L', 1))
          # 
          # while (val[0]!=0x08):
          #   yield delay(2000)
          #   val = yield from rc.mem_read(dev_pf0_bar0+0x000410, 4)
          #   print ("Moein read core 0 slot count:",val)
          # 
          # yield rc.mem_write(dev_pf0_bar0+0x00040C, struct.pack('<L', 0))
          # 
          # yield rc.mem_write(dev_pf0_bar0+0x000410, struct.pack('<L', 5))
          # yield delay(200)
          # val = yield from rc.mem_read(dev_pf0_bar0+0x000410, 4)
          # print ("Moein read core 5 slot count:",val)
          # yield rc.mem_write(dev_pf0_bar0+0x00040C, struct.pack('<L', 0x0020))
          # 
          # while (val[0]!=0x08):
          #   yield delay(2000)
          #   val = yield from rc.mem_read(dev_pf0_bar0+0x000410, 4)
          #   print ("Moein read core 5 slot count:",val)
          # 
          # yield rc.mem_write(dev_pf0_bar0+0x00040C, struct.pack('<L', 0))

          lengths = []
          print ("send data from LAN")
          for j in range (0,SEND_COUNT_1):
            yield xgmii_sink_0.wait()
            rx_frame = xgmii_sink_0.recv()
            data = rx_frame.data
            print ("packet number from port 0:",j)
            for i in range(0, len(data), 16):
                print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+16]))))
            if (CHECK_PKT):
              assert rx_frame.data[0:22] == start_data_2[0:22]
              assert rx_frame.data[23:-4] == start_data_2[23:-4]
            lengths.append(len(data)-8)

          for j in range (0,SEND_COUNT_0):
            yield xgmii_sink_1.wait()
            rx_frame = xgmii_sink_1.recv()
            data = rx_frame.data
            print ("packet number from port 1:",j)
            for i in range(0, len(data), 16):
                print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+16]))))
            if (CHECK_PKT):
              assert rx_frame.data[0:22] == start_data_1[0:22]
              assert rx_frame.data[23:-4] == start_data_1[23:-4]
            lengths.append(len(data)-8)

          # print ("Very last packet:")
          # for i in range(0, len(data), 16):
          #     print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+16]))))
          print ("lengths: " , lengths)

          # eth_frame = eth_ep.EthFrame()
          # eth_frame.parse_axis_fcs(rx_frame.data[8:])

          # print(hex(eth_frame.eth_fcs))
          # print(hex(eth_frame.calc_fcs()))

          # assert len(eth_frame.payload.data) == 46
          # assert eth_frame.eth_fcs == eth_frame.calc_fcs()
          # assert eth_frame.eth_dest_mac == test_frame_1.eth_dest_mac
          # assert eth_frame.eth_src_mac == test_frame_1.eth_src_mac
          # assert eth_frame.eth_type == test_frame_1.eth_type
          # assert eth_frame.payload.data.index(test_frame_1.payload.data) == 0

        raise StopSimulation

    return instances()

def test_bench():
    sim = Simulation(bench())
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test_bench()

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

srcs.append("../rtl/simple_fifo.v")
srcs.append("../rtl/max_finder_tree.v")
srcs.append("../rtl/slot_fifo_loader.v")
srcs.append("../rtl/core_mems.v")
srcs.append("../rtl/axis_dma.v")
srcs.append("../rtl/VexRiscv.v")
srcs.append("../rtl/riscvcore.v")
srcs.append("../rtl/riscv_axis_wrapper.v")
srcs.append("../rtl/simple_scheduler.v")
srcs.append("../rtl/simple_sync_sig.v")
srcs.append("../rtl/axis_switch.v")
srcs.append("../rtl/loopback_msg_fifo.v")
srcs.append("../rtl/header.v")
srcs.append("../rtl/pcie_controller.v")
srcs.append("../rtl/fpga_core.v")

srcs.append("../lib/eth/rtl/eth_mac_10g_fifo.v")
srcs.append("../lib/eth/rtl/eth_mac_10g.v")
srcs.append("../lib/eth/rtl/axis_xgmii_rx_64.v")
srcs.append("../lib/eth/rtl/axis_xgmii_tx_64.v")
srcs.append("../lib/eth/rtl/lfsr.v")

srcs.append("../lib/axi/rtl/axi_ram.v")
srcs.append("../lib/axi/rtl/axi_ram_rd_if.v")
srcs.append("../lib/axi/rtl/axi_ram_wr_if.v")
srcs.append("../lib/axi/rtl/arbiter.v")
srcs.append("../lib/axi/rtl/priority_encoder.v")
srcs.append("../lib/axi/rtl/axi_dma.v")
srcs.append("../lib/axi/rtl/axi_dma_rd.v")
srcs.append("../lib/axi/rtl/axi_dma_wr.v")
srcs.append("../lib/axi/rtl/axi_interconnect.v")
srcs.append("../lib/axi/rtl/axi_crossbar_rd.v")
srcs.append("../lib/axi/rtl/axi_crossbar_wr.v")
srcs.append("../lib/axi/rtl/axi_crossbar_addr.v")
srcs.append("../lib/axi/rtl/axi_register_rd.v")
srcs.append("../lib/axi/rtl/axi_register_wr.v")
srcs.append("../lib/axi/rtl/axi_crossbar.v")

srcs.append("../lib/axis/rtl/axis_adapter.v")
srcs.append("../lib/axis/rtl/axis_arb_mux.v")
srcs.append("../lib/axis/rtl/axis_async_fifo.v")
srcs.append("../lib/axis/rtl/axis_async_fifo_adapter.v")
srcs.append("../lib/axis/rtl/axis_fifo.v")
srcs.append("../lib/axis/rtl/axis_fifo_adapter.v")
srcs.append("../lib/axis/rtl/axis_register.v")

srcs.append("../lib/pcie/rtl/pcie_us_axil_master.v")
srcs.append("../lib/pcie/rtl/pcie_us_axi_dma.v")
srcs.append("../lib/pcie/rtl/pcie_us_axi_dma_rd.v")
srcs.append("../lib/pcie/rtl/pcie_us_axi_dma_wr.v")
srcs.append("../lib/pcie/rtl/pcie_tag_manager.v")
srcs.append("../lib/pcie/rtl/pcie_us_axi_master.v")
srcs.append("../lib/pcie/rtl/pcie_us_axi_master_rd.v")
srcs.append("../lib/pcie/rtl/pcie_us_axi_master_wr.v")
srcs.append("../lib/pcie/rtl/pcie_us_axis_cq_demux.v")
srcs.append("../lib/pcie/rtl/pcie_us_cfg.v")
srcs.append("../lib/pcie/rtl/pcie_us_msi.v")
srcs.append("../lib/pcie/rtl/pulse_merge.v")
srcs.append("%s.v" % testbench)

src = ' '.join(srcs)

build_cmd = "iverilog -o %s.vvp %s" % (testbench, src)

def bench():

    # Parameters
    DATA_WIDTH = 64
    CTRL_WIDTH = (DATA_WIDTH/8)
    AXI_ADDR_WIDTH = 16

    SEND_COUNT_0 = 10
    SEND_COUNT_1 = 10
    SIZE_0       = 150 - 18 
    SIZE_1       = 150 - 18
    CHECK_PKT    = True
    TEST_SFP     = True
    TEST_PCIE    = False

    # Inputs
    sys_clk  = Signal(bool(0))
    sys_rst  = Signal(bool(0))
    pcie_clk  = Signal(bool(0))
    pcie_rst  = Signal(bool(0))
    core_clk = Signal(bool(0))
    core_rst = Signal(bool(0))
    sys_clk_to_pcie=Signal(bool(0))
    sys_rst_to_pcie=Signal(bool(0))
    sfp_1_tx_clk = Signal(bool(0))
    sfp_1_tx_rst = Signal(bool(0))
    sfp_1_rx_clk = Signal(bool(0))
    sfp_1_rx_rst = Signal(bool(0))
    sfp_2_tx_clk = Signal(bool(0))
    sfp_2_tx_rst = Signal(bool(0))
    sfp_2_rx_clk = Signal(bool(0))
    sfp_2_rx_rst = Signal(bool(0))

    sfp_1_rxd = Signal(intbv(0x0707070707070707)[DATA_WIDTH:])
    sfp_1_rxc = Signal(intbv(0xff)[CTRL_WIDTH:])
    sfp_2_rxd = Signal(intbv(0x0707070707070707)[DATA_WIDTH:])
    sfp_2_rxc = Signal(intbv(0xff)[CTRL_WIDTH:])
    
    m_axis_rq_tready = Signal(bool(0))
    s_axis_rc_tdata = Signal(intbv(0)[256:])
    s_axis_rc_tkeep = Signal(intbv(0)[8:])
    s_axis_rc_tlast = Signal(bool(0))
    s_axis_rc_tuser = Signal(intbv(0)[75:])
    s_axis_rc_tvalid = Signal(bool(0))
    s_axis_cq_tdata = Signal(intbv(0)[256:])
    s_axis_cq_tkeep = Signal(intbv(0)[8:])
    s_axis_cq_tlast = Signal(bool(0))
    s_axis_cq_tuser = Signal(intbv(0)[85:])
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

    # Outputs
    sfp_1_txd = Signal(intbv(0x0707070707070707)[DATA_WIDTH:])
    sfp_1_txc = Signal(intbv(0xff)[CTRL_WIDTH:])
    sfp_2_txd = Signal(intbv(0x0707070707070707)[DATA_WIDTH:])
    sfp_2_txc = Signal(intbv(0xff)[CTRL_WIDTH:])

    sma_led = Signal(intbv(0)[2:])
    
    m_axis_rq_tdata = Signal(intbv(0)[256:])
    m_axis_rq_tkeep = Signal(intbv(0)[8:])
    m_axis_rq_tlast = Signal(bool(0))
    m_axis_rq_tuser = Signal(intbv(0)[60:])
    m_axis_rq_tvalid = Signal(bool(0))
    s_axis_rc_tready = Signal(bool(0))
    s_axis_cq_tready = Signal(bool(0))
    m_axis_cc_tdata = Signal(intbv(0)[256:])
    m_axis_cc_tkeep = Signal(intbv(0)[8:])
    m_axis_cc_tlast = Signal(bool(0))
    m_axis_cc_tuser = Signal(intbv(0)[33:])
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
    dev.user_clock_frequency = 250e6

    dev.functions[0].msi_multiple_message_capable = 5

    dev.functions[0].configure_bar(0, 4*1024*1024)
    # dev.functions[0].configure_bar(1, 4*1024*1024)

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
    test_frame_1.payload = bytes([x%256 for x in range(SIZE_0)])
    test_frame_1.update_fcs()
    axis_frame = test_frame_1.build_axis_fcs()
    start_data_1 = bytearray(b'\x55\x55\x55\x55\x55\x55\x55\xD5' + bytearray(axis_frame))

    test_frame_2 = eth_ep.EthFrame()
    test_frame_2.eth_dest_mac = 0x5A5152535455
    test_frame_2.eth_src_mac = 0xDAD1D2D3D4D5
    test_frame_2.eth_type = 0x8000
    test_frame_2.payload = bytes([x%256 for x in range(SIZE_1)])
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
        status_error_uncor=status_error_uncor
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
          test_frame_1.payload = bytes([x%256 for x in range(SIZE_0)])
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
          test_frame_2.payload = bytes([x%256 for x in range(SIZE_1)])
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
       
        if (TEST_SFP):
          yield port1(),None
          yield port2(),None

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
              assert rx_frame.data[22:-4] == start_data_2[22:-4]
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
              assert rx_frame.data[22:-4] == start_data_1[22:-4]
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

        # PCIE test
        if (TEST_PCIE):
          print("PCIE tests")
          print("test 1: enumeration")

          yield rc.enumerate(enable_bus_mastering=True, configure_msi=True)

          dev_pf0_bar0 = dev.functions[0].bar[0] & 0xfffffffc
          # dev_pf0_bar1 = dev.functions[0].bar[1] & 0xfffffffc

          yield delay(100)

          yield pcie_clk.posedge
          # print("test 2: memory write to bar 1")

          # yield rc.mem_write(dev_pf0_bar1, b'\x11\x22\x33\x44')

          # yield delay(100)

          # yield pcie_clk.posedge
          # print("test 3: memory read from bar 1")

          # val = yield from rc.mem_read(dev_pf0_bar1, 4, 1000)
          # print(val)
          # assert val == b'\x11\x22\x33\x44'

          # yield delay(100)

          # yield pcie_clk.posedge
          print("test 4: test DMA")

          # write packet data
          mem_data[0:1024] = bytearray([x%256 for x in range(1024)])
          mem_data[48059:48200] = bytearray([(x+10)%256 for x in range(141)])


          # enable DMA
          yield rc.mem_write(dev_pf0_bar0+0x100000, struct.pack('<L', 1))

          # write pcie read descriptor
          yield rc.mem_write(dev_pf0_bar0+0x100100, struct.pack('<L', (mem_base+0x0000) & 0xffffffff))
          yield rc.mem_write(dev_pf0_bar0+0x100104, struct.pack('<L', (mem_base+0x0000 >> 32) & 0xffffffff))
          yield rc.mem_write(dev_pf0_bar0+0x100108, struct.pack('<L', (0x50100) & 0xffffffff))
          yield rc.mem_write(dev_pf0_bar0+0x10010C, struct.pack('<L', (0x50100 >> 32) & 0xffffffff))
          yield rc.mem_write(dev_pf0_bar0+0x100110, struct.pack('<L', 0x400))
          yield rc.mem_write(dev_pf0_bar0+0x100114, struct.pack('<L', 0xAA))

          yield delay(2000)

          # read status
          val = yield from rc.mem_read(dev_pf0_bar0+0x100118, 4)
          print(val)

          # write pcie write descriptor
          yield rc.mem_write(dev_pf0_bar0+0x100200, struct.pack('<L', (mem_base+0x1000) & 0xffffffff))
          yield rc.mem_write(dev_pf0_bar0+0x100204, struct.pack('<L', (mem_base+0x1000 >> 32) & 0xffffffff))
          yield rc.mem_write(dev_pf0_bar0+0x100208, struct.pack('<L', (0x50100) & 0xffffffff))
          yield rc.mem_write(dev_pf0_bar0+0x10020C, struct.pack('<L', (0x50100 >> 32) & 0xffffffff))
          yield rc.mem_write(dev_pf0_bar0+0x100210, struct.pack('<L', 0x400))
          yield rc.mem_write(dev_pf0_bar0+0x100214, struct.pack('<L', 0x55))

          yield delay(2000)

          # read status
          val = yield from rc.mem_read(dev_pf0_bar0+0x100218, 4)
          print(val)

          data = mem_data[0x1000:(0x1000)+64]
          for i in range(0, len(data), 16):
              print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+16]))))

          assert mem_data[0:1024] == mem_data[0x1000:0x1000+1024]

        yield delay(1000)

        raise StopSimulation

    return instances()

def test_bench():
    sim = Simulation(bench())
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test_bench()

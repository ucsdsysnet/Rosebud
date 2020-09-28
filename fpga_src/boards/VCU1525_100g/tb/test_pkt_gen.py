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
import pcie_usp
import eth_ep
import xgmii_ep
import axis_ep
import udp_ep

import struct
import mqnic

testbench = 'test_fpga_core'

srcs = []

srcs.append("../rtl/fpga_core.v")
srcs.append("../rtl/riscv_block_PR.v")
srcs.append("../rtl/RR_LU_scheduler_PR.v")
srcs.append("../rtl/pcie_config.v")
srcs.append("../ip/ila_5x64_stub.v")
srcs.append("../ip/ila_4x64_stub.v")
srcs.append("../ip/ila_2x64_stub.v")

srcs.append("../lib/smartFPGA/rtl/simple_fifo.v")
srcs.append("../lib/smartFPGA/rtl/max_finder_tree.v")
srcs.append("../lib/smartFPGA/rtl/slot_keeper.v")
srcs.append("../lib/smartFPGA/rtl/core_mems.v")
srcs.append("../lib/smartFPGA/rtl/axis_dma.v")
srcs.append("../lib/smartFPGA/rtl/VexRiscv.v")
srcs.append("../lib/smartFPGA/rtl/riscvcore.v")
srcs.append("../lib/smartFPGA/rtl/riscv_block.v")
srcs.append("../lib/smartFPGA/rtl/accel_wrap.v")
srcs.append("../lib/smartFPGA/rtl/riscv_axis_wrapper.v")
srcs.append("../lib/smartFPGA/rtl/mem_sys.v")
srcs.append("../lib/smartFPGA/rtl/simple_arbiter.v")
srcs.append("../lib/smartFPGA/rtl/simple_sync_sig.v")
srcs.append("../lib/smartFPGA/rtl/simple_axis_switch.v")
srcs.append("../lib/smartFPGA/rtl/axis_ram_switch.v")
srcs.append("../lib/smartFPGA/rtl/axis_stat.v")
srcs.append("../lib/smartFPGA/rtl/stat_reader.v")
srcs.append("../lib/smartFPGA/rtl/axis_switch_2lvl.v")
srcs.append("../lib/smartFPGA/rtl/loopback_msg_fifo.v")
srcs.append("../lib/smartFPGA/rtl/header.v")
srcs.append("../lib/smartFPGA/rtl/pcie_controller.v")
srcs.append("../lib/smartFPGA/rtl/pcie_cont_read.v")
srcs.append("../lib/smartFPGA/rtl/pcie_cont_write.v")
srcs.append("../lib/smartFPGA/rtl/corundum.v")
srcs.append("../lib/smartFPGA/rtl/axis_fifo.v")

srcs.append("../lib/axis/rtl/arbiter.v")
srcs.append("../lib/axis/rtl/priority_encoder.v")
srcs.append("../lib/axis/rtl/axis_adapter.v")
srcs.append("../lib/axis/rtl/axis_arb_mux.v")
srcs.append("../lib/axis/rtl/axis_async_fifo.v")
srcs.append("../lib/axis/rtl/axis_async_fifo_adapter.v")
# srcs.append("../lib/axis/rtl/axis_fifo.v")
srcs.append("../lib/axis/rtl/axis_fifo_adapter.v")
srcs.append("../lib/axis/rtl/axis_register.v")
srcs.append("../lib/axis/rtl/axis_pipeline_register.v")
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
srcs.append("../lib/corundum/rtl/rx_hash.v")
srcs.append("../lib/corundum/rtl/tx_scheduler_rr.v")
srcs.append("../lib/corundum/rtl/tdma_scheduler.v")
srcs.append("../lib/corundum/rtl/event_mux.v")

srcs.append("%s.v" % testbench)

src = ' '.join(srcs)

build_cmd = "iverilog -o %s.vvp %s" % (testbench, src)

def B_2_int(x):
  return int.from_bytes(x, byteorder='little')

def bench():

    # Parameters
    AXIS_PCIE_DATA_WIDTH = 512
    AXIS_PCIE_KEEP_WIDTH = (AXIS_PCIE_DATA_WIDTH/32)
    AXIS_PCIE_RC_USER_WIDTH = 161
    AXIS_PCIE_RQ_USER_WIDTH = 137
    AXIS_PCIE_CQ_USER_WIDTH = 183
    AXIS_PCIE_CC_USER_WIDTH = 81
    RQ_SEQ_NUM_WIDTH = 6
    BAR0_APERTURE = 24
    AXIS_ETH_DATA_WIDTH = 512
    AXIS_ETH_KEEP_WIDTH = AXIS_ETH_DATA_WIDTH/8

    PRINT_PKTS   = True
    FIRMWARE     = "../../../../c_code/pkt_gen_ins.bin"
    DATA         = ""
    # FIRMWARE     = "../../../../c_code/reg_test_ins.bin"
    # DATA         = "../../../../c_code/reg_test_data.bin"

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
    sw = Signal(intbv(0)[4:])
    i2c_scl_i = Signal(bool(1))
    i2c_sda_i = Signal(bool(1))
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
    s_axis_rq_seq_num_0 = Signal(intbv(0)[RQ_SEQ_NUM_WIDTH:])
    s_axis_rq_seq_num_valid_0 = Signal(bool(0))
    s_axis_rq_seq_num_1 = Signal(intbv(0)[RQ_SEQ_NUM_WIDTH:])
    s_axis_rq_seq_num_valid_1 = Signal(bool(0))
    pcie_tfc_nph_av = Signal(intbv(15)[4:])
    pcie_tfc_npd_av = Signal(intbv(15)[4:])
    cfg_max_payload = Signal(intbv(0)[2:])
    cfg_max_read_req = Signal(intbv(0)[3:])
    cfg_mgmt_read_data = Signal(intbv(0)[32:])
    cfg_mgmt_read_write_done = Signal(bool(0))
    cfg_fc_ph = Signal(intbv(0)[8:])
    cfg_fc_pd = Signal(intbv(0)[12:])
    cfg_fc_nph = Signal(intbv(0)[8:])
    cfg_fc_npd = Signal(intbv(0)[12:])
    cfg_fc_cplh = Signal(intbv(0)[8:])
    cfg_fc_cpld = Signal(intbv(0)[12:])
    cfg_interrupt_msi_enable = Signal(intbv(0)[4:])
    cfg_interrupt_msi_mmenable = Signal(intbv(0)[12:])
    cfg_interrupt_msi_mask_update = Signal(bool(0))
    cfg_interrupt_msi_data = Signal(intbv(0)[32:])
    cfg_interrupt_msi_sent = Signal(bool(0))
    cfg_interrupt_msi_fail = Signal(bool(0))
    qsfp0_tx_clk = Signal(bool(0))
    qsfp0_tx_rst = Signal(bool(0))
    qsfp0_rx_clk = Signal(bool(0))
    qsfp0_rx_rst = Signal(bool(0))
    qsfp0_tx_axis_tready = Signal(bool(0))
    qsfp0_rx_axis_tdata = Signal(intbv(0)[AXIS_ETH_DATA_WIDTH:])
    qsfp0_rx_axis_tkeep = Signal(intbv(0)[AXIS_ETH_KEEP_WIDTH:])
    qsfp0_rx_axis_tvalid = Signal(bool(0))
    qsfp0_rx_axis_tlast = Signal(bool(0))
    qsfp0_rx_axis_tuser = Signal(bool(0))
    qsfp0_modprsl = Signal(bool(1))
    qsfp0_intl = Signal(bool(1))
    qsfp1_tx_clk = Signal(bool(0))
    qsfp1_tx_rst = Signal(bool(0))
    qsfp1_rx_clk = Signal(bool(0))
    qsfp1_rx_rst = Signal(bool(0))
    qsfp1_tx_axis_tready = Signal(bool(0))
    qsfp1_rx_axis_tdata = Signal(intbv(0)[AXIS_ETH_DATA_WIDTH:])
    qsfp1_rx_axis_tkeep = Signal(intbv(0)[AXIS_ETH_KEEP_WIDTH:])
    qsfp1_rx_axis_tvalid = Signal(bool(0))
    qsfp1_rx_axis_tlast = Signal(bool(0))
    qsfp1_rx_axis_tuser = Signal(bool(0))
    qsfp1_modprsl = Signal(bool(1))
    qsfp1_intl = Signal(bool(1))

    # Outputs
    led = Signal(intbv(0)[3:])
    i2c_scl_o = Signal(bool(1))
    i2c_scl_t = Signal(bool(1))
    i2c_sda_o = Signal(bool(1))
    i2c_sda_t = Signal(bool(1))
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
    cfg_mgmt_addr = Signal(intbv(0)[10:])
    cfg_mgmt_function_number = Signal(intbv(0)[8:])
    cfg_mgmt_write = Signal(bool(0))
    cfg_mgmt_write_data = Signal(intbv(0)[32:])
    cfg_mgmt_byte_enable = Signal(intbv(0)[4:])
    cfg_mgmt_read = Signal(bool(0))
    cfg_fc_sel = Signal(intbv(4)[3:])
    cfg_interrupt_msi_int = Signal(intbv(0)[32:])
    cfg_interrupt_msi_pending_status = Signal(intbv(0)[32:])
    cfg_interrupt_msi_select = Signal(intbv(0)[2:])
    cfg_interrupt_msi_pending_status_function_num = Signal(intbv(0)[2:])
    cfg_interrupt_msi_pending_status_data_enable = Signal(bool(0))
    cfg_interrupt_msi_attr = Signal(intbv(0)[3:])
    cfg_interrupt_msi_tph_present = Signal(bool(0))
    cfg_interrupt_msi_tph_type = Signal(intbv(0)[2:])
    cfg_interrupt_msi_tph_st_tag = Signal(intbv(0)[8:])
    cfg_interrupt_msi_function_number = Signal(intbv(0)[8:])
    qsfp0_tx_axis_tdata = Signal(intbv(0)[AXIS_ETH_DATA_WIDTH:])
    qsfp0_tx_axis_tkeep = Signal(intbv(0)[AXIS_ETH_KEEP_WIDTH:])
    qsfp0_tx_axis_tvalid = Signal(bool(0))
    qsfp0_tx_axis_tlast = Signal(bool(0))
    qsfp0_tx_axis_tuser = Signal(bool(0))
    qsfp0_modsell = Signal(bool(0))
    qsfp0_resetl = Signal(bool(0))
    qsfp0_lpmode = Signal(bool(0))
    qsfp1_tx_axis_tdata = Signal(intbv(0)[AXIS_ETH_DATA_WIDTH:])
    qsfp1_tx_axis_tkeep = Signal(intbv(0)[AXIS_ETH_KEEP_WIDTH:])
    qsfp1_tx_axis_tvalid = Signal(bool(0))
    qsfp1_tx_axis_tlast = Signal(bool(0))
    qsfp1_tx_axis_tuser = Signal(bool(0))
    qsfp1_modsell = Signal(bool(0))
    qsfp1_resetl = Signal(bool(0))
    qsfp1_lpmode = Signal(bool(0))

    # sources and sinks
    qsfp0_source = axis_ep.AXIStreamSource()
    qsfp0_source_pause = Signal(bool(False))

    qsfp0_source_logic = qsfp0_source.create_logic(
        qsfp0_rx_clk,
        qsfp0_rx_rst,
        tdata=qsfp0_rx_axis_tdata,
        tkeep=qsfp0_rx_axis_tkeep,
        tvalid=qsfp0_rx_axis_tvalid,
        tlast=qsfp0_rx_axis_tlast,
        tuser=qsfp0_rx_axis_tuser,
        pause=qsfp0_source_pause,
        name='qsfp0_source'
    )

    qsfp0_sink = axis_ep.AXIStreamSink()
    qsfp0_sink_pause = Signal(bool(False))

    qsfp0_sink_logic = qsfp0_sink.create_logic(
        qsfp0_tx_clk,
        qsfp0_tx_rst,
        tdata=qsfp0_tx_axis_tdata,
        tkeep=qsfp0_tx_axis_tkeep,
        tvalid=qsfp0_tx_axis_tvalid,
        tready=qsfp0_tx_axis_tready,
        tlast=qsfp0_tx_axis_tlast,
        tuser=qsfp0_tx_axis_tuser,
        pause=qsfp0_sink_pause,
        name='qsfp0_sink'
    )

    qsfp1_source = axis_ep.AXIStreamSource()
    qsfp1_source_pause = Signal(bool(False))

    qsfp1_source_logic = qsfp1_source.create_logic(
        qsfp1_rx_clk,
        qsfp1_rx_rst,
        tdata=qsfp1_rx_axis_tdata,
        tkeep=qsfp1_rx_axis_tkeep,
        tvalid=qsfp1_rx_axis_tvalid,
        tlast=qsfp1_rx_axis_tlast,
        tuser=qsfp1_rx_axis_tuser,
        pause=qsfp1_source_pause,
        name='qsfp1_source'
    )

    qsfp1_sink = axis_ep.AXIStreamSink()
    qsfp1_sink_pause = Signal(bool(False))

    qsfp1_sink_logic = qsfp1_sink.create_logic(
        qsfp1_tx_clk,
        qsfp1_tx_rst,
        tdata=qsfp1_tx_axis_tdata,
        tkeep=qsfp1_tx_axis_tkeep,
        tvalid=qsfp1_tx_axis_tvalid,
        tready=qsfp1_tx_axis_tready,
        tlast=qsfp1_tx_axis_tlast,
        tuser=qsfp1_tx_axis_tuser,
        pause=qsfp1_sink_pause,
        name='qsfp1_sink'
    )

    # PCIe devices
    rc = pcie.RootComplex()

    rc.max_payload_size = 0x1 # 256 bytes
    rc.max_read_request_size = 0x5 # 4096 bytes

    driver = mqnic.Driver(rc)
    mem_base, mem_data = rc.alloc_region(16*1024*1024)

    dev = pcie_usp.UltrascalePlusPCIe()

    dev.pcie_generation = 3
    dev.pcie_link_width = 16
    dev.user_clock_frequency = 250e6

    dev.functions[0].msi_multiple_message_capable = 5

    dev.functions[0].configure_bar(0, 2**BAR0_APERTURE)

    rc.make_port().connect(dev)

    cq_pause = Signal(bool(0))
    cc_pause = Signal(bool(0))
    rq_pause = Signal(bool(0))
    rc_pause = Signal(bool(0))

    pcie_logic = dev.create_logic(
        # Completer reQuest Interface
        m_axis_cq_tdata=s_axis_cq_tdata,
        m_axis_cq_tuser=s_axis_cq_tuser,
        m_axis_cq_tlast=s_axis_cq_tlast,
        m_axis_cq_tkeep=s_axis_cq_tkeep,
        m_axis_cq_tvalid=s_axis_cq_tvalid,
        m_axis_cq_tready=s_axis_cq_tready,
        #pcie_cq_np_req=pcie_cq_np_req,
        pcie_cq_np_req=Signal(intbv(3)[2:]),
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
        pcie_rq_seq_num0=s_axis_rq_seq_num_0,
        pcie_rq_seq_num_vld0=s_axis_rq_seq_num_valid_0,
        pcie_rq_seq_num1=s_axis_rq_seq_num_1,
        pcie_rq_seq_num_vld1=s_axis_rq_seq_num_valid_1,
        #pcie_rq_tag0=pcie_rq_tag0,
        #pcie_rq_tag1=pcie_rq_tag1,
        #pcie_rq_tag_av=pcie_rq_tag_av,
        #pcie_rq_tag_vld0=pcie_rq_tag_vld0,
        #pcie_rq_tag_vld1=pcie_rq_tag_vld1,

        # Requester Completion Interface
        m_axis_rc_tdata=s_axis_rc_tdata,
        m_axis_rc_tuser=s_axis_rc_tuser,
        m_axis_rc_tlast=s_axis_rc_tlast,
        m_axis_rc_tkeep=s_axis_rc_tkeep,
        m_axis_rc_tvalid=s_axis_rc_tvalid,
        m_axis_rc_tready=s_axis_rc_tready,

        # Transmit Flow Control Interface
        #pcie_tfc_nph_av=pcie_tfc_nph_av,
        #pcie_tfc_npd_av=pcie_tfc_npd_av,

        # Configuration Management Interface
        cfg_mgmt_addr=cfg_mgmt_addr,
        cfg_mgmt_function_number=cfg_mgmt_function_number,
        cfg_mgmt_write=cfg_mgmt_write,
        cfg_mgmt_write_data=cfg_mgmt_write_data,
        cfg_mgmt_byte_enable=cfg_mgmt_byte_enable,
        cfg_mgmt_read=cfg_mgmt_read,
        cfg_mgmt_read_data=cfg_mgmt_read_data,
        cfg_mgmt_read_write_done=cfg_mgmt_read_write_done,
        #cfg_mgmt_debug_access=cfg_mgmt_debug_access,

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
        #cfg_local_err_out=cfg_local_err_out,
        #cfg_local_err_valid=cfg_local_err_valid,
        #cfg_rx_pm_state=cfg_rx_pm_state,
        #cfg_tx_pm_state=cfg_tx_pm_state,
        #cfg_ltssm_state=cfg_ltssm_state,
        #cfg_rcb_status=cfg_rcb_status,
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
        cfg_fc_ph=cfg_fc_ph,
        cfg_fc_pd=cfg_fc_pd,
        cfg_fc_nph=cfg_fc_nph,
        cfg_fc_npd=cfg_fc_npd,
        cfg_fc_cplh=cfg_fc_cplh,
        cfg_fc_cpld=cfg_fc_cpld,
        cfg_fc_sel=cfg_fc_sel,

        # Configuration Control Interface
        #cfg_hot_reset_in=cfg_hot_reset_in,
        #cfg_hot_reset_out=cfg_hot_reset_out,
        #cfg_config_space_enable=cfg_config_space_enable,
        #cfg_dsn=cfg_dsn,
        #cfg_ds_port_number=cfg_ds_port_number,
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
        #cfg_interrupt_msix_vec_pending=cfg_interrupt_msix_vec_pending,
        #cfg_interrupt_msix_vec_pending_status=cfg_interrupt_msix_vec_pending_status,
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
        #phy_rdy_out=phy_rdy_out,

        cq_pause=cq_pause,
        cc_pause=cc_pause,
        rq_pause=rq_pause,
        rc_pause=rc_pause
    )

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
        sw=sw,
        led=led,
        i2c_scl_i=i2c_scl_i,
        i2c_scl_o=i2c_scl_o,
        i2c_scl_t=i2c_scl_t,
        i2c_sda_i=i2c_sda_i,
        i2c_sda_o=i2c_sda_o,
        i2c_sda_t=i2c_sda_t,
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
        s_axis_rq_seq_num_0=s_axis_rq_seq_num_0,
        s_axis_rq_seq_num_valid_0=s_axis_rq_seq_num_valid_0,
        s_axis_rq_seq_num_1=s_axis_rq_seq_num_1,
        s_axis_rq_seq_num_valid_1=s_axis_rq_seq_num_valid_1,
        pcie_tfc_nph_av=pcie_tfc_nph_av,
        pcie_tfc_npd_av=pcie_tfc_npd_av,
        cfg_max_payload=cfg_max_payload,
        cfg_max_read_req=cfg_max_read_req,
        cfg_mgmt_addr=cfg_mgmt_addr,
        cfg_mgmt_function_number=cfg_mgmt_function_number,
        cfg_mgmt_write=cfg_mgmt_write,
        cfg_mgmt_write_data=cfg_mgmt_write_data,
        cfg_mgmt_byte_enable=cfg_mgmt_byte_enable,
        cfg_mgmt_read=cfg_mgmt_read,
        cfg_mgmt_read_data=cfg_mgmt_read_data,
        cfg_mgmt_read_write_done=cfg_mgmt_read_write_done,
        cfg_fc_ph=cfg_fc_ph,
        cfg_fc_pd=cfg_fc_pd,
        cfg_fc_nph=cfg_fc_nph,
        cfg_fc_npd=cfg_fc_npd,
        cfg_fc_cplh=cfg_fc_cplh,
        cfg_fc_cpld=cfg_fc_cpld,
        cfg_fc_sel=cfg_fc_sel,
        cfg_interrupt_msi_enable=cfg_interrupt_msi_enable,
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
        qsfp0_tx_clk=qsfp0_tx_clk,
        qsfp0_tx_rst=qsfp0_tx_rst,
        qsfp0_tx_axis_tdata=qsfp0_tx_axis_tdata,
        qsfp0_tx_axis_tkeep=qsfp0_tx_axis_tkeep,
        qsfp0_tx_axis_tvalid=qsfp0_tx_axis_tvalid,
        qsfp0_tx_axis_tready=qsfp0_tx_axis_tready,
        qsfp0_tx_axis_tlast=qsfp0_tx_axis_tlast,
        qsfp0_tx_axis_tuser=qsfp0_tx_axis_tuser,
        qsfp0_rx_clk=qsfp0_rx_clk,
        qsfp0_rx_rst=qsfp0_rx_rst,
        qsfp0_rx_axis_tdata=qsfp0_rx_axis_tdata,
        qsfp0_rx_axis_tkeep=qsfp0_rx_axis_tkeep,
        qsfp0_rx_axis_tvalid=qsfp0_rx_axis_tvalid,
        qsfp0_rx_axis_tlast=qsfp0_rx_axis_tlast,
        qsfp0_rx_axis_tuser=qsfp0_rx_axis_tuser,
        qsfp0_modprsl=qsfp0_modprsl,
        qsfp0_modsell=qsfp0_modsell,
        qsfp0_resetl=qsfp0_resetl,
        qsfp0_intl=qsfp0_intl,
        qsfp0_lpmode=qsfp0_lpmode,
        qsfp1_tx_clk=qsfp1_tx_clk,
        qsfp1_tx_rst=qsfp1_tx_rst,
        qsfp1_tx_axis_tdata=qsfp1_tx_axis_tdata,
        qsfp1_tx_axis_tkeep=qsfp1_tx_axis_tkeep,
        qsfp1_tx_axis_tvalid=qsfp1_tx_axis_tvalid,
        qsfp1_tx_axis_tready=qsfp1_tx_axis_tready,
        qsfp1_tx_axis_tlast=qsfp1_tx_axis_tlast,
        qsfp1_tx_axis_tuser=qsfp1_tx_axis_tuser,
        qsfp1_rx_clk=qsfp1_rx_clk,
        qsfp1_rx_rst=qsfp1_rx_rst,
        qsfp1_rx_axis_tdata=qsfp1_rx_axis_tdata,
        qsfp1_rx_axis_tkeep=qsfp1_rx_axis_tkeep,
        qsfp1_rx_axis_tvalid=qsfp1_rx_axis_tvalid,
        qsfp1_rx_axis_tlast=qsfp1_rx_axis_tlast,
        qsfp1_rx_axis_tuser=qsfp1_rx_axis_tuser,
        qsfp1_modprsl=qsfp1_modprsl,
        qsfp1_modsell=qsfp1_modsell,
        qsfp1_resetl=qsfp1_resetl,
        qsfp1_intl=qsfp1_intl,
        qsfp1_lpmode=qsfp1_lpmode
    )

    @always(delay(2)) #25
    def clkgen():
        sys_clk.next = not sys_clk

    @always(delay(2)) #27
    def clkgen3():
        core_clk.next = not core_clk

    @always(delay(2)) #32
    def qsfp_clkgen():
        qsfp0_tx_clk.next = not qsfp0_tx_clk
        qsfp0_rx_clk.next = not qsfp0_rx_clk
        qsfp1_tx_clk.next = not qsfp1_tx_clk
        qsfp1_rx_clk.next = not qsfp1_rx_clk

    @always_comb
    def clk_logic():
        sys_clk_to_pcie.next = sys_clk
        sys_rst_to_pcie.next = not sys_rst

    @instance
    def check():
        yield delay(100)
        yield sys_clk.posedge
        sys_rst.next = 1
        core_rst.next = 1
        qsfp0_tx_rst.next = 1
        qsfp0_rx_rst.next = 1
        qsfp1_tx_rst.next = 1
        qsfp1_rx_rst.next = 1
        yield sys_clk.posedge
        yield delay(100)
        sys_rst.next = 0
        core_rst.next = 0
        qsfp0_tx_rst.next = 0
        qsfp0_rx_rst.next = 0
        qsfp1_tx_rst.next = 0
        qsfp1_rx_rst.next = 0
        yield delay(2000)
        yield sys_clk.posedge
        yield delay(100)
        yield sys_clk.posedge
        
        print("PCIe enumeration")

        yield rc.enumerate(enable_bus_mastering=True, configure_msi=True)

        dev_pf0_bar0 = dev.functions[0].bar[0] & 0xfffffffc

        yield delay(100)

        yield pcie_clk.posedge

        print("Firmware load")
        ins  = bytearray(open(FIRMWARE, "rb").read())
        mem_data[0:len(ins)] = ins
        mem_data[48059:48200] = bytearray([(x+10)%256 for x in range(141)])

        # enable DMA
        yield rc.mem_write(dev_pf0_bar0+0x000400, struct.pack('<L', 1))
        
        yield rc.mem_write(dev_pf0_bar0+0x000410, struct.pack('<L', 0xffff))
        yield rc.mem_write(dev_pf0_bar0+0x000404, struct.pack('<L', 0x0001))
        yield delay(100)

        # Load instruction memories
        for i in range (0,16):
            yield rc.mem_write(dev_pf0_bar0+0x000408, struct.pack('<L', ((i<<8)|0xf)))
            yield delay(20)
            # write pcie read descriptor
            yield rc.mem_write(dev_pf0_bar0+0x000440, struct.pack('<L', (mem_base+0x0000) & 0xffffffff))
            yield rc.mem_write(dev_pf0_bar0+0x000444, struct.pack('<L', (mem_base+0x0000 >> 32) & 0xffffffff))
            yield rc.mem_write(dev_pf0_bar0+0x000448, struct.pack('<L', ((i<<26)+(1<<25)) & 0xffffffff))
            yield rc.mem_write(dev_pf0_bar0+0x000450, struct.pack('<L', len(ins)))
            yield rc.mem_write(dev_pf0_bar0+0x000454, struct.pack('<L', 0xAA))
            yield delay(1000)
        
        if (DATA!=''):
          data = bytearray(open(DATA, "rb").read())
          mem_data[0:len(data)] = data
          # Load data memories
          for i in range (0,16):
              # write pcie read descriptor
              yield rc.mem_write(dev_pf0_bar0+0x000440, struct.pack('<L', (mem_base+0x0000) & 0xffffffff))
              yield rc.mem_write(dev_pf0_bar0+0x000444, struct.pack('<L', (mem_base+0x0000 >> 32) & 0xffffffff))
              yield rc.mem_write(dev_pf0_bar0+0x000448, struct.pack('<L', ((i<<26)+(1<<23)) & 0xffffffff))
              yield rc.mem_write(dev_pf0_bar0+0x000450, struct.pack('<L', len(data)))
              yield rc.mem_write(dev_pf0_bar0+0x000454, struct.pack('<L', 0xBB))
              yield delay(1000)

        print("Taking cores out of reset")
        yield rc.mem_write(dev_pf0_bar0+0x000404, struct.pack('<L', 0x0000))
        yield delay(100)

        for i in range (0,16):
            yield rc.mem_write(dev_pf0_bar0+0x000408, struct.pack('<L', ((i<<8)|0xf)))

        yield rc.mem_write(dev_pf0_bar0+0x00040C, struct.pack('<L', 0x0000))
        yield rc.mem_write(dev_pf0_bar0+0x000410, struct.pack('<L', 0x0000))
        yield delay(200000)

        # put cores into reset
        yield rc.mem_write(dev_pf0_bar0+0x000404, struct.pack('<L', 0x0001))
        yield delay(100)

        for i in range (0,16):
            yield rc.mem_write(dev_pf0_bar0+0x000408, struct.pack('<L', ((i<<8)|0xf)))

        print ("Read core stat")  
        for k in range (8,12):
          yield rc.mem_write(dev_pf0_bar0+0x000414, struct.pack('<L', k<<4|2))
          yield delay(100)
          slots      = yield from rc.mem_read(dev_pf0_bar0+0x000420, 4)
          bytes_out  = yield from rc.mem_read(dev_pf0_bar0+0x000424, 4)
          yield rc.mem_write(dev_pf0_bar0+0x000414, struct.pack('<L', k<<4|3))
          yield delay(100)
          frames_out = yield from rc.mem_read(dev_pf0_bar0+0x000424, 4)

          print ("Core %d stat read, slots, byte_out, frames_out" % (k))
          print (B_2_int(slots),B_2_int(bytes_out),B_2_int(frames_out))

        print ("Read interface stat")  
        pkt_count = 2*[0]
        for k in range (0,2):
          yield rc.mem_write(dev_pf0_bar0+0x000418, struct.pack('<L', k<<8|0))
          yield delay(100)
          bytes_out  = yield from rc.mem_read(dev_pf0_bar0+0x00042C, 4)
          yield rc.mem_write(dev_pf0_bar0+0x000418, struct.pack('<L', k<<8|1))
          yield delay(100)
          frames_out = yield from rc.mem_read(dev_pf0_bar0+0x00042C, 4)
          pkt_count[k] = B_2_int(frames_out);
          print ("Interface %d stat read, byte_out, frames_out" % (k))
          print (B_2_int(bytes_out),B_2_int(frames_out))
 
        if (PRINT_PKTS):

          print ("packets from port 0:")
          for j in range (0,min(pkt_count[0],250)):
            yield qsfp0_sink.wait()
            rx_frame = qsfp0_sink.recv()
            data = rx_frame.data
            print(" ".join(("{:02x}".format(c) for c in bytearray(data[0:8]))))

          print ("packets from port 1:")
          for j in range (0,min(pkt_count[1],250)):
            yield qsfp1_sink.wait()
            rx_frame = qsfp1_sink.recv()
            data = rx_frame.data
            print(" ".join(("{:02x}".format(c) for c in bytearray(data[0:8]))))
          
        yield delay(1000)
        raise StopSimulation

    return instances()

def test_bench():
    sim = Simulation(bench())
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test_bench()

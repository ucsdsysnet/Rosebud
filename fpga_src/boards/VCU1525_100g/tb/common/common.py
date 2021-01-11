#!/usr/bin/env python3
"""

Copyright 2020, The Regents of the University of California.
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

"""

import logging
import os
import sys

from elftools.elf.elffile import ELFFile

import cocotb_test.simulator

import cocotb
from cocotb.log import SimLog
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer

from cocotbext.pcie.core import RootComplex
from cocotbext.pcie.xilinx.us import UltraScalePlusPcieDevice

from cocotbext.axi import AxiStreamSource, AxiStreamSink
from cocotbext.axi.utils import hexdump_str

try:
    import mqnic
except ImportError:
    # attempt import from current directory
    sys.path.insert(0, os.path.join(os.path.dirname(__file__)))
    try:
        import mqnic
    finally:
        del sys.path[0]


class TB(object):
    def __init__(self, dut):
        self.dut = dut

        self.BAR0_APERTURE = int(os.getenv("PARAM_BAR0_APERTURE"))

        self.log = SimLog("cocotb.tb")
        self.log.setLevel(logging.DEBUG)

        # PCIe
        self.rc = RootComplex()

        self.rc.max_payload_size = 0x1  # 256 bytes
        self.rc.max_read_request_size = 0x2  # 512 bytes

        self.dev = UltraScalePlusPcieDevice(
            # configuration options
            pcie_generation=3,
            pcie_link_width=16,
            user_clk_frequency=250e6,
            alignment="dword",
            cq_cc_straddle=False,
            rq_rc_straddle=False,
            rc_4tlp_straddle=False,
            enable_pf1=False,
            enable_client_tag=True,
            enable_extended_tag=True,
            enable_parity=False,
            enable_rx_msg_interface=False,
            enable_sriov=False,
            enable_extended_configuration=False,

            enable_pf0_msi=True,
            enable_pf1_msi=False,

            # signals
            # Clock and Reset Interface
            user_clk=dut.pcie_clk,
            user_reset=dut.pcie_rst,
            # user_lnk_up
            # sys_clk
            # sys_clk_gt
            # sys_reset
            # phy_rdy_out

            # Requester reQuest Interface
            rq_entity=dut.UUT,
            rq_name="m_axis_rq",
            pcie_rq_seq_num0=dut.UUT.s_axis_rq_seq_num_0,
            pcie_rq_seq_num_vld0=dut.UUT.s_axis_rq_seq_num_valid_0,
            pcie_rq_seq_num1=dut.UUT.s_axis_rq_seq_num_1,
            pcie_rq_seq_num_vld1=dut.UUT.s_axis_rq_seq_num_valid_1,
            # pcie_rq_tag0
            # pcie_rq_tag1
            # pcie_rq_tag_av
            # pcie_rq_tag_vld0
            # pcie_rq_tag_vld1

            # Requester Completion Interface
            rc_entity=dut.UUT,
            rc_name="s_axis_rc",

            # Completer reQuest Interface
            cq_entity=dut.UUT,
            cq_name="s_axis_cq",
            # pcie_cq_np_req
            # pcie_cq_np_req_count

            # Completer Completion Interface
            cc_entity=dut.UUT,
            cc_name="m_axis_cc",

            # Transmit Flow Control Interface
            # pcie_tfc_nph_av=dut.pcie_tfc_nph_av,
            # pcie_tfc_npd_av=dut.pcie_tfc_npd_av,

            # Configuration Management Interface
            cfg_mgmt_addr=dut.pcie_us_cfg_inst.cfg_mgmt_addr,
            cfg_mgmt_function_number=dut.pcie_us_cfg_inst.cfg_mgmt_function_number,
            cfg_mgmt_write=dut.pcie_us_cfg_inst.cfg_mgmt_write,
            cfg_mgmt_write_data=dut.pcie_us_cfg_inst.cfg_mgmt_write_data,
            cfg_mgmt_byte_enable=dut.pcie_us_cfg_inst.cfg_mgmt_byte_enable,
            cfg_mgmt_read=dut.pcie_us_cfg_inst.cfg_mgmt_read,
            cfg_mgmt_read_data=dut.pcie_us_cfg_inst.cfg_mgmt_read_data,
            cfg_mgmt_read_write_done=dut.pcie_us_cfg_inst.cfg_mgmt_read_write_done,
            # cfg_mgmt_debug_access

            # Configuration Status Interface
            # cfg_phy_link_down
            # cfg_phy_link_status
            # cfg_negotiated_width
            # cfg_current_speed
            cfg_max_payload=dut.UUT.cfg_max_payload,
            cfg_max_read_req=dut.UUT.cfg_max_read_req,
            # cfg_function_status
            # cfg_vf_status
            # cfg_function_power_state
            # cfg_vf_power_state
            # cfg_link_power_state
            # cfg_err_cor_out
            # cfg_err_nonfatal_out
            # cfg_err_fatal_out
            # cfg_local_error_out
            # cfg_local_error_valid
            # cfg_rx_pm_state
            # cfg_tx_pm_state
            # cfg_ltssm_state
            # cfg_rcb_status
            # cfg_obff_enable
            # cfg_pl_status_change
            # cfg_tph_requester_enable
            # cfg_tph_st_mode
            # cfg_vf_tph_requester_enable
            # cfg_vf_tph_st_mode

            # Configuration Received Message Interface
            # cfg_msg_received
            # cfg_msg_received_data
            # cfg_msg_received_type

            # Configuration Transmit Message Interface
            # cfg_msg_transmit
            # cfg_msg_transmit_type
            # cfg_msg_transmit_data
            # cfg_msg_transmit_done

            # Configuration Flow Control Interface
            cfg_fc_ph=dut.UUT.pcie_tx_fc_ph_av,
            cfg_fc_pd=dut.UUT.pcie_tx_fc_pd_av,
            cfg_fc_nph=dut.UUT.pcie_tx_fc_nph_av,
            # cfg_fc_npd=dut.cfg_fc_npd,
            # cfg_fc_cplh=dut.cfg_fc_cplh,
            # cfg_fc_cpld=dut.cfg_fc_cpld,
            cfg_fc_sel=0b100,

            # Configuration Control Interface
            # cfg_hot_reset_in
            # cfg_hot_reset_out
            # cfg_config_space_enable
            # cfg_dsn
            # cfg_bus_number
            # cfg_ds_port_number
            # cfg_ds_bus_number
            # cfg_ds_device_number
            # cfg_ds_function_number
            # cfg_power_state_change_ack
            # cfg_power_state_change_interrupt
            cfg_err_cor_in=dut.UUT.status_error_cor,
            cfg_err_uncor_in=dut.UUT.status_error_uncor,
            # cfg_flr_in_process
            # cfg_flr_done
            # cfg_vf_flr_in_process
            # cfg_vf_flr_func_num
            # cfg_vf_flr_done
            # cfg_pm_aspm_l1_entry_reject
            # cfg_pm_aspm_tx_l0s_entry_disable
            # cfg_req_pm_transition_l23_ready
            # cfg_link_training_enable

            # Configuration Interrupt Controller Interface
            # cfg_interrupt_int
            # cfg_interrupt_sent
            # cfg_interrupt_pending
            cfg_interrupt_msi_enable=dut.pcie_us_msi_inst.cfg_interrupt_msi_enable,
            cfg_interrupt_msi_mmenable=dut.pcie_us_msi_inst.cfg_interrupt_msi_mmenable,
            cfg_interrupt_msi_mask_update=dut.pcie_us_msi_inst.cfg_interrupt_msi_mask_update,
            cfg_interrupt_msi_data=dut.pcie_us_msi_inst.cfg_interrupt_msi_data,
            # cfg_interrupt_msi_select=dut.pcie_us_msi_inst.cfg_interrupt_msi_select,
            cfg_interrupt_msi_int=dut.pcie_us_msi_inst.cfg_interrupt_msi_int,
            cfg_interrupt_msi_pending_status=dut.pcie_us_msi_inst.cfg_interrupt_msi_pending_status,
            cfg_interrupt_msi_pending_status_data_enable=dut.pcie_us_msi_inst.cfg_interrupt_msi_pending_status_data_enable,
            # cfg_interrupt_msi_pending_status_function_num=dut.pcie_us_msi_inst.cfg_interrupt_msi_pending_status_function_num,
            cfg_interrupt_msi_sent=dut.pcie_us_msi_inst.cfg_interrupt_msi_sent,
            cfg_interrupt_msi_fail=dut.pcie_us_msi_inst.cfg_interrupt_msi_fail,
            # cfg_interrupt_msix_enable
            # cfg_interrupt_msix_mask
            # cfg_interrupt_msix_vf_enable
            # cfg_interrupt_msix_vf_mask
            # cfg_interrupt_msix_address
            # cfg_interrupt_msix_data
            # cfg_interrupt_msix_int
            # cfg_interrupt_msix_vec_pending
            # cfg_interrupt_msix_vec_pending_status
            cfg_interrupt_msi_attr=dut.pcie_us_msi_inst.cfg_interrupt_msi_attr,
            cfg_interrupt_msi_tph_present=dut.pcie_us_msi_inst.cfg_interrupt_msi_tph_present,
            cfg_interrupt_msi_tph_type=dut.pcie_us_msi_inst.cfg_interrupt_msi_tph_type,
            # cfg_interrupt_msi_tph_st_tag=dut.pcie_us_msi_inst.cfg_interrupt_msi_tph_st_tag,
            # cfg_interrupt_msi_function_number=dut.pcie_us_msi_inst.cfg_interrupt_msi_function_number,

            # Configuration Extend Interface
            # cfg_ext_read_received
            # cfg_ext_write_received
            # cfg_ext_register_number
            # cfg_ext_function_number
            # cfg_ext_write_data
            # cfg_ext_write_byte_enable
            # cfg_ext_read_data
            # cfg_ext_read_data_valid
        )

        # self.dev.log.setLevel(logging.DEBUG)
        self.dev.rq_sink.log.setLevel(logging.WARNING)
        self.dev.rc_source.log.setLevel(logging.WARNING)
        self.dev.cq_source.log.setLevel(logging.WARNING)
        self.dev.cc_sink.log.setLevel(logging.WARNING)

        self.rc.make_port().connect(self.dev)

        self.driver = mqnic.Driver(self.rc)

        self.dev.functions[0].msi_multiple_message_capable = 5

        self.dev.functions[0].configure_bar(0, 2**self.BAR0_APERTURE, ext=True, prefetch=True)

        self.mem_base, self.mem_data = self.rc.alloc_region(16*1024*1024)

        # Ethernet
        cocotb.fork(Clock(dut.UUT.qsfp0_rx_clk, 4, units="ns").start())
        self.qsfp0_source = AxiStreamSource(dut.UUT, "qsfp0_rx_axis", dut.UUT.qsfp0_rx_clk, dut.UUT.qsfp0_rx_rst)
        cocotb.fork(Clock(dut.UUT.qsfp0_tx_clk, 4, units="ns").start())
        self.qsfp0_sink = AxiStreamSink(dut.UUT, "qsfp0_tx_axis", dut.UUT.qsfp0_tx_clk, dut.UUT.qsfp0_tx_rst)

        cocotb.fork(Clock(dut.UUT.qsfp1_rx_clk, 4, units="ns").start())
        self.qsfp1_source = AxiStreamSource(dut.UUT, "qsfp1_rx_axis", dut.UUT.qsfp1_rx_clk, dut.UUT.qsfp1_rx_rst)
        cocotb.fork(Clock(dut.UUT.qsfp1_tx_clk, 4, units="ns").start())
        self.qsfp1_sink = AxiStreamSink(dut.UUT, "qsfp1_tx_axis", dut.UUT.qsfp1_tx_clk, dut.UUT.qsfp1_tx_rst)

        dut.UUT.sw.setimmediatevalue(0)

        dut.UUT.i2c_scl_i.setimmediatevalue(1)
        dut.UUT.i2c_sda_i.setimmediatevalue(1)

        dut.UUT.qsfp0_modprsl.setimmediatevalue(0)
        dut.UUT.qsfp0_intl.setimmediatevalue(1)

        dut.UUT.qsfp1_modprsl.setimmediatevalue(0)
        dut.UUT.qsfp1_intl.setimmediatevalue(1)

        self.loopback_enable = False
        cocotb.fork(self._run_loopback())

    async def init(self):

        self.dut.UUT.qsfp0_rx_rst.setimmediatevalue(0)
        self.dut.UUT.qsfp0_tx_rst.setimmediatevalue(0)
        self.dut.UUT.qsfp1_rx_rst.setimmediatevalue(0)
        self.dut.UUT.qsfp1_tx_rst.setimmediatevalue(0)

        await RisingEdge(self.dut.pcie_clk)
        await RisingEdge(self.dut.pcie_clk)

        self.dut.UUT.qsfp0_rx_rst.setimmediatevalue(1)
        self.dut.UUT.qsfp0_tx_rst.setimmediatevalue(1)
        self.dut.UUT.qsfp1_rx_rst.setimmediatevalue(1)
        self.dut.UUT.qsfp1_tx_rst.setimmediatevalue(1)

        await FallingEdge(self.dut.pcie_rst)
        await Timer(100, 'ns')

        await RisingEdge(self.dut.pcie_clk)
        await RisingEdge(self.dut.pcie_clk)

        self.dut.UUT.qsfp0_rx_rst.setimmediatevalue(0)
        self.dut.UUT.qsfp0_tx_rst.setimmediatevalue(0)
        self.dut.UUT.qsfp1_rx_rst.setimmediatevalue(0)
        self.dut.UUT.qsfp1_tx_rst.setimmediatevalue(0)

        await self.rc.enumerate(enable_bus_mastering=True, configure_msi=True)

        self.dev_pf0_bar0 = self.rc.tree[0][0].bar_addr[0]

    async def _run_loopback(self):
        while True:
            await RisingEdge(self.dut.pcie_clk)

            if self.loopback_enable:
                if not self.qsfp0_sink.empty():
                    await self.qsfp0_source.send(await self.qsfp0_sink.recv())
                if not self.qsfp1_sink.empty():
                    await self.qsfp1_source.send(await self.qsfp1_sink.recv())

    async def block_write(self, data, dest, length=-1):
        if len(data) == 0:
            return
        if length <= 0:
            length = len(data)
        length = min(length, len(data))

        self.log.info("Block write %d bytes to 0x%08x", len(data), dest)

        self.mem_data[0:len(data)] = data

        await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000440, (self.mem_base) & 0xffffffff)
        await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000444, (self.mem_base >> 32) & 0xffffffff)
        await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000448, dest)
        await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000450, length)
        await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000454, 0xAA)

        while await self.rc.mem_read_dword(self.dev_pf0_bar0+0x000458) != 0xAA:
            pass

    async def block_read(self, src, length):
        if length <= 0:
            return

        self.log.info("Block read %d bytes from 0x%08x", length, src)

        await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000460, (self.mem_base) & 0xffffffff)
        await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000464, (self.mem_base >> 32) & 0xffffffff)
        await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000468, src)
        await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000470, length)
        await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000474, 0x55)

        while await self.rc.mem_read_dword(self.dev_pf0_bar0+0x000478) != 0x55:
            pass

        return self.mem_data[0:length]

    async def load_firmware(self, file):
        self.log.info("Load firmware")

        self.log.info("Firmware file: '%s'", file)

        ins_seg = b''
        data_seg = b''

        with open(file, "rb") as f:
            elf = ELFFile(f)
            ins_seg = elf.get_section_by_name('.text').data()
            data_seg = elf.get_section_by_name('.data').data()

        self.log.info("Instruction segment size: %d", len(ins_seg))
        if len(ins_seg) > 0:
            self.log.debug("%s", hexdump_str(ins_seg))

        self.log.info("Data segment size: %d", len(data_seg))
        if len(data_seg) > 0:
            self.log.debug("%s", hexdump_str(data_seg))

        self.log.info("Enable DMA")
        await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000400, 1)

        await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000410, 0xffff)
        await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000404, 0x0001)
        await Timer(100, 'ns')

        for i in range(0, 16):
            self.log.info("Assert reset on core %d", i)
            await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000408, ((i << 8) | 0xf))

        await Timer(20, 'ns')

        self.log.info("Load core memories")
        for i in range(0, 16):
            self.log.info("Load firmware on core %d", i)

            if len(ins_seg) > 0:
                self.log.info("Load instruction memory")
                await self.block_write(ins_seg, (i << 26)+(1 << 25))

            if len(data_seg) > 0:
                self.log.info("Load data memory")
                await self.block_write(data_seg, (i << 26)+(1 << 23))

            self.log.info("Done")

        await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000404, 0x0000)
        await Timer(100, 'ns')

        for i in range(0, 16):
            self.log.info("Release reset on core %d", i)
            await self.rc.mem_write_dword(self.dev_pf0_bar0+0x000408, ((i << 8) | 0xf))

        await Timer(2000, 'ns')

        self.log.info("Done loading firmware")

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

import scapy.utils
from scapy.packet import Raw
from scapy.layers.l2 import Ether
from scapy.layers.inet import IP, UDP, TCP

from elftools.elf.elffile import ELFFile
from collections import deque

import cocotb_test.simulator

import cocotb
from cocotb.log import SimLog
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

from cocotbext.axi import AxiStreamSource, AxiStreamSink, AxiStreamFrame
from cocotbext.axi.utils import hexdump_str

FIRMWARE = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '..', '..', '..', '..', '..', 'c_code', 'basic_fw2.o'))

SIZE_0 = 1024 - 14

PACKETS = []

eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
ip = IP(src='192.168.1.100', dst='192.168.1.101')
udp = UDP(sport=1234, dport=5678)
payload = bytes([0]+[0]+[x % 256 for x in range(SIZE_0-2)])
test_pkt = eth / payload
PACKETS.append(test_pkt)

class TB(object):
    def __init__(self, dut):
        self.dut = dut

        self.log = SimLog("cocotb.tb")
        self.log.setLevel(logging.DEBUG)

        self.slots = []
        self.send_q = deque()
        self.recv_q = deque()

        sys_clk = cocotb.fork(Clock(dut.clk, 4, units="ns").start())

        self.data_ch_source = AxiStreamSource(dut, "data_s_axis",  dut.clk, dut.rst)
        self.data_ch_sink   = AxiStreamSink  (dut, "data_m_axis",  dut.clk, dut.rst)
        self.ctrl_ch_source = AxiStreamSource(dut, "ctrl_s_axis",  dut.clk, dut.rst)
        self.ctrl_ch_sink   = AxiStreamSink  (dut, "ctrl_m_axis",  dut.clk, dut.rst)
        self.dram_ch_source = AxiStreamSource(dut, "dram_s_axis",  dut.clk, dut.rst)
        self.dram_ch_sink   = AxiStreamSink  (dut, "dram_m_axis",  dut.clk, dut.rst)
        self.msg_ch_source  = AxiStreamSource(dut, "core_msg_in",  dut.clk, dut.rst)
        self.msg_ch_sink    = AxiStreamSink  (dut, "core_msg_out", dut.clk, dut.rst)

        self.stat_data = self.dut.core_stat_data

        self.data_ch_source.log.setLevel("WARNING")
        self.data_ch_sink.log.setLevel("WARNING")
        self.ctrl_ch_source.log.setLevel("WARNING")
        self.ctrl_ch_sink.log.setLevel("WARNING")
        self.dram_ch_source.log.setLevel("WARNING")
        self.dram_ch_sink.log.setLevel("WARNING")
        self.msg_ch_source.log.setLevel("WARNING")
        self.msg_ch_sink.log.setLevel("WARNING")

    async def init(self):
        self.dut.core_stat_addr.setimmediatevalue(0)

        self.dut.rst.setimmediatevalue(0)
        await RisingEdge(self.dut.clk)
        await RisingEdge(self.dut.clk)
        self.dut.rst.setimmediatevalue(1)
        await Timer(100, 'ns')
        await RisingEdge(self.dut.clk)
        await RisingEdge(self.dut.clk)
        self.dut.rst.setimmediatevalue(0)

        cocotb.fork(self.scheduler())

    async def load_firmware(self, file):
        self.log.info("Load firmware")

        self.log.info("Firmware file: '%s'", file)

        ins_seg = b''
        data_seg = b''

        # Put core in reset
        await self.ctrl_ch_source.send([0xf00000001])

        # Load instruction and data memories
        with open(file, "rb") as f:
            elf = ELFFile(f)
            ins_seg = elf.get_section_by_name('.text').data()
            data_seg = elf.get_section_by_name('.data').data()

        self.log.info("Instruction segment size: %d", len(ins_seg))
        if len(ins_seg) > 0:
            self.log.debug("%s", hexdump_str(ins_seg))
            addr_hdr = (0x0200000000000000).to_bytes(8, 'little')
            ins_frame = AxiStreamFrame(tdata=addr_hdr+ins_seg,tuser=4,tdest=0)
            await self.data_ch_source.send(ins_frame)

        self.log.info("Data segment size: %d", len(data_seg))
        if len(data_seg) > 0:
            self.log.debug("%s", hexdump_str(data_seg))
            addr_hdr = (0x0000000000000000).to_bytes(8, 'little')
            data_frame = AxiStreamFrame(tdata=addr_hdr+data_seg,tuser=4,tdest=0)
            await self.data_ch_source.send(data_frame)

        # TODO: add pmem write

        await Timer(100, 'ns')
        await self.ctrl_ch_source.send([0xf00000000])

        self.log.info("Done loading firmware")

    def send_pkt(self, data, port=0):
        self.send_q.append(AxiStreamFrame(tdata=data, tuser=port, tkeep=None))

    async def send_manager(self):
        while (1):
            if (self.send_q and self.slots):
                pkt = self.send_q.popleft()
                slot = self.slots.pop()
                pkt.tdest = slot
                await self.data_ch_source.send(pkt)
                self.log.debug("Used slot %d for an incoming packet from port %d", slot, pkt.tuser)
            await RisingEdge(self.dut.clk)

    async def recv_manager(self):
        while (1):
            frame = await self.data_ch_sink.recv()
            self.recv_q.append(frame)

    async def scheduler(self):
        cocotb.fork(self.send_manager())
        cocotb.fork(self.recv_manager())
        while (1):
            frame = await self.ctrl_ch_sink.recv()
            msg_type =  frame.tdata[0]                >> 32
            msg_len  =  frame.tdata[0] & 0x00000FFFF
            msg_dst  = (frame.tdata[0] & 0x0FF000000) >> 24
            msg_slot = (frame.tdata[0] & 0x000FF0000) >> 16

            if (msg_type==0):
              self.slots.append(msg_slot)
              self.slots.sort(reverse=True)
            elif (msg_type==1):
              await ClockCycles(self.dut.clk,4)
              frame.tdata[0] = frame.tdata[0] & 0xFFFFFFFF
              await self.ctrl_ch_source.send(frame)
            elif (msg_type==2):
              await ClockCycles(self.dut.clk,4)
              frame.tdata[0] = (1<<32) | (LOOPBACK_PORT << 24) | (msg_slot << 16) | (msg_dst << TAG_WIDTH)
              await self.ctrl_ch_source.send(frame)
            elif (msg_type==3):
              self.log.debug("Initialize scheduler with %d slots", msg_slot)
              self.slots = list(range(1, msg_slot+1))
              self.slots.sort(reverse=True)


@cocotb.test()
async def run_test_gousheh(dut):
    tb = TB(dut)
    await tb.init()
    await Timer(100, 'ns')

    await tb.load_firmware(FIRMWARE)
    await Timer(1000, 'ns')

    tb.send_pkt(PACKETS[0].build(),1)

    await Timer(1000, 'ns')
    tb.log.debug("received packet: \n%s", hexdump_str(tb.recv_q.pop().tdata))

    await RisingEdge(dut.clk)


# cocotb-test

tests_dir = os.path.dirname(__file__)
rtl_dir = os.path.abspath(os.path.join(tests_dir, '..', '..', 'rtl'))
lib_dir = os.path.abspath(os.path.join(rtl_dir, '..', 'lib'))
axis_rtl_dir = os.path.abspath(os.path.join(lib_dir, 'axis', 'rtl'))
smartfpga_rtl_dir = os.path.abspath(os.path.join(lib_dir, 'smartFPGA', 'rtl'))
accel_dir = os.path.abspath(os.path.join(tests_dir, '..', '..', 'accel'))
accel_rtl_dir = os.path.abspath(os.path.join(accel_dir, 'full_ids', 'rtl'))


def test_fpga_core(request):
    run_test(
        sim_build=os.path.join("sim_build", request.node.name.replace('[', '-').replace(']', '')),
    )


def run_test(parameters=None, sim_build="sim_build", waves=None, force_compile=False, extra_env=None):
    module = os.path.splitext(os.path.basename(__file__))[0]
    toplevel = "test_gousheh"

    verilog_sources = [
        os.path.join(tests_dir, "test_gousheh.v"),
        os.path.join(rtl_dir, "riscv_block_PR_w_accel.v"),

        os.path.join(smartfpga_rtl_dir, "simple_fifo.v"),
        os.path.join(smartfpga_rtl_dir, "core_mems.v"),
        os.path.join(smartfpga_rtl_dir, "axis_dma.v"),
        os.path.join(smartfpga_rtl_dir, "VexRiscv.v"),
        os.path.join(smartfpga_rtl_dir, "riscvcore.v"),
        os.path.join(smartfpga_rtl_dir, "riscv_block.v"),
        os.path.join(smartfpga_rtl_dir, "accel_wrap.v"),
        os.path.join(smartfpga_rtl_dir, "riscv_axis_wrapper.v"),
        os.path.join(smartfpga_rtl_dir, "mem_sys.v"),
        os.path.join(smartfpga_rtl_dir, "simple_arbiter.v"),
        os.path.join(smartfpga_rtl_dir, "simple_sync_sig.v"),
        os.path.join(smartfpga_rtl_dir, "axis_stat.v"),
        os.path.join(smartfpga_rtl_dir, "header.v"),
        os.path.join(smartfpga_rtl_dir, "axis_fifo.v"),

        os.path.join(axis_rtl_dir, "sync_reset.v"),
        os.path.join(axis_rtl_dir, "axis_register.v"),
        os.path.join(axis_rtl_dir, "axis_pipeline_register.v"),
    ]

    if parameters is None:
        parameters = {}
    parameters = {k.upper(): v for k, v in parameters.items() if v is not None}

    parameters.setdefault('SLOT_COUNT', 16)
    parameters.setdefault('LOOPBACK_PORT', 3)
    parameters.setdefault('TAG_WIDTH', 5)

    if extra_env is None:
        extra_env = {}
    extra_env.update({f'PARAM_{k}': str(v) for k, v in parameters.items()})

    extra_env.setdefault('COCOTB_RESOLVE_X', 'RANDOM')

    sim_build = os.path.join(tests_dir, sim_build)

    cocotb_test.simulator.run(
        python_search=[tests_dir],
        verilog_sources=verilog_sources,
        toplevel=toplevel,
        module=module,
        parameters=parameters,
        sim_build=sim_build,
        extra_env=extra_env,
        force_compile=force_compile,
        waves=waves,
    )


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()

    parser.add_argument('--slot_count', type=int, default=16)
    parser.add_argument('--loopback_port', type=int, default=3)
    parser.add_argument('--tag_width', type=int, default=5)

    parser.add_argument('--waves', type=bool)
    parser.add_argument('--sim_build', type=str, default="sim_build")
    parser.add_argument('--force_compile', type=bool, default=True)
    parser.add_argument('--reduced_log', type=bool)
    parser.add_argument('--clean', action='store_true')

    args = vars(parser.parse_args())

    if args.pop("clean"):
        import shutil
        shutil.rmtree(os.path.join(tests_dir, "sim_build"))

    else:
        sim_build = args.pop("sim_build")
        waves = args.pop("waves")
        force_compile = args.pop("force_compile")
        reduced_log = args.pop("reduced_log")

        extra_env = {}

        if reduced_log is not None:
            extra_env['COCOTB_REDUCED_LOG_FMT'] = str(int(reduced_log))

        run_test(args, sim_build, waves, force_compile, extra_env)

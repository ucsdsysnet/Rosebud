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

import ipaddress
import logging
import os

import scapy.config
from scapy.packet import Raw
from scapy.layers.l2 import Ether
from scapy.layers.inet import IP, UDP, TCP
from scapy.utils import PcapReader

from elftools.elf.elffile import ELFFile
from collections import deque
from random import randrange

import cocotb_test.simulator

import cocotb
from cocotb.log import SimLog
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, ClockCycles

from cocotbext.axi import AxiStreamSource, AxiStreamSink, AxiStreamFrame
from cocotbext.axi.utils import hexdump_str

# print actual port numbers
scapy.config.conf.noenum.add(TCP.sport, TCP.dport, UDP.sport, UDP.dport)

FIRMWARE = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '..', '..', 'accel', 'full_ids', 'c', 'full_ids.elf'))
  # '..', '..', '..', '..', '..', 'c_code', 'basic_fw2.elf'))

SEND_COUNT_0 = 1024
SIZE_0 = [66-54, 1500-54, 66-54, 66-54, 1500-54, 1500-54, 66-54]
WAIT_TIME = 20000
MAX_PKT_SPACING = 3
CHECK_PKT = True
PRINT_RX_PKT = False
FLOW_HASH = False

PACKETS = []

eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
ip = IP(src='192.168.1.100', dst='192.168.1.101')
udp = UDP(sport=1234, dport=5678)
payload = bytes([0]+[x % 256 for x in range(SIZE_0[0]-1)])
test_pkt = eth / ip / udp / payload
PACKETS.append(test_pkt)

eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
ip = IP(src='192.168.1.100', dst='192.168.1.101')
tcp = TCP(sport=1234, dport=5678)
payload = bytes([0]+[x % 256 for x in range(SIZE_0[0]-1)])
test_pkt = eth / ip / tcp / payload
PACKETS.append(test_pkt)

eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
ip = IP(src='192.168.1.100', dst='192.168.1.101')
tcp = TCP(sport=12345, dport=80)
payload = bytes([0]+[x % 256 for x in range(SIZE_0[0]-1)])
test_pkt = eth / ip / tcp / payload
PACKETS.append(test_pkt)

eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
ip = IP(src='192.168.1.100', dst='192.168.1.101')
tcp = TCP(sport=54321, dport=80)
payload = bytes([0]+[x % 256 for x in range(SIZE_0[0]-1)])
test_pkt = eth / ip / tcp / payload
PACKETS.append(test_pkt)

PCAP         = None
# PCAP         = os.path.abspath(os.path.join(os.path.dirname(__file__),
#     '../../accel/full_ids/python/ids_test.pcap'))


PACKETS_0 = []

if PCAP:

    with PcapReader(open(PCAP, 'rb')) as pcap:
        for pkt in pcap:
            PACKETS_0.append(pkt)

else:

    pkt_ind = 0
    for i in range(0, SEND_COUNT_0):
        frame = PACKETS[pkt_ind].copy()
        frame[Raw].load = bytes([i % 256] + [x % 256 for x in range(SIZE_0[randrange(len(SIZE_0))]-1)])
        PACKETS_0.append(frame)

        pkt_ind = (pkt_ind+1) % len(PACKETS)


def hash_toep(data, key):
    k = len(key)*8-32
    key = int.from_bytes(key, 'big')

    h = 0

    for b in data:
        for i in range(8):
            if b & 0x80 >> i:
                h ^= (key >> k) & 0xffffffff
            k -= 1

    return h


def tuple_pack(src_ip, dest_ip, src_port=None, dest_port=None):
    src_ip = ipaddress.ip_address(src_ip)
    dest_ip = ipaddress.ip_address(dest_ip)
    data = b''
    if src_ip.version == 6 or dest_ip.version == 6:
        data += src_ip.packed
        data += dest_ip.packed
    else:
        data += src_ip.packed
        data += dest_ip.packed
    if src_port is not None and dest_port is not None:
        data += src_port.to_bytes(2, 'big') + dest_port.to_bytes(2, 'big')
    return data


hash_key = [
    0x6d, 0x5a, 0x56, 0xda, 0x25, 0x5b, 0x0e, 0xc2,
    0x41, 0x67, 0x25, 0x3d, 0x43, 0xa3, 0x8f, 0xb0,
    0xd0, 0xca, 0x2b, 0xcb, 0xae, 0x7b, 0x30, 0xb4,
    0x77, 0xcb, 0x2d, 0xa3, 0x80, 0x30, 0xf2, 0x0c,
    0x6a, 0x42, 0xb7, 0x3b, 0xbe, 0xac, 0x01, 0xfa
]


class TB(object):
    def __init__(self, dut):
        self.dut = dut

        self.loopback_port = 3
        self.dram_port     = int(dut.DRAM_PORT.value)
        self.tag_width     = int(dut.TAG_WIDTH.value)

        self.log = SimLog("cocotb.tb")
        self.log.setLevel(logging.DEBUG)

        self.slots = []
        self.send_q = deque()
        self.recv_q = deque()
        self.sent_pkts = 0
        self.recvd_pkts = 0

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
            self.log.info("Write instruction memory")
            addr_hdr = (0x0200000000000000).to_bytes(8, 'little')
            ins_frame = AxiStreamFrame(tdata=addr_hdr+ins_seg, tuser=self.dram_port, tdest=0)
            await self.data_ch_source.send(ins_frame)
            await self.data_ch_source.wait()

        self.log.info("Data segment size: %d", len(data_seg))
        if len(data_seg) > 0:
            self.log.debug("%s", hexdump_str(data_seg))
            self.log.info("Write data memory")
            addr_hdr = (0x0000000000000000).to_bytes(8, 'little')
            data_frame = AxiStreamFrame(tdata=addr_hdr+data_seg, tuser=self.dram_port, tdest=0)
            await self.data_ch_source.send(data_frame)
            await self.data_ch_source.wait()

        # TODO: add pmem write

        await Timer(100, 'ns')
        await self.ctrl_ch_source.send([0xf00000000])

        self.log.info("Done loading firmware")

    def send_pkt(self, data, port=0):
        if FLOW_HASH:
            # prepend flow hash
            pkt = Ether(data)
            if pkt.haslayer(TCP):
                h = hash_toep(tuple_pack(pkt[IP].src, pkt[IP].dst, pkt[TCP].sport, pkt[TCP].dport), hash_key)
            elif pkt.haslayer(UDP):
                h = hash_toep(tuple_pack(pkt[IP].src, pkt[IP].dst, pkt[UDP].sport, pkt[UDP].dport), hash_key)
            elif pkt.haslayer(IP):
                h = hash_toep(tuple_pack(pkt[IP].src, pkt[IP].dst), hash_key)
            else:
                h = 0
            data = h.to_bytes(4, 'little')+data

        self.send_q.append(AxiStreamFrame(tdata=data, tuser=port, tkeep=None))

    async def send_manager(self):
        while True:
            if (self.send_q and self.slots):
                pkt = self.send_q.popleft()
                slot = self.slots.pop()
                pkt.tdest = slot
                await ClockCycles(self.dut.clk, randrange(MAX_PKT_SPACING))
                await self.data_ch_source.send(pkt)
                self.sent_pkts += 1
                self.log.debug("Used slot %d for an incoming packet from port %d", slot, pkt.tuser)
            else:
                await RisingEdge(self.dut.clk)

    async def recv_manager(self):
        while True:
            frame = await self.data_ch_sink.recv()
            self.log.debug("Received packet for port %d", frame.tdest)
            if PRINT_RX_PKT:
                self.log.debug("%s", repr(Ether(frame.tdata)))
            self.recv_q.append(frame)
            self.recvd_pkts += 1

    async def scheduler(self):
        cocotb.fork(self.send_manager())
        cocotb.fork(self.recv_manager())
        while True:
            frame = await self.ctrl_ch_sink.recv()
            msg_type = (frame.tdata[0] >> 32) & 0xF
            msg_len  = (frame.tdata[0] >> 0)  & 0xFFFF
            msg_dst  = (frame.tdata[0] >> 24) & 0xFF
            msg_slot = (frame.tdata[0] >> 16) & 0xFF

            if (msg_type == 0):
                self.slots.append(msg_slot)
                self.slots.sort(reverse=True)
            elif (msg_type == 1):
                await ClockCycles(self.dut.clk, 4)
                frame.tdata[0] = frame.tdata[0] & 0xFFFFFFFF
                await self.ctrl_ch_source.send(frame)
            elif (msg_type == 2):
                await ClockCycles(self.dut.clk, 4)
                frame.tdata[0] = (1 << 32) | (self.loopback_port << 24) | (msg_slot << 16) | (msg_dst << self.tag_width)
                await self.ctrl_ch_source.send(frame)
            elif (msg_type == 3):
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

    pkts_set = []

    for pkt in PACKETS_0:
        frame = pkt.build()
        tb.send_pkt(frame)
        pkts_set.append(frame)

    while (tb.sent_pkts < len(PACKETS_0)):
        if (CHECK_PKT):
            if (tb.recv_q):
                frame = bytes(tb.recv_q.popleft().tdata)
                if (frame in pkts_set):
                    pkts_set.remove(frame)
                else:
                    tb.log.debug("corupted pkt, \n%s", hexdump_str(frame))
        await RisingEdge(dut.clk)

    await Timer(WAIT_TIME, 'ns')
    tb.log.debug("%d slots in scheduler, %d packets sent, %d packets received.", len(tb.slots), tb.sent_pkts, tb.recvd_pkts)

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
        os.path.join(smartfpga_rtl_dir, "riscv_axis_wrapper.v"),
        os.path.join(smartfpga_rtl_dir, "mem_sys.v"),
        os.path.join(smartfpga_rtl_dir, "simple_arbiter.v"),
        os.path.join(smartfpga_rtl_dir, "simple_sync_sig.v"),
        os.path.join(smartfpga_rtl_dir, "axis_stat.v"),
        os.path.join(smartfpga_rtl_dir, "header.v"),
        os.path.join(smartfpga_rtl_dir, "axis_fifo.v"),
        os.path.join(smartfpga_rtl_dir, "accel_rd_dma_sp.v"),

        os.path.join(accel_rtl_dir, "accel_wrap_full_ids.v"),
        os.path.join(accel_rtl_dir, "sme", "udp_sme.v"),
        os.path.join(accel_rtl_dir, "sme", "tcp_sme.v"),
        os.path.join(accel_rtl_dir, "sme", "http_sme.v"),
        os.path.join(accel_rtl_dir, "fixed_sme", "fixed_loc_sme_8.v"),
        os.path.join(accel_rtl_dir, "ip_match", "ip_match.v"),

        os.path.join(axis_rtl_dir, "arbiter.v"),
        os.path.join(axis_rtl_dir, "priority_encoder.v"),
        os.path.join(axis_rtl_dir, "sync_reset.v"),
        os.path.join(axis_rtl_dir, "axis_register.v"),
        os.path.join(axis_rtl_dir, "axis_pipeline_register.v"),
    ]

    if parameters is None:
        parameters = {}
    parameters = {k.upper(): v for k, v in parameters.items() if v is not None}

    parameters.setdefault('SLOT_COUNT', 16)

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

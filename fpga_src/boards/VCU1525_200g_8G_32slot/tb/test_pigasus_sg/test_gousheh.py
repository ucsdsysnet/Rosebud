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
from elftools.elf.constants import P_FLAGS
from collections import deque
from random import randrange

import cocotb_test.simulator

import cocotb
from cocotb.log import SimLog
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, ClockCycles

from cocotbext.axi import AxiStreamBus, AxiStreamSource, AxiStreamSink, AxiStreamFrame
from cocotbext.axi.utils import hexdump_str

# print actual port numbers
scapy.config.conf.noenum.add(TCP.sport, TCP.dport, UDP.sport, UDP.dport)

FIRMWARE = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '..', '..', 'accel', 'pigasus_sme', 'c', 'pigasus.elf'))

SEND_COUNT_0 = 1024
SIZE_0 = [66-54, 1500-54, 66-54, 66-54, 1500-54, 1500-54, 66-54]
WAIT_TIME = 50000
MAX_PKT_SPACING = 0
CHECK_PKT = True
PRINT_RX_PKT = False
FLOW_HASH = True

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

PCAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
      '../../accel/pigasus_sme/python/attack.pcap'))
      # '../../accel/pigasus_sme/tb/m10_100.pcap'))

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
        if (int(dut.INIT_ROMS.value)==1):
          self.init_roms    = False
        else:
          self.init_roms    = True


        self.log = SimLog("cocotb.tb")
        self.log.setLevel(logging.DEBUG)

        self.slots = []
        self.send_q = deque()
        self.recv_q = deque()
        self.sent_pkts  = [0]*(self.dram_port+1)
        self.recvd_pkts = [0]*(self.dram_port+1)

        sys_clk = cocotb.fork(Clock(dut.clk, 4, units="ns").start())

        self.data_ch_source = AxiStreamSource(AxiStreamBus.from_prefix(dut, "data_s_axis"),  dut.clk, dut.rst)
        self.data_ch_sink   = AxiStreamSink  (AxiStreamBus.from_prefix(dut, "data_m_axis"),  dut.clk, dut.rst)
        self.ctrl_ch_source = AxiStreamSource(AxiStreamBus.from_prefix(dut, "ctrl_s_axis"),  dut.clk, dut.rst)
        self.ctrl_ch_sink   = AxiStreamSink  (AxiStreamBus.from_prefix(dut, "ctrl_m_axis"),  dut.clk, dut.rst)
        self.dram_ch_source = AxiStreamSource(AxiStreamBus.from_prefix(dut, "dram_s_axis"),  dut.clk, dut.rst)
        self.dram_ch_sink   = AxiStreamSink  (AxiStreamBus.from_prefix(dut, "dram_m_axis"),  dut.clk, dut.rst)
        self.msg_ch_source  = AxiStreamSource(AxiStreamBus.from_prefix(dut, "core_msg_in"),  dut.clk, dut.rst)
        self.msg_ch_sink    = AxiStreamSink  (AxiStreamBus.from_prefix(dut, "core_msg_out"), dut.clk, dut.rst)

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

    async def section_write(self, seg, addr, name, verbose=False):
        self.log.info("%s segment size: %d", name, len(seg))
        if (len(seg)>0):
            self.log.info("Write %s memory", name)
            if (verbose):
                self.log.debug("%s", hexdump_str(seg))
            addr_hdr = (addr<<32).to_bytes(8, 'little')
            frame = AxiStreamFrame(tdata=addr_hdr+seg, tuser=self.dram_port, tdest=0)
            await self.data_ch_source.send(frame)
            await self.data_ch_source.wait()

    async def load_firmware(self, file):
        self.log.info("Load firmware")

        self.log.info("Firmware file: '%s'", file)

        # Put core in reset
        await self.ctrl_ch_source.send([0xf00000001])

        if (not self.init_roms):
            self.log.debug("(ROMs are initialized in Verilog.)")

        # Load instruction and data memories
        with open(file, "rb") as f:
            elf = ELFFile(f)
            for section in elf.iter_sections():
                if (section.header['sh_type']=='SHT_PROGBITS'):
                    if (section.header['sh_flags']==(P_FLAGS.PF_R | P_FLAGS.PF_W)):
                        await self.section_write(section.data(), section.header['sh_addr'], "Instruction", True)
                    elif (section.header['sh_flags']==(P_FLAGS.PF_X | P_FLAGS.PF_W)):
                        await self.section_write(section.data(), section.header['sh_addr'], "Data", True)
                    elif ((section.header['sh_flags']==(P_FLAGS.PF_X)) and self.init_roms):
                        await self.section_write(section.data(), section.header['sh_addr'], section.name[1:])

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
                if (MAX_PKT_SPACING > 0):
                  await ClockCycles(self.dut.clk, randrange(MAX_PKT_SPACING))
                await self.data_ch_source.send(pkt)
                self.sent_pkts[pkt.tuser] += 1
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
            self.recvd_pkts[frame.tdest] += 1

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

    while (sum(tb.sent_pkts) < len(PACKETS_0)):
        if (CHECK_PKT):
            if (tb.recv_q):
                frame = bytes(tb.recv_q.popleft().tdata)
                if (frame in pkts_set):
                    pkts_set.remove(frame)
                else:
                    tb.log.debug("corupted pkt, \n%s", hexdump_str(frame))
        await RisingEdge(dut.clk)

    await Timer(WAIT_TIME, 'ns')
    tb.log.debug("%d slots in scheduler, %d packets sent, %d packets received.", len(tb.slots), sum(tb.sent_pkts), sum(tb.recvd_pkts))
    tb.log.debug("packets sent per port:     "+str(tb.sent_pkts));
    tb.log.debug("packets received per port: "+str(tb.recvd_pkts));

    await RisingEdge(dut.clk)

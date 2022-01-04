#!/usr/bin/env python3

"""

Copyright (c) 2021 Moein Khazraee

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

from cocotbext.axi import AxiStreamBus, AxiStreamSource, AxiStreamSink, AxiStreamFrame
from cocotbext.axi.utils import hexdump_str

# print actual port numbers
scapy.config.conf.noenum.add(TCP.sport, TCP.dport, UDP.sport, UDP.dport)

PCAP         = os.path.abspath(os.path.join(os.path.dirname(__file__),
                '../python/attack.pcap'))
                # 'm10_100.pcap'))

SPARSE_PKTS = False
PREAMBLE    = True
PACKETS     = []

with PcapReader(open(PCAP, 'rb')) as pcap:
    for pkt in pcap:
        if TCP in pkt:
          PACKETS.append((pkt[Raw].load, 1, pkt[TCP].sport, pkt[TCP].dport))
        elif UDP in pkt:
          PACKETS.append((pkt[Raw].load, 0, pkt[UDP].sport, pkt[UDP].dport))

@cocotb.test()
async def run_test_pigasus(dut):

    sys_clk = cocotb.fork(Clock(dut.clk, 2).start())

    data_ch_source = AxiStreamSource(AxiStreamBus.from_prefix(dut, "s_axis"),  dut.clk, dut.rst)
    data_ch_source.log.setLevel("WARNING")

    if (PREAMBLE):
      dut.has_preamble <= 1
    else:
      dut.has_preamble <= 0

    dut.preamble <= 0xFEFEFEFEFEFEFE

    dut.meta_valid <= 0
    dut.rst <= 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst <= 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst <= 0

    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    for pkt in PACKETS:
        await RisingEdge(dut.clk)
        dut.is_tcp     <= pkt[1]
        dut.src_port   <= pkt[2]
        dut.dst_port   <= pkt[3]
        dut.meta_valid <= 1
        await RisingEdge(dut.clk)
        dut.meta_valid <= 0
        await data_ch_source.send(pkt[0])
        if (SPARSE_PKTS):
          await data_ch_source.wait()

    if (not SPARSE_PKTS):
      for pkt in PACKETS:
        await data_ch_source.wait()

    await Timer(1000)
    await RisingEdge(dut.clk)

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
                'm10_100.pcap'))

PACKETS_0 = []

with PcapReader(open(PCAP, 'rb')) as pcap:
    for pkt in pcap:
        PACKETS_0.append(bytearray(8*[255])+pkt[Raw].load)
        # print (pkt[TCP].sport, pkt[TCP].dport)

@cocotb.test()
async def run_test_pigasus(dut):

    sys_clk = cocotb.fork(Clock(dut.clk, 2).start())
        
    data_ch_source = AxiStreamSource(AxiStreamBus.from_prefix(dut, "s_axis"),  dut.clk, dut.rst)
    data_ch_source.log.setLevel("WARNING")

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

    for pkt in PACKETS_0:
        await RisingEdge(dut.clk)
        await data_ch_source.send(pkt)
        await data_ch_source.wait()

    await Timer(1000)
    await RisingEdge(dut.clk)

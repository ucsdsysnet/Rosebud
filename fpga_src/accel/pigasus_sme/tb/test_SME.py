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

from cocotbext.axi import AxiStreamBus, AxiStreamSource, AxiStreamSink, AxiStreamFrame
from cocotbext.axi.utils import hexdump_str

# print actual port numbers
scapy.config.conf.noenum.add(TCP.sport, TCP.dport, UDP.sport, UDP.dport)

PCAP         = os.path.abspath(os.path.join(os.path.dirname(__file__),
                '../python/attack.pcap'))
                # 'm10_100.pcap'))

PACKETS = []

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
        # await data_ch_source.wait()

    await Timer(1000)
    await RisingEdge(dut.clk)

#!/usr/bin/env python3
"""

Copyright (c) 2019-2021 Moein Khazraee

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

from RPU_API import TB


# print actual port numbers
scapy.config.conf.noenum.add(TCP.sport, TCP.dport, UDP.sport, UDP.dport)

FIRMWARE = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '..', '..', 'accel', 'ip_matcher', 'c', 'firewall.elf'))

SEND_COUNT_0 = 100
SIZES = [64, 1500, 64, 64, 1500, 1500, 64]
WAIT_TIME = 5000
CHECK_PKT = True
PRINT_RX_PKT = False
FLOW_HASH = False
READ_PCAP = True

PACKETS = []

eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
ip = IP(src='192.168.1.100', dst='192.168.1.101')
udp = UDP(sport=1234, dport=5678)
payload = bytes([0]+[x % 256 for x in range(SIZES[0]-1-42)])
test_pkt = eth / ip / udp / payload
PACKETS.append(test_pkt)

eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
ip = IP(src='192.168.1.100', dst='192.168.1.101')
tcp = TCP(sport=1234, dport=5678)
payload = bytes([0]+[x % 256 for x in range(SIZES[0]-1-54)])
test_pkt = eth / ip / tcp / payload
PACKETS.append(test_pkt)

eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
ip = IP(src='192.168.1.100', dst='192.168.1.101')
tcp = TCP(sport=12345, dport=80)
payload = bytes([0]+[x % 256 for x in range(SIZES[0]-1-54)])
test_pkt = eth / ip / tcp / payload
PACKETS.append(test_pkt)

eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
ip = IP(src='192.168.1.100', dst='192.168.1.101')
tcp = TCP(sport=54321, dport=80)
payload = bytes([0]+[x % 256 for x in range(SIZES[0]-1-54)])
test_pkt = eth / ip / tcp / payload
PACKETS.append(test_pkt)

PCAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
        '../../accel/ip_matcher/python/firewall_test.pcap'))

PACKETS_0 = []

if READ_PCAP:

    with PcapReader(open(PCAP, 'rb')) as pcap:
        for pkt in pcap:
            PACKETS_0.append(pkt)

else:

    pkt_ind = 0
    for i in range(0, SEND_COUNT_0):
        frame = PACKETS[pkt_ind].copy()
        if TCP in frame:
            frame[Raw].load = bytes([i % 256] + [x % 256 for x in range(SIZES[randrange(len(SIZES))]-1-54)])
        else: # UDP
            frame[Raw].load = bytes([i % 256] + [x % 256 for x in range(SIZES[randrange(len(SIZES))]-1-42)])

        PACKETS_0.append(frame)

        pkt_ind = (pkt_ind+1) % len(PACKETS)


@cocotb.test()
async def run_test_RPU(dut):
    tb = TB(dut)
    if (FLOW_HASH):
      tb.set_flow_hash()
    if (PRINT_RX_PKT):
      tb.print_rx_pkt()
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
                    tb.log.debug("Corrupted pkt, \n%s", hexdump_str(frame))
        await RisingEdge(dut.clk)

    await Timer(WAIT_TIME, 'ns')
    tb.log.debug("%d slots in scheduler, %d packets sent, %d packets received.", len(tb.slots), sum(tb.sent_pkts), sum(tb.recvd_pkts))
    tb.log.debug("packets sent per port:     "+str(tb.sent_pkts));
    tb.log.debug("packets received per port: "+str(tb.recvd_pkts));

    await RisingEdge(dut.clk)

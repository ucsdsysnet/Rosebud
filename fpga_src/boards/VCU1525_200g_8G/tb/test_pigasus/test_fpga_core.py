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

import os
import sys

import scapy.config
from scapy.packet import Raw
from scapy.layers.l2 import Ether
from scapy.layers.inet import IP, UDP, TCP
from scapy.utils import PcapReader

import cocotb_test.simulator

import cocotb
from cocotb.log import SimLog
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, ClockCycles

from cocotbext.axi.utils import hexdump_str

try:
    import mqnic
    from common import TB
except ImportError:
    # attempt import from current directory
    sys.path.insert(0, os.path.join(os.path.dirname(__file__)))
    try:
        import mqnic
        from common import TB
    finally:
        del sys.path[0]

# print actual port numbers
scapy.config.conf.noenum.add(TCP.sport, TCP.dport, UDP.sport, UDP.dport)

SEND_COUNT_0 = 50
SEND_COUNT_1 = 50
SIZE_0       = 512 - 14
SIZE_1       = 512 - 14
CHECK_PKT    = False
PRINT_RX_PKT = False
WAIT_TIME = 5000000

FIRMWARE = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '..', '..', 'accel', 'pigasus_sme', 'c', 'pigasus.elf'))

PACKETS = []

eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
ip = IP(src='192.168.1.100', dst='192.168.1.101')
udp = UDP(sport=1234, dport=5678)
payload = bytes([0]+[0]+[x % 256 for x in range(SIZE_0-2)])
test_pkt = eth / ip/ udp / payload
PACKETS.append(test_pkt)

eth = Ether(src='DA:D1:D2:D3:D4:D5', dst='5A:51:52:53:54:55')
ip = IP(src='192.168.1.102', dst='192.168.1.101')
tcp = TCP(sport=1234, dport=5678)
payload = bytes([0]+[0]+[x % 256 for x in range(SIZE_1-2)])
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
        for pkt in pcap:
            PACKETS_0.append(pkt)

else:

    pkt_ind = 0
    for i in range(0, SEND_COUNT_0):
        frame = PACKETS[pkt_ind].copy()
        frame[Raw].load = bytes([i % 256] + [x % 256 for x in range(SIZE_0[randrange(len(SIZE_0))]-1)])
        PACKETS_0.append(frame)

        pkt_ind = (pkt_ind+1) % len(PACKETS)


@cocotb.test()
async def run_test_ins_load(dut):

    tb = TB(dut)

    await tb.init()

    await tb.set_enable_interfaces(0x0000)

    await tb.load_firmware(FIRMWARE)

    tb.log.info("Set core enable mask")
    await tb.set_enable_cores(0xffff)
    await tb.set_receive_cores(0xffff)
    await tb.set_enable_interfaces(0xffff)
    await Timer(100, 'ns')

    if (CHECK_PKT):
        tb.log.info("Init corundum driver")
        await tb.driver.init_dev(tb.dev.functions[0].pcie_id)
        await tb.driver.interfaces[0].open()

        # enable queues
        tb.log.info("Enable queues")
        await tb.rc.mem_write_dword(tb.driver.interfaces[0].ports[0].hw_addr+mqnic.MQNIC_PORT_REG_SCHED_ENABLE, 0x00000001)
        # for k in range(tb.driver.interfaces[0].tx_queue_count):
        #     await tb.rc.mem_write_dword(tb.driver.interfaces[0].ports[0].schedulers[0].hw_addr+4*k, 0x00000003)

        # wait for all writes to complete
        await tb.rc.mem_read(tb.driver.hw_addr, 4)
        tb.log.info("Corundum init complete")

    tb.log.info("Send data from LAN")
    tb.qsfp0_source.log.setLevel("WARNING")
    tb.qsfp1_source.log.setLevel("WARNING")
    tb.qsfp0_sink.log.setLevel("WARNING")
    tb.qsfp1_sink.log.setLevel("WARNING")
    tb.host_if_tx_mon.log.setLevel("WARNING")
    tb.host_if_rx_mon.log.setLevel("WARNING")
    tb.rc.log.setLevel("WARNING")
    tb.driver.log.setLevel("WARNING")

    pkts_set = []

    for i in range(0, len(PACKETS_0),2):
        frame = PACKETS_0[i].build()
        await tb.qsfp0_source.send(frame)
        pkts_set.append(frame)

    for i in range(1, len(PACKETS_0),2):
        frame = PACKETS_0[i].build()
        await tb.qsfp1_source.send(frame)
        pkts_set.append(frame)


    if (CHECK_PKT):
        while (tb.driver.interfaces[0].pkt_rx_queue):
            rx_frame = await tb.driver.interfaces[0].recv().tdata
            tb.log.info("packet number from port 0: %d", j)
            if PRINT_RX_PKT:
                tb.log.debug("%s", hexdump_str(rx_frame))
            if (rx_frame in pkts_set):
                pkts_set.remove(rx_frame)
            else:
                tb.log.debug("corupted pkt, \n%s", hexdump_str(rx_frame))

    await tb.qsfp0_source.wait()
    await tb.qsfp1_source.wait()

    await Timer(WAIT_TIME, 'ns')

    tb.log.info("Read counters")
    for k in range(0, 8):
        slots      = await tb.read_core_slots(k)
        await Timer(100, 'ns')
        bytes_in   = await tb.core_rd_cmd(k, 0)
        await Timer(100, 'ns')
        frames_in  = await tb.core_rd_cmd(k, 1)
        await Timer(100, 'ns')
        bytes_out  = await tb.core_rd_cmd(k, 3)
        await Timer(100, 'ns')
        frames_out = await tb.core_rd_cmd(k, 4)
        await Timer(100, 'ns')

        tb.log.info("Core %d stat read, slots: , bytes_in, byte_out, frames_in, frames_out", k)
        tb.log.info("%d, %d, %d, %d, %d", slots, bytes_in, bytes_out, frames_in, frames_out)

    for k in range(0, 3):
        bytes_in   = await tb.interface_stat_rd(k, 0, 0)
        await Timer(100, 'ns')
        bytes_out  = await tb.interface_stat_rd(k, 1, 0)
        await Timer(100, 'ns')
        frames_in  = await tb.interface_stat_rd(k, 0, 1)
        await Timer(100, 'ns')
        frames_out = await tb.interface_stat_rd(k, 1, 1)
        await Timer(100, 'ns')
        desc       = await tb.read_interface_desc(k)
        tb.log.info("Interface %d stat read, bytes_in, byte_out, frames_in, frames_out, loaded desc", k)
        tb.log.info("%d, %d, %d, %d, %08x", bytes_in, bytes_out, frames_in, frames_out, desc)

    await RisingEdge(dut.pcie_clk)
    await RisingEdge(dut.pcie_clk)


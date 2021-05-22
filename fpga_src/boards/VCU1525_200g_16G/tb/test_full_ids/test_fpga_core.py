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

import os
import sys

import scapy.config
from scapy.packet import Raw
from scapy.layers.l2 import Ether
from scapy.layers.inet import IP, UDP, TCP
from scapy.utils import PcapReader

import cocotb_test.simulator

import cocotb
from cocotb.triggers import RisingEdge, Timer

from cocotbext.axi import AxiStreamBus, AxiStreamMonitor
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


# SEND_COUNT_0 = 6 # 5000
# SEND_COUNT_1 = 6 # 5000
# SEND_COUNT_0 = 256
# SEND_COUNT_1 = 256
SEND_COUNT_0 = 1024
SEND_COUNT_1 = 1024
# SIZE_0       = [64, 128, 256, 512, 1024, 2048, 4096, 9000, 9000, 2048, 4096, 1024, 1500, 256, 128, 1024]
# SIZE_1       = [64, 128, 256, 512, 1024, 2048, 4096, 9000, 9000, 2048, 4096, 1024, 1500, 256, 128, 1024]
# SIZE_0       = [64, 128, 256, 512, 1024, 2048, 2048, 1024, 1500, 256, 128, 1024]
# SIZE_1       = [64, 128, 256, 512, 1024, 2048, 2048, 1024, 1500, 256, 128, 1024]
SIZE_0       = [64, 128, 256, 512, 1024, 1024, 1500, 256, 128, 1024]
SIZE_1       = [64, 128, 256, 512, 1024, 1024, 1500, 256, 128, 1024]
# SIZE_0       = [10, 10, 10, 1460, 1460, 1460]
# SIZE_1       = [10, 10, 10, 1460, 1460, 1460]
# SIZE_0       = [1460]
# SIZE_1       = [1460]
# SIZE_0       = [1455]
# SIZE_1       = [1455]
SIZE_0       = [12, 1460, 1460]
SIZE_1       = [12, 1460, 1460]
CHECK_PKT    = True
DROP_RATE    = 1  #0.66
TEST_PCIE    = False
TEST_DEBUG   = True
PRINT_PKTS   = True
ACCEL_MON    = False

PATTERNS     = [
    b"GET AAAAAAAA HTTP/1.1",
    b"GET / HTTP/1.1\r\n\r\n\r\n",
    b"HTTP/1.0\r\nAccept: */*\r\nAccept-Language: ",
]

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
PACKETS_1 = []

if PCAP:

    with PcapReader(open(PCAP, 'rb')) as pcap:
        for pkt in pcap:
            PACKETS_0.append(pkt)
            PACKETS_1.append(pkt)

else:

    pkt_ind = 0
    pat_ind = 0
    for i in range(0, SEND_COUNT_0):
        frame = PACKETS[pkt_ind].copy()
        frame[Raw].load = PATTERNS[pat_ind] + bytes([i % 256] + [x % 256 for x in range(max(0, SIZE_0[i % len(SIZE_0)]-1-len(PATTERNS[pat_ind])))])
        PACKETS_0.append(frame)

        pkt_ind = (pkt_ind+1) % len(PACKETS)
        pat_ind = (pat_ind+1) % len(PATTERNS)

    pkt_ind = 0
    pat_ind = 0
    for i in range(0, SEND_COUNT_1):
        frame = PACKETS[pkt_ind].copy()
        frame[Raw].load = PATTERNS[pat_ind] + bytes([i % 256] + [x % 256 for x in range(max(0, SIZE_1[i % len(SIZE_1)]-1-len(PATTERNS[pat_ind])))])
        PACKETS_1.append(frame)

        pkt_ind = (pkt_ind+1) % len(PACKETS)
        pat_ind = (pat_ind+1) % len(PATTERNS)


FIRMWARE = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '..', '..', 'accel', 'full_ids', 'c', 'full_ids.elf'))


@cocotb.test()
async def run_test_full_ids(dut):

    tb = TB(dut)

    await tb.init()

    if ACCEL_MON:
        # monitor accelerator DMA channels
        core_accel_mon = []
        for core in dut.UUT.riscv_cores:
            lst = []
            for inst in core.pr_wrapper.Gousheh_inst.accel_wrap_inst.width_converters_1B:
                lst.append(AxiStreamMonitor(AxiStreamBus.from_prefix(inst.accel_width_conv_inst, 'm_axis'), dut.pcie_clk, dut.pcie_rst, byte_size=8))
            for inst in core.pr_wrapper.Gousheh_inst.accel_wrap_inst.width_converters_8B:
                lst.append(AxiStreamMonitor(AxiStreamBus.from_prefix(inst.accel_width_conv_inst, 'm_axis'), dut.pcie_clk, dut.pcie_rst, byte_size=8))
            core_accel_mon.append(lst)

    # load core firmware
    await tb.load_firmware(FIRMWARE)

    tb.log.info("Set core enable mask")
    await tb.set_enable_cores(0xffff)
    await tb.set_receive_cores(0xffff)
    await tb.set_enable_interfaces(0xffff)
    await Timer(100, 'ns')

    if (TEST_DEBUG):
        tb.log.info("Debug Test")
        await Timer(1000, 'ns')

        for i in range(0, 16):
            await tb.core_wr_cmd(i, 0x8, 0x1234ABCD)
            await Timer(200, 'ns')
            await tb.core_wr_cmd(i, 0x9, 0x1234ABCD)
            await Timer(200, 'ns')
            await tb.core_wr_cmd(i, 0xC, 0x1234ABCD)
            await Timer(200, 'ns')
            await tb.core_wr_cmd(i, 0xC, 0)
            await Timer(200, 'ns')

    tb.log.info("Send data from LAN")
    tb.qsfp0_source.log.setLevel("WARNING")
    tb.qsfp1_source.log.setLevel("WARNING")
    tb.qsfp0_sink.log.setLevel("WARNING")
    tb.qsfp1_sink.log.setLevel("WARNING")
    tb.host_if_tx_mon.log.setLevel("WARNING")
    tb.host_if_rx_mon.log.setLevel("WARNING")

    pkts_set_0 = set()

    for pkt in PACKETS_0:
        frame = pkt.build()
        await tb.qsfp0_source.send(frame)
        pkts_set_0.add(frame)

    pkts_set_1 = set()

    for pkt in PACKETS_1:
        frame = pkt.build()
        await tb.qsfp1_source.send(frame)
        pkts_set_1.add(frame)

    lengths = []
    for j in range(0, int(len(PACKETS_1)*(1.0-DROP_RATE))):  # we drop half, so expect at least getting 1/3rd
        rx_frame = await tb.qsfp0_sink.recv()
        tb.log.info("packet number from port 0:", j)
        if PRINT_PKTS:
            tb.log.debug("%s", hexdump_str(bytes(rx_frame), row_size=32))
        if (CHECK_PKT):
            assert Ether(rx_frame.tdata).build() in pkts_set_0
            pkts_set_0.remove(Ether(rx_frame.tdata).build())
        lengths.append(len(rx_frame.data)-8)

    for j in range(0, int(len(PACKETS_0)*(1.0-DROP_RATE))):
        rx_frame = await tb.qsfp1_sink.recv()
        tb.log.info("packet number from port 1:", j)
        if PRINT_PKTS:
            tb.log.debug("%s", hexdump_str(bytes(rx_frame), row_size=32))
        if (CHECK_PKT):
            assert Ether(rx_frame.tdata).build() in pkts_set_1
            pkts_set_1.remove(Ether(rx_frame.tdata).build())
        lengths.append(len(rx_frame.data)-8)

    await tb.qsfp0_source.wait()
    await tb.qsfp1_source.wait()

    if DROP_RATE == 1:
        await Timer(20000, 'ns')
    else:
        await Timer(1000, 'ns')

    tb.log.info("Read counters")

    for k in range(0, 16):
        slots      = await tb.read_core_slots(k)
        await Timer(100, 'ns')
        bytes_in   = await tb.core_rd_cmd(k, 0)
        await Timer(100, 'ns')
        frames_in  = await tb.core_rd_cmd(k, 1)
        await Timer(100, 'ns')
        bytes_out  = await tb.core_rd_cmd(k, 2)
        await Timer(100, 'ns')
        frames_out = await tb.core_rd_cmd(k, 3)
        await Timer(100, 'ns')

        tb.log.info("Core %d stat read, slots: , bytes_in, byte_out, frames_in, frames_out", k)
        tb.log.info("%d, %d, %d, %d, %d", slots, bytes_in, bytes_out, frames_in, frames_out)

        if (TEST_DEBUG):
            debug_l   = await tb.core_rd_cmd(k, 4)
            await Timer(100, 'ns')
            debug_h  = await tb.core_rd_cmd(k, 5)
            await Timer(100, 'ns')
            tb.log.info("Core %d debug_h, debug_l", k)
            tb.log.info("%08x, %08x", debug_h, debug_l)

    for k in range(0, 3):
        bytes_in   = await tb.interface_rd_cmd(k, 0, 0)
        await Timer(100, 'ns')
        bytes_out  = await tb.interface_rd_cmd(k, 1, 0)
        await Timer(100, 'ns')
        frames_in  = await tb.interface_rd_cmd(k, 0, 1)
        await Timer(100, 'ns')
        frames_out = await tb.interface_rd_cmd(k, 1, 1)
        await Timer(100, 'ns')
        desc       = await tb.read_interface_desc(k)
        tb.log.info("Interface %d stat read, bytes_in, byte_out, frames_in, frames_out, loaded desc", k)
        tb.log.info("%d, %d, %d, %d, %08x", bytes_in, bytes_out, frames_in, frames_out, desc)

    if (ACCEL_MON):
        # accelerator data
        for k in range(len(core_accel_mon)):
            core = core_accel_mon[k]
            for x in range(len(core)):
                accel = core[x]
                while not accel.empty():
                    data = accel.recv_nowait()

                    tb.log.info("Core %d accel %d packet length %d", k, x, len(data.tdata))

    await RisingEdge(dut.pcie_clk)
    await RisingEdge(dut.pcie_clk)

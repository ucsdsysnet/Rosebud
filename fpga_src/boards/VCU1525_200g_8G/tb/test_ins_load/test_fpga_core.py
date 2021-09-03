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

from scapy.packet import Raw
from scapy.layers.l2 import Ether
from scapy.layers.inet import IP, UDP, TCP

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


SEND_COUNT_0 = 50
SEND_COUNT_1 = 50
SIZE_0       = 512 - 14
SIZE_1       = 512 - 14
CHECK_PKT    = True
DROP_TEST    = False
TEST_SFP     = True
TEST_PCIE    = True
TEST_DEBUG   = True
TEST_RELOAD  = False
PRINT_PKTS   = True

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


FIRMWARE = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '..', '..', '..', '..', '..', 'c_code', 'basic_fw.elf'))
  # '..', '..', '..', '..', '..', 'c_code', 'basic_fw_n_bc.elf'))
  # '..', '..', '..', '..', '..', 'c_code', 'dram_test.elf'))
  # '..', '..', '..', '..', '..', 'c_code', 'drop.elf'))


@cocotb.test()
async def run_test_ins_load(dut):

    tb = TB(dut)

    await tb.init()

    await tb.set_enable_interfaces(0x0000)

    if (TEST_PCIE):
        tb.log.info("PCIe Test")

        data = bytes(range(256))

        # write pcie read descriptor and read status
        tb.log.info("Write data to core")
        await tb.block_write(data, (4 << 26)+0x1020100, 0x400)
        val = await tb.rc.mem_read_dword(tb.dev_pf0_bar0+0x000458)
        tb.log.info("PCIe write flag: 0x%08x", val)

        # write pcie write descriptor and read status
        tb.log.info("Read data from core")
        check_data = await tb.block_read((4 << 26)+0x1020100, len(data))
        val = await tb.rc.mem_read_dword(tb.dev_pf0_bar0+0x000478)
        tb.log.info("PCIe read flag: 0x%08x", val)

        tb.log.info("Original data")
        tb.log.debug("%s", hexdump_str(data))

        tb.log.info("Readback data")
        tb.log.debug("%s", hexdump_str(check_data))

        assert data == check_data

    await tb.load_firmware(FIRMWARE)

    tb.log.info("Set core enable mask")
    await tb.set_enable_cores(0xffff)
    await tb.set_receive_cores(0xffff)
    await tb.set_enable_interfaces(0xffff)
    await Timer(100, 'ns')

    if (TEST_DEBUG):
        tb.log.info("Debug Test")
        await Timer(1000, 'ns')

        for i in range(0, 8):
            await tb.core_wr_cmd(i, 0x8, 0x1234ABCD)
            await Timer(200, 'ns')
            await tb.core_wr_cmd(i, 0x9, 0x1234ABCD)
            await Timer(200, 'ns')
            await tb.core_wr_cmd(i, 0xC, 0x1234ABCD)
            await Timer(200, 'ns')
            await tb.core_wr_cmd(i, 0xC, 0)
            await Timer(200, 'ns')

    if (TEST_SFP):
        tb.log.info("Send data from LAN")
        tb.qsfp0_source.log.setLevel("WARNING")
        tb.qsfp1_source.log.setLevel("WARNING")
        tb.qsfp0_sink.log.setLevel("WARNING")
        tb.qsfp1_sink.log.setLevel("WARNING")
        tb.host_if_tx_mon.log.setLevel("WARNING")
        tb.host_if_rx_mon.log.setLevel("WARNING")

        pkt_ind = 0
        for i in range(0, SEND_COUNT_0):
            frame = PACKETS[pkt_ind].copy()
            # frame[Raw].load = bytes([i % 256] + [x % 256 for x in range(max(0, SIZE_0[i % len(SIZE_0)]-1-len(PATTERNS[pat_ind])))])
            await tb.qsfp0_source.send(frame.build())

        pkt_ind = 1
        for i in range(0, SEND_COUNT_1):
            frame = PACKETS[pkt_ind].copy()
            # frame[Raw].load = bytes([i % 256] + [x % 256 for x in range(max(0, SIZE_1[i % len(SIZE_1)]-1-len(PATTERNS[pat_ind])))])
            await tb.qsfp1_source.send(frame.build())

        if (not DROP_TEST):
            lengths = []
            # basic_fw sends to the same port
            for j in range(0, SEND_COUNT_0):
                rx_frame = await tb.qsfp0_sink.recv()
                tb.log.info("packet number from port 0: %d", j)
                if PRINT_PKTS:
                    tb.log.debug("%s", hexdump_str(bytes(rx_frame)))
                if (CHECK_PKT):
                    assert Ether(rx_frame.tdata).build() == PACKETS[0].build()
                    # assert rx_frame.tdata[0:14] == PACKETS[0].payload[0:14]
                    # assert rx_frame.tdata[15:]  == PACKETS[0].payload[15:]
                lengths.append(len(rx_frame.tdata)-8)

            for j in range(0, SEND_COUNT_1):
                rx_frame = await tb.qsfp1_sink.recv()
                tb.log.info("packet number from port 1: %d", j)
                if PRINT_PKTS:
                    tb.log.debug("%s", hexdump_str(bytes(rx_frame)))
                if (CHECK_PKT):
                    assert Ether(rx_frame.tdata).build() == PACKETS[1].build()
                    # assert rx_frame.tdata[0:14] == PACKETS[1].payload[0:14]
                    # assert rx_frame.tdata[15:]  == PACKETS[1].payload[15:]
                lengths.append(len(rx_frame.tdata)-8)

            await tb.qsfp0_source.wait()
            await tb.qsfp1_source.wait()

    await Timer(5000, 'ns')

    if (TEST_RELOAD):
        tb.log.info("Firmware reload")
        await tb.load_firmware(FIRMWARE)

    tb.log.info("Reset single cores 4 to 7")
    for k in range(4, 7):
        await tb.reset_single_core(k)

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

        if (TEST_DEBUG):
            debug_l   = await tb.core_rd_cmd(k, 6)
            await Timer(100, 'ns')
            debug_h  = await tb.core_rd_cmd(k, 7)
            await Timer(100, 'ns')
            tb.log.info("Core %d debug_h, debug_l", k)
            tb.log.info("%08x, %08x", debug_h, debug_l)

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


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


PRINT_PKTS = True
WAIT_TIME  = 100

FIRMWARE = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '..', '..', '..', '..', '..', 'riscv_code', 'basic_pkt_gen.elf'))
  # '..', '..', '..', '..', '..', 'riscv_code', 'pkt_gen.elf'))


@cocotb.test()
async def run_test_pkt_gen(dut):

    tb = TB(dut)
        
    tb.qsfp0_sink.log.setLevel("WARNING")
    tb.qsfp1_sink.log.setLevel("WARNING")
    tb.host_if_tx_mon.log.setLevel("WARNING")
    tb.host_if_rx_mon.log.setLevel("WARNING")

    await tb.init()

    await tb.load_firmware(FIRMWARE)

    tb.log.info("Set core enable mask")
    await tb.set_enable_cores(0xffff)
    await tb.set_receive_cores(0xffff)
    await tb.set_enable_interfaces(0xffff)

    await Timer(WAIT_TIME, 'ns')
        
    await tb.reset_all_cores()

    tb.log.info("Read counters")
    for k in range(0, 8):
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

    pkt_count = 2*[0]

    for k in range(0, 2):
        bytes_in   = await tb.interface_stat_rd(k, 0, 0)
        await Timer(100, 'ns')
        bytes_out  = await tb.interface_stat_rd(k, 1, 0)
        await Timer(100, 'ns')
        frames_in  = await tb.interface_stat_rd(k, 0, 1)
        await Timer(100, 'ns')
        frames_out = await tb.interface_stat_rd(k, 1, 1)
        await Timer(100, 'ns')
        desc       = await tb.read_interface_desc(k)

        pkt_count[k] = frames_out
        tb.log.info("Interface %d stat read, bytes_in, byte_out, frames_in, frames_out, loaded desc", k)
        tb.log.info("%d, %d, %d, %d, %08x", bytes_in, bytes_out, frames_in, frames_out, desc)
        
        
    if (PRINT_PKTS):
        tb.log.info("packets from port 0:")
        for j in range (0,min(pkt_count[0],250)):
            rx_frame = await tb.qsfp0_sink.recv()
            tb.log.debug("%s", hexdump_str(bytes(rx_frame)[0:8]))

        tb.log.info("packets from port 1:")
        for j in range (0,min(pkt_count[1],250)):
            rx_frame = await tb.qsfp1_sink.recv()
            tb.log.debug("%s", hexdump_str(bytes(rx_frame)[0:8]))

    await RisingEdge(dut.pcie_clk)
    await RisingEdge(dut.pcie_clk)

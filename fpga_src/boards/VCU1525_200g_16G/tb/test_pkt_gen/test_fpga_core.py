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


PRINT_PKTS = True
WAIT_TIME  = 100

FIRMWARE = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '..', '..', '..', '..', '..', 'c_code', 'basic_pkt_gen.elf'))
  # '..', '..', '..', '..', '..', 'c_code', 'pkt_gen.elf'))


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

    pkt_count = 2*[0]

    for k in range(0, 2):
        bytes_in   = await tb.interface_rd_cmd(k, 0, 0)
        await Timer(100, 'ns')
        bytes_out  = await tb.interface_rd_cmd(k, 1, 0)
        await Timer(100, 'ns')
        frames_in  = await tb.interface_rd_cmd(k, 0, 1)
        await Timer(100, 'ns')
        frames_out = await tb.interface_rd_cmd(k, 1, 1)
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

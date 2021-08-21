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
WAIT_TIME  = 100000

FIRMWARE = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '..', '..', '..', '..', '..', 'c_code', 'latency.elf'))
  # '..', '..', '..', '..', '..', 'c_code', 'bc_test2.elf'))


@cocotb.test()
async def run_test_latency(dut):

    tb = TB(dut)
        
    tb.qsfp0_sink.log.setLevel("WARNING")
    tb.qsfp1_sink.log.setLevel("WARNING")
    tb.qsfp0_source.log.setLevel("WARNING")
    tb.qsfp1_source.log.setLevel("WARNING")
    tb.host_if_tx_mon.log.setLevel("WARNING")
    tb.host_if_rx_mon.log.setLevel("WARNING")

    tb.loopback_enable = True
    await tb.init()

    await tb.load_firmware(FIRMWARE)

    tb.log.info("Set core enable mask")
    await tb.set_enable_cores(0xffff)
    await tb.set_receive_cores(0xaaaa)
    await tb.set_enable_interfaces(0xffff)

    await Timer(WAIT_TIME, 'ns')
        
    await tb.reset_all_cores()

    tb.log.info("Read data from core")
    check_data = await tb.block_read((5 << 26)+0x1080000, 0x800)
    val = await tb.rc.mem_read_dword(tb.dev_pf0_bar0+0x000478)
    tb.log.info("PCIe read flag: 0x%08x", val)
    
    for i in range(0, len(check_data), 8):
        swap1 = bytearray(check_data[i:i+4])
        swap1.reverse()
        swap2 = bytearray(check_data[i+4:i+8])
        swap2.reverse()
        print("".join(("{:02x}".format(c) for c in swap1)),"".join(("{:02x}".format(c) for c in swap2)))

    await RisingEdge(dut.pcie_clk)
    await RisingEdge(dut.pcie_clk)

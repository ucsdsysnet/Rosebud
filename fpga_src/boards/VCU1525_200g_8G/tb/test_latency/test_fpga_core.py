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

from Shire_API import TB
import mqnic


PRINT_PKTS = True
WAIT_TIME  = 100000

FIRMWARE = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '..', '..', '..', '..', '..', 'riscv_code', 'latency.elf'))
  # '..', '..', '..', '..', '..', 'riscv_code', 'bc_test2.elf'))


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

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

import ipaddress
import logging
import os

from collections import deque
from random import randrange

import cocotb_test.simulator

import cocotb
from cocotb.log import SimLog
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, ClockCycles

from cocotbext.axi import AxiStreamBus, AxiStreamSource, AxiStreamSink, AxiStreamFrame
from cocotbext.axi.utils import hexdump_str

def ip_to_num (ip):
    ip_bytes = ip.split('/')[0]
    ip_bytes = [int(x) for x in ip_bytes.split('.')]
    return ((ip_bytes[0]<<24) + (ip_bytes[1]<<16) + (ip_bytes[2]<<8) + ip_bytes[3])

@cocotb.test()
async def run_test_pigasus(dut):
    rules = open('../python/firewall.txt','r')

    sys_clk = cocotb.fork(Clock(dut.clk, 2).start())

    dut.ip_valid = 0

    dut.rst <= 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst <= 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst <= 0

    await RisingEdge(dut.clk)

    for line in rules:
      dut.ip = ip_to_num(line.strip())
      dut.ip_valid = 1
      await RisingEdge(dut.clk)
      dut.ip_valid = 0
      await RisingEdge(dut.clk)
      await RisingEdge(dut.clk)
      assert ((int(dut.match.value)==1) and (int(dut.match_valid.value)==1))

    dut.ip = ip_to_num('8.8.8.8/32')
    dut.ip_valid = 1
    await RisingEdge(dut.clk)
    dut.ip_valid = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert ((int(dut.match.value)==0) and (int(dut.match_valid.value)==1))

    await ClockCycles(dut.clk,10)

    rules.close()

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

import cocotb_test.simulator

import cocotb
from cocotb.log import SimLog
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles
import random

b = 0x0b4e0ef37bc32127

def twos_comp(val):
  if val < 0:
    val = (1<<64) + val
  else:
    if (val & (1 << 63)) != 0:
      val = val - (1<<64)
  return val

async def check (signal, clk, value, mask, num):
    await ClockCycles(clk,12)
    await FallingEdge(clk)
    expected = twos_comp((twos_comp(value & mask) * b)) & 0xffffffffffffffff
    assert str(signal.value) == "{0:{fill}64b}".format(expected, fill='0'), "error on cycle"+str(num)
    # print (hex(expected))

@cocotb.test()
async def run_test_mul_hash(dut):

    clk = cocotb.fork(Clock(dut.clk, 2).start())
    mask = (0xffffffffffffffff << (8*int(dut.MSK_BYTES.value))) & 0xffffffffffffffff
    print ("Mask:", hex(mask))
        
    await RisingEdge(dut.clk)

    val = 2**64 - 1; 
    dut.a <= val
    cocotb.fork(check(dut.p, dut.clk, val, mask, -2))
    await RisingEdge(dut.clk)
    val = 0; 
    dut.a <= val
    cocotb.fork(check(dut.p, dut.clk, val, mask, -1))

    for i in range (0,10000,2):
        await RisingEdge(dut.clk)
        val = random.randrange(2**63) 
        dut.a <= val
        cocotb.fork(check(dut.p, dut.clk, val, mask, i))
        await RisingEdge(dut.clk)
        val = val | (1<<63)
        dut.a <= val
        cocotb.fork(check(dut.p, dut.clk, val, mask, i+1))

    await Timer(25)
    await RisingEdge(dut.clk)

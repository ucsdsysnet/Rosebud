#!/usr/bin/env python3

"""

Copyright (c) 2019 Moein Khazraee

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

from myhdl import *
import os

testbench = 'test_max_finder_tree'

srcs = []

srcs.append("../rtl/max_finder_tree.v")
srcs.append("%s.v" % testbench)

src = ' '.join(srcs)

build_cmd = "iverilog -o %s.vvp %s" % (testbench, src)

def bench():

    # Parameters
    DATA_WIDTH = 8
    PORT_COUNT = 16
    ADDR_WIDTH = 4

    # Inputs
    vals   = [Signal(intbv(0)[DATA_WIDTH:]) for i in range(PORT_COUNT)]
    values = ConcatSignal(*reversed(vals))

    # Outputs
    max_val = Signal(intbv(0)[DATA_WIDTH:])
    max_ptr = Signal(intbv(0)[ADDR_WIDTH:])

    # DUT
    if os.system(build_cmd):
        raise Exception("Error running build command")

    dut = Cosimulation(
        "vvp -m myhdl %s.vvp -lxt2" % testbench,
        values=values,
        max_val=max_val, 
        max_ptr=max_ptr
    )

    @instance
    def check():
        yield delay(100)
        vals[2].next = 6
        yield delay(100)
        vals[15].next = 6
        yield delay(100)
        vals[13].next = 40
        yield delay(100)
        vals[0].next = 9
        yield delay(100)
        vals[2].next = 30
        yield delay(100)
        vals[13].next = 20
        yield delay(100)

        raise StopSimulation

    return instances()

def test_bench():
    sim = Simulation(bench())
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test_bench()

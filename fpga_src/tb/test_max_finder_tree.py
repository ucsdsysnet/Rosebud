#!/usr/bin/env python

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

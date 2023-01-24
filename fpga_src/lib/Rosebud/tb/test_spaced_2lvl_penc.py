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

import os
import cocotb_test.simulator

import cocotb
from cocotb.log import SimLog
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, ClockCycles, FallingEdge

@cocotb.test()
async def run_test_spaced_2lvl_penc(dut):
    sys_clk = cocotb.fork(Clock(dut.clk, 2).start())

    dut.rst <= 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst <= 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst <= 0

    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    dut.one_hot <= 56
    await RisingEdge(dut.clk)
    dut.one_hot <= 58
    await RisingEdge(dut.clk)
    dut.one_hot <= 343
    await RisingEdge(dut.clk)
    print (56,'\t',str(dut.index.value), str(dut.valid.value), str(dut.error.value))
    dut.one_hot <= 4024
    await RisingEdge(dut.clk)
    print (58,'\t',str(dut.index.value), str(dut.valid.value), str(dut.error.value))
    await RisingEdge(dut.clk)
    print (343,'\t',str(dut.index.value), str(dut.valid.value), str(dut.error.value))
    await RisingEdge(dut.clk)
    print (4024,'\t',str(dut.index.value), str(dut.valid.value), str(dut.error.value))
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    print ("TEST1: single bit index verification.")
    dut.one_hot <= (1<<0)
    await RisingEdge(dut.clk)
    dut.one_hot <= (1<<1)
    for i in range(2,4606):
      await RisingEdge(dut.clk)
      await FallingEdge(dut.clk)
      assert int(str(dut.index[(i-2)%8].value),2) == (i-2)
      dut.one_hot <= (1<<i)

# cocotb-test

tests_dir = os.path.dirname(__file__)
rtl_dir = os.path.abspath(os.path.join(tests_dir, '..' , 'rtl'))

def run_test(parameters=None, sim_build="sim_build", waves=None, force_compile=False, extra_env=None):
    module = os.path.splitext(os.path.basename(__file__))[0]
    toplevel = "test_spaced_2lvl_penc"

    verilog_sources = [os.path.join(tests_dir, "test_spaced_2lvl_penc.v"),
                       os.path.join(rtl_dir, "spaced_2lvl_penc.v")]
    if parameters is None:
        parameters = {}
    parameters = {k.upper(): v for k, v in parameters.items() if v is not None}

    parameters.setdefault('INPUT_WIDTH', 4606)
    parameters.setdefault('PENC1_SIZE', 32)
    parameters.setdefault('PENC2_SIZE', 32)
    parameters.setdefault('BIN_COUNT', 8)

    if extra_env is None:
        extra_env = {}
    extra_env.update({f'PARAM_{k}': str(v) for k, v in parameters.items()})

    extra_env.setdefault('COCOTB_RESOLVE_X', 'RANDOM')

    sim_build = os.path.join(tests_dir, sim_build)

    cocotb_test.simulator.run(
        python_search=[tests_dir],
        verilog_sources=verilog_sources,
        toplevel=toplevel,
        module=module,
        parameters=parameters,
        sim_build=sim_build,
        extra_env=extra_env,
        force_compile=force_compile,
        waves=waves,
    )


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()

    parser.add_argument('--waves', type=bool)
    parser.add_argument('--sim_build', type=str, default="sim_build")
    parser.add_argument('--force_compile', type=bool, default=True)
    parser.add_argument('--reduced_log', type=bool)
    parser.add_argument('--clean', action='store_true')

    args = vars(parser.parse_args())

    if args.pop("clean"):
        import shutil
        shutil.rmtree(os.path.join(tests_dir, "sim_build"))

    else:
        sim_build = args.pop("sim_build")
        waves = args.pop("waves")
        force_compile = args.pop("force_compile")
        reduced_log = args.pop("reduced_log")

        extra_env = {}

        if reduced_log is not None:
            extra_env['COCOTB_REDUCED_LOG_FMT'] = str(int(reduced_log))

        run_test(args, sim_build, waves, force_compile, extra_env)

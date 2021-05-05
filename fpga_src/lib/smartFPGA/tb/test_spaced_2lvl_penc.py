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

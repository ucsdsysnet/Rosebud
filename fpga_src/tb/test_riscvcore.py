#!/usr/bin/env python

from myhdl import *
import os
from struct import unpack

module = 'riscvcore'
testbench = 'test_%s' % module

srcs = []

srcs.append("../rtl/core_mems.v")
srcs.append("../rtl/VexRiscv.v")
srcs.append("../rtl/%s.v" % module)
srcs.append("%s.v" % testbench)

src = ' '.join(srcs)

build_cmd = "iverilog -o %s.vvp %s" % (testbench, src)

def bench():
    clk                = Signal(bool(0))
    core_reset         = Signal(bool(0))
    current_test       = Signal(intbv(0)[8:])

    data_dma_en        = Signal(bool(0))
    data_dma_we        = Signal(intbv(0)[8:])
    data_dma_addr      = Signal(intbv(0)[15:])
    data_dma_wr_data   = Signal(intbv(0)[64:])
    data_dma_read_data = Signal(intbv(0)[64:])
    
    ins_dma_wen        = Signal(bool(0))
    ins_dma_addr       = Signal(intbv(0)[13:])
    ins_dma_data       = Signal(intbv(0)[64:])
    
    stat_update        = Signal(bool(0))
    stat_rd_en         = Signal(bool(0))
    stat_rd_data       = Signal(intbv(0)[32:])

    # DUT
    if os.system(build_cmd):
        raise Exception("Error running build command")

    dut = Cosimulation(
        "vvp -m myhdl %s.vvp -lxt2" % testbench,
        clk=clk,
        core_reset=core_reset,
        current_test=current_test,
    
        data_dma_en = data_dma_en,
        data_dma_we = data_dma_we,
        data_dma_addr = data_dma_addr,
        data_dma_wr_data = data_dma_wr_data,
        data_dma_read_data = data_dma_read_data,

        ins_dma_wen = ins_dma_wen,
        ins_dma_addr = ins_dma_addr,
        ins_dma_data = ins_dma_data,

        stat_rd_en = stat_rd_en,
        stat_rd_data = stat_rd_data,
        stat_update = stat_update
    )

    @always(delay(4))
    def clkgen():
        clk.next = not clk

    @instance
    def check():
        yield delay(100)
        yield clk.posedge
        core_reset.next = 1
        yield clk.posedge
        yield delay(100)
        yield clk.posedge

        # testbench stimulus

        yield clk.posedge
        print("writing values to Dmem")
        data_dma_en.next = 1
        data_dma_we.next = 0xFF
        for i in range (0,100,2):
            data_dma_addr.next    = 0x800 + i*4
            data_dma_wr_data.next = (i << 24) + ((i+1) << 56);
            yield clk.posedge
        data_dma_en.next = 0
        data_dma_we.next = 0x0
        yield clk.posedge
        yield delay(100)
        yield clk.posedge

        current_test.next = 1
        yield clk.posedge
        print("reading values from Dmem")
        data_dma_en.next = 1
        data_dma_we.next = 0x0
        for i in range (0,100,2):
            data_dma_addr.next    = 0x800 + i*4
            yield clk.posedge
        data_dma_en.next = 0
        yield clk.posedge
        yield delay(100)
        yield clk.posedge

        current_test.next = 2
        
        # assert check_frame.eth_dest_mac == 0xFFFFFFFFFFFF
        yield delay(100)
        yield clk.posedge

        data = open("../../c_code/test.bin", "rb")
        addr = 0
        while True:
            b = bytearray(data.read(8))
            if (len(b)<8):
                break;
            d = 0
            for i in range (0,8):
              d |= b[i] << i*8
            ins_dma_wen.next = 1
            ins_dma_addr.next = addr
            ins_dma_data.next = d 
            yield clk.posedge
            addr += 8
        ins_dma_wen.next = 0
        yield clk.posedge
        core_reset.next = 0
        yield clk.posedge

        cycles = 0

        while (1):
            while (stat_update == 0) and (cycles < 2500):
                yield clk.posedge
                cycles+=1
            stat_rd_en.next = 1
            yield clk.posedge
            cycles+=1
            stat_rd_en.next = 0
            if cycles >= 2500:
                break

        # yield delay(20000)
        yield clk.posedge

        yield clk.posedge
        print("reading core written values from Dmem")
        data_dma_en.next = 1
        data_dma_we.next = 0x0
        for i in range (0,100,2):
            data_dma_addr.next    = 0x1000 + i*4
            yield clk.posedge
        data_dma_en.next = 0
        yield clk.posedge
        
        yield delay(100)
        yield clk.posedge

        raise StopSimulation

    return instances()

def test_bench():
    sim = Simulation(bench())
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test_bench()

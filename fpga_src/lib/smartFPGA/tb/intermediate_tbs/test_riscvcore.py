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
    data_dma_ren       = Signal(bool(0))
    data_dma_wen       = Signal(intbv(0)[8:])
    data_dma_addr      = Signal(intbv(0)[16:])
    data_dma_wr_data   = Signal(intbv(0)[64:])
    data_dma_rd_data = Signal(intbv(0)[64:])
    
    ins_dma_wen         = Signal(intbv(0)[8:])
    ins_dma_addr       = Signal(intbv(0)[16:])
    ins_dma_data       = Signal(intbv(0)[64:])
    
    stat_rd_en         = Signal(bool(0))
    stat_rd_addr       = Signal(intbv(0)[16:])
    stat_rd_data       = Signal(intbv(0)[32:])
    
    stat_update        = Signal(bool(0))

    # DUT
    if os.system(build_cmd):
        raise Exception("Error running build command")

    dut = Cosimulation(
        "vvp -m myhdl %s.vvp -lxt2" % testbench,
        clk=clk,
        core_reset=core_reset,
        current_test=current_test,
    
        data_dma_en = data_dma_en,
        data_dma_ren = data_dma_ren,
        data_dma_wen = data_dma_wen,
        data_dma_addr = data_dma_addr,
        data_dma_wr_data = data_dma_wr_data,
        data_dma_rd_data = data_dma_rd_data,

        ins_dma_wen = ins_dma_wen,
        ins_dma_addr = ins_dma_addr,
        ins_dma_data = ins_dma_data,

        stat_rd_en = stat_rd_en,
        stat_rd_data = stat_rd_data,
        stat_rd_addr = stat_rd_addr,

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
        data_dma_wen.next = 0xFF
        for i in range (0,100,2):
            data_dma_addr.next    = 0x800 + i*4
            data_dma_wr_data.next = (i << 24) + ((i+1) << 56);
            yield clk.posedge
        data_dma_en.next = 0
        data_dma_wen.next = 0x0
        yield clk.posedge
        yield delay(100)
        yield clk.posedge

        current_test.next = 1
        yield clk.posedge
        print("reading values from Dmem")
        data_dma_en.next = 1
        data_dma_ren.next = 1
        data_dma_wen.next = 0x0
        for i in range (0,100,2):
            data_dma_addr.next    = 0x800 + i*4
            yield clk.posedge
        data_dma_en.next = 0
        data_dma_ren.next = 0
        yield clk.posedge
        yield delay(100)
        yield clk.posedge

        current_test.next = 2
        
        # assert check_frame.eth_dest_mac == 0xFFFFFFFFFFFF
        yield delay(100)
        yield clk.posedge

        data = open("../../c_code/interrupt_test.bin", "rb")
        addr = 0
        while True:
            b = bytearray(data.read(8))
            if (len(b)==0):
                break;
            d = 0
            mask = 0
            for i in range (0,len(b)):
              d |= b[i] << i*8
              mask |= 1 << i
            ins_dma_wen.next = mask
            ins_dma_addr.next = addr
            ins_dma_data.next = d 
            yield clk.posedge
            addr += 8
        ins_dma_wen.next = 0
        yield clk.posedge
        core_reset.next = 0
        yield clk.posedge

        yield delay(20000)

        yield clk.posedge

        yield clk.posedge
        print("writing values to Dmem out of range")
        # data_dma_en.next = 1
        # data_dma_wen.next = 0xFF
        # ins_dma_wen.next = 0xFF
        stat_rd_en.next = 1
        for i in range (0,10,2):
            # data_dma_addr.next    = 0x8000 + i*4
            # data_dma_wr_data.next = (i << 24) + ((i+1) << 56);
            # ins_dma_addr.next    = 0x4000 + i*4
            # ins_dma_data.next = (i << 24) + ((i+1) << 56);
            stat_rd_addr.next = 0x7000 + i*4 
            yield clk.posedge
        # data_dma_en.next = 0
        # data_dma_wen.next = 0x0
        # ins_dma_wen.next = 0x0
        stat_rd_en.next = 0
        yield clk.posedge
        yield delay(100)
        yield clk.posedge
       
        yield clk.posedge
        print("reading core written values from Dmem")
        data_dma_en.next = 1
        data_dma_ren.next = 1
        data_dma_wen.next = 0x0
        for i in range (0,100,2):
            data_dma_addr.next    = 0x1000 + i*4
            yield clk.posedge
        data_dma_en.next = 0
        data_dma_ren.next = 0
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

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
import random

import axi

module = 'riscv_axi_wrapper'
testbench = 'test_%s' % module

test_count = 100

srcs = []

srcs.append("../rtl/core_mems.v")
srcs.append("../rtl/VexRiscv.v")
srcs.append("../rtl/riscvcore.v")
srcs.append("../rtl/%s.v" % module)
srcs.append("%s.v" % testbench)
srcs.append("../lib/axi/rtl/axi_ram_rd_if.v")
srcs.append("../lib/axi/rtl/axi_ram_wr_if.v")

src = ' '.join(srcs)

build_cmd = "iverilog -o %s.vvp %s" % (testbench, src)

def bench():

    # Parameters
    DATA_WIDTH = 64
    ADDR_WIDTH = 16
    STRB_WIDTH = (DATA_WIDTH/8)
    ID_WIDTH = 8
    PIPELINE_OUTPUT = 0
    IMEM_SIZE_BYTES = 8192
    DMEM_SIZE_BYTES = 32768
    CONTROL_BIT_LOC = 16
    STAT_ADDR_WIDTH = 1
    INTERLEAVE      = 1

    # Inputs
    clk = Signal(bool(0))
    rst = Signal(bool(0))

    s_axi_awid = Signal(intbv(0)[ID_WIDTH:])
    s_axi_awaddr = Signal(intbv(0)[ADDR_WIDTH:])
    s_axi_awlen = Signal(intbv(0)[8:])
    s_axi_awsize = Signal(intbv(0)[3:])
    s_axi_awburst = Signal(intbv(0)[2:])
    s_axi_awlock = Signal(bool(0))
    s_axi_awcache = Signal(intbv(0)[4:])
    s_axi_awprot = Signal(intbv(0)[3:])
    s_axi_awvalid = Signal(bool(0))
    s_axi_wdata = Signal(intbv(0)[DATA_WIDTH:])
    s_axi_wstrb = Signal(intbv(0)[STRB_WIDTH:])
    s_axi_wlast = Signal(bool(0))
    s_axi_wvalid = Signal(bool(0))
    s_axi_bready = Signal(bool(0))
    s_axi_arid = Signal(intbv(0)[ID_WIDTH:])
    s_axi_araddr = Signal(intbv(0)[ADDR_WIDTH:])
    s_axi_arlen = Signal(intbv(0)[8:])
    s_axi_arsize = Signal(intbv(0)[3:])
    s_axi_arburst = Signal(intbv(0)[2:])
    s_axi_arlock = Signal(bool(0))
    s_axi_arcache = Signal(intbv(0)[4:])
    s_axi_arprot = Signal(intbv(0)[3:])
    s_axi_arvalid = Signal(bool(0))
    s_axi_rready = Signal(bool(0))

    # Outputs
    s_axi_awready = Signal(bool(0))
    s_axi_wready = Signal(bool(0))
    s_axi_bid = Signal(intbv(0)[ID_WIDTH:])
    s_axi_bresp = Signal(intbv(0)[2:])
    s_axi_bvalid = Signal(bool(0))
    s_axi_arready = Signal(bool(0))
    s_axi_rid = Signal(intbv(0)[ID_WIDTH:])
    s_axi_rdata = Signal(intbv(0)[DATA_WIDTH:])
    s_axi_rresp = Signal(intbv(0)[2:])
    s_axi_rlast = Signal(bool(0))
    s_axi_rvalid = Signal(bool(0))
    core_msg_data = Signal(intbv(0)[64:])
    core_msg_valid = Signal(bool(0))

    # AXI4 master
    axi_master_inst = axi.AXIMaster()
    axi_master_pause  = Signal(bool(False))
    axi_master_awpause= Signal(bool(False))
    axi_master_wpause = Signal(bool(False))
    axi_master_bpause = Signal(bool(False))
    axi_master_arpause= Signal(bool(False))
    axi_master_rpause = Signal(bool(False))


    axi_master_logic = axi_master_inst.create_logic(
        clk,
        rst,
        m_axi_awid=s_axi_awid,
        m_axi_awaddr=s_axi_awaddr,
        m_axi_awlen=s_axi_awlen,
        m_axi_awsize=s_axi_awsize,
        m_axi_awburst=s_axi_awburst,
        m_axi_awlock=s_axi_awlock,
        m_axi_awcache=s_axi_awcache,
        m_axi_awprot=s_axi_awprot,
        m_axi_awvalid=s_axi_awvalid,
        m_axi_awready=s_axi_awready,
        m_axi_wdata=s_axi_wdata,
        m_axi_wstrb=s_axi_wstrb,
        m_axi_wlast=s_axi_wlast,
        m_axi_wvalid=s_axi_wvalid,
        m_axi_wready=s_axi_wready,
        m_axi_bid=s_axi_bid,
        m_axi_bresp=s_axi_bresp,
        m_axi_bvalid=s_axi_bvalid,
        m_axi_bready=s_axi_bready,
        m_axi_arid=s_axi_arid,
        m_axi_araddr=s_axi_araddr,
        m_axi_arlen=s_axi_arlen,
        m_axi_arsize=s_axi_arsize,
        m_axi_arburst=s_axi_arburst,
        m_axi_arlock=s_axi_arlock,
        m_axi_arcache=s_axi_arcache,
        m_axi_arprot=s_axi_arprot,
        m_axi_arvalid=s_axi_arvalid,
        m_axi_arready=s_axi_arready,
        m_axi_rid=s_axi_rid,
        m_axi_rdata=s_axi_rdata,
        m_axi_rresp=s_axi_rresp,
        m_axi_rlast=s_axi_rlast,
        m_axi_rvalid=s_axi_rvalid,
        m_axi_rready=s_axi_rready,
        pause=axi_master_pause,
        awpause=axi_master_awpause,
        wpause=axi_master_wpause,
        bpause=axi_master_bpause,
        arpause=axi_master_arpause,
        rpause=axi_master_rpause,
        name='master'
    )


    sent_data = []
    recv_data = []
    pkt_sizes = []
    read_pkts = []

    # DUT
    if os.system(build_cmd):
        raise Exception("Error running build command")

    dut = Cosimulation(
        "vvp -m myhdl %s.vvp -lxt2" % testbench,
        clk=clk,
        rst=rst,
        s_axi_awid=s_axi_awid,
        s_axi_awaddr=s_axi_awaddr,
        s_axi_awlen=s_axi_awlen,
        s_axi_awsize=s_axi_awsize,
        s_axi_awburst=s_axi_awburst,
        s_axi_awlock=s_axi_awlock,
        s_axi_awcache=s_axi_awcache,
        s_axi_awprot=s_axi_awprot,
        s_axi_awvalid=s_axi_awvalid,
        s_axi_awready=s_axi_awready,
        s_axi_wdata=s_axi_wdata,
        s_axi_wstrb=s_axi_wstrb,
        s_axi_wlast=s_axi_wlast,
        s_axi_wvalid=s_axi_wvalid,
        s_axi_wready=s_axi_wready,
        s_axi_bid=s_axi_bid,
        s_axi_bresp=s_axi_bresp,
        s_axi_bvalid=s_axi_bvalid,
        s_axi_bready=s_axi_bready,
        s_axi_arid=s_axi_arid,
        s_axi_araddr=s_axi_araddr,
        s_axi_arlen=s_axi_arlen,
        s_axi_arsize=s_axi_arsize,
        s_axi_arburst=s_axi_arburst,
        s_axi_arlock=s_axi_arlock,
        s_axi_arcache=s_axi_arcache,
        s_axi_arprot=s_axi_arprot,
        s_axi_arvalid=s_axi_arvalid,
        s_axi_arready=s_axi_arready,
        s_axi_rid=s_axi_rid,
        s_axi_rdata=s_axi_rdata,
        s_axi_rresp=s_axi_rresp,
        s_axi_rlast=s_axi_rlast,
        s_axi_rvalid=s_axi_rvalid,
        s_axi_rready=s_axi_rready,
        core_msg_data=core_msg_data,
        core_msg_valid=core_msg_valid
    )

    @always(delay(4))
    def clkgen():
        clk.next = not clk

    def wait_normal():
        while not axi_master_inst.idle():
            yield clk.posedge

    def wait_pause_master():
        while not axi_master_inst.idle():
            axi_master_pause.next = True
            yield clk.posedge
            yield clk.posedge
            yield clk.posedge
            axi_master_pause.next = False
            yield clk.posedge
    
    def write_short_pause():
        axi_master_awpause.next = True
        axi_master_wpause.next = True
        axi_master_bpause.next = True
        for h in range (random.randrange(12)):
            yield clk.posedge
        axi_master_awpause.next = False
        axi_master_wpause.next = False
        axi_master_bpause.next = False
        yield clk.posedge

    def ar_short_pause():
        axi_master_arpause.next = True
        for h in range (random.randrange(12)):
            yield clk.posedge
        axi_master_arpause.next = False
        yield clk.posedge

    def read_short_pause():
        axi_master_rpause.next = True
        for h in range (random.randrange(12)):
            yield clk.posedge
        axi_master_rpause.next = False
        yield clk.posedge


    def writer():
        a = 400*[0]
        for i in range (0,400,4):
            a[i+3] = (i>>2)
        
        for i in range (test_count):
            addr = 0x800
            for j in range (8):
                bias = random.randrange (256)
                a = [(bias+x)%256 for x in range(random.randrange(1500))]
                while (len(read_pkts) < ((i*8)+j+1-8)):
                    yield clk.posedge
                axi_master_inst.init_write(addr, bytes(a))
                yield axi_master_inst.wait()
                yield clk.posedge
                pkt_sizes.append(len(a))
                sent_data.append(bytes(a))
                # a = [(4+x)%256 for x in a]
                addr += 0x800
                if ((i*8+j)%10==0):
                  yield write_short_pause()

    def reader():
        yield delay(random.randrange(100))
        read_count = 0
        for k in range (test_count):
            raddr = 0x800
            for l in range (8):
                while ((len(pkt_sizes)-1)<read_count):
                    yield clk.posedge
                axi_master_inst.init_read(raddr, pkt_sizes[read_count])
                yield axi_master_inst.wait()
                data = axi_master_inst.get_read_data()
                yield clk.posedge
                recv_data.append(data[1])
                read_pkts.append('1')
                raddr += 0x800
                yield delay(random.randrange(100))
                read_count += 1
                if ((k*8+l)%10==2):
                  yield read_short_pause()
                if ((k*8+l)%10==4):
                  yield ar_short_pause()

    @instance
    def check():
        yield delay(100)
        yield clk.posedge
        rst.next = 1
        yield clk.posedge
        rst.next = 0
        yield clk.posedge
        yield delay(100)
        yield clk.posedge

        # testbench stimulus

        yield clk.posedge
        print("test 1: read and write")

        # 1 line memory access check

        addr = 8
        test_data = b'\x11\x22\x33\x44\x11\x22\x33\x44'

        axi_master_inst.init_write(addr, test_data)

        yield axi_master_inst.wait()
        yield clk.posedge

        axi_master_inst.init_read(addr, len(test_data))

        yield axi_master_inst.wait()
        yield clk.posedge

        data = axi_master_inst.get_read_data()
        assert data[0] == addr
        assert data[1] == test_data

        # yield delay(100)
        # axi_master_inst.init_write(0x8000, bytearray(open("../../riscv_code/test.bin", "rb").read()))
        # yield axi_master_inst.wait()
        # yield clk.posedge
        # axi_master_inst.init_read(0x8000, 4)
        # yield axi_master_inst.wait()
        # yield clk.posedge
        # data = axi_master_inst.get_read_data()
        # yield clk.posedge
        # axi_master_inst.init_read(0x8004, 4)
        # yield axi_master_inst.wait()
        # yield clk.posedge
        # data = axi_master_inst.get_read_data()
        # yield clk.posedge
        
        # reset the core
        yield delay(100)
        yield clk.posedge
        axi_master_inst.init_write(0xffff, b'\x00')
        yield axi_master_inst.wait()
        yield clk.posedge

        yield writer(),None
        yield reader(),None

        # axi_master_inst.init_write(0x100, b'\x90\x01\x00\x00\x00\x08\x00\x00') #b'\x00\x00\x08\x00\x00\x00\x01\x90')
        # yield axi_master_inst.wait()
        # yield clk.posedge
        # while (core_msg_valid == 0):
        #     yield clk.posedge
        # print("core msg data:", core_msg_data)
      
        while (len(recv_data)<(8*test_count)):
            yield clk.posedge
        # print()
        # print("sent data len:", len(sent_data))
        # print ("sent data:",sent_data)
        # print()
        # print("recv data len:", len(recv_data))
        # print ("recv data:",recv_data)

        for i in range (8*test_count):
            if (sent_data[i]!=recv_data[i]):
                print ("test",i,"failed",len(sent_data[i]),len(recv_data[i]))
                print ("sent data:",sent_data[i])
                print ("recv data:",recv_data[i])
                print ()

        assert sent_data == recv_data
        raise StopSimulation

    return instances()

def test_bench():
    sim = Simulation(bench())
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test_bench()

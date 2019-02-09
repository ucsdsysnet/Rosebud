#!/usr/bin/env python
"""

Copyright (c) 2018 Alex Forencich

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

import axi
import axis_ep

testbench = 'test_riscv_with_dma'

srcs = []

srcs.append("../rtl/core_mems.v")
srcs.append("../rtl/VexRiscv.v")
srcs.append("../rtl/riscvcore.v")
srcs.append("../rtl/riscv_axi_wrapper.v")
srcs.append("../lib/axi/rtl/axi_dma.v")
srcs.append("../lib/axi/rtl/axi_dma_rd.v")
srcs.append("../lib/axi/rtl/axi_dma_wr.v")
srcs.append("../lib/axi/rtl/axi_ram_rd_if.v")
srcs.append("../lib/axi/rtl/axi_ram_wr_if.v")
srcs.append("%s.v" % testbench)

src = ' '.join(srcs)

build_cmd = "iverilog -o %s.vvp %s" % (testbench, src)

def bench():

    # Parameters
    AXI_DATA_WIDTH = 64
    AXI_ADDR_WIDTH = 16
    AXI_STRB_WIDTH = (AXI_DATA_WIDTH/8)
    AXI_ID_WIDTH = 8
    AXI_MAX_BURST_LEN = 16
    AXIS_DATA_WIDTH = AXI_DATA_WIDTH
    AXIS_KEEP_ENABLE = (AXIS_DATA_WIDTH>8)
    AXIS_KEEP_WIDTH = (AXIS_DATA_WIDTH/8)
    AXIS_ID_ENABLE = 1
    AXIS_ID_WIDTH = 8
    AXIS_DEST_ENABLE = 0
    AXIS_DEST_WIDTH = 8
    AXIS_USER_ENABLE = 1
    AXIS_USER_WIDTH = 1
    LEN_WIDTH = 20
    TAG_WIDTH = 8
    ENABLE_SG = 0
    ENABLE_UNALIGNED = 0

    # Inputs
    clk = Signal(bool(0))
    rst = Signal(bool(0))
    current_test = Signal(intbv(0)[8:])

    s_axis_read_desc_addr = Signal(intbv(0)[AXI_ADDR_WIDTH:])
    s_axis_read_desc_len = Signal(intbv(0)[LEN_WIDTH:])
    s_axis_read_desc_tag = Signal(intbv(0)[TAG_WIDTH:])
    s_axis_read_desc_id = Signal(intbv(0)[AXIS_ID_WIDTH:])
    s_axis_read_desc_dest = Signal(intbv(0)[AXIS_DEST_WIDTH:])
    s_axis_read_desc_user = Signal(intbv(0)[AXIS_USER_WIDTH:])
    s_axis_read_desc_valid = Signal(bool(0))
    m_axis_read_data_tready = Signal(bool(0))
    s_axis_write_desc_addr = Signal(intbv(0)[AXI_ADDR_WIDTH:])
    s_axis_write_desc_len = Signal(intbv(0)[LEN_WIDTH:])
    s_axis_write_desc_tag = Signal(intbv(0)[TAG_WIDTH:])
    s_axis_write_desc_valid = Signal(bool(0))
    s_axis_write_data_tdata = Signal(intbv(0)[AXIS_DATA_WIDTH:])
    s_axis_write_data_tkeep = Signal(intbv(0)[AXIS_KEEP_WIDTH:])
    s_axis_write_data_tvalid = Signal(bool(0))
    s_axis_write_data_tlast = Signal(bool(0))
    s_axis_write_data_tid = Signal(intbv(0)[AXIS_ID_WIDTH:])
    s_axis_write_data_tdest = Signal(intbv(0)[AXIS_DEST_WIDTH:])
    s_axis_write_data_tuser = Signal(intbv(0)[AXIS_USER_WIDTH:])
    read_enable = Signal(bool(0))
    write_enable = Signal(bool(0))
    write_abort = Signal(bool(0))

    # Outputs
    s_axis_read_desc_ready = Signal(bool(0))
    m_axis_read_desc_status_tag = Signal(intbv(0)[TAG_WIDTH:])
    m_axis_read_desc_status_valid = Signal(bool(0))
    m_axis_read_data_tdata = Signal(intbv(0)[AXIS_DATA_WIDTH:])
    m_axis_read_data_tkeep = Signal(intbv(0)[AXIS_KEEP_WIDTH:])
    m_axis_read_data_tvalid = Signal(bool(0))
    m_axis_read_data_tlast = Signal(bool(0))
    m_axis_read_data_tid = Signal(intbv(0)[AXIS_ID_WIDTH:])
    m_axis_read_data_tdest = Signal(intbv(0)[AXIS_DEST_WIDTH:])
    m_axis_read_data_tuser = Signal(intbv(0)[AXIS_USER_WIDTH:])
    s_axis_write_desc_ready = Signal(bool(0))
    m_axis_write_desc_status_len = Signal(intbv(0)[LEN_WIDTH:])
    m_axis_write_desc_status_tag = Signal(intbv(0)[TAG_WIDTH:])
    m_axis_write_desc_status_id = Signal(intbv(0)[AXIS_ID_WIDTH:])
    m_axis_write_desc_status_dest = Signal(intbv(0)[AXIS_DEST_WIDTH:])
    m_axis_write_desc_status_user = Signal(intbv(0)[AXIS_USER_WIDTH:])
    m_axis_write_desc_status_valid = Signal(bool(0))
    s_axis_write_data_tready = Signal(bool(0))
    
    # sources and sinks
    read_desc_source = axis_ep.AXIStreamSource()
    read_desc_source_pause = Signal(bool(False))

    read_desc_source_logic = read_desc_source.create_logic(
        clk,
        rst,
        tdata=(s_axis_read_desc_addr, s_axis_read_desc_len, s_axis_read_desc_tag, s_axis_read_desc_id, s_axis_read_desc_dest, s_axis_read_desc_user),
        tvalid=s_axis_read_desc_valid,
        tready=s_axis_read_desc_ready,
        pause=read_desc_source_pause,
        name='read_desc_source'
    )

    read_desc_status_sink = axis_ep.AXIStreamSink()

    read_desc_status_sink_logic = read_desc_status_sink.create_logic(
        clk,
        rst,
        tdata=(m_axis_read_desc_status_tag,),
        tvalid=m_axis_read_desc_status_valid,
        name='read_desc_status_sink'
    )

    read_data_sink = axis_ep.AXIStreamSink()
    read_data_sink_pause = Signal(bool(False))

    read_data_sink_logic = read_data_sink.create_logic(
        clk,
        rst,
        tdata=m_axis_read_data_tdata,
        tkeep=m_axis_read_data_tkeep,
        tvalid=m_axis_read_data_tvalid,
        tready=m_axis_read_data_tready,
        tlast=m_axis_read_data_tlast,
        tid=m_axis_read_data_tid,
        tdest=m_axis_read_data_tdest,
        tuser=m_axis_read_data_tuser,
        pause=read_data_sink_pause,
        name='read_data_sink'
    )

    write_desc_source = axis_ep.AXIStreamSource()
    write_desc_source_pause = Signal(bool(False))

    write_desc_source_logic = write_desc_source.create_logic(
        clk,
        rst,
        tdata=(s_axis_write_desc_addr, s_axis_write_desc_len, s_axis_write_desc_tag),
        tvalid=s_axis_write_desc_valid,
        tready=s_axis_write_desc_ready,
        pause=write_desc_source_pause,
        name='write_desc_source'
    )

    write_desc_status_sink = axis_ep.AXIStreamSink()

    write_desc_status_sink_logic = write_desc_status_sink.create_logic(
        clk,
        rst,
        tdata=(m_axis_write_desc_status_len, m_axis_write_desc_status_tag, m_axis_write_desc_status_id, m_axis_write_desc_status_dest, m_axis_write_desc_status_user),
        tvalid=m_axis_write_desc_status_valid,
        name='write_desc_status_sink'
    )

    write_data_source = axis_ep.AXIStreamSource()
    write_data_source_pause = Signal(bool(False))

    write_data_source_logic = write_data_source.create_logic(
        clk,
        rst,
        tdata=s_axis_write_data_tdata,
        tkeep=s_axis_write_data_tkeep,
        tvalid=s_axis_write_data_tvalid,
        tready=s_axis_write_data_tready,
        tlast=s_axis_write_data_tlast,
        tid=s_axis_write_data_tid,
        tdest=s_axis_write_data_tdest,
        tuser=s_axis_write_data_tuser,
        pause=write_data_source_pause,
        name='write_data_source'
    )

    # DUT
    if os.system(build_cmd):
        raise Exception("Error running build command")

    dut = Cosimulation(
        "vvp -m myhdl %s.vvp -lxt2" % testbench,
        clk=clk,
        rst=rst,
        current_test=current_test,
        s_axis_read_desc_addr=s_axis_read_desc_addr,
        s_axis_read_desc_len=s_axis_read_desc_len,
        s_axis_read_desc_tag=s_axis_read_desc_tag,
        s_axis_read_desc_id=s_axis_read_desc_id,
        s_axis_read_desc_dest=s_axis_read_desc_dest,
        s_axis_read_desc_user=s_axis_read_desc_user,
        s_axis_read_desc_valid=s_axis_read_desc_valid,
        s_axis_read_desc_ready=s_axis_read_desc_ready,
        m_axis_read_desc_status_tag=m_axis_read_desc_status_tag,
        m_axis_read_desc_status_valid=m_axis_read_desc_status_valid,
        m_axis_read_data_tdata=m_axis_read_data_tdata,
        m_axis_read_data_tkeep=m_axis_read_data_tkeep,
        m_axis_read_data_tvalid=m_axis_read_data_tvalid,
        m_axis_read_data_tready=m_axis_read_data_tready,
        m_axis_read_data_tlast=m_axis_read_data_tlast,
        m_axis_read_data_tid=m_axis_read_data_tid,
        m_axis_read_data_tdest=m_axis_read_data_tdest,
        m_axis_read_data_tuser=m_axis_read_data_tuser,
        s_axis_write_desc_addr=s_axis_write_desc_addr,
        s_axis_write_desc_len=s_axis_write_desc_len,
        s_axis_write_desc_tag=s_axis_write_desc_tag,
        s_axis_write_desc_valid=s_axis_write_desc_valid,
        s_axis_write_desc_ready=s_axis_write_desc_ready,
        m_axis_write_desc_status_len=m_axis_write_desc_status_len,
        m_axis_write_desc_status_tag=m_axis_write_desc_status_tag,
        m_axis_write_desc_status_id=m_axis_write_desc_status_id,
        m_axis_write_desc_status_dest=m_axis_write_desc_status_dest,
        m_axis_write_desc_status_user=m_axis_write_desc_status_user,
        m_axis_write_desc_status_valid=m_axis_write_desc_status_valid,
        s_axis_write_data_tdata=s_axis_write_data_tdata,
        s_axis_write_data_tkeep=s_axis_write_data_tkeep,
        s_axis_write_data_tvalid=s_axis_write_data_tvalid,
        s_axis_write_data_tready=s_axis_write_data_tready,
        s_axis_write_data_tlast=s_axis_write_data_tlast,
        s_axis_write_data_tid=s_axis_write_data_tid,
        s_axis_write_data_tdest=s_axis_write_data_tdest,
        s_axis_write_data_tuser=s_axis_write_data_tuser,
        read_enable=read_enable,
        write_enable=write_enable,
        write_abort=write_abort
    )

    @always(delay(4))
    def clkgen():
        clk.next = not clk

    def wait_normal():
        while (read_desc_status_sink.empty() or read_data_sink.empty()) and write_desc_status_sink.empty():
            yield clk.posedge

    def wait_pause_source():
        while (read_desc_status_sink.empty() or read_data_sink.empty()) and write_desc_status_sink.empty():
            write_data_source_pause.next = True
            yield clk.posedge
            yield clk.posedge
            yield clk.posedge
            write_data_source_pause.next = False
            yield clk.posedge

    def wait_pause_sink():
        while (read_desc_status_sink.empty() or read_data_sink.empty()) and write_desc_status_sink.empty():
            read_data_sink_pause.next = True
            yield clk.posedge
            yield clk.posedge
            yield clk.posedge
            read_data_sink_pause.next = False
            yield clk.posedge

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

        cur_tag = 1

        read_enable.next = 1
        write_enable.next = 1

        yield clk.posedge
        print("test 1: single data")
        current_test.next = 1

        addr = 0x00000000
        test_data = b'\x11\x22\x33\x44\x11\x22\x33\x44'

        write_desc_source.send([(addr, len(test_data), cur_tag)])
        write_data_source.send(axis_ep.AXIStreamFrame(test_data, id=cur_tag))
        yield write_desc_status_sink.wait(2000)

        read_desc_source.send([(addr, len(test_data), cur_tag, cur_tag, 0, 0)])
        yield read_desc_status_sink.wait(1000)
        yield read_data_sink.wait(1000)

        status = read_desc_status_sink.recv()
        read_data = read_data_sink.recv()

        print(status)
        print(read_data)

        assert status.data[0][0] == cur_tag
        assert read_data.data == test_data

        cur_tag = (cur_tag + 1) % 256

        yield delay(100)

        yield clk.posedge

        yield clk.posedge
        print("test 3: various reads")
        current_test.next = 3

        for length in list(range(1,65))+[128]:
            for offset in [0, 16, 4096-16]:
                for wait in wait_normal, wait_pause_source:
                    print("length %d, offset %d"% (length, offset))
                    #addr = length * 0x100000000 + offset * 0x10000 + offset
                    addr = offset
                    test_data = bytearray([x%256 for x in range(length)])

                    write_desc_source.send([(addr, len(test_data), cur_tag)])
                    write_data_source.send(axis_ep.AXIStreamFrame(test_data, id=cur_tag))
                    yield write_desc_status_sink.wait(2000)
                    
                    yield delay(1000)
                    # yield wait()

                    read_desc_source.send([(addr, len(test_data), cur_tag, cur_tag, 0, 0)])
                    yield read_desc_status_sink.wait(1000)
                    yield read_data_sink.wait(1000)

                    status = read_desc_status_sink.recv()
                    read_data = read_data_sink.recv()

                    print(status)
                    print(read_data)

                    assert status.data[0][0] == cur_tag
                    assert read_data.data == test_data

                    cur_tag = (cur_tag + 1) % 256

                    yield delay(100)

        yield clk.posedge
        print("test 4: various writes")
        current_test.next = 4

        for length in list(range(1,33))+[128]:
            for offset in [0, 16, 4096-16]:
                for wait in wait_normal, wait_pause_sink:
                    print("length %d, offset %d"% (length, offset))
                    #addr = length * 0x100000000 + offset * 0x10000 + offset
                    addr = offset
                    test_data = bytearray([x%256 for x in range(length)])

                    write_desc_source.send([(addr, len(test_data), cur_tag)])
                    write_data_source.send(axis_ep.AXIStreamFrame(test_data, id=cur_tag))

                    yield delay(1000)
                    # yield wait()

                    read_desc_source.send([(addr, len(test_data), cur_tag, cur_tag, 0, 0)])
                    yield read_desc_status_sink.wait(1000)
                    yield read_data_sink.wait(1000)

                    status = write_desc_status_sink.recv()
                    read_data = read_data_sink.recv()

                    print(status)

                    assert read_data.data == test_data

                    cur_tag = (cur_tag + 1) % 256

                    yield delay(100)

        raise StopSimulation

    return instances()

def test_bench():
    sim = Simulation(bench())
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test_bench()

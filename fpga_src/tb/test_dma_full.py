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
import random

import eth_ep
import xgmii_ep

testbench = 'test_dma_full'

pkt_on_each_port = 200
srcs = []

srcs.append("../rtl/temp_pcie.v")
srcs.append("../rtl/simple_fifo.v")
srcs.append("../rtl/core_msg_arbiter.v")
srcs.append("../rtl/full_riscv_sys_2.v")
srcs.append("../rtl/dma_controller.v")
srcs.append("../rtl/eth_interface.v")
srcs.append("../rtl/core_mems.v")
srcs.append("../rtl/VexRiscv.v")
srcs.append("../rtl/riscvcore.v")
srcs.append("../rtl/riscv_axi_wrapper.v")
srcs.append("../lib/axi/rtl/axi_dma.v")
srcs.append("../lib/axi/rtl/axi_dma_rd.v")
srcs.append("../lib/axi/rtl/axi_dma_wr.v")
srcs.append("../lib/axi/rtl/priority_encoder.v")
srcs.append("../lib/axi/rtl/arbiter.v")
srcs.append("../lib/axi/rtl/axi_interconnect.v")
srcs.append("../lib/axi/rtl/axi_register_wr.v")
srcs.append("../lib/axi/rtl/axi_register_rd.v") 
srcs.append("../lib/axi/rtl/axi_crossbar_addr.v")
srcs.append("../lib/axi/rtl/axi_crossbar_wr.v")
srcs.append("../lib/axi/rtl/axi_crossbar_rd.v")
srcs.append("../lib/axi/rtl/axi_crossbar.v")
# srcs.append("../lib/axi/rtl/axi_dma_desc_mux.v")
srcs.append("../lib/axi/rtl/axi_ram_rd_if.v")
srcs.append("../lib/axi/rtl/axi_ram_wr_if.v")
srcs.append("../lib/axi/rtl/axi_fifo_rd.v")
srcs.append("../lib/axi/rtl/axi_fifo_wr.v")
srcs.append("../lib/axi/rtl/axi_fifo.v")
srcs.append("../lib/axis/rtl/axis_async_fifo.v")
srcs.append("../lib/axis/rtl/axis_adapter.v")
srcs.append("../lib/eth/rtl/eth_mac_10g.v")
srcs.append("../lib/eth/rtl/lfsr.v")
srcs.append("../lib/eth/rtl/axis_xgmii_rx_64.v")
srcs.append("../lib/eth/rtl/axis_xgmii_tx_64.v")

srcs.append("%s.v" % testbench)

src = ' '.join(srcs)

build_cmd = "iverilog -o %s.vvp %s" % (testbench, src)

def bench():

    # Parameters
    DATA_WIDTH = 64
    CTRL_WIDTH = (DATA_WIDTH/8)
    AXI_ADDR_WIDTH = 16

    # Inputs
    clk = Signal(bool(0))
    rst = Signal(bool(0))
    tx_clk_0 = Signal(bool(0))
    tx_rst_0 = Signal(bool(0))
    rx_clk_0 = Signal(bool(0))
    rx_rst_0 = Signal(bool(0))
    tx_clk_1 = Signal(bool(0))
    tx_rst_1 = Signal(bool(0))
    rx_clk_1 = Signal(bool(0))
    rx_rst_1 = Signal(bool(0))

    xgmii_rxd_0 = Signal(intbv(0x0707070707070707)[DATA_WIDTH:])
    xgmii_rxc_0 = Signal(intbv(0xff)[CTRL_WIDTH:])
    xgmii_rxd_1 = Signal(intbv(0x0707070707070707)[DATA_WIDTH:])
    xgmii_rxc_1 = Signal(intbv(0xff)[CTRL_WIDTH:])
    
    # Outputs
    xgmii_txd_0 = Signal(intbv(0x0707070707070707)[DATA_WIDTH:])
    xgmii_txc_0 = Signal(intbv(0xff)[CTRL_WIDTH:])
    xgmii_txd_1 = Signal(intbv(0x0707070707070707)[DATA_WIDTH:])
    xgmii_txc_1 = Signal(intbv(0xff)[CTRL_WIDTH:])

    # sources and sinks
    xgmii_source_0 = xgmii_ep.XGMIISource()

    xgmii_source_logic_0 = xgmii_source_0.create_logic(
        clk=rx_clk_0,
        rst=rx_rst_0,
        txd=xgmii_rxd_0,
        txc=xgmii_rxc_0,
        name='xgmii_source_0'
    )

    xgmii_sink_0 = xgmii_ep.XGMIISink()

    xgmii_sink_logic_0 = xgmii_sink_0.create_logic(
        clk=tx_clk_0,
        rst=tx_rst_0,
        rxd=xgmii_txd_0,
        rxc=xgmii_txc_0,
        name='xgmii_sink_0'
    )
    
    xgmii_source_1 = xgmii_ep.XGMIISource()

    xgmii_source_logic_1 = xgmii_source_1.create_logic(
        clk=rx_clk_1,
        rst=rx_rst_1,
        txd=xgmii_rxd_1,
        txc=xgmii_rxc_1,
        name='xgmii_source_1'
    )

    xgmii_sink_1 = xgmii_ep.XGMIISink()

    xgmii_sink_logic_1 = xgmii_sink_1.create_logic(
        clk=tx_clk_1,
        rst=tx_rst_1,
        rxd=xgmii_txd_1,
        rxc=xgmii_txc_1,
        name='xgmii_sink_1'
    )

    # DUT
    if os.system(build_cmd):
        raise Exception("Error running build command")

    dut = Cosimulation(
        "vvp -m myhdl %s.vvp -lxt2" % testbench,
        clk=clk,
        rst=rst,
        rx_clk_0=rx_clk_0,
        rx_rst_0=rx_rst_0,
        tx_clk_0=tx_clk_0,
        tx_rst_0=tx_rst_0,
        rx_clk_1=rx_clk_1,
        rx_rst_1=rx_rst_1,
        tx_clk_1=tx_clk_1,
        tx_rst_1=tx_rst_1,

        xgmii_rxd_0=xgmii_rxd_0,
        xgmii_rxc_0=xgmii_rxc_0,
        xgmii_txd_0=xgmii_txd_0,
        xgmii_txc_0=xgmii_txc_0,
        xgmii_rxd_1=xgmii_rxd_1,
        xgmii_rxc_1=xgmii_rxc_1,
        xgmii_txd_1=xgmii_txd_1,
        xgmii_txc_1=xgmii_txc_1
    )

    @always(delay(25))
    def clkgen():
        clk.next = not clk

    @always(delay(32))
    def clkgen2():
        tx_clk_0.next = not tx_clk_0
        rx_clk_0.next = not rx_clk_0
        tx_clk_1.next = not tx_clk_1
        rx_clk_1.next = not rx_clk_1

    @instance
    def check():
        yield delay(1000)
        yield clk.posedge
        rst.next = 1
        yield clk.posedge
        yield tx_clk_0.posedge
        tx_rst_0.next = 1
        rx_rst_0.next = 1
        tx_rst_1.next = 1
        rx_rst_1.next = 1
        yield tx_clk_0.posedge
        yield clk.posedge
        yield tx_clk_0.posedge
        yield clk.posedge
        rst.next = 0
        yield clk.posedge
        yield tx_clk_0.posedge
        tx_rst_0.next = 0
        rx_rst_0.next = 0
        tx_rst_1.next = 0
        rx_rst_1.next = 0
        yield tx_clk_0.posedge
        yield delay(1000)
        yield clk.posedge
        yield clk.posedge
        yield clk.posedge
        yield clk.posedge
        
        # testbench stimulus

        yield delay(50000)
        yield clk.posedge

        test_data   = bytes([x%256 for x in range(1950-4)])
        test_data_2 = bytes([x%256 for x in range(10,10+50-2)])
        # b'\x11\x22\x33\x44\x11\x22\x33\x44\x11\x22\x33\x44\x11\x22\x33\x44\x11\x22\x33\x44\x11\x22\x33\x44\x11\x22\x33\x44\x11\x22\x33\x44\x11\x22\x33\x44\x11\x22\x33\x44\x11\x22\x33\x44\x11\x22'

        test_frame = eth_ep.EthFrame()
        test_frame.eth_dest_mac = 0xDAD1D2D3D4D5
        test_frame.eth_src_mac = 0x5A5152535455
        test_frame.eth_type = 0x8000
        test_frame.payload = bytes([x%256 for x in range(46)])
        test_frame.update_fcs()
        axis_frame = test_frame.build_axis_fcs()
        start_data_1 = bytearray(b'\x55\x55\x55\x55\x55\x55\x55\xD5' + bytearray(axis_frame))
        
        test_frame_2 = eth_ep.EthFrame()
        test_frame_2.eth_dest_mac = 0x5A5152535455
        test_frame_2.eth_src_mac = 0xDAD1D2D3D4D5
        test_frame_2.eth_type = 0x8000
        test_frame_2.payload = bytes([x%256 for x in range(46)])
        test_frame_2.update_fcs()
        axis_frame_2 = test_frame_2.build_axis_fcs()
        start_data_2 = bytearray(b'\x55\x55\x55\x55\x55\x55\x55\xD5' + bytearray(axis_frame_2))

        for i in range (0,pkt_on_each_port):
          test_frame.payload = bytes([x%256 for x in range(random.randrange(1980))])
          test_frame.update_fcs()
          axis_frame = test_frame.build_axis_fcs()
          xgmii_source_0.send(b'\x55\x55\x55\x55\x55\x55\x55\xD5'+bytearray(axis_frame))
          # yield rx_clk_0.posedge
          # yield delay(random.randrange(100))

          test_frame_2.payload = bytes([x%256 for x in range(10,10+random.randrange(300))])
          test_frame_2.update_fcs()
          axis_frame_2 = test_frame_2.build_axis_fcs()
          xgmii_source_1.send(b'\x55\x55\x55\x55\x55\x55\x55\xD5'+bytearray(axis_frame_2))
          # yield rx_clk_1.posedge
          # yield delay(random.randrange(100))

        lengths = []
        print ("send data from LAN")
        for j in range (0,pkt_on_each_port):
          yield xgmii_sink_0.wait()
          rx_frame = xgmii_sink_0.recv()
          data = rx_frame.data
          print ("packet number from port 0:",j)
          for i in range(0, len(data), 16):
              print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+16]))))
          # assert rx_frame.data[0:8] == bytearray(b'\x55\x55\x55\x55\x55\x55\x55\xD5')
          assert rx_frame.data[0:22] == start_data_2[0:22]
          lengths.append(len(data)-8)

          yield xgmii_sink_1.wait()
          rx_frame = xgmii_sink_1.recv()
          data = rx_frame.data
          print ("packet number from port 1:",j)
          for i in range(0, len(data), 16):
              print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+16]))))
          # assert rx_frame.data[0:8] == bytearray(b'\x55\x55\x55\x55\x55\x55\x55\xD5')
          assert rx_frame.data[0:22] == start_data_1[0:22]
          lengths.append(len(data)-8)

        # print ("Very last packet:")
        # for i in range(0, len(data), 16):
        #     print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+16]))))
        print ("lengths: " , lengths)

        # eth_frame = eth_ep.EthFrame()
        # eth_frame.parse_axis_fcs(rx_frame.data[8:])

        # print(hex(eth_frame.eth_fcs))
        # print(hex(eth_frame.calc_fcs()))

        # assert len(eth_frame.payload.data) == 46
        # assert eth_frame.eth_fcs == eth_frame.calc_fcs()
        # assert eth_frame.eth_dest_mac == test_frame.eth_dest_mac
        # assert eth_frame.eth_src_mac == test_frame.eth_src_mac
        # assert eth_frame.eth_type == test_frame.eth_type
        # assert eth_frame.payload.data.index(test_frame.payload.data) == 0

        yield delay(1000)
        yield clk.posedge

        raise StopSimulation

    return instances()

def test_bench():
    sim = Simulation(bench())
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test_bench()

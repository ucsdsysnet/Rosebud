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

import eth_ep
import xgmii_ep

testbench = 'test_dma_full'

srcs = []

srcs.append("../rtl/temp_pcie.v")
srcs.append("../rtl/simple_fifo.v")
srcs.append("../rtl/core_msg_arbiter.v")
srcs.append("../rtl/full_riscv_sys.v")
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
# srcs.append("../lib/axi/rtl/axi_register_wr.v")
# srcs.append("../lib/axi/rtl/axi_register_rd.v") 
# srcs.append("../lib/axi/rtl/axi_crossbar_addr.v")
# srcs.append("../lib/axi/rtl/axi_crossbar_wr.v")
# srcs.append("../lib/axi/rtl/axi_crossbar_rd.v")
# srcs.append("../lib/axi/rtl/axi_crossbar.v")
srcs.append("../lib/axi/rtl/axi_ram_rd_if.v")
srcs.append("../lib/axi/rtl/axi_ram_wr_if.v")
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
    ENABLE_UNALIGNED = 0 #1
    IMEM_SIZE_BYTES = 8192
    DMEM_SIZE_BYTES = 32768
    INTERLEAVE      = 1
    PIPELINE_OUTPUT = 0
    STAT_ADDR_WIDTH = 1
    ENABLE_PADDING = 1
    ENABLE_DIC = 1
    MIN_FRAME_LENGTH = 64
    TX_FRAME_FIFO = 1
    TX_DROP_WHEN_FULL = 0
    RX_FRAME_FIFO = 1

    # Inputs
    clk = Signal(bool(0))
    rst = Signal(bool(0))
    tx_clk = Signal(bool(0))
    tx_rst = Signal(bool(0))
    rx_clk = Signal(bool(0))
    rx_rst = Signal(bool(0))
    current_test = Signal(intbv(0)[8:])

    xgmii_rxd = Signal(intbv(0x0707070707070707)[DATA_WIDTH:])
    xgmii_rxc = Signal(intbv(0xff)[CTRL_WIDTH:])

    inject_rx_desc = Signal(intbv(0)[7:])
    inject_rx_desc_valid = Signal(bool(0))
    slot_addr_wr_no = Signal(intbv(0)[4:])
    slot_addr_wr_data = Signal(intbv(0)[7:])
    slot_addr_wr_valid = Signal(bool(0))
    
    # Outputs
    xgmii_txd = Signal(intbv(0x0707070707070707)[DATA_WIDTH:])
    xgmii_txc = Signal(intbv(0xff)[CTRL_WIDTH:])
    inject_rx_desc_ready = Signal(bool(0))

    # sources and sinks
    xgmii_source = xgmii_ep.XGMIISource()

    xgmii_source_logic = xgmii_source.create_logic(
        clk,
        rst,
        txd=xgmii_rxd,
        txc=xgmii_rxc,
        name='xgmii_source'
    )

    xgmii_sink = xgmii_ep.XGMIISink()

    xgmii_sink_logic = xgmii_sink.create_logic(
        clk,
        rst,
        rxd=xgmii_txd,
        rxc=xgmii_txc,
        name='xgmii_sink'
    )

    # DUT
    if os.system(build_cmd):
        raise Exception("Error running build command")

    dut = Cosimulation(
        "vvp -m myhdl %s.vvp -lxt2" % testbench,
        clk=clk,
        rst=rst,
        rx_clk=rx_clk,
        rx_rst=rx_rst,
        tx_clk=tx_clk,
        tx_rst=tx_rst,
        current_test=current_test,

        xgmii_rxd=xgmii_rxd,
        xgmii_rxc=xgmii_rxc,
        xgmii_txd=xgmii_txd,
        xgmii_txc=xgmii_txc,

        inject_rx_desc=inject_rx_desc,
        inject_rx_desc_valid=inject_rx_desc_valid,
        slot_addr_wr_no=slot_addr_wr_no,
        slot_addr_wr_data=slot_addr_wr_data,
        slot_addr_wr_valid=slot_addr_wr_valid,
        inject_rx_desc_ready=inject_rx_desc_ready
    )

    @always(delay(4))
    def clkgen():
        clk.next = not clk
        tx_clk.next = not tx_clk
        rx_clk.next = not rx_clk

    @instance
    def check():
        yield delay(100)
        yield clk.posedge
        tx_rst.next = 1
        rx_rst.next = 1
        rst.next = 1
        yield clk.posedge
        tx_rst.next = 0
        rx_rst.next = 0
        rst.next = 0
        yield clk.posedge
        yield delay(100)
        yield clk.posedge
        yield clk.posedge
        yield clk.posedge
        yield clk.posedge
        
        inject_rx_desc.next = (3<<4) + 2      
        inject_rx_desc_valid.next = 1
        yield clk.posedge
        inject_rx_desc.next = (7<<4) + 0      
        yield clk.posedge
        inject_rx_desc.next = (0<<4) + 1
        yield clk.posedge
        inject_rx_desc.next = (1<<4) + 15      
        yield clk.posedge
        inject_rx_desc.next = (2<<4) + 14      
        yield clk.posedge
        inject_rx_desc.next = (5<<4) + 2      
        yield clk.posedge
        inject_rx_desc_valid.next = 0
        yield clk.posedge

        slot_addr_wr_no.next   = 0   
        slot_addr_wr_data.next = 0x40
        slot_addr_wr_valid.next = 1   
        yield clk.posedge
        slot_addr_wr_no.next   = 1   
        slot_addr_wr_data.next = 0x44
        yield clk.posedge
        slot_addr_wr_no.next   = 2   
        slot_addr_wr_data.next = 0x48
        yield clk.posedge
        slot_addr_wr_no.next   = 3   
        slot_addr_wr_data.next = 0x4C
        yield clk.posedge
        slot_addr_wr_no.next   = 4   
        slot_addr_wr_data.next = 0x50
        yield clk.posedge
        slot_addr_wr_no.next   = 5   
        slot_addr_wr_data.next = 0x54
        yield clk.posedge
        slot_addr_wr_no.next   = 6   
        slot_addr_wr_data.next = 0x58
        yield clk.posedge
        slot_addr_wr_no.next   = 7   
        slot_addr_wr_data.next = 0x5C
        yield clk.posedge
        slot_addr_wr_no.next   = 8   
        slot_addr_wr_data.next = 0x60
        yield clk.posedge
        slot_addr_wr_no.next   = 9   
        slot_addr_wr_data.next = 0x64
        yield clk.posedge
        slot_addr_wr_no.next   = 10   
        slot_addr_wr_data.next = 0x68
        yield clk.posedge
        slot_addr_wr_no.next   = 11   
        slot_addr_wr_data.next = 0x6C
        yield clk.posedge
        slot_addr_wr_no.next   = 12   
        slot_addr_wr_data.next = 0x70
        yield clk.posedge
        slot_addr_wr_no.next   = 13   
        slot_addr_wr_data.next = 0x74
        yield clk.posedge
        slot_addr_wr_no.next   = 14   
        slot_addr_wr_data.next = 0x78
        yield clk.posedge
        slot_addr_wr_no.next   = 15   
        slot_addr_wr_data.next = 0x7C
        yield clk.posedge
        slot_addr_wr_valid.next = 0   
        yield clk.posedge

        # testbench stimulus

        yield delay(10000)
        yield clk.posedge

        current_test.next = 1

        test_data = b'\x11\x22\x33\x44\x11\x22\x33\x44'

        test_frame = eth_ep.EthFrame()
        test_frame.eth_dest_mac = 0xDAD1D2D3D4D5
        test_frame.eth_src_mac = 0x5A5152535455
        test_frame.eth_type = 0x8000
        test_frame.payload = test_data
        test_frame.update_fcs()
        axis_frame = test_frame.build_axis_fcs()
        
        print ("send data over LAN")
        xgmii_source.send(b'\x55\x55\x55\x55\x55\x55\x55\xD5'+bytearray(axis_frame))
        yield delay(1000)
        yield clk.posedge
        xgmii_source.send(b'\x55\x55\x55\x55\x55\x55\x55\xD5'+bytearray(axis_frame))
        yield delay(1000)
        yield clk.posedge
        xgmii_source.send(b'\x55\x55\x55\x55\x55\x55\x55\xD5'+bytearray(axis_frame))
        yield delay(1000)
        yield clk.posedge
        xgmii_source.send(b'\x55\x55\x55\x55\x55\x55\x55\xD5'+bytearray(axis_frame))
        yield delay(1000)
        yield clk.posedge
        # # yield delay(10000)

        print ("send data from LAN")
        for i in range (0,4):
          yield xgmii_sink.wait()
          rx_frame = xgmii_sink.recv()
       
          assert rx_frame.data[0:8] == bytearray(b'\x55\x55\x55\x55\x55\x55\x55\xD5')
          data = rx_frame.data
          for i in range(0, len(data), 16):
              print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+16]))))
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

        yield delay(10000)
        yield clk.posedge

        raise StopSimulation

    return instances()

def test_bench():
    sim = Simulation(bench())
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test_bench()

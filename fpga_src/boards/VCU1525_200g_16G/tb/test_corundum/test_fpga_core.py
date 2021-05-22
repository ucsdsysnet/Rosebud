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
import sys

import scapy.utils
from scapy.layers.l2 import Ether
from scapy.layers.inet import IP, UDP

import cocotb_test.simulator

import cocotb
from cocotb.triggers import RisingEdge, Timer

from cocotbext.axi.utils import hexdump_str

try:
    import mqnic
    from common import TB
except ImportError:
    # attempt import from current directory
    sys.path.insert(0, os.path.join(os.path.dirname(__file__)))
    try:
        import mqnic
        from common import TB
    finally:
        del sys.path[0]


# SEND_COUNT_0 = 6 # 5000
# SEND_COUNT_1 = 6 # 5000
# SEND_COUNT_0 = 256
# SEND_COUNT_1 = 256
SEND_COUNT_0 = 1024
SEND_COUNT_1 = 1024
# SIZE_0       = [64, 128, 256, 512, 1024, 2048, 4096, 9000, 9000, 2048, 4096, 1024, 1500, 256, 128, 1024]
# SIZE_1       = [64, 128, 256, 512, 1024, 2048, 4096, 9000, 9000, 2048, 4096, 1024, 1500, 256, 128, 1024]
# SIZE_0       = [64, 128, 256, 512, 1024, 2048, 2048, 1024, 1500, 256, 128, 1024]
# SIZE_1       = [64, 128, 256, 512, 1024, 2048, 2048, 1024, 1500, 256, 128, 1024]
SIZE_0       = [64, 128, 256, 512, 1024, 1024, 1500, 256, 128, 1024]
SIZE_1       = [64, 128, 256, 512, 1024, 1024, 1500, 256, 128, 1024]
CHECK_PKT    = False
DROP_RATE    = 1  #0.66
TEST_PCIE    = False
PRINT_PKTS   = True


PACKETS = []


FIRMWARE = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '..', '..', '..', '..', '..', 'c_code', 'basic_corundum_fw.elf'))


@cocotb.test()
async def run_test_nic(dut):

    tb = TB(dut)

    await tb.init()

    await tb.load_firmware(FIRMWARE)

    tb.log.info("Set core enable mask")
    await tb.set_enable_cores(0xffff)
    await tb.set_receive_cores(0xffff)
    await tb.set_enable_interfaces(0xffff)
    await Timer(100, 'ns')

    tb.log.info("Init driver")
    await tb.driver.init_dev(tb.dev.functions[0].pcie_id)
    await tb.driver.interfaces[0].open()

    # enable queues
    tb.log.info("Enable queues")
    await tb.rc.mem_write_dword(tb.driver.interfaces[0].ports[0].hw_addr+mqnic.MQNIC_PORT_REG_SCHED_ENABLE, 0x00000001)
    for k in range(tb.driver.interfaces[0].tx_queue_count):
        await tb.rc.mem_write_dword(tb.driver.interfaces[0].ports[0].schedulers[0].hw_addr+4*k, 0x00000003)

    # wait for all writes to complete
    await tb.rc.mem_read(tb.driver.hw_addr, 4)
    tb.log.info("Init complete")

    tb.log.info("Send and receive single packet")

    data = bytearray([x % 256 for x in range(1024)])

    await tb.driver.interfaces[0].start_xmit(data, 0)

    pkt = await tb.qsfp0_sink.recv()
    tb.log.info("Packet: %s", pkt)

    await tb.qsfp0_source.send(pkt)

    pkt = await tb.driver.interfaces[0].recv()

    tb.log.info("Packet: %s", pkt)
    assert pkt.rx_checksum == ~scapy.utils.checksum(bytes(pkt.data[14:])) & 0xffff

    tb.log.info("RX and TX checksum tests")

    payload = bytes([x % 256 for x in range(256)])
    eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
    ip = IP(src='192.168.1.100', dst='192.168.1.101')
    udp = UDP(sport=1, dport=2)
    test_pkt = eth / ip / udp / payload

    test_pkt2 = test_pkt.copy()
    test_pkt2[UDP].chksum = scapy.utils.checksum(bytes(test_pkt2[UDP]))

    await tb.driver.interfaces[0].start_xmit(test_pkt2.build(), 0, 34, 6)

    pkt = await tb.qsfp0_sink.recv()
    tb.log.info("Packet: %s", pkt)

    await tb.qsfp0_source.send(pkt)

    pkt = await tb.driver.interfaces[0].recv()

    tb.log.info("Packet: %s", pkt)
    assert pkt.rx_checksum == ~scapy.utils.checksum(bytes(pkt.data[14:])) & 0xffff
    assert Ether(pkt.data).build() == test_pkt.build()

    tb.log.info("Multiple small packets")

    count = 64

    pkts = [bytes([(x+k) % 256 for x in range(60)]) for k in range(count)]
    pkts_set = set(pkts)

    tb.loopback_enable = True

    for p in pkts:
        await tb.driver.interfaces[0].start_xmit(p, 0)

    for k in range(count):
        pkt = await tb.driver.interfaces[0].recv()

        tb.log.debug("%s", hexdump_str(bytes(pkt), row_size=32))
        assert pkt.data in pkts_set
        pkts_set.remove(pkt.data)
        assert pkt.rx_checksum == ~scapy.utils.checksum(bytes(pkt.data[14:])) & 0xffff

    tb.loopback_enable = False

    tb.log.info("Multiple large packets")

    count = 64

    pkts = [bytes([(x+k) % 256 for x in range(1514)]) for k in range(count)]
    pkts_set = set(pkts)

    tb.loopback_enable = True

    for p in pkts:
        await tb.driver.interfaces[0].start_xmit(p, 0)

    for k in range(count):
        pkt = await tb.driver.interfaces[0].recv()

        tb.log.debug("%s", hexdump_str(bytes(pkt), row_size=32))
        assert pkt.data in pkts_set
        pkts_set.remove(pkt.data)
        assert pkt.rx_checksum == ~scapy.utils.checksum(bytes(pkt.data[14:])) & 0xffff

    tb.loopback_enable = False

    tb.log.info("Jumbo frames")

    count = 64

    pkts = [bytes([(x+k) % 256 for x in range(9014)]) for k in range(count)]
    pkts_set = set(pkts)

    tb.loopback_enable = True

    for p in pkts:
        await tb.driver.interfaces[0].start_xmit(p, 0)

    for k in range(count):
        pkt = await tb.driver.interfaces[0].recv()

        tb.log.debug("%s", hexdump_str(bytes(pkt), row_size=32))
        assert pkt.data in pkts_set
        pkts_set.remove(pkt.data)
        assert pkt.rx_checksum == ~scapy.utils.checksum(bytes(pkt.data[14:])) & 0xffff

    tb.loopback_enable = False

    await RisingEdge(dut.pcie_clk)
    await RisingEdge(dut.pcie_clk)

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


# cocotb-test

tests_dir = os.path.dirname(__file__)
rtl_dir = os.path.abspath(os.path.join(tests_dir, '..', '..', 'rtl'))
lib_dir = os.path.abspath(os.path.join(rtl_dir, '..', 'lib'))
axi_rtl_dir = os.path.abspath(os.path.join(lib_dir, 'axi', 'rtl'))
axis_rtl_dir = os.path.abspath(os.path.join(lib_dir, 'axis', 'rtl'))
eth_rtl_dir = os.path.abspath(os.path.join(lib_dir, 'eth', 'rtl'))
pcie_rtl_dir = os.path.abspath(os.path.join(lib_dir, 'pcie', 'rtl'))
corundum_rtl_dir = os.path.abspath(os.path.join(lib_dir, 'corundum', 'rtl'))
smartfpga_rtl_dir = os.path.abspath(os.path.join(lib_dir, 'smartFPGA', 'rtl'))


def test_fpga_core(request):
    run_test(
        sim_build=os.path.join("sim_build", request.node.name.replace('[', '-').replace(']', '')),
    )


def run_test(parameters=None, sim_build="sim_build", waves=None, force_compile=False, extra_env=None):
    dut = "fpga_core"
    module = os.path.splitext(os.path.basename(__file__))[0]
    toplevel = f"test_{dut}"

    verilog_sources = [
        os.path.join(tests_dir, "..", "common", f"{toplevel}.v"),
        os.path.join(rtl_dir, f"{dut}.v"),
        os.path.join(rtl_dir, "Gousheh_PR.v"),
        os.path.join(rtl_dir, "RR_LU_scheduler_PR.v"),
        os.path.join(rtl_dir, "pcie_config.v"),

        os.path.join(smartfpga_rtl_dir, "simple_fifo.v"),
        os.path.join(smartfpga_rtl_dir, "max_finder_tree.v"),
        os.path.join(smartfpga_rtl_dir, "slot_keeper.v"),
        os.path.join(smartfpga_rtl_dir, "core_mems.v"),
        os.path.join(smartfpga_rtl_dir, "axis_dma.v"),
        os.path.join(smartfpga_rtl_dir, "VexRiscv.v"),
        os.path.join(smartfpga_rtl_dir, "riscvcore.v"),
        os.path.join(smartfpga_rtl_dir, "Gousheh.v"),
        os.path.join(smartfpga_rtl_dir, "accel_wrap.v"),
        os.path.join(smartfpga_rtl_dir, "Gousheh_controller.v"),
        os.path.join(smartfpga_rtl_dir, "Gousheh_wrapper.v"),
        os.path.join(smartfpga_rtl_dir, "mem_sys.v"),
        os.path.join(smartfpga_rtl_dir, "simple_arbiter.v"),
        os.path.join(smartfpga_rtl_dir, "simple_sync_sig.v"),
        os.path.join(smartfpga_rtl_dir, "simple_axis_switch.v"),
        os.path.join(smartfpga_rtl_dir, "axis_ram_switch.v"),
        os.path.join(smartfpga_rtl_dir, "axis_stat.v"),
        os.path.join(smartfpga_rtl_dir, "stat_reader.v"),
        os.path.join(smartfpga_rtl_dir, "axis_switch_2lvl.v"),
        os.path.join(smartfpga_rtl_dir, "loopback_msg_fifo.v"),
        os.path.join(smartfpga_rtl_dir, "header.v"),
        os.path.join(smartfpga_rtl_dir, "pcie_controller.v"),
        os.path.join(smartfpga_rtl_dir, "pcie_cont_read.v"),
        os.path.join(smartfpga_rtl_dir, "pcie_cont_write.v"),
        os.path.join(smartfpga_rtl_dir, "corundum.v"),
        os.path.join(smartfpga_rtl_dir, "axis_fifo.v"),
        os.path.join(smartfpga_rtl_dir, "accel_rd_dma_sp.v"),

        os.path.join(eth_rtl_dir, "axis_xgmii_rx_64.v"),
        os.path.join(eth_rtl_dir, "axis_xgmii_tx_64.v"),
        os.path.join(eth_rtl_dir, "lfsr.v"),

        os.path.join(axis_rtl_dir, "arbiter.v"),
        os.path.join(axis_rtl_dir, "priority_encoder.v"),
        os.path.join(axis_rtl_dir, "sync_reset.v"),
        os.path.join(axis_rtl_dir, "axis_adapter.v"),
        os.path.join(axis_rtl_dir, "axis_arb_mux.v"),
        os.path.join(axis_rtl_dir, "axis_async_fifo.v"),
        os.path.join(axis_rtl_dir, "axis_async_fifo_adapter.v"),
        os.path.join(axis_rtl_dir, "axis_fifo_adapter.v"),
        os.path.join(axis_rtl_dir, "axis_register.v"),
        os.path.join(axis_rtl_dir, "axis_pipeline_register.v"),

        os.path.join(axi_rtl_dir, "axil_interconnect.v"),

        os.path.join(pcie_rtl_dir, "pcie_us_axil_master.v"),
        os.path.join(pcie_rtl_dir, "dma_client_axis_sink.v"),
        os.path.join(pcie_rtl_dir, "dma_client_axis_source.v"),
        os.path.join(pcie_rtl_dir, "dma_if_pcie_us.v"),
        os.path.join(pcie_rtl_dir, "dma_if_pcie_us_rd.v"),
        os.path.join(pcie_rtl_dir, "dma_if_pcie_us_wr.v"),
        os.path.join(pcie_rtl_dir, "dma_if_mux.v"),
        os.path.join(pcie_rtl_dir, "dma_if_mux_rd.v"),
        os.path.join(pcie_rtl_dir, "dma_if_mux_wr.v"),
        os.path.join(pcie_rtl_dir, "dma_psdpram.v"),
        os.path.join(pcie_rtl_dir, "pcie_tag_manager.v"),
        os.path.join(pcie_rtl_dir, "pcie_us_cfg.v"),
        os.path.join(pcie_rtl_dir, "pcie_us_msi.v"),
        os.path.join(pcie_rtl_dir, "pulse_merge.v"),

        os.path.join(corundum_rtl_dir, "mqnic_interface.v"),
        os.path.join(corundum_rtl_dir, "mqnic_port.v"),
        os.path.join(corundum_rtl_dir, "cpl_write.v"),
        os.path.join(corundum_rtl_dir, "cpl_op_mux.v"),
        os.path.join(corundum_rtl_dir, "desc_fetch.v"),
        os.path.join(corundum_rtl_dir, "desc_op_mux.v"),
        os.path.join(corundum_rtl_dir, "queue_manager.v"),
        os.path.join(corundum_rtl_dir, "cpl_queue_manager.v"),
        os.path.join(corundum_rtl_dir, "tx_engine.v"),
        os.path.join(corundum_rtl_dir, "rx_engine.v"),
        os.path.join(corundum_rtl_dir, "tx_checksum.v"),
        os.path.join(corundum_rtl_dir, "rx_checksum.v"),
        os.path.join(corundum_rtl_dir, "rx_hash.v"),
        os.path.join(corundum_rtl_dir, "tx_scheduler_rr.v"),
        os.path.join(corundum_rtl_dir, "tdma_scheduler.v"),
        os.path.join(corundum_rtl_dir, "event_mux.v"),
    ]

    if parameters is None:
        parameters = {}
    parameters = {k.upper(): v for k, v in parameters.items() if v is not None}

    parameters.setdefault('AXIS_PCIE_DATA_WIDTH', 512)
    parameters.setdefault('AXIS_PCIE_KEEP_WIDTH', parameters['AXIS_PCIE_DATA_WIDTH'] // 32)
    parameters.setdefault('AXIS_PCIE_RQ_USER_WIDTH', 62 if parameters['AXIS_PCIE_DATA_WIDTH'] < 512 else 137)
    parameters.setdefault('AXIS_PCIE_RC_USER_WIDTH', 75 if parameters['AXIS_PCIE_DATA_WIDTH'] < 512 else 161)
    parameters.setdefault('AXIS_PCIE_CQ_USER_WIDTH', 88 if parameters['AXIS_PCIE_DATA_WIDTH'] < 512 else 183)
    parameters.setdefault('AXIS_PCIE_CC_USER_WIDTH', 33 if parameters['AXIS_PCIE_DATA_WIDTH'] < 512 else 81)
    parameters.setdefault('RQ_SEQ_NUM_WIDTH', 6)
    parameters.setdefault('BAR0_APERTURE', 24)
    parameters.setdefault('AXIS_ETH_DATA_WIDTH', 512)
    parameters.setdefault('AXIS_ETH_KEEP_WIDTH', parameters['AXIS_ETH_DATA_WIDTH'] // 8)
    parameters.setdefault('TB_LOG', 0)

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

    parser.add_argument('--axis_pcie_data_width', type=int, default=512)
    parser.add_argument('--axis_pcie_keep_width')
    parser.add_argument('--axis_pcie_rq_user_width')
    parser.add_argument('--axis_pcie_rc_user_width')
    parser.add_argument('--axis_pcie_cq_user_width')
    parser.add_argument('--axis_pcie_cc_user_width')
    parser.add_argument('--rq_seq_num_width', type=int, default=6)
    parser.add_argument('--bar0_aperture', type=int, default=24)
    parser.add_argument('--axis_eth_data_width', type=int, default=512)
    parser.add_argument('--axis_eth_keep_width', type=int)
    parser.add_argument('--tb_log', type=int, default=0)

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

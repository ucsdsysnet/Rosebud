"""

Copyright (c) 2020-2021 Moein Khazraee

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

# The spacing (indentation) before module names is important, so lines start with "|"+name

MAC_modules = [
"     MAC_async_FIFO\[0\]\.mac_rx_async_fifo_inst",
"     MAC_async_FIFO\[0\]\.mac_rx_fifo_inst",
"     MAC_async_FIFO\[0\]\.mac_rx_pipeline",
"     MAC_async_FIFO\[0\]\.mac_tx_fifo_inst",
"     MAC_async_FIFO\[0\]\.mac_tx_pipeline",
"     MAC_async_FIFO\[1\]\.mac_rx_async_fifo_inst",
"     MAC_async_FIFO\[1\]\.mac_rx_fifo_inst",
"     MAC_async_FIFO\[1\]\.mac_rx_pipeline",
"     MAC_async_FIFO\[1\]\.mac_tx_fifo_inst",
"     MAC_async_FIFO\[1\]\.mac_tx_pipeline",
"   qsfp0_cmac_inst",
"   qsfp0_cmac_pad_inst",
"   qsfp1_cmac_inst",
"   qsfp1_cmac_pad_inst"]

SW_n_stat_modules = [
"     \(core_inst\)",
"     core_stat_data_reg",
"     cores_to_broadcaster",
"     ctrl_in_sw",
"     ctrl_out_sw",
"     data_in_sw",
"     data_out_sw",
"     dram_ctrl_in_sw",
"     dram_ctrl_out_sw",
"     interface_incoming_stat",
"     interface_outgoing_stat",
"     loopback_msg_fifo_inst"]

PCIe_modules = [
"     pcie_config_inst",
"     pcie_controller_inst",
"   pcie4_uscale_plus_inst",
"   pcie_us_cfg_inst",
"   pcie_us_msi_inst"]

Interconnects = [
"     rpus\[0\]\.rpu_intercon_inst",
"     rpus\[1\]\.rpu_intercon_inst",
"     rpus\[2\]\.rpu_intercon_inst",
"     rpus\[3\]\.rpu_intercon_inst",
"     rpus\[4\]\.rpu_intercon_inst",
"     rpus\[5\]\.rpu_intercon_inst",
"     rpus\[6\]\.rpu_intercon_inst",
"     rpus\[7\]\.rpu_intercon_inst",
"     rpus\[8\]\.rpu_intercon_inst",
"     rpus\[9\]\.rpu_intercon_inst",
"     rpus\[10\]\.rpu_intercon_inst",
"     rpus\[11\]\.rpu_intercon_inst",
"     rpus\[12\]\.rpu_intercon_inst",
"     rpus\[13\]\.rpu_intercon_inst",
"     rpus\[14\]\.rpu_intercon_inst",
"     rpus\[15\]\.rpu_intercon_inst"]

RPUs = [
"     rpus\[0\]\.rpu_PR_inst",
"     rpus\[1\]\.rpu_PR_inst",
"     rpus\[2\]\.rpu_PR_inst",
"     rpus\[3\]\.rpu_PR_inst",
"     rpus\[4\]\.rpu_PR_inst",
"     rpus\[5\]\.rpu_PR_inst",
"     rpus\[6\]\.rpu_PR_inst",
"     rpus\[7\]\.rpu_PR_inst",
"     rpus\[8\]\.rpu_PR_inst",
"     rpus\[9\]\.rpu_PR_inst",
"     rpus\[10\]\.rpu_PR_inst",
"     rpus\[11\]\.rpu_PR_inst",
"     rpus\[12\]\.rpu_PR_inst",
"     rpus\[13\]\.rpu_PR_inst",
"     rpus\[14\]\.rpu_PR_inst",
"     rpus\[15\]\.rpu_PR_inst"]

LB_module = ["     lb_PR_inst"]


mem_modules = ["         memories"]
riscv_modules = ["         core"]
acc_manager =   ["           \(accel_wrap_inst\)",
                 "       \(rpus\[0\]\.rpu_PR_inst\) ",
                 "       \(rpus\[1\]\.rpu_PR_inst\) ",
                 "       \(rpus\[2\]\.rpu_PR_inst\) ",
                 "       \(rpus\[3\]\.rpu_PR_inst\) ",
                 "       \(rpus\[4\]\.rpu_PR_inst\) ",
                 "       \(rpus\[5\]\.rpu_PR_inst\) ",
                 "       \(rpus\[6\]\.rpu_PR_inst\) ",
                 "       \(rpus\[7\]\.rpu_PR_inst\) ",
                 "       \(rpus\[8\]\.rpu_PR_inst\) ",
                 "       \(rpus\[9\]\.rpu_PR_inst\) ",
                 "       \(rpus\[10\]\.rpu_PR_inst\) ",
                 "       \(rpus\[11\]\.rpu_PR_inst\) ",
                 "       \(rpus\[12\]\.rpu_PR_inst\) ",
                 "       \(rpus\[13\]\.rpu_PR_inst\) ",
                 "       \(rpus\[14\]\.rpu_PR_inst\) ",
                 "       \(rpus\[15\]\.rpu_PR_inst\) ",
                 "       bc_msg_in_reg",
                 "       bc_msg_out_reg",
                 "       dma_rd_reg",
                 "       dma_rd_resp_reg",
                 "       dma_wr_reg",
                 "       in_desc_reg",
                 "       out_desc_reg",
                 "         rpu_controller_inst"]
firewall = ["           firewall_inst"]

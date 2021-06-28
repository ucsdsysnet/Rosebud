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

Core_wrappers = [
"     riscv_cores\[0\]\.core_wrapper",
"     riscv_cores\[1\]\.core_wrapper",
"     riscv_cores\[2\]\.core_wrapper",
"     riscv_cores\[3\]\.core_wrapper",
"     riscv_cores\[4\]\.core_wrapper",
"     riscv_cores\[5\]\.core_wrapper",
"     riscv_cores\[6\]\.core_wrapper",
"     riscv_cores\[7\]\.core_wrapper"]

Gushehs = [
"     riscv_cores\[0\]\.pr_wrapper",
"     riscv_cores\[1\]\.pr_wrapper",
"     riscv_cores\[2\]\.pr_wrapper",
"     riscv_cores\[3\]\.pr_wrapper",
"     riscv_cores\[4\]\.pr_wrapper",
"     riscv_cores\[5\]\.pr_wrapper",
"     riscv_cores\[6\]\.pr_wrapper",
"     riscv_cores\[7\]\.pr_wrapper"]

PR_regs = [
"       \(riscv_cores\[0\]\.pr_wrapper\) ",
"       \(riscv_cores\[1\]\.pr_wrapper\) ",
"       \(riscv_cores\[2\]\.pr_wrapper\) ",
"       \(riscv_cores\[3\]\.pr_wrapper\) ",
"       \(riscv_cores\[4\]\.pr_wrapper\) ",
"       \(riscv_cores\[5\]\.pr_wrapper\) ",
"       \(riscv_cores\[6\]\.pr_wrapper\) ",
"       \(riscv_cores\[7\]\.pr_wrapper\) ",
"       bc_msg_in_reg",
"       bc_msg_out_reg",
"       dma_rd_reg",
"       dma_rd_resp_reg",
"       dma_wr_reg",
"       in_desc_reg",
"       out_desc_reg"]

Scheduler_module = ["     scheduler"]


mem_modules = ["         memories"]
riscv_modules = ["         core"]
gousheh_cont = ["         Gousheh_controller_inst"]
acc_manager =   ["           \(accel_wrap_inst\)"]
acc_dma =   ["           accel_dma_engine "]
fixed_sme = ["           fied_loc_sme\[12\]\.fixed_loc_sme_inst "]
http_sme = [
"           http_sme\[10\]\.http_sme_inst ",
"           http_sme\[11\]\.http_sme_inst ",
"           http_sme\[8\]\.http_sme_inst ",
"           http_sme\[9\]\.http_sme_inst "]

tcp_sme = [
"           tcp_sme\[0\]\.tcp_sme_inst ",
"           tcp_sme\[1\]\.tcp_sme_inst ",
"           tcp_sme\[2\]\.tcp_sme_inst ",
"           tcp_sme\[3\]\.tcp_sme_inst "]

udp_sme = [
"           udp_sme\[4\]\.udp_sme_inst ",
"           udp_sme\[5\]\.udp_sme_inst ",
"           udp_sme\[6\]\.udp_sme_inst ",
"           udp_sme\[7\]\.udp_sme_inst "]
width = [
"           width_converters_1B\[0\]\.accel_width_conv_inst ",
"           width_converters_1B\[10\]\.accel_width_conv_inst ",
"           width_converters_1B\[11\]\.accel_width_conv_inst ",
"           width_converters_1B\[1\]\.accel_width_conv_inst ",
"           width_converters_1B\[2\]\.accel_width_conv_inst ",
"           width_converters_1B\[3\]\.accel_width_conv_inst ",
"           width_converters_1B\[4\]\.accel_width_conv_inst ",
"           width_converters_1B\[5\]\.accel_width_conv_inst ",
"           width_converters_1B\[6\]\.accel_width_conv_inst ",
"           width_converters_1B\[7\]\.accel_width_conv_inst ",
"           width_converters_1B\[8\]\.accel_width_conv_inst ",
"           width_converters_1B\[9\]\.accel_width_conv_inst ",
"           width_converters_8B\[12\]\.accel_width_conv_inst "]
ip_match = ["           ip_match_inst "]

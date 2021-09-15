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
"     riscv_cores\[7\]\.core_wrapper",
"     riscv_cores\[8\]\.core_wrapper",
"     riscv_cores\[9\]\.core_wrapper",
"     riscv_cores\[10\]\.core_wrapper",
"     riscv_cores\[11\]\.core_wrapper",
"     riscv_cores\[12\]\.core_wrapper",
"     riscv_cores\[13\]\.core_wrapper",
"     riscv_cores\[14\]\.core_wrapper",
"     riscv_cores\[15\]\.core_wrapper"]

Gushehs = [
"     riscv_cores\[0\]\.pr_wrapper",
"     riscv_cores\[1\]\.pr_wrapper",
"     riscv_cores\[2\]\.pr_wrapper",
"     riscv_cores\[3\]\.pr_wrapper",
"     riscv_cores\[4\]\.pr_wrapper",
"     riscv_cores\[5\]\.pr_wrapper",
"     riscv_cores\[6\]\.pr_wrapper",
"     riscv_cores\[7\]\.pr_wrapper",
"     riscv_cores\[8\]\.pr_wrapper",
"     riscv_cores\[9\]\.pr_wrapper",
"     riscv_cores\[10\]\.pr_wrapper",
"     riscv_cores\[11\]\.pr_wrapper",
"     riscv_cores\[12\]\.pr_wrapper",
"     riscv_cores\[13\]\.pr_wrapper",
"     riscv_cores\[14\]\.pr_wrapper",
"     riscv_cores\[15\]\.pr_wrapper"]

PR_regs = [
"       \(riscv_cores\[0\]\.pr_wrapper\) ",
"       \(riscv_cores\[1\]\.pr_wrapper\) ",
"       \(riscv_cores\[2\]\.pr_wrapper\) ",
"       \(riscv_cores\[3\]\.pr_wrapper\) ",
"       \(riscv_cores\[4\]\.pr_wrapper\) ",
"       \(riscv_cores\[5\]\.pr_wrapper\) ",
"       \(riscv_cores\[6\]\.pr_wrapper\) ",
"       \(riscv_cores\[7\]\.pr_wrapper\) ",
"       \(riscv_cores\[8\]\.pr_wrapper\) ",
"       \(riscv_cores\[9\]\.pr_wrapper\) ",
"       \(riscv_cores\[10\]\.pr_wrapper\) ",
"       \(riscv_cores\[11\]\.pr_wrapper\) ",
"       \(riscv_cores\[12\]\.pr_wrapper\) ",
"       \(riscv_cores\[13\]\.pr_wrapper\) ",
"       \(riscv_cores\[14\]\.pr_wrapper\) ",
"       \(riscv_cores\[15\]\.pr_wrapper\) ",
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
firewall = ["           firewall_inst"]

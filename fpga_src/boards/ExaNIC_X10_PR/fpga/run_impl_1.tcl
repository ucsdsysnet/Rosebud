open_project fpga.xpr
set_property AUTO_INCREMENTAL_CHECKPOINT 1 [get_runs impl_1]
set_property PR_FLOW 1 [current_project]
if {[llength [get_pr_configurations  config_1]]==0} then {create_pr_configuration -name config_1 -partitions [list core_inst/riscv_cores[0].pr_wrapper:riscv_block_PR core_inst/riscv_cores[1].pr_wrapper:riscv_block_PR core_inst/riscv_cores[2].pr_wrapper:riscv_block_PR core_inst/riscv_cores[3].pr_wrapper:riscv_block_PR core_inst/riscv_cores[4].pr_wrapper:riscv_block_PR core_inst/riscv_cores[5].pr_wrapper:riscv_block_PR core_inst/riscv_cores[6].pr_wrapper:riscv_block_PR core_inst/riscv_cores[7].pr_wrapper:riscv_block_PR core_inst/riscv_cores[8].pr_wrapper:riscv_block_PR core_inst/riscv_cores[9].pr_wrapper:riscv_block_PR core_inst/riscv_cores[10].pr_wrapper:riscv_block_PR core_inst/riscv_cores[11].pr_wrapper:riscv_block_PR core_inst/riscv_cores[12].pr_wrapper:riscv_block_PR core_inst/riscv_cores[13].pr_wrapper:riscv_block_PR core_inst/riscv_cores[14].pr_wrapper:riscv_block_PR core_inst/riscv_cores[15].pr_wrapper:riscv_block_PR ]}
set_property PR_CONFIGURATION config_1 [get_runs impl_1]
set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]
reset_run impl_1
launch_runs impl_1
wait_on_run impl_1
exit

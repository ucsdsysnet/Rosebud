open_project fpga.xpr
if {[llength [get_pr_configurations  "config_2"]]==0} then {create_pr_configuration -name config_2 -partitions { }  -greyboxes [list core_inst/riscv_cores[0].pr_wrapper core_inst/riscv_cores[1].pr_wrapper core_inst/riscv_cores[2].pr_wrapper core_inst/riscv_cores[3].pr_wrapper core_inst/riscv_cores[4].pr_wrapper core_inst/riscv_cores[5].pr_wrapper core_inst/riscv_cores[6].pr_wrapper core_inst/riscv_cores[7].pr_wrapper core_inst/riscv_cores[8].pr_wrapper core_inst/riscv_cores[9].pr_wrapper core_inst/riscv_cores[10].pr_wrapper core_inst/riscv_cores[11].pr_wrapper core_inst/riscv_cores[12].pr_wrapper core_inst/riscv_cores[13].pr_wrapper core_inst/riscv_cores[14].pr_wrapper core_inst/riscv_cores[15].pr_wrapper ]}
if {[llength [get_runs  "impl_2"]]==0} then {create_run impl_2 -parent_run impl_1 -flow {Vivado Implementation 2019} -pr_config config_2}
set_property strategy Performance_ExtraTimingOpt [get_runs impl_2]
reset_run impl_2
launch_runs impl_2
wait_on_run impl_2
exit

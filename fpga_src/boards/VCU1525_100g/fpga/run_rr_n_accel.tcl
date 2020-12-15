open_project fpga.xpr

update_compile_order -fileset sources_1
set_property needs_refresh false [get_runs synth_1]
set_property needs_refresh false [get_runs impl_1]
# set_property needs_refresh false [get_runs impl_2]

if {[llength [get_pr_configurations rr_n_accel]]!=0} then {
  delete_pr_configurations rr_n_accel}
create_pr_configuration -name rr_n_accel -partitions [list \
  core_inst/riscv_cores[0].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[1].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[2].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[3].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[4].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[5].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[6].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[7].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[8].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[9].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[10].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[11].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[12].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[13].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[14].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/riscv_cores[15].pr_wrapper:riscv_block_PR_w_accel \
  core_inst/scheduler_PR_inst:scheduler_PR]

if {[llength [get_runs "impl_accel"]]!=0} then {delete_run impl_accel}
create_run impl_accel -parent_run impl_1 -flow {Vivado Implementation 2020} -pr_config rr_n_accel
set_property strategy Performance_ExtraTimingOpt [get_runs impl_accel]

# update_compile_order -fileset riscv_block_PR_w_accel
# update_compile_order -fileset scheduler_PR
# update_compile_order -fileset sources_1

reset_run impl_accel
launch_runs impl_accel
wait_on_run impl_accel

open_run impl_accel
report_utilization -force -hierarchical -hierarchical_percentage -file fpga_utilization_hierarchy_placed_accel.rpt
report_utilization -force -pblocks [get_pblocks -regexp {pblock_([2-9]|1[0-6]|1)}] -file fpga_utilization_accel_pblocks.rpt
write_bitstream -no_partial_bitfile -force fpga.runs/impl_accel/fpga.bit

exit

open_project fpga.xpr

update_compile_order -fileset sources_1
set_property needs_refresh false [get_runs synth_1]
set_property needs_refresh false [get_runs impl_1]
# set_property needs_refresh false [get_runs impl_2]

if {[llength [get_reconfig_modules scheduler_PR2]]==0} then {
  create_reconfig_module -name scheduler_PR2 -partition_def [get_partition_defs pr_scheduler]  -top scheduler_PR2}

add_files -norecurse {
  ../lib/eth/lib/axis/rtl/arbiter.v 
  ../lib/eth/lib/axis/rtl/axis_arb_mux.v
  ../lib/eth/lib/axis/rtl/axis_register.v
  ../lib/eth/lib/axis/rtl/axis_pipeline_register.v
  ../lib/eth/lib/axis/rtl/priority_encoder.v
  ../lib/eth/lib/axis/rtl/sync_reset.v
  ../lib/corundum/rtl/rx_hash.v
  ../lib/smartFPGA/rtl/axis_fifo.v
  ../lib/smartFPGA/rtl/simple_arbiter.v
  ../lib/smartFPGA/rtl/simple_fifo.v
  ../lib/smartFPGA/rtl/header.v
  ../lib/smartFPGA/rtl/slot_keeper.v
  ../lib/smartFPGA/rtl/max_finder_tree.v
  ../rtl/RR_LU_scheduler_PR.v
} -of_objects [get_reconfig_modules scheduler_PR2]


if {[llength [get_pr_configurations sched_config]]!=0} then {
  delete_pr_configurations sched_config}
create_pr_configuration -name sched_config -partitions [list \
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
  core_inst/scheduler_PR_inst:scheduler_PR2]

if {[llength [get_runs "impl_sched"]]!=0} then {delete_run impl_sched}
create_run impl_sched -parent_run impl_1 -flow {Vivado Implementation 2020} -pr_config sched_config
set_property strategy Performance_ExtraTimingOpt [get_runs impl_sched]

update_compile_order -fileset scheduler_PR2
update_compile_order -fileset sources_1

reset_run scheduler_PR2_synth_1
launch_runs scheduler_PR2_synth_1
wait_on_run scheduler_PR2_synth_1

# add_files -fileset utils_1 -norecurse ../lib/axis/syn/sync_reset.tcl
# add_files -fileset utils_1 -norecurse ../lib/smartFPGA/syn/simple_sync_sig.tcl
set_property STEPS.OPT_DESIGN.TCL.PRE [ get_files ../lib/axis/syn/sync_reset.tcl -of [get_fileset utils_1] ] [get_runs impl_sched]
set_property STEPS.OPT_DESIGN.TCL.PRE [ get_files ../lib/smartFPGA/syn/simple_sync_sig.tcl -of [get_fileset utils_1] ] [get_runs impl_sched]
set_property STEPS.ROUTE_DESIGN.TCL.PRE [ get_files ../lib/axis/syn/sync_reset.tcl -of [get_fileset utils_1] ] [get_runs impl_sched]
set_property STEPS.ROUTE_DESIGN.TCL.PRE [ get_files ../lib/smartFPGA/syn/simple_sync_sig.tcl -of [get_fileset utils_1] ] [get_runs impl_sched]
# set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE SSI_SpreadLogic_high [get_runs sched]

add_files -fileset utils_1 -norecurse fpga.runs/impl_w_accel/fpga_routed.dcp
set_property incremental_checkpoint fpga.runs/impl_w_accel/fpga_routed.dcp [get_runs impl_sched]

reset_run impl_sched
launch_runs impl_sched
wait_on_run impl_sched

open_run impl_sched
# report_utilization -force -hierarchical -hierarchical_percentage -file fpga_utilization_hierarchy_placed_sched.rpt
# report_utilization -force -pblocks [get_pblocks -regexp {pblock_([2-9]|1[0-6]|1)}] -file fpga_utilization_sched_pblocks.rpt
write_bitstream -no_partial_bitfile -force fpga.runs/impl_sched/fpga.bit

exit

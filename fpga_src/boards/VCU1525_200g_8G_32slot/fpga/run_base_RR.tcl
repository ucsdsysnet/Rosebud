open_project fpga.xpr

update_compile_order -fileset sources_1
set_property needs_refresh false [get_runs synth_1]
set_property needs_refresh false [get_runs impl_1]

if {[llength [get_reconfig_modules scheduler_RR]]!=0} then {
  delete_reconfig_modules scheduler_RR}
create_reconfig_module -name scheduler_RR -partition_def [get_partition_defs pr_scheduler] -top scheduler_PR

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
  ../lib/smartFPGA/rtl/axis_dropper.v
  ../lib/smartFPGA/rtl/slot_keeper.v
  ../lib/smartFPGA/rtl/max_finder_tree.v
  ../rtl/RR_LU_scheduler_PR.v
  ../lib/axis/syn/vivado/sync_reset.tcl
} -of_objects [get_reconfig_modules scheduler_RR]

if {[llength [get_pr_configurations base_RR_config]]!=0} then {
  delete_pr_configurations base_RR_config}
create_pr_configuration -name base_RR_config -partitions [list \
  core_inst/riscv_cores[0].pr_wrapper:Gousheh_base \
  core_inst/riscv_cores[1].pr_wrapper:Gousheh_base \
  core_inst/riscv_cores[2].pr_wrapper:Gousheh_base \
  core_inst/riscv_cores[3].pr_wrapper:Gousheh_base \
  core_inst/riscv_cores[4].pr_wrapper:Gousheh_base \
  core_inst/riscv_cores[5].pr_wrapper:Gousheh_base \
  core_inst/riscv_cores[6].pr_wrapper:Gousheh_base \
  core_inst/riscv_cores[7].pr_wrapper:Gousheh_base \
  core_inst/scheduler_PR_inst:scheduler_RR]

if {[llength [get_runs "impl_base_RR"]]!=0} then {delete_run impl_base_RR}
create_run impl_base_RR -parent_run impl_1 -flow {Vivado Implementation 2021} -pr_config base_RR_config
set_property strategy Performance_ExtraTimingOpt [get_runs impl_base_RR]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_base_RR]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_base_RR]
set_property -name {STEPS.OPT_DESIGN.ARGS.MORE OPTIONS} -value {-retarget -propconst -sweep -bufg_opt -shift_register_opt -aggressive_remap} -objects [get_runs impl_base_RR]
# set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_base_RR]

update_compile_order -fileset scheduler_RR
update_compile_order -fileset sources_1

reset_run scheduler_RR_synth_1
launch_runs scheduler_RR_synth_1 -jobs 12
wait_on_run scheduler_RR_synth_1

# add_files -fileset utils_1 -norecurse fpga.runs/impl_PIG_HASH/fpga_postroute_physopt.dcp
# set_property incremental_checkpoint fpga.runs/impl_PIG_HASH/fpga_postroute_physopt.dcp [get_runs impl_base_RR]
# set_property incremental_checkpoint.directive TimingClosure [get_runs impl_base_RR]

set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_base_RR] impl_base_RR_route_report_drc_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_base_RR] impl_base_RR_route_report_power_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_base_RR] impl_base_RR_opt_report_drc_0]

reset_run impl_base_RR
launch_runs impl_base_RR -jobs 12
wait_on_run impl_base_RR

open_run impl_base_RR
write_bitstream -no_partial_bitfile -force fpga.runs/impl_base_RR/fpga.bit

exit

open_project fpga.xpr

update_compile_order -fileset sources_1
set_property needs_refresh false [get_runs synth_1]
set_property needs_refresh false [get_runs impl_1]

if {[llength [get_reconfig_modules Gousheh_PIG]]!=0} then {
  delete_reconfig_modules Gousheh_PIG}
create_reconfig_module -name Gousheh_PIG -partition_def [get_partition_defs pr_riscv] -top Gousheh_PR

add_files -norecurse {
  ../lib/eth/lib/axis/rtl/arbiter.v 
  ../lib/eth/lib/axis/rtl/priority_encoder.v 
  ../lib/smartFPGA/rtl/core_mems.v
  ../lib/smartFPGA/rtl/axis_fifo.v
  ../lib/smartFPGA/rtl/VexRiscv.v
  ../lib/eth/lib/axis/rtl/axis_register.v
  ../lib/eth/lib/axis/rtl/axis_pipeline_register.v
  ../lib/smartFPGA/rtl/simple_sync_sig.v
  ../lib/smartFPGA/rtl/riscvcore.v
  ../lib/smartFPGA/rtl/simple_fifo.v
  ../lib/smartFPGA/rtl/mem_sys.v
  ../lib/smartFPGA/rtl/Gousheh.v
  ../lib/smartFPGA/rtl/Gousheh_controller.v
  ../lib/smartFPGA/rtl/accel_rd_dma_sp.v
  ../accel/pigasus_sme/rtl/backend.sv
  ../accel/pigasus_sme/rtl/first_filter.sv
  ../accel/pigasus_sme/rtl/frontend.sv
  ../accel/pigasus_sme/rtl/hashtable.sv
  ../accel/pigasus_sme/rtl/hashtable_top.sv
  ../accel/pigasus_sme/rtl/ips.sv
  ../accel/pigasus_sme/rtl/mul_hash.sv
  ../accel/pigasus_sme/rtl/rr_arbiter.sv
  ../accel/pigasus_sme/rtl/rr_arbiter_4.sv
  ../accel/pigasus_sme/rtl/string_matcher.sv
  ../accel/pigasus_sme/rtl/struct_s.sv
  ../accel/pigasus_sme/rtl/SME_wrapper.v
  ../accel/pigasus_sme/rtl/accel_wrap_pigasus.v
  ../accel/pigasus_sme/rtl/ip_match.v
  ../rtl/Gousheh_PR_pig.v
} -of_objects [get_reconfig_modules Gousheh_PIG]
  
if {[llength [get_pr_configurations PIG_RR_config]]!=0} then {
  delete_pr_configurations PIG_RR_config}
create_pr_configuration -name PIG_RR_config -partitions [list \
  core_inst/riscv_cores[0].pr_wrapper:Gousheh_PIG \
  core_inst/riscv_cores[1].pr_wrapper:Gousheh_PIG \
  core_inst/riscv_cores[2].pr_wrapper:Gousheh_PIG \
  core_inst/riscv_cores[3].pr_wrapper:Gousheh_PIG \
  core_inst/riscv_cores[4].pr_wrapper:Gousheh_PIG \
  core_inst/riscv_cores[5].pr_wrapper:Gousheh_PIG \
  core_inst/riscv_cores[6].pr_wrapper:Gousheh_PIG \
  core_inst/riscv_cores[7].pr_wrapper:Gousheh_PIG \
  core_inst/scheduler_PR_inst:scheduler_RR]

if {[llength [get_runs "impl_PIG_RR"]]!=0} then {delete_run impl_PIG_RR}
create_run impl_PIG_RR -parent_run impl_1 -flow {Vivado Implementation 2020} -pr_config PIG_RR_config
set_property strategy Performance_ExtraTimingOpt [get_runs impl_PIG_RR]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_PIG_RR]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_PIG_RR]
# set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_PIG_RR]
set_property AUTO_INCREMENTAL_CHECKPOINT 1 [get_runs impl_PIG_RR]

update_compile_order -fileset Gousheh_PIG
update_compile_order -fileset sources_1

reset_run Gousheh_PIG_synth_1
launch_runs Gousheh_PIG_synth_1 -jobs 12
wait_on_run Gousheh_PIG_synth_1

create_fileset -quiet PIG_RR_utils
add_files -fileset PIG_RR_utils -norecurse ../lib/axis/syn/sync_reset.tcl
add_files -fileset PIG_RR_utils -norecurse ../lib/smartFPGA/syn/simple_sync_sig.tcl
set_property STEPS.OPT_DESIGN.TCL.PRE [ get_files ../lib/axis/syn/sync_reset.tcl -of [get_fileset PIG_RR_utils] ] [get_runs impl_PIG_RR]
set_property STEPS.OPT_DESIGN.TCL.PRE [ get_files ../lib/smartFPGA/syn/simple_sync_sig.tcl -of [get_fileset PIG_RR_utils] ] [get_runs impl_PIG_RR]
set_property STEPS.ROUTE_DESIGN.TCL.PRE [ get_files ../lib/axis/syn/sync_reset.tcl -of [get_fileset PIG_RR_utils] ] [get_runs impl_PIG_RR]
set_property STEPS.ROUTE_DESIGN.TCL.PRE [ get_files ../lib/smartFPGA/syn/simple_sync_sig.tcl -of [get_fileset PIG_RR_utils] ] [get_runs impl_PIG_RR]

set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_PIG_RR] impl_PIG_RR_route_report_drc_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_PIG_RR] impl_PIG_RR_route_report_power_0]

reset_run impl_PIG_RR
launch_runs impl_PIG_RR -jobs 12
wait_on_run impl_PIG_RR

open_run impl_PIG_RR
write_bitstream -no_partial_bitfile -force fpga.runs/impl_PIG_RR/fpga.bit

exit

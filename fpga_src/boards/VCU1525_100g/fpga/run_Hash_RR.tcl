open_project fpga.xpr

update_compile_order -fileset sources_1
set_property needs_refresh false [get_runs synth_1]
set_property needs_refresh false [get_runs impl_1]

if {[llength [get_reconfig_modules riscv_block_Hash]]!=0} then {
  delete_reconfig_modules riscv_block_Hash}
create_reconfig_module -name riscv_block_Hash -partition_def [get_partition_defs pr_riscv] -top riscv_block_PR

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
  ../lib/smartFPGA/rtl/riscv_block.v
  ../lib/smartFPGA/rtl/accel_rd_dma_sp.v
  ../accel/merged/rtl/hash_acc.v
  ../accel/merged/rtl/re_sql.v
  ../accel/merged/rtl/accel_wrap_merged.v
  ../rtl/riscv_block_PR_w_accel.v
} -of_objects [get_reconfig_modules riscv_block_Hash]
  
if {[llength [get_pr_configurations Hash_RR_config]]!=0} then {
  delete_pr_configurations Hash_RR_config}
create_pr_configuration -name Hash_RR_config -partitions [list \
  core_inst/riscv_cores[0].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[1].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[2].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[3].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[4].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[5].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[6].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[7].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[8].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[9].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[10].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[11].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[12].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[13].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[14].pr_wrapper:riscv_block_Hash \
  core_inst/riscv_cores[15].pr_wrapper:riscv_block_Hash \
  core_inst/scheduler_PR_inst:scheduler_RR]

if {[llength [get_runs "impl_Hash_RR"]]!=0} then {delete_run impl_Hash_RR}
create_run impl_Hash_RR -parent_run impl_1 -flow {Vivado Implementation 2020} -pr_config Hash_RR_config
set_property strategy Performance_ExtraTimingOpt [get_runs impl_Hash_RR]

update_compile_order -fileset riscv_block_Hash
update_compile_order -fileset sources_1

reset_run riscv_block_Hash_synth_1
launch_runs riscv_block_Hash_synth_1
wait_on_run riscv_block_Hash_synth_1

create_fileset -quiet Hash_RR_utils
add_files -fileset Hash_RR_utils -norecurse ../lib/axis/syn/sync_reset.tcl
add_files -fileset Hash_RR_utils -norecurse ../lib/smartFPGA/syn/simple_sync_sig.tcl
set_property STEPS.OPT_DESIGN.TCL.PRE [ get_files ../lib/axis/syn/sync_reset.tcl -of [get_fileset Hash_RR_utils] ] [get_runs impl_Hash_RR]
set_property STEPS.OPT_DESIGN.TCL.PRE [ get_files ../lib/smartFPGA/syn/simple_sync_sig.tcl -of [get_fileset Hash_RR_utils] ] [get_runs impl_Hash_RR]
set_property STEPS.ROUTE_DESIGN.TCL.PRE [ get_files ../lib/axis/syn/sync_reset.tcl -of [get_fileset Hash_RR_utils] ] [get_runs impl_Hash_RR]
set_property STEPS.ROUTE_DESIGN.TCL.PRE [ get_files ../lib/smartFPGA/syn/simple_sync_sig.tcl -of [get_fileset Hash_RR_utils] ] [get_runs impl_Hash_RR]
# set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE SSI_SpreadLogic_high [get_runs impl_Hash_RR]

set_property AUTO_INCREMENTAL_CHECKPOINT 1 [get_runs impl_Hash_RR]

reset_run impl_Hash_RR
launch_runs impl_Hash_RR
wait_on_run impl_Hash_RR

open_run impl_Hash_RR
write_bitstream -no_partial_bitfile -force fpga.runs/impl_Hash_RR/fpga.bit

exit

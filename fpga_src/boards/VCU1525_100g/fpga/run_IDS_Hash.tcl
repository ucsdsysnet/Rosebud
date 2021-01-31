open_project fpga.xpr

update_compile_order -fileset sources_1
set_property needs_refresh false [get_runs synth_1]
set_property needs_refresh false [get_runs impl_1]

if {[llength [get_reconfig_modules Gousheh_IDS]]!=0} then {
  delete_reconfig_modules Gousheh_IDS}
create_reconfig_module -name Gousheh_IDS -partition_def [get_partition_defs pr_riscv] -top Gousheh_PR

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
  ../lib/smartFPGA/rtl/accel_rd_dma_sp.v
  ../accel/full_ids/rtl/sme/tcp_sme.v
  ../accel/full_ids/rtl/sme/udp_sme.v
  ../accel/full_ids/rtl/sme/http_sme.v
  ../accel/full_ids/rtl/fixed_sme/fixed_loc_sme_8.v
  ../accel/full_ids/rtl/ip_match/ip_match.v
  ../accel/full_ids/rtl/accel_wrap_full_ids.v
  ../rtl/Gousheh_PR_w_accel.v
} -of_objects [get_reconfig_modules Gousheh_IDS]
  
if {[llength [get_reconfig_modules scheduler_Hash]]!=0} then {
  delete_reconfig_modules scheduler_Hash}
create_reconfig_module -name scheduler_Hash -partition_def [get_partition_defs pr_scheduler] -top scheduler_PR

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
  ../rtl/Hash_Dropping_scheduler_PR.v
} -of_objects [get_reconfig_modules scheduler_Hash]

if {[llength [get_pr_configurations IDS_Hash_config]]!=0} then {
  delete_pr_configurations IDS_Hash_config}
create_pr_configuration -name IDS_Hash_config -partitions [list \
  core_inst/riscv_cores[0].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[1].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[2].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[3].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[4].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[5].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[6].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[7].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[8].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[9].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[10].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[11].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[12].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[13].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[14].pr_wrapper:Gousheh_IDS \
  core_inst/riscv_cores[15].pr_wrapper:Gousheh_IDS \
  core_inst/scheduler_PR_inst:scheduler_Hash]

if {[llength [get_runs "impl_IDS_Hash"]]!=0} then {delete_run impl_IDS_Hash}
create_run impl_IDS_Hash -parent_run impl_1 -flow {Vivado Implementation 2020} -pr_config IDS_Hash_config
set_property strategy Performance_ExtraTimingOpt [get_runs impl_IDS_Hash]

update_compile_order -fileset scheduler_Hash
update_compile_order -fileset sources_1

reset_run Gousheh_IDS_synth_1
launch_runs Gousheh_IDS_synth_1
wait_on_run Gousheh_IDS_synth_1

reset_run scheduler_Hash_synth_1
launch_runs scheduler_Hash_synth_1
wait_on_run scheduler_Hash_synth_1

create_fileset -quiet IDS_Hash_utils
add_files -fileset IDS_Hash_utils -norecurse ../lib/axis/syn/sync_reset.tcl
add_files -fileset IDS_Hash_utils -norecurse ../lib/smartFPGA/syn/simple_sync_sig.tcl
set_property STEPS.OPT_DESIGN.TCL.PRE [ get_files ../lib/axis/syn/sync_reset.tcl -of [get_fileset IDS_Hash_utils] ] [get_runs impl_IDS_Hash]
set_property STEPS.OPT_DESIGN.TCL.PRE [ get_files ../lib/smartFPGA/syn/simple_sync_sig.tcl -of [get_fileset IDS_Hash_utils] ] [get_runs impl_IDS_Hash]
set_property STEPS.ROUTE_DESIGN.TCL.PRE [ get_files ../lib/axis/syn/sync_reset.tcl -of [get_fileset IDS_Hash_utils] ] [get_runs impl_IDS_Hash]
set_property STEPS.ROUTE_DESIGN.TCL.PRE [ get_files ../lib/smartFPGA/syn/simple_sync_sig.tcl -of [get_fileset IDS_Hash_utils] ] [get_runs impl_IDS_Hash]
# set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE SSI_SpreadLogic_high [get_runs impl_IDS_Hash]

set_property AUTO_INCREMENTAL_CHECKPOINT 1 [get_runs impl_IDS_Hash]

reset_run impl_IDS_Hash
launch_runs impl_IDS_Hash
wait_on_run impl_IDS_Hash

open_run impl_IDS_Hash
write_bitstream -no_partial_bitfile -force fpga.runs/impl_IDS_Hash/fpga.bit

exit

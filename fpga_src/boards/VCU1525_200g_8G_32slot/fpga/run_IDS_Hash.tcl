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
  ../lib/smartFPGA/rtl/Gousheh_controller.v
  ../lib/smartFPGA/rtl/accel_rd_dma_sp.v
  ../accel/full_ids/rtl/sme/tcp_sme.v
  ../accel/full_ids/rtl/sme/udp_sme.v
  ../accel/full_ids/rtl/sme/http_sme.v
  ../accel/full_ids/rtl/fixed_sme/fixed_loc_sme_8.v
  ../accel/full_ids/rtl/ip_match/ip_match.v
  ../accel/full_ids/rtl/accel_wrap_full_ids.v
  ../rtl/Gousheh_PR_w_accel.v
  ../lib/smartFPGA/syn/vivado/simple_sync_sig.tcl
} -of_objects [get_reconfig_modules Gousheh_IDS]

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
  core_inst/scheduler_PR_inst:scheduler_Hash]

if {[llength [get_runs "impl_IDS_Hash"]]!=0} then {delete_run impl_IDS_Hash}
create_run impl_IDS_Hash -parent_run impl_1 -flow {Vivado Implementation 2021} -pr_config IDS_Hash_config
set_property strategy Performance_ExtraTimingOpt [get_runs impl_IDS_Hash]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_IDS_Hash]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_IDS_Hash]
set_property -name {STEPS.OPT_DESIGN.ARGS.MORE OPTIONS} -value {-retarget -propconst -sweep -bufg_opt -shift_register_opt -aggressive_remap} -objects [get_runs impl_IDS_HASH]
# set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_IDS_Hash]
# set_property AUTO_INCREMENTAL_CHECKPOINT 1 [get_runs impl_IDS_Hash]

update_compile_order -fileset Gousheh_IDS
update_compile_order -fileset sources_1

reset_run Gousheh_IDS_synth_1
launch_runs Gousheh_IDS_synth_1
wait_on_run Gousheh_IDS_synth_1

set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_IDS_Hash] impl_IDS_Hash_route_report_drc_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_IDS_Hash] impl_IDS_Hash_route_report_power_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_IDS_Hash] impl_IDS_Hash_opt_report_drc_0]

reset_run impl_IDS_Hash
launch_runs impl_IDS_Hash -jobs 12
wait_on_run impl_IDS_Hash

open_run impl_IDS_Hash
write_bitstream -no_partial_bitfile -force fpga.runs/impl_IDS_Hash/fpga.bit

exit

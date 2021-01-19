open_project fpga.xpr

update_compile_order -fileset sources_1
set_property needs_refresh false [get_runs synth_1]
set_property needs_refresh false [get_runs impl_1]
# set_property needs_refresh false [get_runs impl_2]

if {[llength [get_reconfig_modules riscv_block_PR_w_accel]]==0} then {
  create_reconfig_module -name riscv_block_PR_w_accel -partition_def [get_partition_defs pr_riscv ] -top riscv_block_PR_w_accel}

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
  ../accel/full_ids/rtl/sme/tcp_sme.v
  ../accel/full_ids/rtl/sme/udp_sme.v
  ../accel/full_ids/rtl/sme/http_sme.v
  ../accel/full_ids/rtl/fixed_sme/fixed_loc_sme_8.v
  ../accel/full_ids/rtl/ip_match/ip_match.v
  ../accel/full_ids/rtl/accel_wrap_full_ids.v
  ../rtl/riscv_block_PR_w_accel.v
} -of_objects [get_reconfig_modules riscv_block_PR_w_accel]
  
  # ../accel/hash/rtl/hash_acc.v
  # ../accel/merged/rtl/re_sql.v
  # ../accel/merged/rtl/accel_wrap_merged.v

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

update_compile_order -fileset riscv_block_PR_w_accel
update_compile_order -fileset scheduler_PR
update_compile_order -fileset sources_1

reset_run riscv_block_PR_w_accel_synth_1
launch_runs riscv_block_PR_w_accel_synth_1
wait_on_run riscv_block_PR_w_accel_synth_1

add_files -fileset utils_1 -norecurse ../lib/axis/syn/sync_reset.tcl
add_files -fileset utils_1 -norecurse ../lib/smartFPGA/syn/simple_sync_sig.tcl
set_property STEPS.OPT_DESIGN.TCL.PRE [ get_files ../lib/axis/syn/sync_reset.tcl -of [get_fileset utils_1] ] [get_runs impl_accel]
set_property STEPS.OPT_DESIGN.TCL.PRE [ get_files ../lib/smartFPGA/syn/simple_sync_sig.tcl -of [get_fileset utils_1] ] [get_runs impl_accel]
set_property STEPS.ROUTE_DESIGN.TCL.PRE [ get_files ../lib/axis/syn/sync_reset.tcl -of [get_fileset utils_1] ] [get_runs impl_accel]
set_property STEPS.ROUTE_DESIGN.TCL.PRE [ get_files ../lib/smartFPGA/syn/simple_sync_sig.tcl -of [get_fileset utils_1] ] [get_runs impl_accel]
set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE SSI_SpreadLogic_high [get_runs impl_accel]

reset_run impl_accel
launch_runs impl_accel
wait_on_run impl_accel

open_run impl_accel
report_utilization -force -hierarchical -hierarchical_percentage -file fpga_utilization_hierarchy_placed_accel.rpt
report_utilization -force -pblocks [get_pblocks -regexp {pblock_([2-9]|1[0-6]|1)}] -file fpga_utilization_accel_pblocks.rpt
write_bitstream -no_partial_bitfile -force fpga.runs/impl_accel/fpga.bit

exit

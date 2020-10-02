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

if {[llength [get_reconfig_modules scheduler_PR2]]==0} then {
  create_reconfig_module -name scheduler_PR2 -partition_def [get_partition_defs pr_scheduler]  -top scheduler_PR2}

add_files -norecurse {
  ../lib/eth/lib/axis/rtl/arbiter.v 
  ../lib/eth/lib/axis/rtl/axis_arb_mux.v
  ../lib/eth/lib/axis/rtl/axis_register.v
  ../lib/eth/lib/axis/rtl/axis_pipeline_register.v
  ../lib/eth/lib/axis/rtl/priority_encoder.v
  ../lib/corundum/rtl/rx_hash.v
  ../lib/smartFPGA/rtl/axis_fifo.v
  ../lib/smartFPGA/rtl/simple_arbiter.v
  ../lib/smartFPGA/rtl/simple_fifo.v
  ../lib/smartFPGA/rtl/header.v
  ../lib/smartFPGA/rtl/slot_keeper.v
  ../rtl/Hash_Dropping_scheduler_PR.v
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

update_compile_order -fileset riscv_block_PR_w_accel
update_compile_order -fileset scheduler_PR2
update_compile_order -fileset sources_1

reset_run scheduler_PR2_synth_1
launch_runs scheduler_PR2_synth_1
wait_on_run scheduler_PR2_synth_1

reset_run riscv_block_PR_w_accel_synth_1
launch_runs riscv_block_PR_w_accel_synth_1
wait_on_run riscv_block_PR_w_accel_synth_1

reset_run impl_sched
launch_runs impl_sched
wait_on_run impl_sched

open_run impl_sched
report_utilization -force -hierarchical -hierarchical_percentage -file fpga_utilization_hierarchy_placed_sched.rpt
report_utilization -force -pblocks [get_pblocks -regexp {pblock_([2-9]|1[0-6]|1)}] -file fpga_utilization_sched_pblocks.rpt
write_bitstream -no_partial_bitfile -force fpga.runs/impl_sched/fpga.bit

exit

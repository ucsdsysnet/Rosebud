open_project fpga.xpr
set_property PR_FLOW 1 [current_project]

if {[llength [get_partition_defs  pr_riscv]]==0} then {
  create_partition_def -name pr_riscv -module riscv_block_PR}
if {[llength [get_partition_defs  pr_scheduler]]==0} then {
  create_partition_def -name pr_scheduler -module scheduler_PR}

if {[llength [get_reconfig_modules riscv_block_base]]==0} then {
  create_reconfig_module -name riscv_block_base -partition_def [get_partition_defs pr_riscv]  -define_from riscv_block_PR}
if {[llength [get_reconfig_modules scheduler_RR]]==0} then {
  create_reconfig_module -name scheduler_RR -partition_def [get_partition_defs pr_scheduler] -define_from scheduler_PR}

update_compile_order -fileset scheduler_RR
update_compile_order -fileset riscv_block_base
update_compile_order -fileset sources_1

reset_run synth_1
launch_runs synth_1
wait_on_run synth_1

exit

open_project fpga.xpr
set_property PR_FLOW 1 [current_project]

if {[llength [get_partition_defs  pr_riscv]]==0} then {
  create_partition_def -name pr_riscv -module Gousheh_PR}
if {[llength [get_partition_defs  pr_scheduler]]==0} then {
  create_partition_def -name pr_scheduler -module scheduler_PR}

if {[llength [get_reconfig_modules Gousheh_base]]==0} then {
  create_reconfig_module -name Gousheh_base -partition_def [get_partition_defs pr_riscv]  -define_from Gousheh_PR}
if {[llength [get_reconfig_modules scheduler_Hash]]==0} then {
  create_reconfig_module -name scheduler_Hash -partition_def [get_partition_defs pr_scheduler] -define_from scheduler_PR}

update_compile_order -fileset scheduler_Hash
update_compile_order -fileset Gousheh_base
update_compile_order -fileset sources_1

reset_run synth_1
launch_runs synth_1 -jobs 12
wait_on_run synth_1

exit

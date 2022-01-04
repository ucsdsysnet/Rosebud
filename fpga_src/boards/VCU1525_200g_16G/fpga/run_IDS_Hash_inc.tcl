# Copyright (c) 2019-2021 Moein Khazraee
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

open_project fpga.xpr

update_compile_order -fileset sources_1
set_property needs_refresh false [get_runs synth_1]
set_property needs_refresh false [get_runs impl_1]

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
  ../lib/Shire/rtl/axis_fifo.v
  ../lib/Shire/rtl/simple_arbiter.v
  ../lib/Shire/rtl/simple_fifo.v
  ../lib/Shire/rtl/header.v
  ../lib/Shire/rtl/slot_keeper.v
  ../rtl/Hash_Dropping_scheduler_PR.v
  ../lib/axis/syn/vivado/sync_reset.tcl
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
create_run impl_IDS_Hash -parent_run impl_1 -flow {Vivado Implementation 2021} -pr_config IDS_Hash_config
set_property strategy Performance_ExtraTimingOpt [get_runs impl_IDS_Hash]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_IDS_Hash]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_IDS_Hash]
set_property -name {STEPS.OPT_DESIGN.ARGS.MORE OPTIONS} -value {-retarget -propconst -sweep -bufg_opt -shift_register_opt -aggressive_remap} -objects [get_runs impl_IDS_Hash]
# set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_IDS_Hash]

update_compile_order -fileset scheduler_Hash
update_compile_order -fileset sources_1

reset_run scheduler_Hash_synth_1
launch_runs scheduler_Hash_synth_1 -jobs 12
wait_on_run scheduler_Hash_synth_1


add_files -fileset utils_1 -norecurse fpga.runs/impl_IDS_RR/fpga_postroute_physopt.dcp
set_property incremental_checkpoint fpga.runs/impl_IDS_RR/fpga_postroute_physopt.dcp [get_runs impl_IDS_Hash]
set_property incremental_checkpoint.directive TimingClosure [get_runs impl_IDS_Hash]

set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_IDS_Hash] impl_IDS_Hash_route_report_drc_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_IDS_Hash] impl_IDS_Hash_route_report_power_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_IDS_Hash] impl_IDS_Hash_opt_report_drc_0]

reset_run impl_IDS_Hash
launch_runs impl_IDS_Hash -jobs 12
wait_on_run impl_IDS_Hash

open_run impl_IDS_Hash
write_bitstream -no_partial_bitfile -force fpga.runs/impl_IDS_Hash/fpga.bit

exit

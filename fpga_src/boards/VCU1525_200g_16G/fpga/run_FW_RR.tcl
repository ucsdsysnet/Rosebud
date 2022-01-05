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

if {[llength [get_reconfig_modules Gousheh_FW]]!=0} then {
  delete_reconfig_modules Gousheh_FW}
create_reconfig_module -name Gousheh_FW -partition_def [get_partition_defs pr_riscv] -top Gousheh_PR

add_files -norecurse {
  ../lib/axis/rtl/arbiter.v
  ../lib/axis/rtl/priority_encoder.v
  ../lib/axis/rtl/axis_fifo.v
  ../lib/axis/rtl/axis_register.v
  ../lib/axis/rtl/axis_pipeline_register.v
  ../lib/Shire/rtl/core_mems.v
  ../lib/Shire/rtl/VexRiscv.v
  ../lib/Shire/rtl/simple_sync_sig.v
  ../lib/Shire/rtl/riscvcore.v
  ../lib/Shire/rtl/simple_fifo.v
  ../lib/Shire/rtl/mem_sys.v
  ../lib/Shire/rtl/Gousheh.v
  ../lib/Shire/rtl/Gousheh_controller.v
  ../accel/ip_matcher/rtl/firewall.v
  ../accel/ip_matcher/rtl/accel_wrap_firewall.v
  ../rtl/Gousheh_PR_w_accel.v
  ../lib/Shire/syn/vivado/simple_sync_sig.tcl
} -of_objects [get_reconfig_modules Gousheh_FW]

if {[llength [get_pr_configurations FW_RR_config]]!=0} then {
  delete_pr_configurations FW_RR_config}
create_pr_configuration -name FW_RR_config -partitions [list \
  core_inst/riscv_cores[0].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[1].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[2].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[3].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[4].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[5].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[6].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[7].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[8].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[9].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[10].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[11].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[12].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[13].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[14].pr_wrapper:Gousheh_FW \
  core_inst/riscv_cores[15].pr_wrapper:Gousheh_FW \
  core_inst/scheduler_PR_inst:scheduler_RR]

if {[llength [get_runs "impl_FW_RR"]]!=0} then {delete_run impl_FW_RR}
create_run impl_FW_RR -parent_run impl_1 -flow {Vivado Implementation 2021} -pr_config FW_RR_config
set_property strategy Performance_ExtraTimingOpt [get_runs impl_FW_RR]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_FW_RR]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_FW_RR]
set_property -name {STEPS.OPT_DESIGN.ARGS.MORE OPTIONS} -value {-retarget -propconst -sweep -bufg_opt -shift_register_opt -aggressive_remap} -objects [get_runs impl_FW_RR]
# set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_FW_RR]
set_property AUTO_INCREMENTAL_CHECKPOINT 1 [get_runs impl_FW_RR]

update_compile_order -fileset Gousheh_FW
update_compile_order -fileset sources_1

reset_run Gousheh_FW_synth_1
launch_runs Gousheh_FW_synth_1 -jobs 12
wait_on_run Gousheh_FW_synth_1

set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_FW_RR] impl_FW_RR_route_report_drc_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_FW_RR] impl_FW_RR_route_report_power_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_FW_RR] impl_FW_RR_opt_report_drc_0]

reset_run impl_FW_RR
launch_runs impl_FW_RR -jobs 12
wait_on_run impl_FW_RR

open_run impl_FW_RR
write_bitstream -no_partial_bitfile -force fpga.runs/impl_FW_RR/fpga.bit

exit

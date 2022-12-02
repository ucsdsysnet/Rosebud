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

if {[llength [get_reconfig_modules RPU_Hash]]!=0} then {
  delete_reconfig_modules RPU_Hash}
create_reconfig_module -name RPU_Hash -partition_def [get_partition_defs pr_riscv] -top rpu_PR

add_files -norecurse {
  ../lib/axis/rtl/arbiter.v
  ../lib/axis/rtl/priority_encoder.v
  ../lib/axis/rtl/axis_fifo.v
  ../lib/axis/rtl/axis_register.v
  ../lib/axis/rtl/axis_pipeline_register.v
  ../lib/Shire/rtl/mem_modules.v
  ../lib/Shire/rtl/VexRiscv.v
  ../lib/Shire/rtl/simple_sync_sig.v
  ../lib/Shire/rtl/riscvcore.v
  ../lib/Shire/rtl/simple_fifo.v
  ../lib/Shire/rtl/mem_sys.v
  ../lib/Shire/rtl/rpu.v
  ../lib/Shire/rtl/rpu_controller.v
  ../lib/Shire/rtl/accel_rd_dma_sp.v
  ../accel/merged/rtl/hash_acc.v
  ../accel/merged/rtl/re_sql.v
  ../accel/merged/rtl/accel_wrap_merged.v
  ../rtl/rpu_PR_fw.v
  ../lib/Shire/syn/vivado/simple_sync_sig.tcl
} -of_objects [get_reconfig_modules RPU_Hash]

if {[llength [get_pr_configurations Hash_RR_config]]!=0} then {
  delete_pr_configurations Hash_RR_config}
create_pr_configuration -name Hash_RR_config -partitions [list \
  core_inst/rpus[0].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[1].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[2].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[3].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[4].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[5].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[6].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[7].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[8].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[9].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[10].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[11].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[12].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[13].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[14].rpu_PR_inst:RPU_Hash \
  core_inst/rpus[15].rpu_PR_inst:RPU_Hash \
  core_inst/lb_PR_inst:LB_RR]

if {[llength [get_runs "impl_Hash_RR"]]!=0} then {delete_run impl_Hash_RR}
create_run impl_Hash_RR -parent_run impl_1 -flow {Vivado Implementation 2021} -pr_config Hash_RR_config
set_property strategy Performance_ExtraTimingOpt [get_runs impl_Hash_RR]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_Hash_RR]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_Hash_RR]
set_property -name {STEPS.OPT_DESIGN.ARGS.MORE OPTIONS} -value {-retarget -propconst -sweep -bufg_opt -shift_register_opt -aggressive_remap} -objects [get_runs impl_Hash_RR]
# set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_Hash_RR]
set_property AUTO_INCREMENTAL_CHECKPOINT 1 [get_runs impl_Hash_RR]

update_compile_order -fileset RPU_Hash
update_compile_order -fileset sources_1

reset_run RPU_Hash_synth_1
launch_runs RPU_Hash_synth_1 -jobs 12
wait_on_run RPU_Hash_synth_1

set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_Hash_RR] impl_Hash_RR_route_report_drc_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_Hash_RR] impl_Hash_RR_route_report_power_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_Hash_RR] impl_Hash_RR_opt_report_drc_0]

reset_run impl_Hash_RR
launch_runs impl_Hash_RR -jobs 12
wait_on_run impl_Hash_RR

open_run impl_Hash_RR
write_bitstream -no_partial_bitfile -force fpga.runs/impl_Hash_RR/fpga.bit

exit

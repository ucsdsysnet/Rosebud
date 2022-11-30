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

if {[llength [get_reconfig_modules RPU_PIG]]!=0} then {
  delete_reconfig_modules RPU_PIG}
create_reconfig_module -name RPU_PIG -partition_def [get_partition_defs pr_riscv] -top rpu_PR

add_files -norecurse {
  ../lib/axis/rtl/arbiter.v
  ../lib/axis/rtl/priority_encoder.v
  ../lib/axis/rtl/axis_register.v
  ../lib/axis/rtl/axis_pipeline_register.v
  ../lib/axis/rtl/axis_fifo.v
  ../lib/Shire/rtl/core_mems.v
  ../lib/Shire/rtl/VexRiscv.v
  ../lib/Shire/rtl/simple_sync_sig.v
  ../lib/Shire/rtl/riscvcore.v
  ../lib/Shire/rtl/simple_fifo.v
  ../lib/Shire/rtl/mem_sys.v
  ../lib/Shire/rtl/rpu.v
  ../lib/Shire/rtl/rpu_controller.v
  ../lib/Shire/rtl/single_accel_rd_dma.v
  ../accel/pigasus_sme/rtl/backend.sv
  ../accel/pigasus_sme/rtl/first_filter.sv
  ../accel/pigasus_sme/rtl/frontend.sv
  ../accel/pigasus_sme/rtl/hashtable.sv
  ../accel/pigasus_sme/rtl/hashtable_top.sv
  ../accel/pigasus_sme/rtl/ips.sv
  ../accel/pigasus_sme/rtl/mul_hash.sv
  ../accel/pigasus_sme/rtl/acc_hash.sv
  ../accel/pigasus_sme/rtl/rr_arbiter.sv
  ../accel/pigasus_sme/rtl/rr_arbiter_4.sv
  ../accel/pigasus_sme/rtl/hyper_pipe.sv
  ../accel/pigasus_sme/rtl/hyper_pipe_rst.sv
  ../accel/pigasus_sme/rtl/string_matcher.sv
  ../accel/pigasus_sme/rtl/port_unit.sv
  ../accel/pigasus_sme/rtl/rule_unit.sv
  ../accel/pigasus_sme/rtl/port_group.sv
  ../accel/pigasus_sme/rtl/pkt_almost_full.sv
  ../accel/pigasus_sme/rtl/reduction_2t1.sv
  ../accel/pigasus_sme/rtl/unified_fifo.sv
  ../accel/pigasus_sme/rtl/unified_pkt_fifo.sv
  ../accel/pigasus_sme/rtl/rule_depacker_64_32.sv
  ../accel/pigasus_sme/rtl/rule_depacker_128_64.sv
  ../accel/pigasus_sme/rtl/struct_s.sv
  ../accel/pigasus_sme/rtl/SME_wrapper.sv
  ../accel/pigasus_sme/rtl/accel_wrap_pigasus.v
  ../accel/pigasus_sme/rtl/ip_match.v
  ../rtl/rpu_PR_pig.v
  ../lib/Shire/syn/vivado/simple_sync_sig.tcl
} -of_objects [get_reconfig_modules RPU_PIG]

if {[llength [get_pr_configurations PIG_HASH_config]]!=0} then {
  delete_pr_configurations PIG_HASH_config}
create_pr_configuration -name PIG_HASH_config -partitions [list \
  core_inst/rpus[0].rpu_PR_inst:RPU_PIG \
  core_inst/rpus[1].rpu_PR_inst:RPU_PIG \
  core_inst/rpus[2].rpu_PR_inst:RPU_PIG \
  core_inst/rpus[3].rpu_PR_inst:RPU_PIG \
  core_inst/rpus[4].rpu_PR_inst:RPU_PIG \
  core_inst/rpus[5].rpu_PR_inst:RPU_PIG \
  core_inst/rpus[6].rpu_PR_inst:RPU_PIG \
  core_inst/rpus[7].rpu_PR_inst:RPU_PIG \
  core_inst/lb_PR_inst:LB_Hash]

if {[llength [get_runs "impl_PIG_HASH"]]!=0} then {delete_run impl_PIG_HASH}
create_run impl_PIG_HASH -parent_run impl_1 -flow {Vivado Implementation 2021} -pr_config PIG_HASH_config
set_property strategy Performance_ExtraTimingOpt [get_runs impl_PIG_HASH]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_PIG_HASH]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_PIG_HASH]
set_property -name {STEPS.OPT_DESIGN.ARGS.MORE OPTIONS} -value {-retarget -propconst -sweep -bufg_opt -shift_register_opt} -objects [get_runs impl_PIG_HASH]
set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_PIG_HASH]
set_property AUTO_INCREMENTAL_CHECKPOINT 1 [get_runs impl_PIG_HASH]

update_compile_order -fileset RPU_PIG
update_compile_order -fileset sources_1

reset_run RPU_PIG_synth_1
launch_runs RPU_PIG_synth_1 -jobs 12
wait_on_run RPU_PIG_synth_1

set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_PIG_HASH] impl_PIG_HASH_route_report_drc_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_PIG_HASH] impl_PIG_HASH_route_report_power_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_PIG_HASH] impl_PIG_HASH_opt_report_drc_0]

reset_run impl_PIG_HASH
launch_runs impl_PIG_HASH -jobs 12
wait_on_run impl_PIG_HASH

open_run impl_PIG_HASH
write_bitstream -no_partial_bitfile -force fpga.runs/impl_PIG_HASH/fpga.bit

exit

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
set_property AUTO_INCREMENTAL_CHECKPOINT 1 [get_runs impl_1]
set_property PR_FLOW 1 [current_project]

if {[llength [get_pr_configurations config_1]]==0} then {
  create_pr_configuration -name config_1 -partitions [list \
  core_inst/rpus[0].rpu_PR_inst:RPU_base \
  core_inst/rpus[1].rpu_PR_inst:RPU_base \
  core_inst/rpus[2].rpu_PR_inst:RPU_base \
  core_inst/rpus[3].rpu_PR_inst:RPU_base \
  core_inst/rpus[4].rpu_PR_inst:RPU_base \
  core_inst/rpus[5].rpu_PR_inst:RPU_base \
  core_inst/rpus[6].rpu_PR_inst:RPU_base \
  core_inst/rpus[7].rpu_PR_inst:RPU_base \
  core_inst/lb_PR_inst:LB_Hash]}

set_property PR_CONFIGURATION config_1 [get_runs impl_1]
set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]
set_property -name {STEPS.OPT_DESIGN.ARGS.MORE OPTIONS} -value {-retarget -propconst -sweep -bufg_opt -shift_register_opt -aggressive_remap} -objects [get_runs impl_1]
set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE SSI_SpreadSLLs [get_runs impl_1]
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
# set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE AggressiveExplore [get_runs impl_1]

add_files -fileset utils_1 -norecurse hints.tcl
set_property STEPS.OPT_DESIGN.TCL.PRE [get_files hints.tcl -of [get_fileset utils_1]] [get_runs impl_1]

# set_property -name {STEPS.PLACE_DESIGN.ARGS.MORE OPTIONS} -value -verbose -objects [get_runs impl_1]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_1] impl_1_route_report_drc_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_1] impl_1_route_report_power_0]
set_property IS_ENABLED false [get_report_config -of_object [get_runs impl_1] impl_1_opt_report_drc_0]

reset_run impl_1
launch_runs impl_1 -jobs 12
wait_on_run impl_1

exit

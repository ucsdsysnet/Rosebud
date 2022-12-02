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
set_property PR_FLOW 1 [current_project]

if {[llength [get_partition_defs  pr_riscv]]==0} then {
  create_partition_def -name pr_riscv -module rpu_PR}
if {[llength [get_partition_defs  pr_load_balancer]]==0} then {
  create_partition_def -name pr_load_balancer -module lb_PR}

if {[llength [get_reconfig_modules RPU_base]]==0} then {
  create_reconfig_module -name RPU_base -partition_def [get_partition_defs pr_riscv]  -define_from rpu_PR}
if {[llength [get_reconfig_modules LB_Hash]]==0} then {
  create_reconfig_module -name LB_Hash -partition_def [get_partition_defs pr_load_balancer] -define_from lb_PR}

update_compile_order -fileset LB_Hash
update_compile_order -fileset RPU_base
update_compile_order -fileset sources_1

reset_run synth_1
launch_runs synth_1 -jobs 12
wait_on_run synth_1

exit

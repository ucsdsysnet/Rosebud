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

create_project -in_memory -part xcvu9p-fsgd2104-2L-e

exec sh -c "mkdir -p fpga.runs/impl_PIG_RR"

add_files -quiet fpga.runs/impl_1/fpga_postroute_physopt_bb.dcp

add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_0_.pr_wrapper_Gousheh_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_1_.pr_wrapper_Gousheh_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_2_.pr_wrapper_Gousheh_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_3_.pr_wrapper_Gousheh_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_4_.pr_wrapper_Gousheh_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_5_.pr_wrapper_Gousheh_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_6_.pr_wrapper_Gousheh_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_7_.pr_wrapper_Gousheh_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_base_RR/core_inst_scheduler_PR_inst_scheduler_RR_post_routed.dcp

set_property SCOPED_TO_CELLS {core_inst/riscv_cores[0].pr_wrapper} [get_files fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_0_.pr_wrapper_Gousheh_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS {core_inst/riscv_cores[1].pr_wrapper} [get_files fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_1_.pr_wrapper_Gousheh_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS {core_inst/riscv_cores[2].pr_wrapper} [get_files fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_2_.pr_wrapper_Gousheh_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS {core_inst/riscv_cores[3].pr_wrapper} [get_files fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_3_.pr_wrapper_Gousheh_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS {core_inst/riscv_cores[4].pr_wrapper} [get_files fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_4_.pr_wrapper_Gousheh_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS {core_inst/riscv_cores[5].pr_wrapper} [get_files fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_5_.pr_wrapper_Gousheh_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS {core_inst/riscv_cores[6].pr_wrapper} [get_files fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_6_.pr_wrapper_Gousheh_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS {core_inst/riscv_cores[7].pr_wrapper} [get_files fpga.runs/impl_PIG_HASH/core_inst_riscv_cores_7_.pr_wrapper_Gousheh_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS core_inst/scheduler_PR_inst [get_files fpga.runs/impl_base_RR/core_inst_scheduler_PR_inst_scheduler_RR_post_routed.dcp]
  
link_design -mode default -top fpga -part xcvu9p-fsgd2104-2L-e -reconfig_partitions {{core_inst/riscv_cores[0].pr_wrapper} {core_inst/riscv_cores[1].pr_wrapper} {core_inst/riscv_cores[2].pr_wrapper} {core_inst/riscv_cores[3].pr_wrapper} {core_inst/riscv_cores[4].pr_wrapper} {core_inst/riscv_cores[5].pr_wrapper} {core_inst/riscv_cores[6].pr_wrapper} {core_inst/riscv_cores[7].pr_wrapper} core_inst/scheduler_PR_inst}

write_bitstream -no_partial_bitfile -force fpga.runs/impl_PIG_RR/fpga.bit

exit

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

add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_rpus_0_.rpu_PR_inst_RPU_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_rpus_1_.rpu_PR_inst_RPU_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_rpus_2_.rpu_PR_inst_RPU_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_rpus_3_.rpu_PR_inst_RPU_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_rpus_4_.rpu_PR_inst_RPU_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_rpus_5_.rpu_PR_inst_RPU_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_rpus_6_.rpu_PR_inst_RPU_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_PIG_HASH/core_inst_rpus_7_.rpu_PR_inst_RPU_PIG_post_routed.dcp
add_files -quiet fpga.runs/impl_base_RR/core_inst_lb_PR_inst_LB_RR_post_routed.dcp

set_property SCOPED_TO_CELLS {core_inst/rpus[0].rpu_PR_inst} [get_files fpga.runs/impl_PIG_HASH/core_inst_rpus_0_.rpu_PR_inst_RPU_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS {core_inst/rpus[1].rpu_PR_inst} [get_files fpga.runs/impl_PIG_HASH/core_inst_rpus_1_.rpu_PR_inst_RPU_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS {core_inst/rpus[2].rpu_PR_inst} [get_files fpga.runs/impl_PIG_HASH/core_inst_rpus_2_.rpu_PR_inst_RPU_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS {core_inst/rpus[3].rpu_PR_inst} [get_files fpga.runs/impl_PIG_HASH/core_inst_rpus_3_.rpu_PR_inst_RPU_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS {core_inst/rpus[4].rpu_PR_inst} [get_files fpga.runs/impl_PIG_HASH/core_inst_rpus_4_.rpu_PR_inst_RPU_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS {core_inst/rpus[5].rpu_PR_inst} [get_files fpga.runs/impl_PIG_HASH/core_inst_rpus_5_.rpu_PR_inst_RPU_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS {core_inst/rpus[6].rpu_PR_inst} [get_files fpga.runs/impl_PIG_HASH/core_inst_rpus_6_.rpu_PR_inst_RPU_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS {core_inst/rpus[7].rpu_PR_inst} [get_files fpga.runs/impl_PIG_HASH/core_inst_rpus_7_.rpu_PR_inst_RPU_PIG_post_routed.dcp]
set_property SCOPED_TO_CELLS core_inst/lb_PR_inst [get_files fpga.runs/impl_base_RR/core_inst_lb_PR_inst_LB_RR_post_routed.dcp]
  
link_design -mode default -top fpga -part xcvu9p-fsgd2104-2L-e -reconfig_partitions {{core_inst/rpus[0].rpu_PR_inst} {core_inst/rpus[1].rpu_PR_inst} {core_inst/rpus[2].rpu_PR_inst} {core_inst/rpus[3].rpu_PR_inst} {core_inst/rpus[4].rpu_PR_inst} {core_inst/rpus[5].rpu_PR_inst} {core_inst/rpus[6].rpu_PR_inst} {core_inst/rpus[7].rpu_PR_inst} core_inst/lb_PR_inst}

write_bitstream -no_partial_bitfile -force fpga.runs/impl_PIG_RR/fpga.bit

exit

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

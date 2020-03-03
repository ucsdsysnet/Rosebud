open_project fpga.xpr

update_compile_order -fileset sources_1
set_property needs_refresh false [get_runs synth_1]
set_property needs_refresh false [get_runs impl_1]
# set_property needs_refresh false [get_runs impl_2]

if {[llength [get_reconfig_modules riscv_block_PR_RegEx]]==0} then {create_reconfig_module -name riscv_block_PR_RegEx -partition_def [get_partition_defs pr_riscv ] -top riscv_block_PR_RegEx}

add_files -norecurse /home/moein/BumpinTheWire/fpga_src/lib/eth/lib/axis/rtl/axis_async_fifo.v /home/moein/BumpinTheWire/fpga_src/lib/smartFPGA/rtl/core_mems.v /home/moein/BumpinTheWire/fpga_src/lib/eth/lib/axis/rtl/axis_fifo.v /home/moein/BumpinTheWire/fpga_src/lib/smartFPGA/rtl/VexRiscv.v /home/moein/BumpinTheWire/fpga_src/accel/regex/rtl/regex_acc.v /home/moein/BumpinTheWire/fpga_src/lib/eth/lib/axis/rtl/axis_register.v /home/moein/BumpinTheWire/fpga_src/accel/regex/rtl/re_sql.v /home/moein/BumpinTheWire/fpga_src/lib/eth/lib/axis/rtl/axis_pipeline_register.v /home/moein/BumpinTheWire/fpga_src/boards/VCU1525_100g/rtl/riscv_block_PR_RegEx.v /home/moein/BumpinTheWire/fpga_src/lib/smartFPGA/rtl/simple_sync_sig.v /home/moein/BumpinTheWire/fpga_src/accel/regex/rtl/accel_wrap_regex_multi.v /home/moein/BumpinTheWire/fpga_src/lib/smartFPGA/rtl/riscvcore.v /home/moein/BumpinTheWire/fpga_src/lib/smartFPGA/rtl/simple_fifo.v /home/moein/BumpinTheWire/fpga_src/accel/regex/rtl/re_hw.v /home/moein/BumpinTheWire/fpga_src/lib/smartFPGA/rtl/mem_sys.v /home/moein/BumpinTheWire/fpga_src/lib/smartFPGA/rtl/riscv_block.v  -of_objects [get_reconfig_modules riscv_block_PR_RegEx]

if {[llength [get_pr_configurations  "RegEx_config"]]==0} then {create_pr_configuration -name RegEx_config -partitions [list core_inst/riscv_cores[0].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[1].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[2].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[3].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[4].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[5].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[6].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[7].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[8].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[9].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[10].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[11].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[12].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[13].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[14].pr_wrapper:riscv_block_PR_RegEx core_inst/riscv_cores[15].pr_wrapper:riscv_block_PR_RegEx ]}

if {[llength [get_runs "impl_RegEx"]]==0} then {create_run impl_RegEx -parent_run impl_1 -flow {Vivado Implementation 2019} -pr_config RegEx_config}
set_property strategy Performance_ExtraTimingOpt [get_runs impl_RegEx]

update_compile_order -fileset riscv_block_PR_RegEx
update_compile_order -fileset sources_1
reset_run riscv_block_PR_RegEx_synth_1
launch_runs riscv_block_PR_RegEx_synth_1
wait_on_run riscv_block_PR_RegEx_synth_1

reset_run impl_RegEx
launch_runs impl_RegEx
wait_on_run impl_RegEx

open_run impl_RegEx
report_utilization -force -hierarchical -hierarchical_percentage -file fpga_utilization_hierarchy_placed_full.rpt
report_utilization -force -pblocks [get_pblocks -regexp {pblock_([2-9]|1[0-6]|1)}] -file fpga_utilization_pblocks.rpt
write_bitstream -force fpga.runs/impl_RegEx/fpga.bit

exit

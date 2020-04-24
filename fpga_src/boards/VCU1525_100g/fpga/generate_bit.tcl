open_project fpga.xpr
open_run impl_1
write_debug_probes -force debug_probes.ltx
report_utilization -force -hierarchical -hierarchical_percentage -file fpga_utilization_hierarchy_placed_raw.rpt
report_utilization -force -pblocks [get_pblocks -regexp {pblock_([2-9]|1[0-6]|1)}] -file fpga_utilization_raw.rpt
write_bitstream -force fpga.runs/impl_1/fpga.bit
exit

open_project fpga.xpr
open_run impl_1
report_utilization -force -hierarchical -hierarchical_percentage -file fpga_utilization_hierarchy_placed_full_no_accel.rpt
report_utilization -force -pblocks [get_pblocks -regexp {pblock_([2-9]|1[0-6]|1)}] -file fpga_utilization_pblocks_no_accel.rpt
exit

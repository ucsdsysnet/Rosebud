open_project fpga.xpr
open_run impl_IDS_RR
report_utilization -force -hierarchical -hierarchical_percentage -file fpga_utilization_hierarchy_placed_IDS_RR.rpt
report_utilization -force -pblocks [get_pblocks -regexp {Gousheh_([2-9]|1[0-6]|1)}] -file fpga_utilization_gousheh_IDS_RR.rpt
report_utilization -force -pblocks [get_pblocks User_Scheduler] -file fpga_utilization_scheduler_IDS_RR.rpt
exit

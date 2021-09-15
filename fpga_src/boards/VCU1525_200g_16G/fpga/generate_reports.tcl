open_project fpga.xpr
open_run impl_FW_RR
report_utilization -force -hierarchical -hierarchical_percentage -file fpga_utilization_hierarchy_placed_FW_RR.rpt
# report_utilization -force -pblocks [get_pblocks -regexp {Gousheh_([2-9]|1[0-6]|1)}] -file fpga_utilization_Gousheh_FW_RR.rpt
foreach Gousheh [get_pblocks -regexp {Gousheh_([2-9]|1[0-6]|1)}] {
    report_utilization -force -pblocks $Gousheh -file fpga_utilization_${Gousheh}_FW_RR.rpt
}
report_utilization -force -pblocks [get_pblocks User_Scheduler] -file fpga_utilization_scheduler_FW_RR.rpt
exit

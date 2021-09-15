open_project fpga.xpr
open_run impl_PIG_HASH
report_utilization -force -hierarchical -hierarchical_percentage -file fpga_utilization_hierarchy_placed_PIG_HASH.rpt
# report_utilization -force -pblocks [get_pblocks -regexp {Gousheh_([1-8])}] -file fpga_utilization_Gousheh_IDS_RR.rpt
foreach Gousheh [get_pblocks -regexp {Gousheh_([1-8])}] {
    report_utilization -force -pblocks $Gousheh -file fpga_utilization_${Gousheh}_PIG_HASH.rpt
}
report_utilization -force -pblocks [get_pblocks User_Scheduler] -file fpga_utilization_scheduler_PIG_HASH.rpt
exit

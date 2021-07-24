open_project fpga.xpr
open_run impl_1
# write_debug_probes -force debug_probes.ltx

report_utilization -force -hierarchical -hierarchical_percentage -file fpga_utilization_hierarchy_placed_raw.rpt
# report_utilization -force -pblocks [get_pblocks -regexp {Gousheh_([2-9]|1[0-6]|1)}] -file fpga_utilization_gousheh_raw.rpt
foreach Gousheh [get_pblocks -regexp {Gousheh_([2-9]|1[0-6]|1)}] {
    report_utilization -force -pblocks $Gousheh -file fpga_utilization_${Gousheh}_raw.rpt
}
report_utilization -force -pblocks [get_pblocks User_Scheduler] -file fpga_utilization_scheduler_raw.rpt

write_bitstream -no_partial_bitfile -force fpga.runs/impl_1/fpga.bit
exit

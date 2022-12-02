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

open_project fpga.xpr
open_run impl_1
# write_debug_probes -force debug_probes.ltx

report_utilization -force -hierarchical -hierarchical_percentage -file fpga_utilization_hierarchy_placed_raw.rpt
# report_utilization -force -pblocks [get_pblocks -regexp {RPU_([1-8])}] -file fpga_utilization_RPU_raw.rpt
foreach RPU [get_pblocks -regexp {RPU_([1-8])}] {
    report_utilization -force -pblocks $RPU -file fpga_utilization_${RPU}_raw.rpt
}
report_utilization -force -pblocks [get_pblocks User_LB] -file fpga_utilization_lb_raw.rpt

write_bitstream -no_partial_bitfile -force fpga.runs/impl_1/fpga.bit
exit

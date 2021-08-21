############################################################
## This file is generated automatically by Vitis HLS.
## Please DO NOT edit it.
## Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
############################################################
open_project -reset port_group_tcl

set_top port_group
add_files port_group.cc

open_solution -reset "solution1" -flow_target vivado
set_part {xcvu9p-fsgd2104-2L-e}
create_clock -period 4 -name default
set_directive_top -name port_group "port_group"

csynth_design
export_design -format ip_catalog

exit

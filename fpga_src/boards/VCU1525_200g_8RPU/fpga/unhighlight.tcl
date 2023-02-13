# Coloring of different components

unhighlight_objects -leaf_cells [get_cells *]

# Net coloring
unhighlight_objects [get_nets [list {core_inst/ctrl_in_sw/ctrl_s_axis_tdata[*]} {core_inst/ctrl_in_sw/dout_reg_reg[35][*]}]]

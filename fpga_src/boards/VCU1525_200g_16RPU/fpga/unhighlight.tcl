# Coloring of different components

unhighlight_objects -leaf_cells [get_cells *]

# Net coloring
unhighlight_objects [get_nets core_inst/ctrl_in_sw/ctrl_s_axis_tdata[*]]

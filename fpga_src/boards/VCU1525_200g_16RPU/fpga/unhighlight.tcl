# Coloring of different components

# Leaf cell coloring
unhighlight_objects -leaf_cells [get_cells core_inst/rpus[*].rpu_intercon_inst]
unhighlight_objects -leaf_cells [get_cells core_inst/lb_PR_inst]
unhighlight_objects -leaf_cells [get_cells [list {core_inst/MAC_async_FIFO[*].*} {qsfp*}]]
unhighlight_objects -leaf_cells [get_cells [list {core_inst/pcie*} {pcie*}]]

# Net coloring
unhighlight_objects [get_nets [list {core_inst/ctrl_in_sw/ctrl_s_axis_tdata[*]} {core_inst/ctrl_in_sw/dout_reg_reg[35][*]}]]

# unhighlight_objects [get_nets -regexp {core_inst/data_out_sw/shrink.axis_switch_2lvl_shrink_inst/input_registers\[.*\].input_register/dout\[[0-9]\]}]
# unhighlight_objects [get_nets -regexp {core_inst/data_out_sw/shrink.axis_switch_2lvl_shrink_inst/input_registers\[.*\].input_register/dout\[1[0-9]\]}]
# unhighlight_objects [get_nets -regexp {core_inst/data_out_sw/shrink.axis_switch_2lvl_shrink_inst/input_registers\[.*\].input_register/sll_data_reg\[153\]\[[0-9]\]}]
# unhighlight_objects [get_nets -regexp {core_inst/data_out_sw/shrink.axis_switch_2lvl_shrink_inst/input_registers\[.*\].input_register/sll_data_reg\[153\]\[1[0-9]\]}]

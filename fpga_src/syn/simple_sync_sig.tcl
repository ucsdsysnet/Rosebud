foreach sync_inst [get_cells -hier -filter {(ORIG_REF_NAME == simple_sync_sig || REF_NAME == simple_sync_sig)}] {
    puts "Inserting timing constraints for simple_sync_sig instance $sync_inst"

    set_false_path -to [get_cells $sync_inst/sync_reg_reg[0]]
}


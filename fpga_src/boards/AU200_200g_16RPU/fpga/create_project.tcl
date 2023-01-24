create_project -force -part xcu200-fsgd2104-2-e fpga

add_files -fileset sources_1 -norecurse {
  ../rtl/fpga.v
  ../rtl/fpga_core.v
  ../rtl/rpu_PR.v
  ../rtl/lb_rr_lu_PR.v
  ../rtl/pcie_config.v
  ../rtl/debounce_switch.v
  ../rtl/sync_signal.v

  ../lib/Rosebud/rtl/riscvcore.v
  ../lib/Rosebud/rtl/rpu.v
  ../lib/Rosebud/rtl/accel_wrap.v
  ../lib/Rosebud/rtl/VexRiscv.v
  ../lib/Rosebud/rtl/mem_modules.v
  ../lib/Rosebud/rtl/axis_register.v
  ../lib/Rosebud/rtl/slot_keeper.v
  ../lib/Rosebud/rtl/lb_controller.v
  ../lib/Rosebud/rtl/lb_rr_lu.v
  ../lib/Rosebud/rtl/max_finder_tree.v
  ../lib/Rosebud/rtl/basic_fifo.v
  ../lib/Rosebud/rtl/simple_arbiter.v
  ../lib/Rosebud/rtl/axis_dma.v
  ../lib/Rosebud/rtl/axis_stat.v
  ../lib/Rosebud/rtl/stat_reader.v
  ../lib/Rosebud/rtl/mem_sys.v
  ../lib/Rosebud/rtl/rpu_controller.v
  ../lib/Rosebud/rtl/rpu_intercon.v
  ../lib/Rosebud/rtl/pipe_reg.v
  ../lib/Rosebud/rtl/simple_sync_sig.v
  ../lib/Rosebud/rtl/simple_axis_switch.v
  ../lib/Rosebud/rtl/axis_ram_switch.v
  ../lib/Rosebud/rtl/axis_slr_register.v
  ../lib/Rosebud/rtl/axis_switch_2lvl.v
  ../lib/Rosebud/rtl/loopback_msg_fifo.v
  ../lib/Rosebud/rtl/bc_msg_merger.v
  ../lib/Rosebud/rtl/cmd_stat_sys.v
  ../lib/Rosebud/rtl/header.v
  ../lib/Rosebud/rtl/pcie_controller.v
  ../lib/Rosebud/rtl/pcie_cont_read.v
  ../lib/Rosebud/rtl/pcie_cont_write.v
  ../lib/Rosebud/rtl/corundum.v
  ../lib/Rosebud/rtl/axis_fifo_w_count.v
  ../lib/Rosebud/rtl/axis_stopper.v
  ../lib/Rosebud/rtl/axis_dropper.v

  ../lib/axis/rtl/axis_arb_mux.v
  ../lib/axis/rtl/sync_reset.v
  ../lib/axis/rtl/axis_fifo.v
  ../lib/axis/rtl/axis_fifo_adapter.v
  ../lib/axis/rtl/axis_pipeline_register.v
  ../lib/axis/rtl/arbiter.v
  ../lib/axis/rtl/priority_encoder.v
  ../lib/axis/rtl/axis_async_fifo.v
  ../lib/axis/rtl/axis_async_fifo_adapter.v
  ../lib/axis/rtl/axis_adapter.v
  ../lib/axi/rtl/axil_interconnect.v

  ../lib/pcie/rtl/pcie_us_axil_master.v
  ../lib/pcie/rtl/dma_client_axis_sink.v
  ../lib/pcie/rtl/dma_client_axis_source.v
  ../lib/pcie/rtl/dma_if_pcie_us.v
  ../lib/pcie/rtl/dma_if_pcie_us_rd.v
  ../lib/pcie/rtl/dma_if_pcie_us_wr.v
  ../lib/pcie/rtl/dma_if_desc_mux.v
  ../lib/pcie/rtl/dma_ram_demux_wr.v
  ../lib/pcie/rtl/dma_ram_demux_rd.v
  ../lib/pcie/rtl/dma_if_mux.v
  ../lib/pcie/rtl/dma_if_mux_rd.v
  ../lib/pcie/rtl/dma_if_mux_wr.v
  ../lib/pcie/rtl/dma_psdpram.v
  ../lib/pcie/rtl/pcie_us_cfg.v
  ../lib/pcie/rtl/pcie_us_msi.v
  ../lib/pcie/rtl/pulse_merge.v

  ../lib/corundum/rtl/mqnic_interface.v
  ../lib/corundum/rtl/cmac_pad.v
  ../lib/corundum/rtl/mqnic_port.v
  ../lib/corundum/rtl/cpl_write.v
  ../lib/corundum/rtl/cpl_op_mux.v
  ../lib/corundum/rtl/desc_fetch.v
  ../lib/corundum/rtl/desc_op_mux.v
  ../lib/corundum/rtl/queue_manager.v
  ../lib/corundum/rtl/cpl_queue_manager.v
  ../lib/corundum/rtl/tx_engine.v
  ../lib/corundum/rtl/rx_engine.v
  ../lib/corundum/rtl/tx_checksum.v
  ../lib/corundum/rtl/rx_checksum.v
  ../lib/corundum/rtl/rx_hash.v
  ../lib/corundum/rtl/tx_scheduler_rr.v
  ../lib/corundum/rtl/tdma_scheduler.v
  ../lib/corundum/rtl/event_mux.v
}

set_property include_dirs  "../lib/Rosebud/rtl" [current_fileset]

add_files -fileset constrs_1 {
	../fpga.xdc
	../lib/axis/syn/vivado/axis_async_fifo.tcl
	../lib/axis/syn/vivado/sync_reset.tcl
	../lib/Rosebud/syn/vivado/simple_sync_sig.tcl
}

source ../ip/pcie4_uscale_plus_0.tcl
source ../ip/cmac_usplus_0.tcl
source ../ip/cmac_usplus_1.tcl

# unused license critical warning
set_msg_config -id {Vivado 12-1790} -new_severity {INFO}
# Design linking license warning
set_msg_config -id {IP_Flow 19-650} -new_severity {INFO}
# PARTPIN warning for constant nets
set_msg_config -id {Vivado 12-4385} -new_severity {INFO}
# Local parameter warning
set_msg_config -id {Synth 8-2507} -new_severity {INFO}
# Zero replication warning
set_msg_config -id {Synth 8-693} -new_severity {INFO}

exit

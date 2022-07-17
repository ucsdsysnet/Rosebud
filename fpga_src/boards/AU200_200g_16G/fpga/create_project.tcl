create_project -force -part xcu200-fsgd2104-2-e fpga

add_files -fileset sources_1 -norecurse {
  ../rtl/fpga.v
  ../rtl/fpga_core.v
  ../rtl/Gousheh_PR.v
  ../rtl/RR_LU_scheduler_PR.v
  ../rtl/pcie_config.v
  ../rtl/debounce_switch.v
  ../rtl/sync_signal.v

  ../lib/Shire/rtl/riscvcore.v
  ../lib/Shire/rtl/Gousheh.v
  ../lib/Shire/rtl/accel_wrap.v
  ../lib/Shire/rtl/VexRiscv.v
  ../lib/Shire/rtl/core_mems.v
  ../lib/Shire/rtl/slot_keeper.v
  ../lib/Shire/rtl/max_finder_tree.v
  ../lib/Shire/rtl/simple_fifo.v
  ../lib/Shire/rtl/simple_arbiter.v
  ../lib/Shire/rtl/axis_dma.v
  ../lib/Shire/rtl/axis_stat.v
  ../lib/Shire/rtl/stat_reader.v
  ../lib/Shire/rtl/mem_sys.v
  ../lib/Shire/rtl/Gousheh_controller.v
  ../lib/Shire/rtl/Gousheh_wrapper.v
  ../lib/Shire/rtl/pipe_reg.v
  ../lib/Shire/rtl/simple_sync_sig.v
  ../lib/Shire/rtl/simple_axis_switch.v
  ../lib/Shire/rtl/axis_ram_switch.v
  ../lib/Shire/rtl/axis_slr_register.v
  ../lib/Shire/rtl/axis_switch_2lvl.v
  ../lib/Shire/rtl/loopback_msg_fifo.v
  ../lib/Shire/rtl/header.v
  ../lib/Shire/rtl/pcie_controller.v
  ../lib/Shire/rtl/pcie_cont_read.v
  ../lib/Shire/rtl/pcie_cont_write.v
  ../lib/Shire/rtl/corundum.v
  ../lib/Shire/rtl/axis_fifo_w_count.v
  ../lib/Shire/rtl/axis_stopper.v
  ../lib/Shire/rtl/axis_dropper.v

  ../lib/axis/rtl/axis_arb_mux.v
  ../lib/axis/rtl/sync_reset.v
  ../lib/axis/rtl/axis_fifo.v
  ../lib/axis/rtl/axis_fifo_adapter.v
  ../lib/axis/rtl/axis_register.v
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

add_files -fileset constrs_1 {
	../fpga.xdc
	../lib/axis/syn/vivado/axis_async_fifo.tcl
	../lib/axis/syn/vivado/sync_reset.tcl
	../lib/Shire/syn/vivado/simple_sync_sig.tcl
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

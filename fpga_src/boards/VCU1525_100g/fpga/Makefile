
# FPGA settings
FPGA_PART = xcvu9p-fsgd2104-2L-e
FPGA_TOP = fpga
FPGA_ARCH = virtexuplus

# Files for synthesis
SYN_FILES  = rtl/fpga.v
SYN_FILES += rtl/fpga_core.v
SYN_FILES += rtl/Gousheh_PR.v
SYN_FILES += rtl/RR_LU_scheduler_PR.v
SYN_FILES += rtl/pcie_config.v
SYN_FILES += rtl/debounce_switch.v
SYN_FILES += rtl/sync_signal.v
SYN_FILES += lib/smartFPGA/rtl/riscvcore.v
SYN_FILES += lib/smartFPGA/rtl/Gousheh.v
SYN_FILES += lib/smartFPGA/rtl/accel_wrap.v
SYN_FILES += lib/smartFPGA/rtl/VexRiscv.v
SYN_FILES += lib/smartFPGA/rtl/core_mems.v
SYN_FILES += lib/smartFPGA/rtl/slot_keeper.v
SYN_FILES += lib/smartFPGA/rtl/simple_fifo.v
SYN_FILES += lib/smartFPGA/rtl/simple_arbiter.v
SYN_FILES += lib/smartFPGA/rtl/max_finder_tree.v
SYN_FILES += lib/smartFPGA/rtl/axis_dma.v
SYN_FILES += lib/smartFPGA/rtl/axis_stat.v
SYN_FILES += lib/smartFPGA/rtl/stat_reader.v
SYN_FILES += lib/smartFPGA/rtl/mem_sys.v
SYN_FILES += lib/smartFPGA/rtl/Gousheh_controller.v
SYN_FILES += lib/smartFPGA/rtl/Gousheh_wrapper.v
SYN_FILES += lib/smartFPGA/rtl/simple_sync_sig.v
SYN_FILES += lib/smartFPGA/rtl/simple_axis_switch.v
SYN_FILES += lib/smartFPGA/rtl/axis_ram_switch.v
SYN_FILES += lib/smartFPGA/rtl/axis_switch_2lvl.v
SYN_FILES += lib/smartFPGA/rtl/loopback_msg_fifo.v
SYN_FILES += lib/smartFPGA/rtl/header.v
SYN_FILES += lib/smartFPGA/rtl/pcie_controller.v
SYN_FILES += lib/smartFPGA/rtl/pcie_cont_read.v
SYN_FILES += lib/smartFPGA/rtl/pcie_cont_write.v
SYN_FILES += lib/smartFPGA/rtl/corundum.v
SYN_FILES += lib/smartFPGA/rtl/axis_fifo.v

# SYN_FILES += lib/axis/rtl/axis_switch.v
SYN_FILES += lib/axis/rtl/axis_arb_mux.v
SYN_FILES += lib/axis/rtl/sync_reset.v
# SYN_FILES += lib/axis/rtl/axis_fifo.v
SYN_FILES += lib/axis/rtl/axis_fifo_adapter.v
SYN_FILES += lib/axis/rtl/axis_register.v
SYN_FILES += lib/axis/rtl/axis_pipeline_register.v
SYN_FILES += lib/axis/rtl/arbiter.v
SYN_FILES += lib/axis/rtl/priority_encoder.v
SYN_FILES += lib/axis/rtl/axis_async_fifo.v
SYN_FILES += lib/axis/rtl/axis_async_fifo_adapter.v
SYN_FILES += lib/axis/rtl/axis_adapter.v
SYN_FILES += lib/axi/rtl/axil_interconnect.v

SYN_FILES += lib/pcie/rtl/pcie_us_axil_master.v
SYN_FILES += lib/pcie/rtl/dma_client_axis_sink.v
SYN_FILES += lib/pcie/rtl/dma_client_axis_source.v
SYN_FILES += lib/pcie/rtl/dma_if_pcie_us.v
SYN_FILES += lib/pcie/rtl/dma_if_pcie_us_rd.v
SYN_FILES += lib/pcie/rtl/dma_if_pcie_us_wr.v
SYN_FILES += lib/pcie/rtl/dma_if_mux.v
SYN_FILES += lib/pcie/rtl/dma_if_mux_rd.v
SYN_FILES += lib/pcie/rtl/dma_if_mux_wr.v
SYN_FILES += lib/pcie/rtl/dma_psdpram.v
SYN_FILES += lib/pcie/rtl/pcie_us_cfg.v
SYN_FILES += lib/pcie/rtl/pcie_us_msi.v
SYN_FILES += lib/pcie/rtl/pcie_tag_manager.v
SYN_FILES += lib/pcie/rtl/pulse_merge.v

SYN_FILES += lib/corundum/rtl/mqnic_interface.v
SYN_FILES += lib/corundum/rtl/cmac_pad.v
SYN_FILES += lib/corundum/rtl/mqnic_port.v
SYN_FILES += lib/corundum/rtl/cpl_write.v
SYN_FILES += lib/corundum/rtl/cpl_op_mux.v
SYN_FILES += lib/corundum/rtl/desc_fetch.v
SYN_FILES += lib/corundum/rtl/desc_op_mux.v
SYN_FILES += lib/corundum/rtl/queue_manager.v
SYN_FILES += lib/corundum/rtl/cpl_queue_manager.v
SYN_FILES += lib/corundum/rtl/tx_engine.v
SYN_FILES += lib/corundum/rtl/rx_engine.v
SYN_FILES += lib/corundum/rtl/tx_checksum.v
SYN_FILES += lib/corundum/rtl/rx_checksum.v
SYN_FILES += lib/corundum/rtl/rx_hash.v
SYN_FILES += lib/corundum/rtl/tx_scheduler_rr.v
SYN_FILES += lib/corundum/rtl/tdma_scheduler.v
SYN_FILES += lib/corundum/rtl/event_mux.v
# XDC files
XDC_FILES = fpga.xdc
XDC_FILES += lib/axis/syn/axis_async_fifo.tcl
XDC_FILES += lib/axis/syn/sync_reset.tcl
XDC_FILES += lib/smartFPGA/syn/simple_sync_sig.tcl

# IP
IP_TCL_FILES = ip/pcie4_uscale_plus_0.tcl
IP_TCL_FILES += ip/cmac_usplus_0.tcl
IP_TCL_FILES += ip/cmac_usplus_1.tcl
# IP_TCL_FILES += ip/ila_2x64.tcl

include ../common/vivado.mk

program: $(FPGA_TOP).bit
	echo "open_hw" > program.tcl
	echo "connect_hw_server" >> program.tcl
	echo "open_hw_target" >> program.tcl
	echo "current_hw_device [lindex [get_hw_devices] 0]" >> program.tcl
	echo "refresh_hw_device -update_hw_probes false [current_hw_device]" >> program.tcl
	echo "set_property PROGRAM.FILE {$(FPGA_TOP).bit} [current_hw_device]" >> program.tcl
	echo "program_hw_devices [current_hw_device]" >> program.tcl
	echo "exit" >> program.tcl
	vivado -nojournal -nolog -mode batch -source program.tcl

%_primary.mcs %_secondary.mcs %_primary.prm %_secondary.prm: %.bit
	echo "write_cfgmem -force -format mcs -size 256 -interface SPIx8 -loadbit {up 0x0000000 $*.bit} -checksum -file $*.mcs" > generate_mcs.tcl
	echo "exit" >> generate_mcs.tcl
	vivado -nojournal -nolog -mode batch -source generate_mcs.tcl
	mkdir -p rev
	COUNT=100; \
	while [ -e rev/$*_rev$$COUNT.bit ]; \
	do COUNT=$$((COUNT+1)); done; \
	COUNT=$$((COUNT-1)); \
	for x in _primary.mcs _secondary.mcs _primary.prm _secondary.prm; \
	do cp $*$$x rev/$*_rev$$COUNT$$x; \
	echo "Output: rev/$*_rev$$COUNT$$x"; done;

flash: $(FPGA_TOP)_primary.mcs $(FPGA_TOP)_secondary.mcs $(FPGA_TOP)_primary.prm $(FPGA_TOP)_secondary.prm
	echo "open_hw" > flash.tcl
	echo "connect_hw_server" >> flash.tcl
	echo "open_hw_target" >> flash.tcl
	echo "current_hw_device [lindex [get_hw_devices] 0]" >> flash.tcl
	echo "refresh_hw_device -update_hw_probes false [current_hw_device]" >> flash.tcl
	echo "create_hw_cfgmem -hw_device [current_hw_device] [lindex [get_cfgmem_parts {mt25qu01g-spi-x1_x2_x4_x8}] 0]" >> flash.tcl
	echo "current_hw_cfgmem -hw_device [current_hw_device] [get_property PROGRAM.HW_CFGMEM [current_hw_device]]" >> flash.tcl
	echo "set_property PROGRAM.FILES [list \"$(FPGA_TOP)_primary.mcs\" \"$(FPGA_TOP)_secondary.mcs\"] [current_hw_cfgmem]" >> flash.tcl
	echo "set_property PROGRAM.PRM_FILES [list \"$(FPGA_TOP)_primary.prm\" \"$(FPGA_TOP)_secondary.prm\"] [current_hw_cfgmem]" >> flash.tcl
	echo "set_property PROGRAM.ERASE 1 [current_hw_cfgmem]" >> flash.tcl
	echo "set_property PROGRAM.CFG_PROGRAM 1 [current_hw_cfgmem]" >> flash.tcl
	echo "set_property PROGRAM.VERIFY 1 [current_hw_cfgmem]" >> flash.tcl
	echo "set_property PROGRAM.CHECKSUM 0 [current_hw_cfgmem]" >> flash.tcl
	echo "set_property PROGRAM.ADDRESS_RANGE {use_file} [current_hw_cfgmem]" >> flash.tcl
	echo "set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [current_hw_cfgmem]" >> flash.tcl
	echo "create_hw_bitstream -hw_device [current_hw_device] [get_property PROGRAM.HW_CFGMEM_BITFILE [current_hw_device]]" >> flash.tcl
	echo "program_hw_devices [current_hw_device]" >> flash.tcl
	echo "refresh_hw_device [current_hw_device]" >> flash.tcl
	echo "program_hw_cfgmem -hw_cfgmem [current_hw_cfgmem]" >> flash.tcl
	echo "boot_hw_device [current_hw_device]" >> flash.tcl
	echo "exit" >> flash.tcl
	vivado -nojournal -nolog -mode batch -source flash.tcl


ICARUS_INC_DIR ?= /usr/local/include/iverilog

SIM ?= icarus
TOPLEVEL_LANG ?= verilog
CWD=.
export COCOTB_REDUCED_LOG_FMT=1
export COCOTB_RESOLVE_X=RANDOM
export PARAM_BAR0_APERTURE=24

DUT=fpga_core
MODULE=test_$(DUT)
TOPLEVEL=$(MODULE)

COMPILE_ARGS += -P $(TOPLEVEL).TB_LOG=0
COMPILE_ARGS += -P $(TOPLEVEL).INIT_ROMS=1

RTL_DIR = $(CWD)/../../rtl
ACC_DIR = $(CWD)/../../accel/pigasus_sme/rtl
SHIRE = $(CWD)/../../lib/Shire/rtl
AXIS_LIB = $(CWD)/../../lib/axis/rtl
AXI_LIB = $(CWD)/../../lib/axi/rtl
PCIE_LIB = $(CWD)/../../lib/pcie/rtl
CORUNDUM_LIB = $(CWD)/../../lib/corundum/rtl

VERILOG_SOURCES  = $(CWD)/../$(TOPLEVEL).v

VERILOG_SOURCES += $(RTL_DIR)/fpga_core.v
VERILOG_SOURCES += $(RTL_DIR)/rpu_PR_pig.v
VERILOG_SOURCES += $(RTL_DIR)/RR_LU_scheduler_PR.v
# VERILOG_SOURCES += $(RTL_DIR)/Hash_Dropping_scheduler_PR.v
VERILOG_SOURCES += $(RTL_DIR)/pcie_config.v
VERILOG_SOURCES += $(RTL_DIR)/sync_signal.v

VERILOG_SOURCES += $(SHIRE)/simple_fifo.v
VERILOG_SOURCES += $(SHIRE)/max_finder_tree.v
VERILOG_SOURCES += $(SHIRE)/slot_keeper.v
VERILOG_SOURCES += $(SHIRE)/core_mems.v
VERILOG_SOURCES += $(SHIRE)/axis_dma.v
VERILOG_SOURCES += $(SHIRE)/VexRiscv.v
VERILOG_SOURCES += $(SHIRE)/riscvcore.v
VERILOG_SOURCES += $(SHIRE)/rpu.v
VERILOG_SOURCES += $(SHIRE)/rpu_controller.v
VERILOG_SOURCES += $(SHIRE)/rpu_intercon.v
VERILOG_SOURCES += $(SHIRE)/mem_sys.v
VERILOG_SOURCES += $(SHIRE)/simple_arbiter.v
VERILOG_SOURCES += $(SHIRE)/pipe_reg.v
VERILOG_SOURCES += $(SHIRE)/simple_sync_sig.v
VERILOG_SOURCES += $(SHIRE)/simple_axis_switch.v
VERILOG_SOURCES += $(SHIRE)/axis_ram_switch.v
VERILOG_SOURCES += $(SHIRE)/axis_stat.v
VERILOG_SOURCES += $(SHIRE)/stat_reader.v
VERILOG_SOURCES += $(SHIRE)/axis_slr_register.v
VERILOG_SOURCES += $(SHIRE)/axis_switch_2lvl.v
VERILOG_SOURCES += $(SHIRE)/loopback_msg_fifo.v
VERILOG_SOURCES += $(SHIRE)/header.v
VERILOG_SOURCES += $(SHIRE)/single_accel_rd_dma.v
VERILOG_SOURCES += $(SHIRE)/spaced_2lvl_penc.v
VERILOG_SOURCES += $(SHIRE)/pcie_controller.v
VERILOG_SOURCES += $(SHIRE)/pcie_cont_read.v
VERILOG_SOURCES += $(SHIRE)/pcie_cont_write.v
VERILOG_SOURCES += $(SHIRE)/corundum.v
VERILOG_SOURCES += $(SHIRE)/axis_fifo_w_count.v
VERILOG_SOURCES += $(SHIRE)/axis_stopper.v
VERILOG_SOURCES += $(SHIRE)/axis_dropper.v

VERILOG_SOURCES += $(ACC_DIR)/backend.sv
VERILOG_SOURCES += $(ACC_DIR)/first_filter.sv
VERILOG_SOURCES += $(ACC_DIR)/frontend.sv
VERILOG_SOURCES += $(ACC_DIR)/hashtable.sv
VERILOG_SOURCES += $(ACC_DIR)/hashtable_top.sv
VERILOG_SOURCES += $(ACC_DIR)/ips.sv
VERILOG_SOURCES += $(ACC_DIR)/acc_hash.sv
VERILOG_SOURCES += $(ACC_DIR)/mul_hash.sv
VERILOG_SOURCES += $(ACC_DIR)/rr_arbiter.sv
VERILOG_SOURCES += $(ACC_DIR)/rr_arbiter_4.sv
VERILOG_SOURCES += $(ACC_DIR)/string_matcher.sv
VERILOG_SOURCES += $(ACC_DIR)/hyper_pipe.sv
VERILOG_SOURCES += $(ACC_DIR)/hyper_pipe_rst.sv
VERILOG_SOURCES += $(ACC_DIR)/port_unit.sv
VERILOG_SOURCES += $(ACC_DIR)/port_group.sv
VERILOG_SOURCES += $(ACC_DIR)/rule_unit.sv
VERILOG_SOURCES += $(ACC_DIR)/pkt_almost_full.sv
VERILOG_SOURCES += $(ACC_DIR)/reduction_2t1_2.sv
VERILOG_SOURCES += $(ACC_DIR)/unified_fifo.sv
VERILOG_SOURCES += $(ACC_DIR)/unified_pkt_fifo.sv
VERILOG_SOURCES += $(ACC_DIR)/rule_depacker_128_64.sv
VERILOG_SOURCES += $(ACC_DIR)/rule_depacker_64_32.sv
VERILOG_SOURCES += $(ACC_DIR)/struct_s.sv
VERILOG_SOURCES += $(ACC_DIR)/SME_wrapper.sv
VERILOG_SOURCES += $(ACC_DIR)/accel_wrap_pigasus.v
VERILOG_SOURCES += $(ACC_DIR)/ip_match.v


VERILOG_SOURCES += $(AXIS_LIB)/arbiter.v
VERILOG_SOURCES += $(AXIS_LIB)/priority_encoder.v
VERILOG_SOURCES += $(AXIS_LIB)/sync_reset.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_adapter.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_arb_mux.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_async_fifo.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_async_fifo_adapter.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_fifo.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_fifo_adapter.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_register.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_pipeline_register.v

VERILOG_SOURCES += $(AXI_LIB)/axil_interconnect.v

VERILOG_SOURCES += $(PCIE_LIB)/pcie_us_axil_master.v
VERILOG_SOURCES += $(PCIE_LIB)/dma_client_axis_sink.v
VERILOG_SOURCES += $(PCIE_LIB)/dma_client_axis_source.v
VERILOG_SOURCES += $(PCIE_LIB)/dma_if_pcie_us.v
VERILOG_SOURCES += $(PCIE_LIB)/dma_if_pcie_us_rd.v
VERILOG_SOURCES += $(PCIE_LIB)/dma_if_pcie_us_wr.v
VERILOG_SOURCES += $(PCIE_LIB)/dma_if_desc_mux.v
VERILOG_SOURCES += $(PCIE_LIB)/dma_ram_demux_wr.v
VERILOG_SOURCES += $(PCIE_LIB)/dma_ram_demux_rd.v
VERILOG_SOURCES += $(PCIE_LIB)/dma_if_mux.v
VERILOG_SOURCES += $(PCIE_LIB)/dma_if_mux_rd.v
VERILOG_SOURCES += $(PCIE_LIB)/dma_if_mux_wr.v
VERILOG_SOURCES += $(PCIE_LIB)/dma_psdpram.v
VERILOG_SOURCES += $(PCIE_LIB)/pcie_us_cfg.v
VERILOG_SOURCES += $(PCIE_LIB)/pcie_us_msi.v
VERILOG_SOURCES += $(PCIE_LIB)/pulse_merge.v

VERILOG_SOURCES += $(CORUNDUM_LIB)/mqnic_interface.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/mqnic_port.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/cpl_write.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/cpl_op_mux.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/desc_fetch.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/desc_op_mux.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/queue_manager.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/cpl_queue_manager.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/tx_engine.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/rx_engine.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/tx_checksum.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/rx_checksum.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/rx_hash.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/tx_scheduler_rr.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/tdma_scheduler.v
VERILOG_SOURCES += $(CORUNDUM_LIB)/event_mux.v

COMPILE_ARGS += -I $(ACC_DIR)/struct_s.sv
PLUSARGS+=-fst
INC_DIR=$(ICARUS_INC_DIR)

include $(shell cocotb-config --makefiles)/Makefile.sim

compile:
	make -C ../../accel/pigasus/c/ NAME=pigasus
	make -C ../../accel/pigasus/c/ NAME=pigasus2

clean::
	@rm -rf *.xml __pycache__

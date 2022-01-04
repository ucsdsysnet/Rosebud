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

RTL_DIR = $(CWD)/../../rtl
SMARTFPGA = $(CWD)/../../lib/Shire/rtl
ACC_DIR = $(CWD)/../../accel/full_ids/rtl
AXIS_LIB = $(CWD)/../../lib/axis/rtl
AXI_LIB = $(CWD)/../../lib/axi/rtl
ETH_LIB = $(CWD)/../../lib/eth/rtl
PCIE_LIB = $(CWD)/../../lib/pcie/rtl
CORUNDUM_LIB = $(CWD)/../../lib/corundum/rtl

VERILOG_SOURCES  = $(CWD)/../common/$(TOPLEVEL).v
VERILOG_SOURCES += $(CWD)/../common/FDCE.v

VERILOG_SOURCES += $(RTL_DIR)/fpga_core.v
VERILOG_SOURCES += $(RTL_DIR)/Gousheh_PR.v
VERILOG_SOURCES += $(RTL_DIR)/RR_LU_scheduler_PR.v
# VERILOG_SOURCES += $(RTL_DIR)/Hash_Dropping_scheduler_PR.v
VERILOG_SOURCES += $(RTL_DIR)/pcie_config.v

VERILOG_SOURCES += $(SMARTFPGA)/simple_fifo.v
VERILOG_SOURCES += $(SMARTFPGA)/max_finder_tree.v
VERILOG_SOURCES += $(SMARTFPGA)/slot_keeper.v
VERILOG_SOURCES += $(SMARTFPGA)/core_mems.v
VERILOG_SOURCES += $(SMARTFPGA)/axis_dma.v
VERILOG_SOURCES += $(SMARTFPGA)/VexRiscv.v
VERILOG_SOURCES += $(SMARTFPGA)/riscvcore.v
VERILOG_SOURCES += $(SMARTFPGA)/Gousheh.v
VERILOG_SOURCES += $(SMARTFPGA)/Gousheh_controller.v
VERILOG_SOURCES += $(SMARTFPGA)/Gousheh_wrapper.v
VERILOG_SOURCES += $(SMARTFPGA)/mem_sys.v
VERILOG_SOURCES += $(SMARTFPGA)/simple_arbiter.v
VERILOG_SOURCES += $(SMARTFPGA)/simple_sync_sig.v
VERILOG_SOURCES += $(SMARTFPGA)/simple_axis_switch.v
VERILOG_SOURCES += $(SMARTFPGA)/axis_ram_switch.v
VERILOG_SOURCES += $(SMARTFPGA)/axis_stat.v
VERILOG_SOURCES += $(SMARTFPGA)/stat_reader.v
VERILOG_SOURCES += $(SMARTFPGA)/axis_slr_crossing_register.v
VERILOG_SOURCES += $(SMARTFPGA)/axis_switch_2lvl.v
VERILOG_SOURCES += $(SMARTFPGA)/loopback_msg_fifo.v
VERILOG_SOURCES += $(SMARTFPGA)/header.v
VERILOG_SOURCES += $(SMARTFPGA)/pcie_controller.v
VERILOG_SOURCES += $(SMARTFPGA)/pcie_cont_read.v
VERILOG_SOURCES += $(SMARTFPGA)/pcie_cont_write.v
VERILOG_SOURCES += $(SMARTFPGA)/corundum.v
VERILOG_SOURCES += $(SMARTFPGA)/axis_fifo.v
VERILOG_SOURCES += $(SMARTFPGA)/axis_stopper.v
VERILOG_SOURCES += $(SMARTFPGA)/axis_dropper.v
VERILOG_SOURCES += $(SMARTFPGA)/accel_rd_dma_sp.v

VERILOG_SOURCES += $(ACC_DIR)/accel_wrap_full_ids.v
VERILOG_SOURCES += $(ACC_DIR)/sme/udp_sme.v
VERILOG_SOURCES += $(ACC_DIR)/sme/tcp_sme.v
VERILOG_SOURCES += $(ACC_DIR)/sme/http_sme.v
VERILOG_SOURCES += $(ACC_DIR)/fixed_sme/fixed_loc_sme_8.v
VERILOG_SOURCES += $(ACC_DIR)/ip_match/ip_match.v

# For new SME
# VERILOG_SOURCES += $(ACC_DIR)/accel_wrap_full_ids_4sme.v
# VERILOG_SOURCES += $(ACC_DIR)/SME_wrapper.v
# VERILOG_SOURCES += $(ACC_DIR)/FSME_wrapper.v
# VERILOG_SOURCES += $(ACC_DIR)/new_sme/fast_pattern_sme.v
# VERILOG_SOURCES += $(ACC_DIR)/new_fixed_sme/fixed_loc_sme_8.v
# VERILOG_SOURCES += $(ACC_DIR)/ip_match/ip_match.v

VERILOG_SOURCES += $(ETH_LIB)/axis_xgmii_rx_64.v
VERILOG_SOURCES += $(ETH_LIB)/axis_xgmii_tx_64.v
VERILOG_SOURCES += $(ETH_LIB)/lfsr.v

VERILOG_SOURCES += $(AXIS_LIB)/arbiter.v
VERILOG_SOURCES += $(AXIS_LIB)/priority_encoder.v
VERILOG_SOURCES += $(AXIS_LIB)/sync_reset.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_adapter.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_arb_mux.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_async_fifo.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_async_fifo_adapter.v
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

PLUSARGS+=-fst
INC_DIR=$(ICARUS_INC_DIR)

include $(shell cocotb-config --makefiles)/Makefile.sim

compile:
	make -C ../../accel/full_ids/c/ NAME=full_ids

clean::
	@rm -rf *.xml __pycache__

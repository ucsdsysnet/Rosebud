ICARUS_INC_DIR ?= /usr/local/include/iverilog

SIM ?= icarus
TOPLEVEL_LANG ?= verilog
CWD=.
export COCOTB_REDUCED_LOG_FMT=1
export COCOTB_RESOLVE_X=RANDOM

DUT=gousheh
MODULE=test_$(DUT)
TOPLEVEL=$(MODULE)

RTL_DIR = $(CWD)/../../rtl
ACC_DIR = $(CWD)/../../accel/ip_matcher/rtl
SMARTFPGA = $(CWD)/../../lib/Shire/rtl
AXIS_LIB = $(CWD)/../../lib/axis/rtl

VERILOG_SOURCES  = $(CWD)/test_gousheh.v
VERILOG_SOURCES += $(RTL_DIR)/Gousheh_PR_w_accel.v

VERILOG_SOURCES += $(SMARTFPGA)/simple_fifo.v
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
VERILOG_SOURCES += $(SMARTFPGA)/axis_stat.v
VERILOG_SOURCES += $(SMARTFPGA)/header.v
VERILOG_SOURCES += $(SMARTFPGA)/axis_fifo.v
VERILOG_SOURCES += $(SMARTFPGA)/accel_rd_dma_sp.v
VERILOG_SOURCES += $(SMARTFPGA)/spaced_2lvl_penc.v

VERILOG_SOURCES += $(ACC_DIR)/accel_wrap_firewall.v
VERILOG_SOURCES += $(ACC_DIR)/firewall.v

VERILOG_SOURCES += $(AXIS_LIB)/arbiter.v
VERILOG_SOURCES += $(AXIS_LIB)/priority_encoder.v
VERILOG_SOURCES += $(AXIS_LIB)/sync_reset.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_register.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_pipeline_register.v

PLUSARGS+=-fst
INC_DIR=$(ICARUS_INC_DIR)

include $(shell cocotb-config --makefiles)/Makefile.sim

compile:
	make -C ../../accel/full_ids/c/ NAME=full_ids

clean::
	@rm -rf *.xml __pycache__

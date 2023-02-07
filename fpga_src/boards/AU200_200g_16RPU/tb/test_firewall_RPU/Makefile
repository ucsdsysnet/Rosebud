ICARUS_INC_DIR ?= /usr/local/include/iverilog

SIM ?= icarus
TOPLEVEL_LANG ?= verilog
CWD=.
export COCOTB_REDUCED_LOG_FMT=1
export COCOTB_RESOLVE_X=RANDOM

DUT=rpu
MODULE=test_$(DUT)
TOPLEVEL=$(MODULE)

RTL_DIR = $(CWD)/../../rtl
ACC_DIR = $(CWD)/../../accel/ip_matcher/rtl
ROSEBUD = $(CWD)/../../lib/Rosebud/rtl
AXIS_LIB = $(CWD)/../../lib/axis/rtl

COMPILE_ARGS += -P $(TOPLEVEL).SLOT_COUNT=16
COMPILE_ARGS += -P $(TOPLEVEL).INIT_ROMS=1
COMPILE_ARGS += -I $(ROSEBUD)

VERILOG_SOURCES  = $(ROSEBUD)/../tb/common/test_rpu.v
VERILOG_SOURCES += $(RTL_DIR)/rpu_PR_fw.v

VERILOG_SOURCES += $(ROSEBUD)/basic_fifo.v
VERILOG_SOURCES += $(ROSEBUD)/axis_register.v
VERILOG_SOURCES += $(ROSEBUD)/mem_modules.v
VERILOG_SOURCES += $(ROSEBUD)/axis_dma.v
VERILOG_SOURCES += $(ROSEBUD)/VexRiscv.v
VERILOG_SOURCES += $(ROSEBUD)/riscvcore.v
VERILOG_SOURCES += $(ROSEBUD)/rpu.v
VERILOG_SOURCES += $(ROSEBUD)/rpu_controller.v
VERILOG_SOURCES += $(ROSEBUD)/rpu_intercon.v
VERILOG_SOURCES += $(ROSEBUD)/mem_sys.v
VERILOG_SOURCES += $(ROSEBUD)/simple_arbiter.v
VERILOG_SOURCES += $(ROSEBUD)/simple_sync_sig.v
VERILOG_SOURCES += $(ROSEBUD)/axis_stat.v
VERILOG_SOURCES += $(ROSEBUD)/header.v
VERILOG_SOURCES += $(ROSEBUD)/accel_rd_dma_sp.v
VERILOG_SOURCES += $(ROSEBUD)/spaced_2lvl_penc.v

VERILOG_SOURCES += $(ACC_DIR)/accel_wrap_firewall.v
VERILOG_SOURCES += $(ACC_DIR)/firewall.v

VERILOG_SOURCES += $(AXIS_LIB)/axis_fifo.v
VERILOG_SOURCES += $(AXIS_LIB)/arbiter.v
VERILOG_SOURCES += $(AXIS_LIB)/priority_encoder.v
VERILOG_SOURCES += $(AXIS_LIB)/sync_reset.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_pipeline_register.v

PLUSARGS+=-fst
INC_DIR=$(ICARUS_INC_DIR)

include $(shell cocotb-config --makefiles)/Makefile.sim

compile:
	make -C ../../accel/ip_matcher/c/ NAME=firewall

clean::
	@rm -rf *.xml __pycache__

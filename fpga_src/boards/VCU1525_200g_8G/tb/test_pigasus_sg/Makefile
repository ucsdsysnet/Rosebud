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
ACC_DIR = $(CWD)/../../accel/pigasus_sme/rtl
SMARTFPGA = $(CWD)/../../lib/smartFPGA/rtl
AXIS_LIB = $(CWD)/../../lib/axis/rtl

VERILOG_SOURCES  = $(CWD)/test_gousheh.v
VERILOG_SOURCES += $(RTL_DIR)/Gousheh_PR_pig.v

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
VERILOG_SOURCES += $(SMARTFPGA)/single_accel_rd_dma.v
VERILOG_SOURCES += $(SMARTFPGA)/spaced_2lvl_penc.v

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
VERILOG_SOURCES += $(ACC_DIR)/reduction_2t1.sv
VERILOG_SOURCES += $(ACC_DIR)/unified_fifo.sv
VERILOG_SOURCES += $(ACC_DIR)/unified_pkt_fifo.sv
VERILOG_SOURCES += $(ACC_DIR)/rule_depacker_128_64.sv
VERILOG_SOURCES += $(ACC_DIR)/struct_s.sv
VERILOG_SOURCES += $(ACC_DIR)/SME_wrapper.sv
VERILOG_SOURCES += $(ACC_DIR)/accel_wrap_pigasus.v
VERILOG_SOURCES += $(ACC_DIR)/ip_match.v

VERILOG_SOURCES += $(AXIS_LIB)/arbiter.v
VERILOG_SOURCES += $(AXIS_LIB)/priority_encoder.v
VERILOG_SOURCES += $(AXIS_LIB)/sync_reset.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_register.v
VERILOG_SOURCES += $(AXIS_LIB)/axis_pipeline_register.v

COMPILE_ARGS  = -I $(ACC_DIR)/struct_s.sv
PLUSARGS+=-fst
INC_DIR=$(ICARUS_INC_DIR)

include $(shell cocotb-config --makefiles)/Makefile.sim

compile:
	make -C ../../../../../c_code/ NAME=basic_fw

clean::
	@rm -rf *.xml __pycache__

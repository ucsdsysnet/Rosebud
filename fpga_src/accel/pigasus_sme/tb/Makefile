ICARUS_INC_DIR ?= /usr/local/include/iverilog

SIM ?= icarus
TOPLEVEL_LANG ?= verilog
export COCOTB_REDUCED_LOG_FMT=1 

CWD = .
RTL_DIR = ../rtl
MYLIB_DIR = ../../../lib/Shire/rtl
AXIS_DIR = ../../../lib/axis/rtl

MODULE = test_SME
# MODULE = test_pigasus
# MODULE = test_mul_hash
TOPLEVEL = $(MODULE)

# COMPILE_ARGS += -P $(TOPLEVEL).MSK_BYTES=2
COMPILE_ARGS  += -I $(RTL_DIR)

VERILOG_SOURCES  = ./$(MODULE).v

VERILOG_SOURCES += $(AXIS_DIR)/axis_async_fifo.v
VERILOG_SOURCES += $(AXIS_DIR)/arbiter.v
VERILOG_SOURCES += $(AXIS_DIR)/priority_encoder.v
VERILOG_SOURCES += $(MYLIB_DIR)/simple_fifo.v

VERILOG_SOURCES += $(RTL_DIR)/backend.sv
VERILOG_SOURCES += $(RTL_DIR)/first_filter.sv
VERILOG_SOURCES += $(RTL_DIR)/frontend.sv
VERILOG_SOURCES += $(RTL_DIR)/hashtable.sv
VERILOG_SOURCES += $(RTL_DIR)/hashtable_top.sv
VERILOG_SOURCES += $(RTL_DIR)/ips.sv
VERILOG_SOURCES += $(RTL_DIR)/mul_hash.sv
VERILOG_SOURCES += $(RTL_DIR)/acc_hash.sv
VERILOG_SOURCES += $(RTL_DIR)/rr_arbiter.sv
VERILOG_SOURCES += $(RTL_DIR)/rr_arbiter_4.sv
VERILOG_SOURCES += $(RTL_DIR)/hyper_pipe.sv
VERILOG_SOURCES += $(RTL_DIR)/hyper_pipe_rst.sv
VERILOG_SOURCES += $(RTL_DIR)/string_matcher.sv
VERILOG_SOURCES += $(RTL_DIR)/port_unit.sv
VERILOG_SOURCES += $(RTL_DIR)/rule_unit.sv
VERILOG_SOURCES += $(RTL_DIR)/port_group.sv
VERILOG_SOURCES += $(RTL_DIR)/pkt_almost_full.sv
VERILOG_SOURCES += $(RTL_DIR)/reduction_2t1_2.sv
VERILOG_SOURCES += $(RTL_DIR)/unified_fifo.sv
VERILOG_SOURCES += $(RTL_DIR)/unified_pkt_fifo.sv
VERILOG_SOURCES += $(RTL_DIR)/rule_depacker_128_64.sv
VERILOG_SOURCES += $(RTL_DIR)/rule_depacker_64_32.sv
VERILOG_SOURCES += $(RTL_DIR)/SME_wrapper.sv

PLUSARGS+=-fst 
INC_DIR=$(ICARUS_INC_DIR)

include $(shell cocotb-config --makefiles)/Makefile.sim 

clean:: 
	@rm -rf *.xml __pycache__

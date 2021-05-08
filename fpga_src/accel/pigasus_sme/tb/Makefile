ICARUS_INC_DIR ?= /usr/local/include/iverilog

SIM ?= icarus
TOPLEVEL_LANG ?= verilog
export COCOTB_REDUCED_LOG_FMT=1 

CWD = .
RTL_DIR = ../rtl
MYLIB_DIR = ../../../lib/smartFPGA/rtl

MODULE = test_pigasus
TOPLEVEL = test_pigasus

VERILOG_SOURCES  = ./test_pigasus.v

VERILOG_SOURCES += $(MYLIB_DIR)/simple_fifo.v

VERILOG_SOURCES += $(RTL_DIR)/backend.sv
VERILOG_SOURCES += $(RTL_DIR)/first_filter.sv
VERILOG_SOURCES += $(RTL_DIR)/frontend.sv
VERILOG_SOURCES += $(RTL_DIR)/hashtable.sv
VERILOG_SOURCES += $(RTL_DIR)/hashtable_top.sv
VERILOG_SOURCES += $(RTL_DIR)/ips.sv
VERILOG_SOURCES += $(RTL_DIR)/mul_hash.sv
VERILOG_SOURCES += $(RTL_DIR)/rr_arbiter.sv
VERILOG_SOURCES += $(RTL_DIR)/rr_arbiter_4.sv
VERILOG_SOURCES += $(RTL_DIR)/hyper_pipe.sv
VERILOG_SOURCES += $(RTL_DIR)/string_matcher.sv

COMPILE_ARGS  = -I ./struct_s.sv
PLUSARGS+=-fst 
INC_DIR=$(ICARUS_INC_DIR)

include $(shell cocotb-config --makefiles)/Makefile.sim 

clean:: 
	@rm -rf *.xml __pycache__

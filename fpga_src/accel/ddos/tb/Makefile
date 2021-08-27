ICARUS_INC_DIR ?= /usr/local/include/iverilog

SIM ?= icarus
TOPLEVEL_LANG ?= verilog
export COCOTB_REDUCED_LOG_FMT=1

CWD = .
RTL_DIR = ../rtl

MODULE = test_ddos
TOPLEVEL = $(MODULE)

VERILOG_SOURCES  = ./$(MODULE).v

VERILOG_SOURCES += $(RTL_DIR)/ddos_detector.v

PLUSARGS+=-fst
INC_DIR=$(ICARUS_INC_DIR)

include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	@rm -rf *.xml __pycache__

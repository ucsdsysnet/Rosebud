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
ACC_DIR = $(CWD)/../../accel/full_ids/rtl
SHIRE = $(CWD)/../../lib/Shire/rtl
AXIS_LIB = $(CWD)/../../lib/axis/rtl

VERILOG_SOURCES  = $(CWD)/test_gousheh.v
VERILOG_SOURCES += $(RTL_DIR)/Gousheh_PR_w_accel.v

VERILOG_SOURCES += $(SHIRE)/simple_fifo.v
VERILOG_SOURCES += $(SHIRE)/core_mems.v
VERILOG_SOURCES += $(SHIRE)/axis_dma.v
VERILOG_SOURCES += $(SHIRE)/VexRiscv.v
VERILOG_SOURCES += $(SHIRE)/riscvcore.v
VERILOG_SOURCES += $(SHIRE)/Gousheh.v
VERILOG_SOURCES += $(SHIRE)/Gousheh_controller.v
VERILOG_SOURCES += $(SHIRE)/Gousheh_wrapper.v
VERILOG_SOURCES += $(SHIRE)/mem_sys.v
VERILOG_SOURCES += $(SHIRE)/simple_arbiter.v
VERILOG_SOURCES += $(SHIRE)/simple_sync_sig.v
VERILOG_SOURCES += $(SHIRE)/axis_stat.v
VERILOG_SOURCES += $(SHIRE)/header.v
VERILOG_SOURCES += $(SHIRE)/accel_rd_dma_sp.v
VERILOG_SOURCES += $(SHIRE)/spaced_2lvl_penc.v

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

VERILOG_SOURCES += $(AXIS_LIB)/axis_fifo.v
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

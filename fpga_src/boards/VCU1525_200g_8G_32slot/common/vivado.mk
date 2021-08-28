###################################################################
# 
# Xilinx Vivado FPGA Makefile
# 
# Copyright (c) 2016 Alex Forencich
# 
###################################################################
# 
# Parameters:
# FPGA_TOP - Top module name
# FPGA_FAMILY - FPGA family (e.g. VirtexUltrascale)
# FPGA_DEVICE - FPGA device (e.g. xcvu095-ffva2104-2-e)
# SYN_FILES - space-separated list of source files
# INC_FILES - space-separated list of include files
# XDC_FILES - space-separated list of timing constraint files
# XCI_FILES - space-separated list of IP XCI files
# 
# Example:
# 
# FPGA_TOP = fpga
# FPGA_FAMILY = VirtexUltrascale
# FPGA_DEVICE = xcvu095-ffva2104-2-e
# SYN_FILES = rtl/fpga.v
# XDC_FILES = fpga.xdc
# XCI_FILES = ip/pcspma.xci
# include ../common/vivado.mk
# 
###################################################################

# phony targets
.PHONY: clean fpga

# prevent make from deleting intermediate files and reports
.PRECIOUS: %.xpr %.bit %.mcs %.prm
.SECONDARY:

CONFIG ?= config.mk
-include ../$(CONFIG)

SYN_FILES_REL = $(patsubst %, ../%, $(SYN_FILES))
INC_FILES_REL = $(patsubst %, ../%, $(INC_FILES))
XCI_FILES_REL = $(patsubst %, ../%, $(XCI_FILES))
IP_TCL_FILES_REL = $(patsubst %, ../%, $(IP_TCL_FILES))

ifdef XDC_FILES
  XDC_FILES_REL = $(patsubst %, ../%, $(XDC_FILES))
else
  XDC_FILES_REL = $(FPGA_TOP).xdc
endif

###################################################################
# Main Targets
#
# all: build everything
# clean: remove output files and project files
###################################################################

all: fpga

fpga: $(FPGA_TOP).bit

vivado: $(FPGA_TOP).xpr
	vivado $(FPGA_TOP).xpr

tmpclean:
	-rm -rf *.log *.jou *.cache *.hw *.ip_user_files *.runs *.xpr *.html *.xml *.sim *.srcs *.str .Xil defines.v rev *.rpt hd_visual fpga.hbs
	-rm -rf create_project.tcl __pycache__

clean: tmpclean
	-rm -rf *.bit program.tcl generate_mcs.tcl *.mcs *.prm flash.tcl fpga.gen

distclean: clean
	-rm -rf rev

###################################################################
# Target implementations
###################################################################

# Vivado project file
%.xpr: Makefile $(XCI_FILES_REL) $(IP_TCL_FILES_REL)
	rm -rf defines.v
	touch defines.v
	for x in $(DEFS); do echo '`define' $$x >> defines.v; done
	echo "create_project -force -part $(FPGA_PART) $*" > create_project.tcl
	echo "add_files -fileset sources_1 {defines.v $(SYN_FILES_REL)}" >> create_project.tcl
	echo "add_files -fileset constrs_1 {$(XDC_FILES_REL)}" >> create_project.tcl
	for x in $(XCI_FILES_REL); do echo "import_ip $$x" >> create_project.tcl; done
	for x in $(IP_TCL_FILES_REL); do echo "source $$x" >> create_project.tcl; done
	echo "exit" >> create_project.tcl
	vivado -nojournal -nolog -mode batch -source create_project.tcl

# synthesis run
%.runs/synth_1/%.dcp: %.xpr $(SYN_FILES_REL) $(INC_FILES_REL) $(XDC_FILES_REL)
	vivado -nojournal -nolog -mode batch -source run_synth.tcl

# implementation run
%.runs/impl_1/%_routed.dcp: %.runs/synth_1/%.dcp
	vivado -nojournal -nolog -mode batch -source run_impl_1.tcl

# %.runs/impl_2/%_routed.dcp: %.runs/synth_1/%.dcp
# 	vivado -nojournal -nolog -mode batch -source run_impl_2.tcl

# bit file
%.bit: %.runs/impl_1/%_routed.dcp # %.runs/impl_2/%_routed.dcp
	vivado -nojournal -nolog -mode batch -source generate_bit.tcl
	mkdir -p rev
	EXT=bit; COUNT=100; \
	while [ -e rev/$*_rev$$COUNT.$$EXT ]; \
	do COUNT=$$((COUNT+1)); done; \
	cp $@ rev/$*_rev$$COUNT.$$EXT; \
	echo "Output: rev/$*_rev$$COUNT.$$EXT";

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

tmpclean:
	-rm -rf *.log *.jou *.cache *.hw *.ip_user_files *.runs *.xpr *.html *.xml *.sim *.srcs *.str .Xil defines.v rev *.rpt
	-rm -rf create_project.tcl run_synth.tcl run_impl.tcl generate_bit.tcl

clean: tmpclean
	-rm -rf *.bit program.tcl generate_mcs.tcl *.mcs *.prm flash.tcl

distclean: clean
	-rm -rf rev

###################################################################
# Target implementations
###################################################################

# Vivado project file
%.xpr: Makefile $(XCI_FILES_REL)
	rm -rf defines.v
	touch defines.v
	for x in $(DEFS); do echo '`define' $$x >> defines.v; done
	echo "create_project -force -part $(FPGA_PART) $*" > create_project.tcl
	echo "add_files -fileset sources_1 defines.v" >> create_project.tcl
	for x in $(SYN_FILES_REL); do echo "add_files -fileset sources_1 $$x" >> create_project.tcl; done
	for x in $(XDC_FILES_REL); do echo "add_files -fileset constrs_1 $$x" >> create_project.tcl; done
	for x in $(XCI_FILES_REL); do echo "import_ip $$x" >> create_project.tcl; done
	echo "exit" >> create_project.tcl
	vivado -nojournal -nolog -mode batch -source create_project.tcl

# synthesis run
%.runs/synth_1/%.dcp: %.xpr $(SYN_FILES_REL) $(INC_FILES_REL) $(XDC_FILES_REL)
	echo "open_project $*.xpr" > run_synth.tcl
	echo "set_property PR_FLOW 1 [current_project]" >> run_synth.tcl
	echo "create_partition_def -name pr_riscv -module riscv_block" >> run_synth.tcl
	echo "create_reconfig_module -name riscv_block -partition_def [get_partition_defs pr_riscv ]  -define_from riscv_block" >> run_synth.tcl
	echo "update_compile_order -fileset riscv_block" >> run_synth.tcl
	echo "update_compile_order -fileset sources_1" >> run_synth.tcl
	echo "reset_run synth_1" >> run_synth.tcl
	echo "launch_runs synth_1 -jobs 12" >> run_synth.tcl
	echo "wait_on_run synth_1" >> run_synth.tcl
	echo "exit" >> run_synth.tcl
	vivado -nojournal -nolog -mode batch -source run_synth.tcl

# implementation run
%.runs/impl_1/%_routed.dcp: %.runs/synth_1/%.dcp
	echo "open_project $*.xpr" > run_impl.tcl
	echo "set_property AUTO_INCREMENTAL_CHECKPOINT 1 [get_runs impl_1]" >> run_impl.tcl
	echo "set_property PR_FLOW 1 [current_project]" >> run_impl.tcl
	echo "create_pr_configuration -name config_1 -partitions [list core_inst/riscv_cores[0].riscv_block_inst:riscv_block core_inst/riscv_cores[1].riscv_block_inst:riscv_block core_inst/riscv_cores[2].riscv_block_inst:riscv_block core_inst/riscv_cores[3].riscv_block_inst:riscv_block core_inst/riscv_cores[4].riscv_block_inst:riscv_block core_inst/riscv_cores[5].riscv_block_inst:riscv_block core_inst/riscv_cores[6].riscv_block_inst:riscv_block core_inst/riscv_cores[7].riscv_block_inst:riscv_block core_inst/riscv_cores[8].riscv_block_inst:riscv_block core_inst/riscv_cores[9].riscv_block_inst:riscv_block core_inst/riscv_cores[10].riscv_block_inst:riscv_block core_inst/riscv_cores[11].riscv_block_inst:riscv_block core_inst/riscv_cores[12].riscv_block_inst:riscv_block core_inst/riscv_cores[13].riscv_block_inst:riscv_block core_inst/riscv_cores[14].riscv_block_inst:riscv_block core_inst/riscv_cores[15].riscv_block_inst:riscv_block ]" >> run_impl.tcl
	echo "set_property PR_CONFIGURATION config_1 [get_runs impl_1]" >> run_impl.tcl
	echo "reset_run impl_1" >> run_impl.tcl
	echo "launch_runs impl_1 -jobs 12" >> run_impl.tcl
	echo "wait_on_run impl_1" >> run_impl.tcl
	echo "exit" >> run_impl.tcl
	vivado -nojournal -nolog -mode batch -source run_impl.tcl

# bit file
%.bit: %.runs/impl_1/%_routed.dcp
	echo "open_project $*.xpr" > generate_bit.tcl
	echo "open_run impl_1" >> generate_bit.tcl
	echo "write_debug_probes -force debug_probes.ltx" >> generate_bit.tcl
	echo "report_utilization -force -hierarchical  -file fpga_utilization_hierarchy_placed.rpt" >> generate_bit.tcl
	echo "write_bitstream -force $*.bit" >> generate_bit.tcl
	echo "exit" >> generate_bit.tcl
	vivado -nojournal -nolog -mode batch -source generate_bit.tcl
	mkdir -p rev
	EXT=bit; COUNT=100; \
	while [ -e rev/$*_rev$$COUNT.$$EXT ]; \
	do COUNT=$$((COUNT+1)); done; \
	cp $@ rev/$*_rev$$COUNT.$$EXT; \
	echo "Output: rev/$*_rev$$COUNT.$$EXT";

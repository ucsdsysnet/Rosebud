# Targets
TARGETS:=

# Subdirectories
SUBDIRS = fpga
SUBDIRS_CLEAN = $(patsubst %,%.clean,$(SUBDIRS))

# Rules
.PHONY: all
all: $(SUBDIRS) $(TARGETS)

.PHONY: $(SUBDIRS)
$(SUBDIRS):
	cd $@ && $(MAKE)

.PHONY: $(SUBDIRS_CLEAN)
$(SUBDIRS_CLEAN):
	cd $(@:.clean=) && $(MAKE) clean

.PHONY: clean
clean: $(SUBDIRS_CLEAN)
	-rm -rf $(TARGETS) vivado* fpga/hd_visual

program:
	#djtgcfg prog -d Atlys --index 0 --file fpga/fpga.bit

# Runs after main run in order
FW_RR_1:
	cd fpga && vivado -nojournal -nolog -mode batch -source run_FW_RR.tcl 2>&1 | tee FW_RR.log

parse_log:
	grep "WARNING" fpga/run.log | grep -v "Unused" | grep -v "given" | grep -v "driven by" | grep -v "unconnected or" | grep -v "lib/pcie" | grep -v "lib/corundum" > parsed_log.txt

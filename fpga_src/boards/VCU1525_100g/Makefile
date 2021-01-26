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

parse_log:
	grep "WARNING" fpga/run.log | grep -v "replication" | grep -v "parameter declaration" | grep -v "Unused" | grep -v "given" > parsed_log.txt 

add_accel:
	cd fpga && vivado -nojournal -nolog -mode batch -source run_add_accel.tcl 2>&1 | tee add_accel.log

swap_sched:
	cd fpga && vivado -nojournal -nolog -mode batch -source run_swap_sched.tcl 2>&1 | tee swap_sched.log

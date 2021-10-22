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
IDS_Hash_1:
	cd fpga && vivado -nojournal -nolog -mode batch -source run_IDS_Hash.tcl 2>&1 | tee IDS_Hash.log

IDS_RR_2:
	cd fpga && vivado -nojournal -nolog -mode batch -source run_IDS_RR_inc.tcl 2>&1 | tee IDS_RR.log

PIG_Hash_1:
	cd fpga && vivado -nojournal -nolog -mode batch -source run_PIG_Hash.tcl 2>&1 | tee PIG_Hash.log

PIG_base_2:
	cd fpga && vivado -nojournal -nolog -mode batch -source run_base_RR.tcl 2>&1 | tee base_RR.log

PIG_RR_3:
	cd fpga && vivado -nojournal -nolog -mode batch -source run_PIG_RR_merge.tcl 2>&1 | tee PIG_RR.log

IDS_RR_direct:
	cd fpga && vivado -nojournal -nolog -mode batch -source run_IDS_RR_direct.tcl 2>&1 | tee IDS_RR_direct.log

parse_log:
	grep "WARNING" fpga/run.log | grep -v "license" | grep -v "replication" | grep -v "parameter declaration" | grep -v "Unused" | grep -v "given" > parsed_log.txt 
parse_log2:
	grep "WARNING" fpga/run.log | grep -v "license" | grep -v "replication" | grep -v "parameter declaration" | grep -v "Unused" | grep -v "given" | grep -v "simple_fifo" | grep -v "status_line_count" > parsed_log.txt

parse_log3:
	grep "WARNING" fpga/run.log | grep -v "license" | grep -v "replication" | grep -v "parameter declaration" | grep -v "Unused" | grep -v "given" | grep -v "simple_fifo" | grep -v "status_line_count" | grep -v "driven by" | grep -v "unconnected or" > parsed_log.txt

parse_log_p:
	grep "WARNING" fpga/PIG_Hash.log | grep -v "license" | grep -v "replication" | grep -v "parameter declaration" | grep -v "Unused" | grep -v "given" | grep -v "simple_fifo" | grep -v "status_line_count" | grep -v "driven by" | grep -v "unconnected or" > parsed_log_p.txt

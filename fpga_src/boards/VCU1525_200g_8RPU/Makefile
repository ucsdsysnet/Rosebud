# Targets
TARGETS:=

# Subdirectories
SUBDIRS = fpga
SUBDIRS_CLEAN = $(patsubst %,%.clean,$(SUBDIRS))

# Rules
.PHONY: all
all: base_0 PIG_Hash_1 PIG_base_2 PIG_RR_3

.PHONY: clean
clean:
	rm -rf vivado* *.txt
	make -C fpga clean

base_0:
	make -C fpga 2>&1 | tee fpga/base_run.log

PIG_Hash_1:
	cd fpga && vivado -nojournal -nolog -mode batch -source run_PIG_Hash.tcl 2>&1 | tee PIG_Hash.log

PIG_base_2:
	cd fpga && vivado -nojournal -nolog -mode batch -source run_base_RR.tcl 2>&1 | tee base_RR.log

PIG_RR_3:
	cd fpga && vivado -nojournal -nolog -mode batch -source run_PIG_RR_merge.tcl 2>&1 | tee PIG_RR.log

parse_log:
	grep "WARNING" fpga/base_run.log | grep -v "Unused" | grep -v "given" | grep -v "driven by" | grep -v "unconnected or" | grep -v "lib/pcie" | grep -v "lib/corundum" > parsed_log.txt

parse_log_pig:
	grep "WARNING" fpga/PIG_Hash.log | grep -v "Unused" | grep -v "given" | grep -v "driven by" | grep -v "unconnected or" > parsed_log.txt

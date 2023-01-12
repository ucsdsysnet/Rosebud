# Subdirectories
SUBDIRS = fpga
SUBDIRS_CLEAN = $(patsubst %,%.clean,$(SUBDIRS))

# Rules
.PHONY: all
all: base_0 FW_RR_1

.PHONY: clean
clean:
	rm -rf vivado* *.txt
	make -C fpga clean

base_0:
	make -C fpga 2>&1 | tee fpga/base_run.log

FW_RR_1:
	cd fpga && vivado -nojournal -nolog -mode batch -source run_FW_RR.tcl 2>&1 | tee FW_RR.log

parse_log:
	grep "WARNING" fpga/base_run.log | grep -v "Unused" | grep -v "given" | grep -v "driven by" | grep -v "unconnected or" | grep -v "lib/pcie" | grep -v "lib/corundum" > parsed_log.txt

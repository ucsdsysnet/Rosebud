# Test selection

TEST=basic_fw
# TEST=pkt_gen
DEST_DIR=../../riscv_code/
# DEST_DIR=../accel/ip_matcher/c/
PKT_SIZE=9000

# Corresponding input and output files
PR_FILES=bitstreams
INS_BIN_FILE=$(DEST_DIR)/$(TEST)_ins.bin
DATA_MAP_FILE=$(INS_BIN_FILE:%_ins.bin=%.map)
OUT_FILE=$(TEST)_$(PKT_SIZE).csv

# System and run parameters
RPUS=16
DEV=mqnic0
ENABLE=0xffff
RECV=0xffff
DEBUG=8
BLOCK_INTS=0

PCI_ID=$(subst ../,,$(shell readlink /sys/class/misc/$(DEV)/device))

ifneq ("$(wildcard $(DATA_MAP_FILE))","")
	DMAP_FLAG = -m $(DATA_MAP_FILE)
else
	DMAP_FLAG=
endif

DMAP=0

CC = gcc
CFLAGS = -O3 -Wall -I../driver/mqnic -I./mcap

MCAPLIB = mcap/libmcap.a

BIN=dump perf rvfw pr_reload

GENDEPFLAGS = -MD -MP -MF .$(@F).d

ALL_CFLAGS = $(CFLAGS) $(GENDEPFLAGS)

all: $(BIN)

$(MCAPLIB):
	$(MAKE) -C mcap libmcap.a

%.o: %.c
	$(CC) $(ALL_CFLAGS) -c -o $@ $<

dump: dump.o mqnic.o rpu.o
	$(CC) $(ALL_CFLAGS) $^ -o $@

perf: perf.o mqnic.o timespec.o rpu.o
	$(CC) $(ALL_CFLAGS) $^ -o $@

rvfw: rvfw.o mqnic.o rpu.o
	$(CC) $(ALL_CFLAGS) $^ -o $@

pr_reload: pr_reload.o mqnic.o rpu.o $(MCAPLIB)
	$(CC) $(ALL_CFLAGS) $^ $(MCAPLIB) -ludev -lpci -lz -o $@

clean:
	$(MAKE) -C mcap clean
	rm -f $(BIN)
	rm -f *.o
	rm -f .*.d

-include $(wildcard .*.d)

.PHONY: all install clean

do: $(BIN)
	make -C $(DEST_DIR) NAME=$(TEST) DEFINES="-DPKT_SIZE=$(PKT_SIZE)"
	sudo ./rvfw -d /dev/$(DEV) -i $(INS_BIN_FILE) $(DMAP_FLAG) -e $(ENABLE) -r $(RECV) -c $(RPUS) -b $(BLOCK_INTS)
	sudo ./perf -d /dev/$(DEV) -o $(OUT_FILE) -c $(RPUS) -g $(DEBUG)

status:
	sudo ./perf -d /dev/$(DEV) -o $(OUT_FILE) -g $(DEBUG) -c $(RPUS) 

pr_test:
	sudo ./pr_reload -d /dev/$(DEV) -i $(INS_BIN_FILE) $(DMAP_FLAG) -e $(ENABLE) -r $(RECV) -c $(RPUS) -p $(PR_FILES)

reset_all:
	sudo sh -c "lspci -d 1234:1001 | cut -d ' ' -f 1 | xargs -L 1 ./pcie_hot_reset.sh"

reset_dev:
	sudo ./pcie_hot_reset.sh $(PCI_ID)

TEST=basic_fw
SIZE=9000
DEST_DIR=../../riscv_code/
# DEST_DIR=../accel/ip_matcher/c/
INS_BIN_FILE=$(DEST_DIR)/$(TEST)_ins.bin
DATA_MAP_FILE=$(INS_BIN_FILE:%_ins.bin=%.map)
OUT_FILE=$(TEST)_$(SIZE).csv
DEV=mqnic0
ENABLE=0xffff
RECV=0xffff
DEBUG=8
PR_FILES=bitstreams
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

dump: dump.o mqnic.o gousheh.o
	$(CC) $(ALL_CFLAGS) $^ -o $@

perf: perf.o mqnic.o timespec.o gousheh.o
	$(CC) $(ALL_CFLAGS) $^ -o $@

rvfw: rvfw.o mqnic.o gousheh.o
	$(CC) $(ALL_CFLAGS) $^ -o $@

pr_reload: pr_reload.o mqnic.o gousheh.o $(MCAPLIB)
	$(CC) $(ALL_CFLAGS) $^ $(MCAPLIB) -ludev -lpci -lz -o $@

clean:
	$(MAKE) -C mcap clean
	rm -f $(BIN)
	rm -f *.o
	rm -f .*.d

-include $(wildcard .*.d)

.PHONY: all install clean

do:
	make -C $(DEST_DIR) NAME=$(TEST)
	sudo ./rvfw -d /dev/$(DEV) -i $(INS_BIN_FILE) $(DMAP_FLAG) -e $(ENABLE) -r $(RECV)
	sudo ./perf -d /dev/$(DEV) -o $(OUT_FILE) -g $(DEBUG)

status:
	sudo ./perf -d /dev/$(DEV) -o $(OUT_FILE) -g $(DEBUG)

pr_test:
	sudo ./pr_reload -d /dev/$(DEV) -i $(INS_BIN_FILE) $(DMAP_FLAG) -e $(ENABLE) -r $(RECV) -p $(PR_FILES)

reset:
	sudo sh -c "lspci -d 1234:1001 | cut -d ' ' -f 1 | xargs -L 1 ./pcie_hot_reset.sh"

reset0:
	sudo ./pcie_hot_reset.sh 81:00.0
reset1:
	sudo ./pcie_hot_reset.sh 01:00.0

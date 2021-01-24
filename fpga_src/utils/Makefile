TEST=basic_fw2
SIZE=9000
PREFIX=/usr/local
BINDIR=$(DESTDIR)$(PREFIX)/bin
INS_BIN_FILE=../../c_code/$(TEST)_ins.bin
DATA_MAP_FILE=$(INS_BIN_FILE:%_ins.bin=%.map)
OUT_FILE=$(TEST)_$(SIZE).csv
DEV=mqnic0
ENABLE=0xffff
RECV=0xffff
DEBUG=8
ifneq ("$(wildcard $(DATA_MAP_FILE))","")
	DMAP_FLAG = -m $(DATA_MAP_FILE)
else
	DMAP_FLAG= 
endif

DMAP=0

CC=gcc
CFLAGS=-O3 -Wall -I../driver/mqnic

BIN=dump perf rvfw

all: $(BIN)

mcap/libmcap.a:
	$(MAKE) -C mcap libmcap.a

dump: dump.c mqnic.c gousheh.c
	$(CC) $(CFLAGS) $^ -o $@

perf: perf.c mqnic.c timespec.c gousheh.c
	$(CC) $(CFLAGS) $^ -o $@

rvfw: rvfw.c mqnic.c gousheh.c mcap/libmcap.a
	$(CC) $(CFLAGS) $^ -o $@

install:
	install -d $(BINDIR)
	install -m 0755 $(BIN) $(BINDIR)

clean:
	$(MAKE) -C mcap clean
	rm -f $(BIN)

do:
	make -C ../../c_code/ NAME=$(TEST)
	sudo ./rvfw -d /dev/$(DEV) -i $(INS_BIN_FILE) $(DMAP_FLAG) -e $(ENABLE) -r $(RECV)
	sudo ./perf -d /dev/$(DEV) -o $(OUT_FILE) -g $(DEBUG)

reset: 
	sudo sh -c "lspci -d 1234:1001 | cut -d ' ' -f 1 | xargs -L 1 ./pcie_hot_reset.sh"


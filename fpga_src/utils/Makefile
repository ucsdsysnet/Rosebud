TEST=basic_fw2
SIZE=9000
PREFIX=/usr/local
BINDIR=$(DESTDIR)$(PREFIX)/bin
BIN_FILE=/home/moein/BumpinTheWire/c_code/$(TEST).bin
OUT_FILE=$(TEST)_$(SIZE).csv
DEV=mqnic0
ENABLE=0xffff
RECV=0xffff
DEBUG=8

CC=gcc
CFLAGS=-O3 -Wall -I../driver/mqnic

BIN=dump perf rvfw

all: $(BIN)

dump: dump.c mqnic.c
	$(CC) $(CFLAGS) $^ -o $@

perf: perf.c mqnic.c timespec.c
	$(CC) $(CFLAGS) $^ -o $@

rvfw: rvfw.c mqnic.c
	$(CC) $(CFLAGS) $^ -o $@

install:
	install -d $(BINDIR)
	install -m 0755 $(BIN) $(BINDIR)

clean:
	rm -f $(BIN)

do:
	make -C ../../c_code/ NAME=$(TEST)
	sudo ./rvfw -d /dev/$(DEV) -w $(BIN_FILE) -e $(ENABLE) -r $(RECV)
	sudo ./perf -d /dev/$(DEV) -o $(OUT_FILE) -g $(DEBUG)

reset: 
	sudo sh -c "lspci -d 1234:1001 | cut -d ' ' -f 1 | xargs -L 1 ./pcie_hot_reset.sh"


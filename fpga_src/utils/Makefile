TEST=rx_bw
SIZE=64
PREFIX=/usr/local
BINDIR=$(DESTDIR)$(PREFIX)/bin
BIN_FILE=/home/moein/BumpinTheWire/c_code/$(TEST).bin
OUT_FILE=$(TEST)_$(SIZE).csv
DEV=mqnic0
ENABLE=0xffff
RECV=0xf000

CC=gcc
CFLAGS=-O3 -Wall -I../driver/mqnic

BIN=dump perf rvfw

all: $(BIN)

dump: dump.c mqnic.c
	$(CC) $(CFLAGS) $^ -o $@

perf: perf.c mqnic.c
	$(CC) $(CFLAGS) $^ -o $@

rvfw: rvfw.c mqnic.c
	$(CC) $(CFLAGS) $^ -o $@

install:
	install -d $(BINDIR)
	install -m 0755 $(BIN) $(BINDIR)

clean:
	rm -f $(BIN)

do:
	make -C ~/c/ NAME=$(TEST)
	sudo ./rvfw -d /dev/$(DEV) -w $(BIN_FILE) -e $(ENABLE) -r $(RECV)
	sudo ./perf -d /dev/$(DEV) -o $(OUT_FILE)

reset: 
	sudo sh -c "lspci -d 1234:1001 | cut -d ' ' -f 1 | xargs -L 1 ./pcie_hot_reset.sh"


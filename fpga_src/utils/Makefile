
PREFIX=/usr/local
BINDIR=$(DESTDIR)$(PREFIX)/bin
BIN_FILE=/home/moein/BumpinTheWire/c_code/latency.bin
OUT_FILE=stat_read.csv
DEV=mqnic1
ENABLE=0xffff
RECV=0xff00

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
	make -C ~/c/
	sudo ./rvfw -d /dev/$(DEV) -w $(BIN_FILE) -e $(ENABLE) -r $(RECV)
	sudo ./perf -d /dev/$(DEV) -o $(OUT_FILE)


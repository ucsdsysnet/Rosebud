
PREFIX=/usr/local
BINDIR=$(DESTDIR)$(PREFIX)/bin

CC=gcc
CFLAGS=-O3 -Wall -I../driver/mqnic

BIN=dump perf

all: $(BIN)

dump: dump.c mqnic.c
	$(CC) $(CFLAGS) $^ -o $@

perf: perf.c mqnic.c
	$(CC) $(CFLAGS) $^ -o $@

install:
	install -d $(BINDIR)
	install -m 0755 $(BIN) $(BINDIR)

clean:
	rm -f $(BIN)


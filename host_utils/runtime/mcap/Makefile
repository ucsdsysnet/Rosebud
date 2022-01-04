# Makefile for Xilinx MCAP Interface Library
# (c) 2014-2015 Xilinx Inc.

INCLUDES = -I.

OPT=-O2
CFLAGS=$(OPT) -Wall -W -Wno-parentheses -Wstrict-prototypes -Wmissing-prototypes $(INCLUDES)

MCAPLIB = libmcap.a
MCAPINC = mcap_lib.h

OBJ = mcap_lib.o

all: $(MCAPLIB) mcap

$(MCAPLIB): $(OBJ)
	ar rcs $(MCAPLIB) $(OBJ)

$(OBJ):
	gcc $(CFLAGS) -c mcap_lib.c $< -o $@

mcap: mcap.o
	gcc $(CFLAGS) mcap.c $(MCAPLIB) -ludev -lpci -lz -o mcap

clean:
	rm -f *.o *.a mcap

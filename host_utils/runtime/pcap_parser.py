#!/usr/bin/env python

import sys
import dpkt
import struct

if (len(sys.argv)!=2):
    print ("Enter input pcap")
else:
    with open(str(sys.argv[1]), 'rb') as f:
        pcap = dpkt.pcap.Reader(f)
        for timestamp, buf in pcap:
            
            # print each 4 bytes as an unsigned integer
            if (len(buf)==1500):
                for i in range(0,len(buf),4):
                    clock_cycles = struct.unpack("I", buf[i:i+4])[0]
                    if (clock_cycles > 100000000): clock_cycles = 4294967295 - clock_cycles
                    nanoseconds = clock_cycles*4
                    if (nanoseconds !=0):
                        print (nanoseconds)

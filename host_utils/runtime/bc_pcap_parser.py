#!/usr/bin/env python

import sys
import dpkt
import struct

temp_send = 0;

if (len(sys.argv)!=2):
    print ("Enter input pcap")
else:
    with open(str(sys.argv[1]), 'rb') as f:
        pcap = dpkt.pcap.Reader(f)
        for timestamp, buf in pcap:

            # print each 4 bytes as an unsigned integer
            if (len(buf)==1496):
                for i in range(0,len(buf),8):
                    send_time = struct.unpack("I", buf[i:i+4])[0]
                    recv_time = struct.unpack("I", buf[i+4:i+8])[0]
                    nanoseconds = (recv_time-send_time)*4
                    if ((send_time != temp_send) and (nanoseconds > 0)):
                        print (nanoseconds)
                    temp_send=send_time

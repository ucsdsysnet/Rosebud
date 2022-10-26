#!/usr/bin/env python3

"""

Copyright (c) 2021 Moein Khazraee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

"""

import random

from scapy.layers.l2 import Ether
from scapy.layers.inet import IP, UDP, TCP, fragment
from scapy.utils import PcapWriter

# pcap_name   = "safe_pcap_no_ooo_128.pcap"
pcap_name   = "safe_pcap_6_perc_128.pcap"
min_size    = 128
max_size    = 128
reorder_per = 6
sport       = 1234
dport       = 5678
udp_count   = 2500 # same number of TCP flows

r = random.Random(521)

def random_ip():
  return str(r.randint(0,255))+"."+str(r.randint(0,255))+"."+str(r.randint(0,255))+"."+str(r.randint(0,255))

def make_ooo(pkts, min_index, min_dist, max_dist):
    ind1 = random.randrange(min_index, len(pkts)-max_dist)
    ind2 = random.randrange(ind1+min_dist, ind1+max_dist)
    pkts.insert(ind2,pkts.pop(ind1))

def main():
    pcap  = PcapWriter(open(pcap_name, 'wb'), sync=True)
    eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
    pcaps = []

    for i in range(udp_count):
        ip = IP(src=random_ip(), dst='192.168.1.101')

        pkt_len = r.randint(min_size, max_size)
        udp = UDP(sport=sport, dport=dport)
        payload = bytes([x % 256 for x in range(pkt_len-42)])
        pcaps.append(eth / ip / udp / payload)

        pkt_len = r.randint(min_size, max_size)
        seq_num = random.randrange(0,2**32)
        tcp = TCP(sport=sport, dport=dport, seq=seq_num, flags="S")
        payload = bytes([r.randint(0,255) for x in range(pkt_len-54)])
        # payload = bytes([x % 256 for x in range(pkt_len)])
        pcaps.append(eth / ip / tcp / payload)
        seq_num = seq_num + pkt_len + 1

        for k in range(r.randint(3, 8)):
            pkt_len = r.randint(min_size, max_size)
            tcp = TCP(sport=sport, dport=dport, seq=seq_num, flags="PA")
            payload = bytes([r.randint(0,255) for x in range(pkt_len-54)])
            pcaps.append(eth / ip / tcp / payload)
            seq_num += pkt_len

        pkt_len = r.randint(min_size, max_size)
        tcp = TCP(sport=sport, dport=dport, seq=seq_num, flags="F")
        payload = bytes([r.randint(0,255) for x in range(pkt_len-54)])
        pcaps.append(eth / ip / tcp / payload)

    for i in range (int(reorder_per*len(pcaps)//100.0)):
      make_ooo(pcaps, 2*udp_count, 6, 100)

    for pkt in pcaps:
      pcap.write(pkt)

    pcap.close()

if __name__ == "__main__":
    main()

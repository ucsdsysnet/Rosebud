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

pcap_name = "safe_pcap.pcap"
min_size  = 128
max_size  = 1440

r = random.Random(521)

min_port_val = 1024
max_port_val = 49151

def random_ip():
  return str(r.randint(0,255))+"."+str(r.randint(0,255))+"."+str(r.randint(0,255))+"."+str(r.randint(0,255))

def main():
    pcap  = PcapWriter(open(pcap_name, 'wb'), sync=True)
    eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')

    for i in range(50000):
        ip = IP(src=random_ip(), dst='192.168.1.101')

        pkt_len = r.randint(min_size, max_size)
        udp = UDP(sport=1234, dport=5678)
        payload = bytes([x % 256 for x in range(pkt_len)])
        pcap.write(eth / ip / udp / payload)

        pkt_len = r.randint(min_size, max_size)
        tcp = TCP(sport=1234, dport=5678, flags="S", seq=random.randrange(0,2**32))
        payload = bytes([x % 256 for x in range(pkt_len)])
        pcap.write(eth / ip / tcp / payload)

        pkt_len = r.randint(min_size, max_size)
        tcp = TCP(sport=12345, dport=80, flags = "S")
        payload = bytes([x % 256 for x in range(pkt_len)])
        pcap.write(eth / ip / tcp / payload)

        pkt_len = r.randint(min_size, max_size)
        tcp = TCP(sport=54321, dport=80, flags = "F")
        payload = bytes([x % 256 for x in range(pkt_len)])
        pcap.write(eth / ip / tcp / payload)

    pcap.close()

if __name__ == "__main__":
    main()

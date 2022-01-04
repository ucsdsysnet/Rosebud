"""

Copyright (c) 2019-2021 Moein Khazraee

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
from scapy.layers.inet import IP, UDP, TCP
from scapy.utils import PcapWriter

r = random.Random(521)

rules = open('firewall.txt','r')
pcap  = PcapWriter(open('firewall_test.pcap', 'wb'), sync=True)

# test packets which shouldn't be dropped
eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
ip = IP(src='192.168.1.100', dst='192.168.1.101')

udp = UDP(sport=1234, dport=5678)
payload = bytes([x % 256 for x in range(256)])
pcap.write(eth / ip / udp / payload)

tcp = TCP(sport=1234, dport=5678)
payload = bytes([x % 256 for x in range(256)])
pcap.write(eth / ip / tcp / payload)

tcp = TCP(sport=12345, dport=80)
payload = bytes([x % 256 for x in range(256)])
pcap.write(eth / ip / tcp / payload)

tcp = TCP(sport=54321, dport=80)
payload = bytes([x % 256 for x in range(256)])
pcap.write(eth / ip / tcp / payload)

# Packets with src ip in firewall rules
for line in rules:
    src_ip = line.strip().split('/')[0]
    eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
    ip = IP(src=src_ip, dst='192.168.1.101')
    udp = UDP(sport=1234, dport=5678)
    tcp = TCP(sport=1234, dport=5678)
    payload = bytes([x % 256 for x in range(r.randint(64, 500))])
    pcap.write(eth / ip / udp / payload)
    pcap.write(eth / ip / tcp / payload)

rules.close()
pcap.close()

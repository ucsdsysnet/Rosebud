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

#!/usr/bin/env python
"""
Copyright 2020, The Regents of the University of California.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE REGENTS OF THE UNIVERSITY OF CALIFORNIA ''AS
IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE REGENTS OF THE UNIVERSITY OF CALIFORNIA OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of The Regents of the University of California.
"""

import argparse
import collections
import os
import re
import random

from idstools.rule import parse

from scapy.layers.l2 import Ether
from scapy.layers.inet import IP, UDP, TCP, fragment
from scapy.utils import PcapWriter

HTTP_PORTS=[36,80,81,82,83,84,85,86,87,88,89,90,311,383,555,591,593,631,801,808,818,901,972,1158,1220,1414,1533,1741,1812,1830,1942,2231,2301,2381,2578,2809,2980,3029,3037,3057,3128,3443,3702,4000,4343,4848,5000,5117,5250,5450,5600,5814,6080,6173,6988,7000,7001,7005,7071,7144,7145,7510,7770,7777,7778,7779,8000,8001,8008,8014,8015,8020,8028,8040,8080,8081,8082,8085,8088,8090,8118,8123,8180,8181,8182,8222,8243,8280,8300,8333,8344,8400,8443,8500,8509,8787,8800,8888,8899,8983,9000,9002,9060,9080,9090,9091,9111,9290,9443,9447,9710,9788,9999,10000,11371,12601,13014,15489,19980,29991,33300,34412,34443,34444,40007,41080,44449,50000,50002,51423,53331,55252,55555,56712]

r = random.Random(521)

min_port_val = 1024
max_port_val = 49151

def parse_content_string(s):
    """
    Parse content string and convert to byte string

    Converts hex sections delineated with pipes

    an example|20|string|0d 0a|

    b'an example string\r\n'

    """
    b = bytearray()
    offset = 0

    while offset < len(s):
        if '|' in s[offset:]:
            rs = s.index('|', offset)
            re = s.index('|', rs+1)

            b.extend(s[offset:rs].encode('utf-8'))
            b.extend(bytearray.fromhex(s[rs+1:re]))

            offset = re+1
        else:
            b.extend(s[offset:].encode('utf-8'))
            break

    return bytes(str(b)[12:-2].encode('utf-8').upper())

def fast_pattern_extractor (line):
  if (len(line.strip()) == 0):
    return "", ""
  else:
    fast_pattern = ""
    pattern_len  = 0
    unknown_flag = False
    fast_flag    = False

    rule    = parse(line)
    options = rule['options']
    header  = rule['header']

    # idstools doesn't always find sid by itself!
    sid = re.findall("sid:[0-9]+;", line)
    sid = int(re.findall("[0-9]+", sid[0])[0])

    for opt in options:
      if opt['name'] == 'content':
        value = re.findall('"([^"]*)"', opt['value'])[0]
        flags = opt['value'][len(value)+3:]
        cont_len = len(parse_content_string(value))

        if "fast_pattern" in flags:
          fast_pattern = value[:]
          fast_flag = True
          if opt['value'].startswith("!"):
            unknown_flag = True
          break

        elif opt['value'].startswith("!"):

          # Not acceptable for fast pattern
          if (len(flags)!=0):
            if ("relative" in flags) or ("case" in flags) or ("offset" in flags) or \
              ("depth" in flags) or ("within" in flags) or ("distance" in flags):
              continue

          # Acceptable but not long enough
          elif (cont_len <= pattern_len):
              continue

          # Acceptable, not sure what to do for hardware check
          # might get overriden by a longer pattern
          else:
            unknown_flag = True
            pattern_len = cont_len
            continue

        else:
          # No \" in curent content rules, might not be always true
          # re strips of the ! and ""
          if (cont_len>pattern_len):
            unknown_flag = False
            fast_pattern = value[:]
            pattern_len = cont_len

    # if unknown_flag:
    #   print ("WARNING: used", fast_pattern, "for", line,'\n')

    return fast_pattern, header, sid, unknown_flag

def port_gen (query):
  has_http = False
  if ("$HTTP_PORTS," in query):
    query = query.replace("$HTTP_PORTS,", "")
    has_http = True
  if (",$HTTP_PORTS" in query):
    query = query.replace(",$HTTP_PORTS", "")
    has_http = True
  if (query.startswith("[")):
    query = query[1:-1]

  if (query=="$HTTP_PORTS"):
    return r.choice(HTTP_PORTS)
  elif (query=="$FILE_DATA_PORTS"):
    return r.choice(HTTP_PORTS+[110, 143])
  elif (query=="$FTP_PORTS"):
    return r.choice([21, 2100, 3535])
  elif (query=="$ORACLE_PORTS"):
    return random.randint(1024, max_port_val)
  elif (":" in query):
    if (query[-1]==":"):
      ports = [int(x) for x in query[:-1].split(",")]
      if (len(ports)==1):
        if (has_http):
          return r.choice(list(range(ports[0],max_port_val)) + HTTP_PORTS)
        else:
          return random.randint(ports[0], max_port_val)
      else:
        if (has_http):
          return r.choice(ports[:-1]+HTTP_PORTS+list(range(ports[-1], max_port_val)))
        else:
          return r.choice(ports[:-1]+list(range(ports[-1], max_port_val)))
    else:
      ports = query.split(",")
      if (len(ports)==1):
        [low, high] = [int(x) for x in ports[0].split(":")]
        if (has_http):
          return r.choice(list(range(low, high)) + HTTP_PORTS)
        else:
          return random.randint(low, high)
      elif (len(ports)==2):
        if (has_http):
          print("case not supported", query)
          return -1
        elif (":" in ports[0]):
          [low, high] = [int(x) for x in ports[0].split(":")]
          return r.choice(list(range(low, high)) + [int(ports[1])])
        else:
          [low, high] = [int(x) for x in ports[1].split(":")]
          return r.choice(list(range(low, high)) + [int(ports[0])])
      else:
        print("case not supported")
        return -1

  elif (query=="any"):
    return random.randint(min_port_val, max_port_val)
  else:
    ports = [int(x) for x in query.split(",")]
    if (has_http):
      return r.choice(HTTP_PORTS+ports)
    else:
      return r.choice(ports)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--rules_file', type=str, default=[], action='append', help="Rules file")
    parser.add_argument('--selected_file', type=str, default=None, help="Selected Rules file")
    parser.add_argument('--summary_file', type=str, default="attack_summary.txt", help="Summary file")
    parser.add_argument('--details_file', type=str, default="attack_details.txt", help="Details file")
    parser.add_argument('--output_pcap', type=str, default='attack.pcap', help="Pcap output file name")
    parser.add_argument('--pcap_limit', type=int, default=0, help="Max PCAP rules")
    parser.add_argument('--test_packets', type=bool, default=False, help="Add non-matching test packets")
    args = parser.parse_args()

    sumf =  open(args.summary_file, 'w')
    detf =  open(args.details_file, 'w')
    pcap = PcapWriter(open(args.output_pcap, 'wb'), sync=True)

    id_map = {}
    i = 1;
    if (args.selected_file):
        for line in open(args.selected_file,"r"):
            id_map[int(line)] = i
            i += 1

    if (args.test_packets):
        if (args.pcap_limit!=0):
            if (args.pcap_limit>4):
                pcap_limit = args.pcap_limit - 4
            else:
                print ("Error, not enough pcap rules for test packets.")
                pcap_limit = 1
        else:
            pcap_limit = 0
    else:
        pcap_limit = args.pcap_limit

    rule_count = 0
    dropped = 0
    match_list = []

    for fn in args.rules_file:
        with open(fn, 'r') as f:
            for w in f.read().splitlines():
                if (len(w.strip()) != 0):
                    pattern, header, sid, unknown = fast_pattern_extractor(w)
                    hdr = header.split()
                    prot     = hdr[1]

                    if (sid in id_map or not args.selected_file):
                        if (unknown or not (prot=="tcp" or prot=="udp")):
                            dropped += 1
                        else:
                            rule_count += 1
                            b = parse_content_string(pattern)
                            if not b:
                                if w:
                                    print ("ERROR: No patterns found for", w,'\n')
                                continue

                            src_port = port_gen(hdr[3])
                            dst_port = port_gen(hdr[6])
                            match_list.append((b, prot, src_port, dst_port, random.randrange(0,2**32)))

                            if (rule_count <= pcap_limit) or (pcap_limit == 0):
                                detf.write("Extracted pattern: "+str(b)+", protocol: "+prot+ \
                                           ", src_port: "+str(src_port)+", dst_port: "+str(dst_port)+ \
                                            ", rule ID: "+str(id_map[sid])+", Original rule:\n"+w+"\n\n")

                                sumf.write("Writing "+prot+" packet from port "+str(src_port)+ \
                                           " to port "+str(dst_port)+" with pattern "+str(b)+ \
                                           " in paylod (rule id "+str(id_map[sid])+").\n")

    print ("Dropped rules: %d, Total filtered rules: %d" %(dropped, rule_count))

    eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
    ip = IP(src='192.168.1.100', dst='192.168.1.101')

    if (args.test_packets):
        print ("Adding 4 test packets that shouldn't match any rules")

        sumf.write("Writing udp packet from port 1234 to port 5678 with no pattern in paylod.\n")
        udp = UDP(sport=1234, dport=5678)
        payload = bytes([x % 256 for x in range(256)])
        pcap.write(eth / ip / udp / payload)

        sumf.write("Writing tcp packet from port 1234 to port 5678 with no pattern in paylod.\n")
        tcp = TCP(sport=1234, dport=5678, flags="S", seq=random.randrange(0,2**32))
        payload = bytes([x % 256 for x in range(172)])
        pcap.write(eth / ip / tcp / payload)

        sumf.write("Writing tcp packet from port 12345 to port 80 with no pattern in paylod.\n")
        tcp = TCP(sport=12345, dport=80, flags = "S")
        payload = bytes([x % 256 for x in range(4)])
        pcap.write(eth / ip / tcp / payload)

        sumf.write("Writing tcp packet from port 54321 to port 80 with no pattern in paylod.\n")
        tcp = TCP(sport=54321, dport=80, flags = "F")
        payload = bytes([x % 256 for x in range(15)])
        pcap.write(eth / ip / tcp / payload)


    pcap_count = 0
    tcp_count = 0
    for i in range(len(match_list)):
        if ((pcap_limit!=0) and (pcap_count == pcap_limit)):
            break
        else:
            pcap_count += 1

        payload, prot, sport, dport, seq_num = match_list[i]
        pkt_len = max(r.randint(64, 500), len(payload)+1)
        if (prot=='udp'):
            udp = UDP(sport=sport, dport=dport)
            payload += bytes([0xFF for x in range(pkt_len-len(payload))])
            pcap.write(eth / ip / udp / payload)
        else: #tcp
            tcp = TCP(sport=sport, dport=dport, seq=seq_num, flags="S")
            payload += bytes([0xFA for x in range(pkt_len-len(payload))])
            pcap.write(eth / ip / tcp / payload)
            tcp_count += 1
            match_list[i] = (payload, prot, sport, dport, seq_num+pkt_len)


    for k in range(3):
        rep_count = 0
        for i in range(len(match_list)):
            if (rep_count == tcp_count):
                break
            else:
                rep_count += 1

            payload, prot, sport, dport, seq_num = match_list[i]
            pkt_len = max(r.randint(64, 500), len(payload)+1)

            if (prot=='udp'):
                continue
            else: #tcp
                tcp = TCP(sport=sport, dport=dport, seq=seq_num+1, flags="PA")
                payload += bytes([0xBB+k for x in range(pkt_len-len(payload))])
                pcap.write(eth / ip / tcp / payload)
                match_list[i] = (payload, prot, sport, dport, seq_num+pkt_len)

    rep_count = 0
    for i in range(len(match_list)):
        if (rep_count == tcp_count):
            break
        else:
            rep_count += 1

        payload, prot, sport, dport, seq_num = match_list[i]
        pkt_len = max(r.randint(64, 500), len(payload)+1)

        if (prot=='udp'):
            continue
        else: #tcp
            tcp = TCP(sport=sport, dport=dport, seq=seq_num+1, flags="F")
            payload += bytes([0xFF for x in range(pkt_len-len(payload))])
            pcap.write(eth / ip / tcp / payload)
            match_list[i] = (payload, prot, sport, dport, seq_num+pkt_len)

    pcap.close()
    detf.close()
    sumf.close()

if __name__ == "__main__":
    main()

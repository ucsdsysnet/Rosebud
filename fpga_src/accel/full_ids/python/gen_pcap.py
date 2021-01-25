#!/usr/bin/env python3

from scapy.layers.l2 import Ether
from scapy.layers.inet import IP, UDP, TCP
from scapy.utils import PcapWriter

output_pcap = "ids_test.pcap"

with PcapWriter(open(output_pcap, 'wb'), sync=True) as pcap:
    eth = Ether(src='5A:51:52:53:54:55', dst='DA:D1:D2:D3:D4:D5')
    ip = IP(src='192.168.1.100', dst='192.168.1.101')

    # test packets that shouldn't match any rules
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

    # UDP rules
    # ET DOS DNS Amplification Attack Possible Outbound Windows Non-Recursive Root Hint Reserved Port
    # ET DOS DNS Amplification Attack Possible Inbound Windows Non-Recursive Root Hint Reserved Port

    # alert udp $HOME_NET 53 -> $EXTERNAL_NET 1:1023 (msg:"ET DOS DNS Amplification Attack Possible Outbound Windows Non-Recursive Root Hint Reserved Port";
    # content:"|81 00 00 01 00 00|"; depth:6; offset:2; byte_test:2,>,10,0,relative; byte_test:2,>,10,2,relative;
    # content:"|0c|root-servers|03|net|00|"; distance:0;
    # content:"|0c|root-servers|03|net|00|"; distance:0; threshold: type both, track by_dst, seconds 60, count 5; reference:url,twitter.com/sempersecurus/status/763749835421941760; reference:url,pastebin.com/LzubgtVb; classtype:bad-unknown; sid:2023054; rev:2; metadata:attack_target Server, created_at 2016_08_12, deployment Datacenter, performance_impact Low, updated_at 2016_08_12;)

    udp = UDP(sport=53, dport=1001)
    payload = b'\xAB\xCD'+b'\x81\x00\x00\x01\x00\x00'
    payload += b'\x00\x10'+b'\x00\x10'
    payload += b'\x0croot-servers\x03net\x00'+b'\x0croot-servers\x03net\x00'
    pcap.write(eth / ip / udp / payload)

    # ET DOS MC-SQLR Response Outbound Possible DDoS Participation
    # ET DOS MC-SQLR Response Inbound Possible DDoS Target

    # alert udp $HOME_NET 1434 -> $EXTERNAL_NET any (msg:"ET DOS MC-SQLR Response Outbound Possible DDoS Participation";
    # content:"|05|"; depth:1;
    # content:"ServerName|3b|"; nocase;
    # content:"InstanceName|3b|"; distance:0;
    # content:"IsClustered|3b|"; distance:0;
    # content:"Version|3b|"; distance:0; threshold:type both,track by_src,count 30,seconds 60; reference:url,kurtaubuchon.blogspot.com.es/2015/01/mc-sqlr-amplification-ms-sql-server.html; classtype:attempted-dos; sid:2020305; rev:4; metadata:created_at 2015_01_23, updated_at 2015_01_23;)

    udp = UDP(sport=1434, dport=1002)
    payload = b'\x05'+b'ServerName\x3b'+b'InstanceName\x3b'+b'IsClustered\x3b'+b'Version\x3b'
    pcap.write(eth / ip / udp / payload)

    # ET DOS CLDAP Amplification Reflection (PoC based)"; dsize:52;

    # alert udp $EXTERNAL_NET 389 -> $HOME_NET 389 (msg:"ET DOS CLDAP Amplification Reflection (PoC based)"; dsize:52;
    # content:"|30 84 00 00 00 2d 02 01 01 63 84 00 00 00 24 04 00 0a 01 00|"; fast_pattern; threshold:type both, count 100, seconds 60, track by_src; reference:url,www.akamai.com/us/en/multimedia/documents/state-of-the-internet/cldap-threat-advisory.pdf; reference:url,packetstormsecurity.com/files/139561/LDAP-Amplication-Denial-Of-Service.html; classtype:attempted-dos; sid:2024584; rev:1; metadata:affected_product Windows_XP_Vista_7_8_10_Server_32_64_Bit, affected_product Linux, attack_target Server, created_at 2017_08_16, deployment Perimeter, former_category DOS, performance_impact Significant, signature_severity Major, updated_at 2017_08_16;)

    udp = UDP(sport=389, dport=389)
    payload = b'\x30\x84\x00\x00\x00\x2d\x02\x01\x01\x63\x84\x00\x00\x00\x24\x04\x00\x0a\x01\x00'
    payload += bytes([x % 256 for x in range(52-len(payload))])
    pcap.write(eth / ip / udp / payload)

    # ET DOS DNS Amplification Attack Inbound

    # alert udp any any -> $HOME_NET 53 (msg:"ET DOS DNS Amplification Attack Inbound";
    # content:"|01 00 00 01 00 00 00 00 00 01|"; depth:10; offset:2; pcre:"/^[^\x00]+?\x00/R";
    # content:"|00 ff 00 01 00 00 29|"; within:7; fast_pattern; byte_test:2,>,4095,0,relative; threshold: type both, track by_dst, seconds 60, count 5; classtype:bad-unknown; sid:2016016; rev:8; metadata:created_at 2012_12_11, updated_at 2012_12_11;)

    udp = UDP(sport=1004, dport=53)
    payload = b'\xab\xcd'+b'\x01\x00\x00\x01\x00\x00\x00\x00\x00\x01'+b'\x00\xff\x00\x01\x00\x00\x29'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Potential CLDAP Amplification Reflection

    # alert udp $EXTERNAL_NET any -> $HOME_NET 389 (msg:"ET DOS Potential CLDAP Amplification Reflection";
    # content:"objectclass0"; fast_pattern; threshold:type both, count 200, seconds 60, track by_src; reference:url,www.akamai.com/us/en/multimedia/documents/state-of-the-internet/cldap-threat-advisory.pdf; reference:url,packetstormsecurity.com/files/139561/LDAP-Amplication-Denial-Of-Service.html; classtype:attempted-dos; sid:2024585; rev:1; metadata:affected_product Windows_XP_Vista_7_8_10_Server_32_64_Bit, affected_product Linux, attack_target Client_and_Server, created_at 2017_08_16, deployment Perimeter, former_category DOS, performance_impact Significant, signature_severity Major, updated_at 2017_08_16;)

    udp = UDP(sport=1005, dport=389)
    payload = b'objectclass0'
    pcap.write(eth / ip / udp / payload)

    # ET DOS LibuPnP CVE-2012-5963 ST UDN Buffer Overflow

    # alert udp $EXTERNAL_NET any -> $HOME_NET 1900 (msg:"ET DOS LibuPnP CVE-2012-5963 ST UDN Buffer Overflow";
    # content:"|0D 0A|ST|3A|"; nocase; pcre:"/^[^\r\n]*uuid\x3a[^\r\n\x3a]{181}/Ri"; reference:cve,CVE-2012-5963; classtype:attempted-dos; sid:2016323; rev:1; metadata:created_at 2013_01_31, updated_at 2013_01_31;)

    udp = UDP(sport=1006, dport=1900)
    payload = b'\x0d\x0aST\x3a'
    payload += b'uuid\x3a'+b'x'*181
    pcap.write(eth / ip / udp / payload)

    # ET DOS Miniupnpd M-SEARCH Buffer Overflow CVE-2013-0229

    # alert udp any any -> $HOME_NET 1900 (msg:"ET DOS Miniupnpd M-SEARCH Buffer Overflow CVE-2013-0229";
    # content:"M-SEARCH"; depth:8; isdataat:1492,relative;
    # content:!"|0d 0a|"; distance:1490; within:2; reference:url,community.rapid7.com/community/infosec/blog/2013/01/29/security-flaws-in-universal-plug-and-play-unplug-dont-play; reference:url,upnp.org/specs/arch/UPnP-arch-DeviceArchitecture-v1.1.pdf; reference:cve,CVE-2013-0229; classtype:attempted-dos; sid:2016363; rev:2; metadata:created_at 2013_02_06, updated_at 2013_02_06;)

    udp = UDP(sport=1007, dport=1900)
    payload = b'M-SEARCH'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible SSDP Amplification Scan in Progress

    # alert udp any any -> $HOME_NET 1900 (msg:"ET DOS Possible SSDP Amplification Scan in Progress";
    # content:"M-SEARCH * HTTP/1.1";
    # content:"ST|3a 20|ssdp|3a|all|0d 0a|"; nocase; distance:0; fast_pattern; threshold: type both,track by_src,count 2,seconds 60; reference:url,community.rapid7.com/community/metasploit/blog/2014/08/29/weekly-metasploit-update; classtype:attempted-dos; sid:2019102; rev:1; metadata:created_at 2014_09_02, updated_at 2014_09_02;)

    udp = UDP(sport=1008, dport=1900)
    payload = b'M-SEARCH * HTTP/1.1'
    payload += b'ST\x3a\x20ssdp\x3aall\x0d\x0a'
    pcap.write(eth / ip / udp / payload)

    # ET DOS LibuPnP CVE-2012-5958 ST DeviceType Buffer Overflow

    # alert udp $EXTERNAL_NET any -> $HOME_NET 1900 (msg:"ET DOS LibuPnP CVE-2012-5958 ST DeviceType Buffer Overflow";
    # content:"|0D 0A|ST|3a|"; nocase; pcre:"/^[^\r\n]*schemas\x3adevice\x3a[^\r\n\x3a]{181}/Ri";
    # content:"schemas|3a|device"; nocase; fast_pattern; reference:cve,CVE_2012-5958; reference:cve,CVE-2012-5962; classtype:attempted-dos; sid:2016322; rev:2; metadata:created_at 2013_01_31, updated_at 2019_10_07;)

    udp = UDP(sport=1009, dport=1900)
    payload = b'\x0d\x0aST\x3a'
    payload += b'schemas\x3adevice\x3a'+b'x'*181
    pcap.write(eth / ip / udp / payload)

    # ET DOS LibuPnP CVE-2012-5964 ST URN ServiceType Buffer Overflow

    # alert udp $EXTERNAL_NET any -> $HOME_NET 1900 (msg:"ET DOS LibuPnP CVE-2012-5964 ST URN ServiceType Buffer Overflow";
    # content:"|0D 0A|ST|3a|"; nocase; pcre:"/^[^\r\n]*urn\x3aservice\x3a[^\r\n\x3a]{181}/Ri";
    # content:"urn|3a|service"; nocase; fast_pattern; reference:cve,CVE-2012-5964; classtype:attempted-dos; sid:2016324; rev:2; metadata:created_at 2013_01_31, updated_at 2019_10_07;)

    udp = UDP(sport=1010, dport=1900)
    payload = b'\x0d\x0aST\x3a'
    payload += b'urn\x3aservice\x3a'+b'x'*181
    pcap.write(eth / ip / udp / payload)

    # ET DOS LibuPnP CVE-2012-5965 ST URN DeviceType Buffer Overflow

    # alert udp $EXTERNAL_NET any -> $HOME_NET 1900 (msg:"ET DOS LibuPnP CVE-2012-5965 ST URN DeviceType Buffer Overflow";
    # content:"|0D 0A|ST|3a|"; nocase; pcre:"/^[^\r\n]*urn\x3adevice\x3a[^\r\n\x3a]{181}/Ri";
    # content:"urn|3a|device"; nocase; fast_pattern; reference:cve,CVE-2012-5965; classtype:attempted-dos; sid:2016325; rev:2; metadata:created_at 2013_01_31, updated_at 2019_10_07;)

    udp = UDP(sport=1011, dport=1900)
    payload = b'\x0d\x0aST\x3a'
    payload += b'urn\x3adevice\x3a'+b'x'*181
    pcap.write(eth / ip / udp / payload)

    # ET DOS LibuPnP CVE-2012-5961 ST UDN Buffer Overflow

    # alert udp $EXTERNAL_NET any -> $HOME_NET 1900 (msg:"ET DOS LibuPnP CVE-2012-5961 ST UDN Buffer Overflow";
    # content:"|0D 0A|ST|3a|"; nocase; pcre:"/^[^\r\n]*schemas\x3adevice\x3a[^\r\n\x3a]{1,180}\x3a[^\r\n\x3a]{181}/Ri";
    # content:"schemas|3a|device"; nocase; fast_pattern; reference:cve,CVE-2012-5961; classtype:attempted-dos; sid:2016326; rev:2; metadata:created_at 2013_01_31, updated_at 2019_10_07;)

    udp = UDP(sport=1012, dport=1900)
    payload = b'\x0d\x0aST\x3a'
    payload += b'schemas\x3adevice\x3a'+b'x'*50+b'\x3a'+b'x'*181
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible Sentinal LM Amplification attack (Request) Inbound"; dsize:6

    # alert udp $EXTERNAL_NET any -> $HOME_NET 5093 (msg:"ET DOS Possible Sentinal LM Amplification attack (Request) Inbound"; dsize:6;
    # content:"|7a 00 00 00 00 00|"; threshold: type both,track by_dst,count 10,seconds 60; classtype:attempted-dos; sid:2021172; rev:1; metadata:created_at 2015_05_29, updated_at 2015_05_29;)

    udp = UDP(sport=1013, dport=5093)
    payload = b'\x7a\x00\x00\x00\x00\x00'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible Memcached DDoS Amplification Query (set)

    # alert udp $EXTERNAL_NET any -> any 11211 (msg:"ET DOS Possible Memcached DDoS Amplification Query (set)";
    # content:"|00 00 00 00 00 01 00|"; depth:7; fast_pattern;
    # content:"|0d 0a|"; within:20; endswith; threshold: type both, count 100, seconds 60, track by_dst; flowbits:set,ET.memcached.ddos; reference:url,blog.cloudflare.com/memcrashed-major-amplification-attacks-from-port-11211/; classtype:attempted-dos; sid:2025401; rev:4; metadata:affected_product Windows_XP_Vista_7_8_10_Server_32_64_Bit, affected_product Linux, attack_target Server, created_at 2018_03_01, deployment Perimeter, former_category DOS, performance_impact Low, signature_severity Major, updated_at 2020_08_19;)

    udp = UDP(sport=1014, dport=11211)
    payload = b'\x00\x00\x00\x00\x00\x01\x00'
    payload += b'\x0d\x0a'
    pcap.write(eth / ip / udp / payload)

    # UDP fixed rules

    # ET DOS Likely NTP DDoS In Progress MON_LIST Response to Non-Ephemeral Port IMPL 0x02
    # index 4 alert udp any 123 -> any 0:1023 (msg:"ET DOS Likely NTP DDoS In Progress MON_LIST Response to Non-Ephemeral Port IMPL 0x02";
    # content:"|00 02 2a|"; offset:1; depth:3;
    # byte_test:1,&,128,0;
    # byte_test:1,&,64,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_src,count 1,seconds 120; reference:url,www.symantec.com/connect/blogs/hackers-spend-christmas-break-launching-large-scale-ntp-reflection-attacks; reference:url,en.wikipedia.org/wiki/Ephemeral_port; classtype:attempted-dos; sid:2017965; rev:3; metadata:created_at 2014_01_13, updated_at 2014_01_13;)
    udp = UDP(sport=123, dport=1015)
    payload = b'\xcf'+b'\x00\x02\x2a'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Likely NTP DDoS In Progress PEER_LIST Response to Non-Ephemeral Port IMPL 0x02
    # index 5 alert udp any 123 -> any 0:1023 (msg:"ET DOS Likely NTP DDoS In Progress PEER_LIST Response to Non-Ephemeral Port IMPL 0x02";
    # content:"|00 02 00|"; offset:1; depth:3;
    # byte_test:1,&,128,0;
    # byte_test:1,&,64,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_src,count 1,seconds 120; reference:url,community.rapid7.com/community/metasploit/blog/2014/08/25/r7-2014-12-more-amplification-vulnerabilities-in-ntp-allow-even-more-drdos-attacks; reference:url,en.wikipedia.org/wiki/Ephemeral_port; classtype:attempted-dos; sid:2019010; rev:3; metadata:created_at 2014_08_25, updated_at 2014_08_25;)
    udp = UDP(sport=123, dport=1016)
    payload = b'\xcf'+b'\x00\x02\x00'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Likely NTP DDoS In Progress PEER_LIST Response to Non-Ephemeral Port IMPL 0x03
    # index 6 alert udp any 123 -> any 0:1023 (msg:"ET DOS Likely NTP DDoS In Progress PEER_LIST Response to Non-Ephemeral Port IMPL 0x03";
    # content:"|00 03 00|"; offset:1; depth:3;
    # byte_test:1,&,128,0;
    # byte_test:1,&,64,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_src,count 1,seconds 120; reference:url,community.rapid7.com/community/metasploit/blog/2014/08/25/r7-2014-12-more-amplification-vulnerabilities-in-ntp-allow-even-more-drdos-attacks; reference:url,en.wikipedia.org/wiki/Ephemeral_port; classtype:attempted-dos; sid:2019011; rev:3; metadata:created_at 2014_08_25, updated_at 2014_08_25;)
    udp = UDP(sport=123, dport=1017)
    payload = b'\xcf'+b'\x00\x03\x00'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Likely NTP DDoS In Progress PEER_LIST_SUM Response to Non-Ephemeral Port IMPL 0x02
    # index 7 alert udp any 123 -> any 0:1023 (msg:"ET DOS Likely NTP DDoS In Progress PEER_LIST_SUM Response to Non-Ephemeral Port IMPL 0x02";
    # content:"|00 02 01|"; offset:1; depth:3;
    # byte_test:1,&,128,0;
    # byte_test:1,&,64,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_src,count 1,seconds 120; reference:url,community.rapid7.com/community/metasploit/blog/2014/08/25/r7-2014-12-more-amplification-vulnerabilities-in-ntp-allow-even-more-drdos-attacks; reference:url,en.wikipedia.org/wiki/Ephemeral_port; classtype:attempted-dos; sid:2019012; rev:3; metadata:created_at 2014_08_25, updated_at 2014_08_25;)
    udp = UDP(sport=123, dport=1018)
    payload = b'\xcf'+b'\x00\x02\x01'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Likely NTP DDoS In Progress PEER_LIST_SUM Response to Non-Ephemeral Port IMPL 0x03
    # index 8 alert udp any 123 -> any 0:1023 (msg:"ET DOS Likely NTP DDoS In Progress PEER_LIST_SUM Response to Non-Ephemeral Port IMPL 0x03";
    # content:"|00 03 01|"; offset:1; depth:3;
    # byte_test:1,&,128,0;
    # byte_test:1,&,64,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_src,count 1,seconds 120; reference:url,community.rapid7.com/community/metasploit/blog/2014/08/25/r7-2014-12-more-amplification-vulnerabilities-in-ntp-allow-even-more-drdos-attacks; reference:url,en.wikipedia.org/wiki/Ephemeral_port; classtype:attempted-dos; sid:2019013; rev:3; metadata:created_at 2014_08_25, updated_at 2014_08_25;)
    udp = UDP(sport=123, dport=1019)
    payload = b'\xcf'+b'\x00\x03\x01'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Likely NTP DDoS In Progress MON_LIST Response to Non-Ephemeral Port IMPL 0x03
    # index 9 alert udp any 123 -> any 0:1023 (msg:"ET DOS Likely NTP DDoS In Progress MON_LIST Response to Non-Ephemeral Port IMPL 0x03";
    # content:"|00 03 2a|"; offset:1; depth:3;
    # byte_test:1,&,128,0;
    # byte_test:1,&,64,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_src,count 1,seconds 120; reference:url,www.symantec.com/connect/blogs/hackers-spend-christmas-break-launching-large-scale-ntp-reflection-attacks; reference:url,en.wikipedia.org/wiki/Ephemeral_port; classtype:attempted-dos; sid:2017966; rev:3; metadata:created_at 2014_01_13, updated_at 2014_01_13;)
    udp = UDP(sport=123, dport=1020)
    payload = b'\xcf'+b'\x00\x03\x2a'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Likely NTP DDoS In Progress GET_RESTRICT Response to Non-Ephemeral Port IMPL 0x03
    # index 13 alert udp any 123 -> any 0:1023 (msg:"ET DOS Likely NTP DDoS In Progress GET_RESTRICT Response to Non-Ephemeral Port IMPL 0x03";
    # content:"|00 03 10|"; offset:1; depth:3;
    # byte_test:1,&,128,0;
    # byte_test:1,&,64,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_src,count 1,seconds 120; reference:url,community.rapid7.com/community/metasploit/blog/2014/08/25/r7-2014-12-more-amplification-vulnerabilities-in-ntp-allow-even-more-drdos-attacks; reference:url,en.wikipedia.org/wiki/Ephemeral_port; classtype:attempted-dos; sid:2019014; rev:4; metadata:created_at 2014_08_25, updated_at 2014_08_25;)
    udp = UDP(sport=123, dport=1021)
    payload = b'\xcf'+b'\x00\x03\x10'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Likely NTP DDoS In Progress GET_RESTRICT Response to Non-Ephemeral Port IMPL 0x02
    # index 14 alert udp any 123 -> any 0:1023 (msg:"ET DOS Likely NTP DDoS In Progress GET_RESTRICT Response to Non-Ephemeral Port IMPL 0x02";
    # content:"|00 02 10|"; offset:1; depth:3;
    # byte_test:1,&,128,0;
    # byte_test:1,&,64,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_src,count 1,seconds 120; reference:url,community.rapid7.com/community/metasploit/blog/2014/08/25/r7-2014-12-more-amplification-vulnerabilities-in-ntp-allow-even-more-drdos-attacks; reference:url,en.wikipedia.org/wiki/Ephemeral_port; classtype:attempted-dos; sid:2019015; rev:4; metadata:created_at 2014_08_25, updated_at 2014_08_25;)
    udp = UDP(sport=123, dport=1022)
    payload = b'\xcf'+b'\x00\x02\x10'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible NTP DDoS Multiple MON_LIST Seq 0 Response Spanning Multiple Packets IMPL 0x02
    # index 2 alert udp $HOME_NET 123 -> $EXTERNAL_NET any (msg:"ET DOS Possible NTP DDoS Multiple MON_LIST Seq 0 Response Spanning Multiple Packets IMPL 0x02";
    # content:"|00 02 2a|"; offset:1; depth:3;
    # byte_test:1,&,128,0;
    # byte_test:1,&,64,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_src,count 2,seconds 60; reference:url,www.symantec.com/connect/blogs/hackers-spend-christmas-break-launching-large-scale-ntp-reflection-attacks; classtype:attempted-dos; sid:2017920; rev:2; metadata:created_at 2014_01_02, updated_at 2014_01_02;)
    udp = UDP(sport=123, dport=1023)
    payload = b'\xcf'+b'\x00\x02\x2a'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible NTP DDoS Multiple MON_LIST Seq 0 Response Spanning Multiple Packets IMPL 0x03
    # index 3 alert udp $HOME_NET 123 -> $EXTERNAL_NET any (msg:"ET DOS Possible NTP DDoS Multiple MON_LIST Seq 0 Response Spanning Multiple Packets IMPL 0x03";
    # content:"|00 03 2a|"; offset:1; depth:3;
    # byte_test:1,&,128,0;
    # byte_test:1,&,64,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_src,count 2,seconds 60; reference:url,www.symantec.com/connect/blogs/hackers-spend-christmas-break-launching-large-scale-ntp-reflection-attacks; classtype:attempted-dos; sid:2017921; rev:2; metadata:created_at 2014_01_02, updated_at 2014_01_02;)
    udp = UDP(sport=123, dport=1024)
    payload = b'\xcf'+b'\x00\x03\x2a'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Likely NTP DDoS In Progress Multiple UNSETTRAP Mode 6 Responses
    # index 21 alert udp any 123 -> any any (msg:"ET DOS Likely NTP DDoS In Progress Multiple UNSETTRAP Mode 6 Responses";
    # content:"|df 00 00 04 00|"; offset:1; depth:5;
    # byte_test:1,!&,128,0;
    # byte_test:1,!&,64,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,!&,1,0; threshold: type both,track by_src,count 2,seconds 60; reference:url,community.rapid7.com/community/metasploit/blog/2014/08/25/r7-2014-12-more-amplification-vulnerabilities-in-ntp-allow-even-more-drdos-attacks; classtype:attempted-dos; sid:2019022; rev:4; metadata:created_at 2014_08_25, updated_at 2014_08_25;)
    udp = UDP(sport=123, dport=1025)
    payload = b'\x0e'+b'\xdf\x00\x00\x04\x00'+b'\x00\x00\x04\x02\x00'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible Sentinal LM  Application attack in progress Outbound (Response)
    # index 22 alert udp $HOME_NET 5093 -> $EXTERNAL_NET any (msg:"ET DOS Possible Sentinal LM  Application attack in progress Outbound (Response)"; dsize:>1390;
    # content:"|7a 00 00 00 00 00 00 00 00 00 00 00|"; depth:12; threshold: type both,track by_src,count 10,seconds 60; classtype:attempted-dos; sid:2021170; rev:1; metadata:created_at 2015_05_29, updated_at 2015_05_29;)
    udp = UDP(sport=5093, dport=1026)
    payload = b'\x7a\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible Sentinal LM Amplification attack (Response) Inbound"
    # index 23 alert udp $EXTERNAL_NET 5093 -> $HOME_NET any (msg:"ET DOS Possible Sentinal LM Amplification attack (Response) Inbound"; dsize:>1390;
    # content:"|7a 00 00 00 00 00 00 00 00 00 00 00|"; depth:12; threshold: type both,track by_src,count 10,seconds 60; classtype:attempted-dos; sid:2021171; rev:1; metadata:created_at 2015_05_29, updated_at 2015_05_29;)
    udp = UDP(sport=5093, dport=1027)
    payload = b'\x7a\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible Memcached DDoS Amplification Response Outbound
    # index 25 alert udp any 11211 -> $EXTERNAL_NET any (msg:"ET DOS Possible Memcached DDoS Amplification Response Outbound"; flowbits:isset,ET.memcached.ddos;
    # content:"STATS|20|pid"; depth:9; fast_pattern; threshold: type both, count 100, seconds 60, track by_dst; reference:url,blog.cloudflare.com/memcrashed-major-amplification-attacks-from-port-11211/; classtype:attempted-dos; sid:2025402; rev:1; metadata:affected_product Windows_XP_Vista_7_8_10_Server_32_64_Bit, affected_product Linux, attack_target Server, created_at 2018_03_01, deployment Perimeter, former_category DOS, performance_impact Low, signature_severity Major, updated_at 2018_03_01;)
    udp = UDP(sport=11211, dport=1028)
    payload = b'STATS\x20pid'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible Memcached DDoS Amplification Inbound
    # index 26 alert udp $EXTERNAL_NET 11211 -> $HOME_NET any (msg:"ET DOS Possible Memcached DDoS Amplification Inbound";
    # content:"STATS|20|pid"; depth:9; fast_pattern; threshold: type both, count 100, seconds 60, track by_dst; reference:url,blog.cloudflare.com/memcrashed-major-amplification-attacks-from-port-11211/; classtype:attempted-dos; sid:2025403; rev:1; metadata:affected_product Windows_XP_Vista_7_8_10_Server_32_64_Bit, affected_product Linux, attack_target Client_Endpoint, created_at 2018_03_01, deployment Perimeter, former_category DOS, performance_impact Low, signature_severity Major, updated_at 2018_03_01;)
    udp = UDP(sport=11211, dport=1029)
    payload = b'STATS\x20pid'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible NTP DDoS Inbound Frequent Un-Authed MON_LIST Requests IMPL 0x02
    # index 0 alert udp any any -> any 123 (msg:"ET DOS Possible NTP DDoS Inbound Frequent Un-Authed MON_LIST Requests IMPL 0x02";
    # content:"|00 02 2A|"; offset:1; depth:3;
    # byte_test:1,!&,128,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_dst,count 2,seconds 60; reference:url,www.symantec.com/connect/blogs/hackers-spend-christmas-break-launching-large-scale-ntp-reflection-attacks; classtype:attempted-dos; sid:2017918; rev:2; metadata:created_at 2014_01_02, updated_at 2014_01_02;)
    udp = UDP(sport=1030, dport=123)
    payload = b'\x0f'+b'\x00\x02\x2a'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible NTP DDoS Inbound Frequent Un-Authed MON_LIST Requests IMPL 0x03
    # index 1 alert udp any any -> any 123 (msg:"ET DOS Possible NTP DDoS Inbound Frequent Un-Authed MON_LIST Requests IMPL 0x03";
    # content:"|00 03 2A|"; offset:1; depth:3;
    # byte_test:1,!&,128,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_dst,count 2,seconds 60; reference:url,www.symantec.com/connect/blogs/hackers-spend-christmas-break-launching-large-scale-ntp-reflection-attacks; classtype:attempted-dos; sid:2017919; rev:2; metadata:created_at 2014_01_02, updated_at 2014_01_02;)
    udp = UDP(sport=1031, dport=123)
    payload = b'\x0f'+b'\x00\x03\x2a'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible NTP DDoS Inbound Frequent Un-Authed PEER_LIST Requests IMPL 0x03
    # index 15 alert udp any any -> any 123 (msg:"ET DOS Possible NTP DDoS Inbound Frequent Un-Authed PEER_LIST Requests IMPL 0x03";
    # content:"|00 03 00|"; offset:1; depth:3;
    # byte_test:1,!&,128,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_dst,count 2,seconds 60; reference:url,community.rapid7.com/community/metasploit/blog/2014/08/25/r7-2014-12-more-amplification-vulnerabilities-in-ntp-allow-even-more-drdos-attacks; classtype:attempted-dos; sid:2019016; rev:3; metadata:created_at 2014_08_25, updated_at 2014_08_25;)
    udp = UDP(sport=1032, dport=123)
    payload = b'\x0f'+b'\x00\x03\x00'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible NTP DDoS Inbound Frequent Un-Authed PEER_LIST Requests IMPL 0x02
    # index 16 alert udp any any -> any 123 (msg:"ET DOS Possible NTP DDoS Inbound Frequent Un-Authed PEER_LIST Requests IMPL 0x02";
    # content:"|00 02 00|"; offset:1; depth:3;
    # byte_test:1,!&,128,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_dst,count 2,seconds 60; reference:url,community.rapid7.com/community/metasploit/blog/2014/08/25/r7-2014-12-more-amplification-vulnerabilities-in-ntp-allow-even-more-drdos-attacks; classtype:attempted-dos; sid:2019017; rev:3; metadata:created_at 2014_08_25, updated_at 2014_08_25;)
    udp = UDP(sport=1033, dport=123)
    payload = b'\x0f'+b'\x00\x02\x00'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible NTP DDoS Inbound Frequent Un-Authed PEER_LIST_SUM Requests IMPL 0x03
    # index 17 alert udp any any -> any 123 (msg:"ET DOS Possible NTP DDoS Inbound Frequent Un-Authed PEER_LIST_SUM Requests IMPL 0x03";
    # content:"|00 03 01|"; offset:1; depth:3;
    # byte_test:1,!&,128,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_dst,count 2,seconds 60; reference:url,community.rapid7.com/community/metasploit/blog/2014/08/25/r7-2014-12-more-amplification-vulnerabilities-in-ntp-allow-even-more-drdos-attacks; classtype:attempted-dos; sid:2019018; rev:3; metadata:created_at 2014_08_25, updated_at 2014_08_25;)
    udp = UDP(sport=1034, dport=123)
    payload = b'\x0f'+b'\x00\x03\x01'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible NTP DDoS Inbound Frequent Un-Authed PEER_LIST_SUM Requests IMPL 0x02
    # index 18 alert udp any any -> any 123 (msg:"ET DOS Possible NTP DDoS Inbound Frequent Un-Authed PEER_LIST_SUM Requests IMPL 0x02";
    # content:"|00 02 01|"; offset:1; depth:3;
    # byte_test:1,!&,128,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_dst,count 2,seconds 60; reference:url,community.rapid7.com/community/metasploit/blog/2014/08/25/r7-2014-12-more-amplification-vulnerabilities-in-ntp-allow-even-more-drdos-attacks; classtype:attempted-dos; sid:2019019; rev:3; metadata:created_at 2014_08_25, updated_at 2014_08_25;)
    udp = UDP(sport=1035, dport=123)
    payload = b'\x0f'+b'\x00\x02\x01'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible NTP DDoS Inbound Frequent Un-Authed GET_RESTRICT Requests IMPL 0x02
    # index 19 alert udp any any -> any 123 (msg:"ET DOS Possible NTP DDoS Inbound Frequent Un-Authed GET_RESTRICT Requests IMPL 0x02";
    # content:"|00 02 10|"; offset:1; depth:3;
    # byte_test:1,!&,128,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_dst,count 2,seconds 60; reference:url,community.rapid7.com/community/metasploit/blog/2014/08/25/r7-2014-12-more-amplification-vulnerabilities-in-ntp-allow-even-more-drdos-attacks; classtype:attempted-dos; sid:2019021; rev:3; metadata:created_at 2014_08_25, updated_at 2014_08_25;)
    udp = UDP(sport=1036, dport=123)
    payload = b'\x0f'+b'\x00\x02\x10'
    pcap.write(eth / ip / udp / payload)

    # ET DOS Possible NTP DDoS Inbound Frequent Un-Authed GET_RESTRICT Requests IMPL 0x03
    # index 20 alert udp any any -> any 123 (msg:"ET DOS Possible NTP DDoS Inbound Frequent Un-Authed GET_RESTRICT Requests IMPL 0x03";
    # content:"|00 03 10|"; offset:1; depth:3;
    # byte_test:1,!&,128,0;
    # byte_test:1,&,4,0;
    # byte_test:1,&,2,0;
    # byte_test:1,&,1,0; threshold: type both,track by_dst,count 2,seconds 60; reference:url,community.rapid7.com/community/metasploit/blog/2014/08/25/r7-2014-12-more-amplification-vulnerabilities-in-ntp-allow-even-more-drdos-attacks; classtype:attempted-dos; sid:2019020; rev:3; metadata:created_at 2014_08_25, updated_at 2014_08_25;)
    udp = UDP(sport=1037, dport=123)
    payload = b'\x0f'+b'\x00\x03\x10'
    pcap.write(eth / ip / udp / payload)

    # TCP rules

    # ET DOS CVE-2013-0230 Miniupnpd SoapAction MethodName Buffer Overflow

    # alert tcp $EXTERNAL_NET any -> $HOME_NET any (msg:"ET DOS CVE-2013-0230 Miniupnpd SoapAction MethodName Buffer Overflow"; flow:to_server,established;
    # content:"POST "; depth:5;
    # content:"|0d 0a|SOAPAction|3a|"; nocase; distance:0; pcre:"/^[^\r\n]+#[^\x22\r\n]{2049}/R"; reference:url,community.rapid7.com/community/infosec/blog/2013/01/29/security-flaws-in-universal-plug-and-play-unplug-dont-play; reference:url,upnp.org/specs/arch/UPnP-arch-DeviceArchitecture-v1.1.pdf; reference:cve,CVE-2013-0230; classtype:attempted-dos; sid:2016364; rev:1; metadata:created_at 2013_02_06, updated_at 2013_02_06;)

    tcp = TCP(sport=1038, dport=54321)
    payload = b'POST '
    payload += b'\x0d\x0aSOAPAction\x3a'
    pcap.write(eth / ip / tcp / payload)

    # ET DOS SMB Tree_Connect Stack Overflow Attempt (CVE-2017-0016)

    # alert tcp any 445 -> $HOME_NET any (msg:"ET DOS SMB Tree_Connect Stack Overflow Attempt (CVE-2017-0016)"; flow:from_server,established;
    # content:"|FE|SMB"; offset:4; depth:4;
    # content:"|03 00|"; distance:8; within:2; byte_test:1,&,1,2,relative; byte_jump:2,8,little,from_beginning; byte_jump:2,4,relative,little; isdataat:1000,relative;
    # content:!"|FE|SMB"; within:1000; reference:cve,2017-0016; classtype:attempted-dos; sid:2023832; rev:3; metadata:affected_product SMBv3, attack_target Client_and_Server, created_at 2017_02_03, deployment Datacenter, signature_severity Major, updated_at 2017_02_07;)

    tcp = TCP(sport=445, dport=1039)
    payload = b'\xFESMB'
    payload += b'\x03\x00'
    pcap.write(eth / ip / tcp / payload)

    # ET DOS Microsoft Windows LSASS Remote Memory Corruption (CVE-2017-0004)

    # alert tcp any any -> $HOME_NET 445 (msg:"ET DOS Microsoft Windows LSASS Remote Memory Corruption (CVE-2017-0004)"; flow:established,to_server;
    # content:"|FF|SMB|73|"; offset:4; depth:5; byte_test:1,&,0x80,6,relative; byte_test:1,&,0x08,6,relative; byte_test:1,&,0x10,5,relative; byte_test:1,&,0x04,5,relative; byte_test:1,&,0x02,5,relative; byte_test:1,&,0x01,5,relative;
    # content:"|ff 00|"; distance:28; within:2;
    # content:"|84|"; distance:25; within:1;
    # content:"NTLMSSP"; fast_pattern; within:64; reference:url,github.com/lgandx/PoC/tree/master/LSASS; reference:url,support.microsoft.com/en-us/kb/3216771; reference:url,support.microsoft.com/en-us/kb/3199173; reference:cve,2017-0004; reference:url,technet.microsoft.com/library/security/MS17-004; classtype:attempted-dos; sid:2023497; rev:3; metadata:affected_product Windows_XP_Vista_7_8_10_Server_32_64_Bit, attack_target Client_and_Server, created_at 2016_11_11, deployment Perimeter, deployment Datacenter, performance_impact Low, signature_severity Major, updated_at 2017_01_12;)

    tcp = TCP(sport=1040, dport=445)
    payload = b'\xFFSMB\x73'
    payload += b'\xff\x00'
    payload += b'\x84'
    payload += b'NTLMSSP'
    pcap.write(eth / ip / tcp / payload)

    # TCP fixed rules

    # ET DOS SMBLoris NBSS Length Mem Exhaustion Attempt (PoC Based)
    # index 24 alert tcp any any -> $HOME_NET [139,445] (msg:"ET DOS SMBLoris NBSS Length Mem Exhaustion Attempt (PoC Based)"; flow:established,to_server;
    # content:"|00 01 ff ff|"; depth:4; threshold:type both,track by_dst,count 30, seconds 300; reference:url,isc.sans.edu/forums/diary/SMBLoris+the+new+SMB+flaw/22662/; classtype:trojan-activity; sid:2024511; rev:2; metadata:affected_product Windows_XP_Vista_7_8_10_Server_32_64_Bit, attack_target Client_and_Server, created_at 2017_08_02, deployment Internal, former_category DOS, performance_impact Significant, signature_severity Major, updated_at 2017_08_03;)
    tcp = TCP(sport=1041, dport=139)
    payload = b'\x00\x01\xff\xff'
    pcap.write(eth / ip / tcp / payload)

    tcp = TCP(sport=1041, dport=445)
    payload = b'\x00\x01\xff\xff'
    pcap.write(eth / ip / tcp / payload)

    # ET DOS Excessive Large Tree Connect Response
    # index 27 alert tcp any 445 -> $HOME_NET any (msg:"ET DOS Excessive Large Tree Connect Response"; flow:from_server,established;
    # byte_test:  3,>,1000,1;
    # content: "|fe 53 4d 42 40 00|"; offset: 4; depth: 6;
    # content: "|03 00|"; offset: 16; depth:2; reference:url,isc.sans.edu/forums/diary/Windows+SMBv3+Denial+of+Service+Proof+of+Concept+0+Day+Exploit/22029/; classtype:attempted-dos; sid:2023831; rev:3; metadata:affected_product SMBv3, attack_target Client_and_Server, created_at 2017_02_03, deployment Datacenter, signature_severity Major, updated_at 2020_08_19;)
    tcp = TCP(sport=445, dport=1042)
    payload = b'\x00\x10\x00'+b'\x00'+b'\xfe\x53\x4d\x42\x40\x00'+b'\x00\x00\x00\x00\x00\x00'+b'\x03\x00'
    pcap.write(eth / ip / tcp / payload)

    # HTTP rules

    # alert http $EXTERNAL_NET any -> $HTTP_SERVERS any (flow:established,to_server;
    # content:"Bittorrent"; http_user_agent; depth:10; threshold: type both, count 1, seconds 60, track by_src;
    tcp = TCP(sport=1043, dport=80)
    payload = b'GET / HTTP/1.1\r\n'
    payload += b'Bittorrent'
    pcap.write(eth / ip / tcp / payload)

    # alert http $HOME_NET any -> $EXTERNAL_NET any (flow:to_server,established;
    # content:"GET"; http_method;
    # content:"If-Modified-Since|3a 20 20|"; http_raw_header;
    # content:"Keep-Alive|3a 20 20|"; http_raw_header;
    # content:"Connection|3a 20 20|"; http_raw_header;
    # content:"User-Agent|3a 20 20|"; http_raw_header; http_start;
    # content:"HTTP/1.0|0d 0a|Accept|3a 20|*/*|0d 0a|Accept-Language|3a 20|"; threshold: type both, count 1, seconds 60, track by_src;
    tcp = TCP(sport=1044, dport=80)
    payload = b'GET / HTTP/1.1\r\n'
    payload += b'If-Modified-Since\x3a\x20\x20'
    payload += b'Keep-Alive\x3a\x20\x20'
    payload += b'Connection\x3a\x20\x20'
    payload += b'User-Agent\x3a\x20\x20'
    payload += b'HTTP/1.0\x0d\x0aAccept\x3a\x20*/*\x0d\x0aAccept-Language\x3a\x20'
    pcap.write(eth / ip / tcp / payload)

    # alert http $EXTERNAL_NET any -> $HTTP_SERVERS any (flow:to_server,established;
    # content:"GET"; http_method;
    # content:"If-Modified-Since|3a 20 20|"; http_raw_header;
    # content:"Keep-Alive|3a 20 20|"; http_raw_header;
    # content:"Connection|3a 20 20|"; http_raw_header;
    # content:"User-Agent|3a 20 20|"; http_raw_header; http_start;
    # content:"HTTP/1.0|0d 0a|Accept|3a 20|*/*|0d 0a|Accept-Language|3a 20|"; threshold: type both, count 1, seconds 60, track by_dst;
    tcp = TCP(sport=1045, dport=80)
    payload = b'GET / HTTP/1.1\r\n'
    payload += b'If-Modified-Since\x3a\x20\x20'
    payload += b'Keep-Alive\x3a\x20\x20'
    payload += b'Connection\x3a\x20\x20'
    payload += b'User-Agent\x3a\x20\x20'
    payload += b'HTTP/1.0\x0d\x0aAccept\x3a\x20*/*\x0d\x0aAccept-Language\x3a\x20'
    pcap.write(eth / ip / tcp / payload)

    # alert http $EXTERNAL_NET any -> $HOME_NET any (flow:established,to_server;
    # content:"User-Agent|3a 20 20|"; http_raw_header; fast_pattern; threshold: type both, track by_src, count 225, seconds 60;
    tcp = TCP(sport=1046, dport=80)
    payload = b'User-Agent\x3a\x20\x20'
    pcap.write(eth / ip / tcp / payload)

    # alert http $EXTERNAL_NET any -> $HTTP_SERVERS any (flow:established,to_server; threshold: type both, count 5, seconds 60, track by_src; http.method;
    # content:"POST"; http.user_agent;
    # content:"Mozilla/4.0 (compatible|3b 20|Synapse)"; fast_pattern; http.request_body;
    # content:"login="; depth:6;
    # content:"$pass="; within:50;
    tcp = TCP(sport=1047, dport=80)
    payload = b'POST'
    payload += b'Mozilla/4.0 (compatible\x3b\x20Synapse)'
    payload += b'login='
    payload += b'$pass='
    pcap.write(eth / ip / tcp / payload)

    # alert http $HOME_NET any -> $EXTERNAL_NET any (flow:established,to_server; threshold: type both, track by_src, count 5, seconds 60; http.method;
    # content:"GET"; http.uri;
    # content:"/?id="; fast_pattern; depth:5;
    # content:"&msg="; distance:13; within:5; pcre:"/^\/\?id=[0-9]{13}&msg=/";
    tcp = TCP(sport=1048, dport=80)
    payload = b'GET'
    payload += b'/?id='
    payload += b'&msg='
    pcap.write(eth / ip / tcp / payload)

    # alert http $EXTERNAL_NET any -> $HTTP_SERVERS any (flow:established,to_server; threshold:type limit, track by_src, count 1, seconds 300; http.method;
    # content:"POST"; http.request_body;
    # content:"13"; depth:2;
    # content:"=MSG"; fast_pattern; distance:11; within:4; pcre:"/^13\d{11}/"; classtype:web-application-attack; sid:2016030; rev:5; metadata:created_at 2012_12_13, updated_at 2020_05_06;)
    tcp = TCP(sport=1049, dport=80)
    payload = b'POST'
    payload += b'13'
    payload += b'=MSG'
    pcap.write(eth / ip / tcp / payload)

    # alert http $EXTERNAL_NET any -> $HTTP_SERVERS any (flow:established,to_server; threshold:type limit, track by_src, count 1, seconds 300; http.method;
    # content:"GET"; http.uri;
    # content:"/?msg=MSG"; classtype:web-application-attack; sid:2016031; rev:4; metadata:created_at 2012_12_13, updated_at 2020_05_06;)
    tcp = TCP(sport=1050, dport=80)
    payload = b'GET'
    payload += b'/?msg=MSG'
    pcap.write(eth / ip / tcp / payload)

    # alert http $EXTERNAL_NET any -> any any (flow:established,to_server; http.method;
    # content:"SUBSCRIBE"; http.uri; http.header;
    # content:"CALLBACK|3a 20|"; fast_pattern; nocase;
    # content:"<http"; distance:0;
    # content:"><http"; distance:0; pcre:"/^Callback\x3a\x20<http[^>]+><http/Hmi";
    tcp = TCP(sport=1051, dport=80)
    payload = b'SUBSCRIBE'
    payload += b'CALLBACK\x3a\x20'
    payload += b'<http'
    payload += b'><http'
    pcap.write(eth / ip / tcp / payload)

    # alert http $HOME_NET any -> $EXTERNAL_NET any (flow:established,to_server; http.user_agent;
    # content:"Mozilla/5.0 (Windows|3b 20|U|3b 20|Windows NT 5.1|3b 20|ru|3b 20|rv|3a|1.8.1.1) Gecko/20061204 Firefox/2.0.0.1";
    tcp = TCP(sport=1052, dport=80)
    payload = b'GET / HTTP/1.1\r\n'
    payload += b'Mozilla/5.0 (Windows\x3b\x20U\x3b\x20Windows NT 5.1\x3b\x20ru\x3b\x20rv\x3a1.8.1.1) Gecko/20061204 Firefox/2.0.0.1'
    pcap.write(eth / ip / tcp / payload)

    # alert http $EXTERNAL_NET any -> $HOME_NET any (flow:established,to_server; http.user_agent;
    # content:"Mozilla/5.0 (Windows|3b 20|U|3b 20|Windows NT 5.1|3b 20|ru|3b 20|rv|3a|1.8.1.1) Gecko/20061204 Firefox/2.0.0.1";
    tcp = TCP(sport=1053, dport=80)
    payload = b'GET / HTTP/1.1\r\n'
    payload += b'Mozilla/5.0 (Windows\x3b\x20U\x3b\x20Windows NT 5.1\x3b\x20ru\x3b\x20rv\x3a1.8.1.1) Gecko/20061204 Firefox/2.0.0.1'
    pcap.write(eth / ip / tcp / payload)

    # alert http $HOME_NET any -> $EXTERNAL_NET any (flow:established,to_server; http.user_agent;
    # content:"Opera/9.02 (Windows NT 5.1|3b 20|U|3b 20|ru)";
    tcp = TCP(sport=1054, dport=80)
    payload = b'GET / HTTP/1.1\r\n'
    payload += b'Opera/9.02 (Windows NT 5.1\x3b\x20U\x3b\x20ru)'
    pcap.write(eth / ip / tcp / payload)

    # alert http $EXTERNAL_NET any -> $HOME_NET any (flow:established,to_server; http.user_agent;
    # content:"Opera/9.02 (Windows NT 5.1|3b 20|U|3b 20|ru)";
    tcp = TCP(sport=1055, dport=80)
    payload = b'GET / HTTP/1.1\r\n'
    payload += b'Opera/9.02 (Windows NT 5.1\x3b\x20U\x3b\x20ru)'
    pcap.write(eth / ip / tcp / payload)

    # alert http $EXTERNAL_NET any -> $HOME_NET any (flow:to_server,established; http.user_agent;
    # content:"x00_-gawa.sa.pilipinas.2015";
    tcp = TCP(sport=1056, dport=80)
    payload = b'GET / HTTP/1.1\r\n'
    payload += b'x00_-gawa.sa.pilipinas.2015'
    pcap.write(eth / ip / tcp / payload)

    # alert http $EXTERNAL_NET any -> $HTTP_SERVERS any (flow:established,to_server; threshold: type both, track by_src, count 100, seconds 300; http.uri;
    # content:"/?"; fast_pattern; depth:2;
    # content:"="; distance:3; within:11; pcre:"/^\/\?[a-zA-Z0-9]{3,10}=[a-zA-Z0-9]{3,20}(?:&[a-zA-Z0-9]{3,10}=[a-zA-Z0-9]{3,20})*?$/"; http.header;
    # content:"Keep|2d|Alive|3a|";
    # content:"Connection|3a| keep|2d|alive";
    # content:"Cache|2d|Control|3a|"; pcre:"/^Cache-Control\x3a\x20(?:max-age=0|no-cache)\r?$/m";
    # content:"Accept|2d|Encoding|3a|";
    tcp = TCP(sport=1057, dport=80)
    payload = b'/?'
    payload += b'='
    payload += b'Keep\x2dAlive\x3a'
    payload += b'Connection\x3a keep\x2dalive\r\n'
    payload += b'Cache\x2dControl\x3a\x20max-age=0\r\n'
    payload += b'Accept\x2dEncoding\x3a'
    pcap.write(eth / ip / tcp / payload)

    # alert http $EXTERNAL_NET any -> $HTTP_SERVERS any (flow:established,to_server; threshold: type both, track by_src, count 5,   seconds 90;  http.uri;
    # content:"/xmlrpc.php"; nocase; http.request_body;
    # content:"pingback.ping"; nocase; fast_pattern; classtype:attempted-dos; sid:2018277; rev:4; metadata:affected_product Wordpress, affected_product Wordpress_Plugins, attack_target Web_Server, created_at 2014_03_14, deployment Datacenter, signature_severity Major, tag Wordpress, updated_at 2020_05_14;)
    tcp = TCP(sport=1058, dport=80)
    payload = b'/xmlrpc.php'
    payload += b'pingback.ping'
    pcap.write(eth / ip / tcp / payload)

    # alert tcp $EXTERNAL_NET any -> $HOME_NET $HTTP_PORTS (msg:"ET DOS Terse HTTP GET Likely GoodBye 5.2 DDoS tool"; flow:to_server,established; dsize:<50;
    # content:"|20|HTTP/1.1Host|3a 20|"; threshold:type both,track by_dst,count 500,seconds 60; classtype:attempted-dos; sid:2019350; rev:2; metadata:created_at 2014_10_03, updated_at 2014_10_03;)
    tcp = TCP(sport=1059, dport=80)
    payload = b'\x20HTTP/1.1Host\x3a\x20'
    pcap.write(eth / ip / tcp / payload)

    # alert tcp $EXTERNAL_NET any -> $HOME_NET $HTTP_PORTS (msg:"ET DOS HTTP GET AAAAAAAA Likely FireFlood"; flow:to_server,established;
    # content:"GET AAAAAAAA HTTP/1.1";
    # content:!"Referer|3a|"; distance:0;
    # content:!"Accept"; distance:0;
    # content:!"|0d 0a|"; distance:0; threshold:type both,track by_dst,count 500,seconds 60; classtype:attempted-dos; sid:2019347; rev:2; metadata:created_at 2014_10_03, updated_at 2014_10_03;)
    tcp = TCP(sport=1060, dport=80)
    payload = b'GET AAAAAAAA HTTP/1.1'
    pcap.write(eth / ip / tcp / payload)

    # HTTP fixed rules

    # ET DOS Terse HTTP GET Likely LOIC
    # index 10 alert tcp $EXTERNAL_NET any -> $HOME_NET $HTTP_PORTS (msg:"ET DOS Terse HTTP GET Likely LOIC"; flow:to_server,established; dsize:18; content:"GET / HTTP/1.1|0d 0a 0d 0a|"; depth:18; threshold:type both,track by_dst,count 500,seconds 60; classtype:attempted-dos; sid:2019346; rev:2; metadata:created_at 2014_10_03, updated_at 2014_10_03;)
    tcp = TCP(sport=1061, dport=80)
    payload = b'GET / HTTP/1.1\x0d\x0a\x0d\x0a'
    pcap.write(eth / ip / tcp / payload)

    # ET DOS Terse HTTP GET Likely AnonMafiaIC DDoS tool
    # index 11 alert tcp $EXTERNAL_NET any -> $HOME_NET $HTTP_PORTS (msg:"ET DOS Terse HTTP GET Likely AnonMafiaIC DDoS tool"; flow:to_server,established; dsize:20; content:"GET / HTTP/1.0|0d 0a 0d 0a 0d 0a|"; depth:20; threshold:type both,track by_dst,count 500,seconds 60; classtype:attempted-dos; sid:2019348; rev:2; metadata:created_at 2014_10_03, updated_at 2014_10_03;)
    tcp = TCP(sport=1062, dport=80)
    payload = b'GET / HTTP/1.1\x0d\x0a\x0d\x0a\x0d\x0a'
    pcap.write(eth / ip / tcp / payload)

    # ET DOS Terse HTTP GET Likely AnonGhost DDoS tool
    # index 12 alert tcp $EXTERNAL_NET any -> $HOME_NET $HTTP_PORTS (msg:"ET DOS Terse HTTP GET Likely AnonGhost DDoS tool"; flow:to_server,established; dsize:20; content:"GET / HTTP/1.1|0d 0a 0d 0a 0d 0a|"; depth:20; threshold:type both,track by_dst,count 500,seconds 60; classtype:attempted-dos; sid:2019349; rev:2; metadata:created_at 2014_10_03, updated_at 2014_10_03;)
    tcp = TCP(sport=1063, dport=80)
    payload = b'GET / HTTP/1.1\x0d\x0a\x0d\x0a\x0d\x0a'
    pcap.write(eth / ip / tcp / payload)

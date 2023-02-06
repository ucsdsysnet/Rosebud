# Firewall accelerator generator

## Introduction

The scripts in this directory parse the <ins>firewall.txt</ins> file to
generate an accelerator that matches against the IP addresses in that file. 

This set of IPs were obtained from:
```https://rules:emergingthreats:net/fwrules/emerging-PF-DROP:rules```

## How to generate

To generate the accelerator follow the following steps:
* run prefix_parser.py [optional] run data_analyzer.py to see ip distribution,
* for example to see longest prefix is /24, which is used in the next step.
* run ip_match_generator.py to generate the verilog files

To generate a test pcap trace:
* run pcap_gen.py

## History
This directory include a simplified version from another project, where we
analyzed IP forwarding rules for backbone internet. Idea being to find the
target AS, and now simplified to being a match or not. For example, in that 
project we got the latest google CDN IPs by: 
``` curl https://www.gstatic.com/ipranges/cloud.json | jq '.prefixes[] | .ipv4Prefix // .ipv6Prefix' -r |sort -r ```
And then ran the python scripts to generate an accelerator from the input IP to
destination AS.

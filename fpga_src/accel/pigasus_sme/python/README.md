# PCAP generator for the Pigasus accelerator

## Inputs

<ins>all_rules.txt</ins> is from the Snort ruleset, and <ins>selected_rules</ins> are the rules that were used by the authors of the pigasus paper.
<ins>attack_test.pcap</ins> is the initial test pcap trace used by Pigasus Authors.

## Scripts

* pcap_gen.py: Reads the rule files and generates an attack traffic.
* safe_gen.py: Generates some safe traffic as background traffic (used in the Snort on Xeon CPU comparison test).
* rule_cleaner.py: Simplifies some of the rules, so the checks performed are the same as the checks done by the hardware acclerator (used in the Snort on Xeon CPU comparison test).
* hls_gen.py: Used to convert the rules into C code and then use Vivado HLS to generate the accelerator. <ins>final_mapping.txt</ins> is used by this script, which was output of the <ins>pcap_gen.py</ins> script as it did the parsing of the rules. This effort was forwent as Vitis HLS was very slow, but we kept the scripts for future use.

# To merge pigasus rules:
# grep -h -v "^#" no_file_data_no_nocase/*.rules | grep -v "^$$" > all_rules.txt

pcap:
	python3 pcap_gen.py --rules_file all_rules.txt --selected_file selected_rules --ooo_pkts 0 --min_pkt_size 128 --max_pkt_size 1440 --output_pcap attack_pcap_no_ooo.pcap
	python3 pcap_gen.py --rules_file all_rules.txt --selected_file selected_rules --ooo_pkts 6 --min_pkt_size 128 --max_pkt_size 1440 --output_pcap attack_pcap_6_perc_ooo.pcap

hls:
	python3 hls_gen.py

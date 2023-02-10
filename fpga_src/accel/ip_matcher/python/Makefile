DEV  = mqnic0
INT  = $(shell ls /sys/class/misc/$(DEV)/device/net | head -1)
MTU  = 9000

run:
	sudo tcpreplay -i $(INT) -K --mbps 5000 --loop 1000000 firewall_test.pcap

gen:
	python3 pcap_gen.py

set_mtu:
	sudo ip link set $(INT) down
	sudo ip link set dev $(INT) mtu $(MTU)
	sudo ip link set $(INT) up

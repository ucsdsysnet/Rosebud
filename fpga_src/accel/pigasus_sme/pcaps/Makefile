# 1% of 200 is 2000, times max rate, divided by 200, becomes 10 times the max rate
MAX_RATE_64   = 1454
MAX_RATE_128  = 1684
MAX_RATE_256  = 1829
MAX_RATE_512  = 1910
MAX_RATE_800  = 1942
MAX_RATE_1024 = 1954
MAX_RATE_1500 = 1968
MAX_RATE_2048 = 1977
MAX_RATE_4096 = 1988
MAX_RATE_9000 = 1995

SIZE = 1024
RATE = $(MAX_RATE_$(SIZE))
DEV  = mqnic0
INT  = $(shell ls /sys/class/misc/$(DEV)/device/net | head -1)
MTU  = 4096

safe:
	sudo tcpreplay -i $(INT) -K --mbps $(RATE) --loop 1000000 safe_pcap_no_ooo_$(SIZE).pcap

safe_ooo:
	sudo tcpreplay -i $(INT) -K --mbps $(RATE) --loop 1000000 safe_pcap_6_perc_$(SIZE).pcap

attack:
	sudo tcpreplay -i $(INT) -K --mbps $(RATE) --loop 1000000 attack_pcap_no_ooo.pcap

attack_ooo:
	sudo tcpreplay -i $(INT) -K --mbps $(RATE) --loop 1000000 attack_pcap_6_perc_ooo.pcap

set_mtu:
	sudo ip link set $(INT) down
	sudo ip link set dev $(INT) mtu $(MTU)
	sudo ip link set $(INT) up

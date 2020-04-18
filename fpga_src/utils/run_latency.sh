#!/bin/bash

for i in 64 65 128 256 512 1024 1500 2048 4096 9000; do
	make -C ../../c_code/ NAME=latency_$i
  sudo ./pcie_hot_reset.sh 02:00.0
  sleep 1s
  sudo ./rvfw -d /dev/mqnic1 -i /home/moein/BumpinTheWire/c_code/latency_$i\_ins.bin -e 0xffff -r 0xaaaa
	sudo timeout -k 0 5s ./perf -d /dev/mqnic1 -o latency_$i.csv -g 12
  sudo tcpdump -c 100 -i eth1 -w latency_$i.pcap 
  sudo ./pcie_hot_reset.sh 02:00.0
done

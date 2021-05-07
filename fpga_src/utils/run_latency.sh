#!/bin/bash

dev=mqnic0
eth=$(ls /sys/class/misc/$dev/device/net | head -1)
pci_id=$(basename $(readlink /sys/class/misc/$dev/device))

mkdir -p latency_res

for i in 64 65 128 256 512 1024 1500 2048 4096 9000; do
	make -C ../../c_code/ NAME=latency TARGET=latency_$i SRC=latency.c DEFINES="-DSIZE=$i"
  sudo ./pcie_hot_reset.sh $pci_id
  sleep 1s
  sudo ip link set dev $eth up
  sudo ./rvfw -d /dev/$dev -i ../../c_code/latency_$i\_ins.bin -e 0xffff -r 0xaaaa -m ../../c_code/latency.map
  sudo timeout -k 0 5s ./perf -d /dev/$dev -o latency_$i.csv -g 12

  sudo tcpdump -c 100 -i $eth -w latency_res/latency_$i.pcap
  sudo ./pcie_hot_reset.sh $pci_id
done

#!/bin/bash

for i in $(ls latency*/*.pcap | sort -V -t "/" -k 2); do
  echo $i
  ./pcap_parser.py $i > ${i%.*}.txt
  awk '{ total += $1; count++ } END { print total/count }' ${i%.*}.txt
done


# Rosebud for VCU1525, with 8 RPUs

## Introduction

This design targets the Xilinx VCU1525 FPGA board.

* FPGA: xcvu9p-fsgd2104-2L-e
* MAC: Xilinx 100G CMAC
* PHY: 100G CAUI-4 CMAC and internal GTY transceivers

## How to build

Run ```make``` to build the FPGA image. It will first generate the base Rosebud
framework design (```make base_0```), and then build the Pigasus case study
for the RPUs. To do so, it first builds RPUs with Pigasus (```make
PIG_Hash_1```), then uses the base design and just replaces the
loadbalancer with a Round Robin one (```make base_RR_2```), and finally
merges the results of the previous two (```make PIG_RR_3```).

(Vivado can build PR runs from the base run, hence the merging speeds up the process.)

Ensure that the Xilinx Vivado toolchain components are in PATH.

## Generate utilization reports

```make csv``` generates the required resource utilization reports, and parses
them into a csv file.

(```make parselog``` and its variations are for debugging purposes to parse the
Vivado output log file.)

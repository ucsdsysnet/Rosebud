# Rosebud for Alveo U200, with 16 RPUs

## Introduction

This design targets the Xilinx VCU1525 FPGA board.

* FPGA: xcu200-fsgd2104-2-e
* MAC: Xilinx 100G CMAC
* PHY: 100G CAUI-4 CMAC and internal GTY transceivers

## How to build

Run ```make``` to build the FPGA image. It will first generate the base Rosebud
framework design (```make base_0```), and then build the Firewall case study
for the RPUs (```make FW_RR_1```).

Ensure that the Xilinx Vivado toolchain components are in PATH.

## Generate utilization reports

```make csv``` generates the required resource utilization reports, and parses
them into a csv file.

(```make parselog``` and its variations are for debugging purposes to parse the
Vivado output log file.)

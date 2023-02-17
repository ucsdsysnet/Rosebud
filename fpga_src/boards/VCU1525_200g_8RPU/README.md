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

Ensure that the Xilinx Vivado toolchain components are in PATH.

* We can go directly from base to using round robin LB and RSUs with Pigasus, but it takes longer and might fail as it might get to challenging for the heuristic algorithms. <ins>run_PIG_RR.tcl</ins> uses this method, but during development iterations sometimes it met timing and sometimes it failed. 

* Vivado does not support use of child runs (PR runs) in another child run, only you can reuse the PR modules from the parent run (here the base run with static regions).If it is only merging the PR regions from the child runs, we can use the non-project mode and add an in_memory project to get around this issue. For example, <ins>run_PIG_RR_merge.tcl</ins> does this and picks the RSUs from *PIG_Hash_1* run and the LB from *base_RR_2* run. However, if we want to only change some of the PR runs relative to another child run, and let the place and route run, things get more complicated. Using some hacky method that within the run changes some file contents from Linux shell, <ins>run_PIG_RR_inc.tcl</ins> can use RSUs from *PIG_Hash_1* and then build the round robin LB and attach them. That being said, using an extra child with only the LB changed and then merging them is faster and not hacky, and hence that script is just as archive. 


## Generate utilization reports

```make csv``` generates the required resource utilization reports, and parses
them into a csv file.

(```make parselog``` and its variations are for debugging purposes to parse the
Vivado output log file.)

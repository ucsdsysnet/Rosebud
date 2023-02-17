# Rosebud C library for RISCV cores within RPU

## Library files and how to build a binary

*	<ins>core.h</ins> is the header file for functions to talk to the RPU interconnect.
*	<ins>riscv_encoding.h</ins> has the defines for the VexRiscv. 
*	<ins>startup.S</ins> has the required boot process for the core to initialize stack and prepare the interrupts, and jump to start of the code.
*	<ins>link_option.ld</ins> provide the mapping of segments based on the Rosebud addressing. 
<ins>packet_headers.h</ins> is a set of structs for TCP/UDP packets.
*	<ins>int_handler</ins> is a default interrupt handler if user does not want to specify their own. 
*	<ins>hex_gen.py</ins> script converts the output binary files based on the required format of RISCV cores.

To build a C file you can run ```make NAME=basic_fw```, where NAME is the name of the c file. You can also pass parameters using DEFINES, for example:
```make NAME=pkt_gen DEFINES="-DPKT_SIZE=1500"```

The make rule will also output the assembly output for verification, and ELF output to be used in the Python testbenches. It also generates separate files for instruction memory and data memory that can be directly loaded.

<ins>table_gen.py</ins> generates supplemntary binary files to initialize the data and packet memories with 0, namely <ins>empty_dmem.bin</ins>, <ins>empty_half_pmem.bin</ins> and <ins>empty_pmem.bin</ins>. It also produces two example binaries, <ins>table.bin</ins> and <ins>table_qtr1.bin</ins>, which can be used as initializing part of the packet memory as a lookup table for the RISCV code.

Note that to tell the firmware loader script to load specific binary into data memory or packet memory, it should be declared in a <ins>.map</ins> file. For example, <ins>basic_pkt_gen.map</ins> and <ins>latency.map</ins>only instructs the firmware loader to initialize the data and packet memories with zero, while <ins>pkt_gen.map</ins> has some heap data and that also gets written after the initialization step.

## Example C codes

Forwarding:
* <ins>loopback.c</ins>: loops back packets to the interface they came in from.
* <ins>basic_fw.c</ins>: Same code as <ins>loopback.c</ins> in a more optimized method without using function calls.
* <ins>basic_corundum_fw.c</ins>: Forwards all the traffic from the host to the fw_port, and drops the rest of the traffic.
* <ins>basic_corundum_tb.c</ins>: Forwards between the host and the first physical Ethernet, used for the corundum testbench.
* <ins>inter_core.c</ins>: Example use of inter-core messages. Packets arrive from the first physical Ethernet port to the first half of the RPUs. Then they are forwarded to the second half, which send the packets to the second phyiscal port.


Packet generator:
* <ins>basic_pkt_gen.c</ins>: Each packet is all zeros from the firmware loader initialization. Before send, they are stamped with the ID of the generator RPU, as well as a sequence number increased per packet generated. Based on the RPU cluster, they send the data to first or second physical port.
* <ins>pkt_gen.c</ins>: A more sophisticated packet generator that creates TCP/UDP packets and generates flow ID based on random number generation provided by <ins>pcg_basic.c/h</ins>. It also includes patterns in the payload for deep packet inspection tests. It drops packets received from the Ethernet physical ports, and injects the packets received from the host within the generated traffic.
* <ins>rx_bw.c</ins>: 12 out of 16 cores generate packets, and 4 receive and drop packets. A mixed tests of dropping and packet generation to see combined impact.


Latency tnd broadcast messaging tests:
* <ins>latency.c</ins>: Each core generates some packets and timestamps them before sending them out. The packets are looped back, either with an in-port loopback module or through another FPGA with Rosebud design that uses the forwarding firmware. After the packets arrive back at the tester FPGA, the difference in time is measured. (Timers in all RPUs are synced). This values are periodically sent to the host. Size of the packet is parameterized and can be changed through the ```make```.
* <ins>bc_waterfall.c</ins>: Each core assumes a specific 4B location in the broadcast region, where it looks for new data. The other cores write to the location for the next core. In this test, the first riscv core will constantly read the timer and write it to broadcast messaging region of the second core. The other cores will check that location in memory, and when the value is changed, they write their local timer to the next core's assigned broadcast location, and also compare the received data nad local timer to measure time of travel for the broadcast message. They write this time into their memory, and after a message full of such values is ready, they send it to host. The first core just writes and starts the process among the other cores, and hence the waterfall name.
* <ins>bc_all_to_all.c</ins>: Similar to the <ins>bc_waterfall.c</ins> code, but here every core writes to the next core's allocated memory. Also instead of doing the computation for time of travel, only the time stamps are included in the packet sent to host, while only 1 in 10 packets are sent, as in this mode there is more communication among the cores.


System tests:
* <ins>drop.c</ins>: Every packet is dropped. 
* <ins>dram_test.c</ins>: Same code as <ins>loopback.c</ins>, while in the boot process writes to host DRAM and reads back those values. Also exposes a read from packet memory. Used mainly in the Python testbenches. 
* <ins>cor_test.c</ins>: Same code as <ins>basic_pkt_gen.c</ins>, where all the generated traffic goes to the host. Used to verify the operation of the Corundum driver.
* <ins>basic_fw_n_bc.c</ins>: Same code as <ins>loopback.c</ins> where ```set_bc_filter()``` is tested. This function sets which brodcast messages notify the core, based on its address. The goal being that for a longer message, the sender core first writes the data throught broadcast messages, and then writes to this speicifc address with some metadata regarding the rest of the message. This way the cores can use event based handlign of broadcast messages and not poll all the time.  
* <ins>timer_test.c</ins>: Timer step verification, by sending a message to the host in a priodic manner.
* <ins>len_check.c</ins>: Example debugging script to catch problematic packets and send them to host. This was used to debug a buggy condition that CMAC IP caused corrupted messages.

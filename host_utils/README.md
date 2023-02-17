# Host side drivers, libraries, and test scripts

## Programming the FPGA

You can program the FPGA by the runtime/loadbit.sh script, and also get the list of devices and get their status either by target_index or the target ID:
```
./loadbit.sh list
./loadbit.sh prog RR_accel_1_8.bit --target_index=0
./loadbit.sh status --target "*06xx"
```

After programming the FPGA for the first time, a system reboot is required for the PCIe IP to properly be recognized.

* If there are multiple cards in a single machine, sometime the <ins>loadbit.sh</ins> script can only program the first card. In that situation you need to run Vivado to program the boards.
* If after programming, PCIe enumeration fails and host cannot see an FPGA (missing in lspci or when driver is loaded), a system reboot and then reload of the Corundum driver is required (no need to reprogram).

## Loading the driver

To build the driver, go to driver/mqnic and do

```make```

Then you can load the driver with

```sudo insmod mqnic.ko```

* If this operation fails, with errors such as ```mqnic: Unknown symbol ptp_clock_index (err 0)```, do ```modprobe ptp```

Now we need to reset the PCIe card to let the driver be properly loaded. To do so run the pcie_hot_reset.sh from runtime directory based on the device PCIe address, found in ```lspci``` output. For example:

```sudo ./pcie_hot_reset.sh 81:00.0```

If necessary to remove the driver, you can do so by:

```sudo rmmod mqnic.ko```

## Generating runtime binaries

There are 4 runtime binaries which all can be made by running ```make``` from the runtime directory. Their role are:
* rvfw: loads the firmware for RISCV codes, and configures the load balancer.
* perf: Reads back status of the system during runtime. Such as number of bytes and frames sent and received per RPU and interface, number of stalls, number of available slots, or some debug register values if they change from 0.
* dump: Similar to perf, but dumps to a file and runs for a limited time.
* pr_reload: Performs the steps to reload RPUs. Meaning puts each RPU into sleep, does the PR update process through Vivado, and reinitializes the RPU and boots it. The current binary is intended for our PR reload latency measurement experiment, and hence does reload of all RPUs for several iterations.

These binaries use the mqnic.c/h and rpu.c.h which are the developed host side libraries to access the Rosebud system through the Corundum driver, and the APIs to talk to RPUs and LB in Rosebud. Also timespec.c/h is used for the timing tests. For the PR reload, we use the mcap driver from Xilinx.

Note that rvfw overrides RPU memories with zero. To generate the zero blocks used for this purpose, go to <ins>Rosebud/riscv_code</ins> and run ```table_gen.py```. This script would generate files such as <ins>empty_dmem.bin</ins> and <ins>empty_pmem.bin</ins> if you got an error that they are missing.

## Makefile based experiments

To use Rosebud, binaries for RISC-V cores on the FPGA should be generated first. Then, they should be loaded to the cores, and also system setting such as receiving cores for the load balancer should be set. Finally, the host side profiling utility can be run to measure the throughput of the system. All these steps are performed from the ```make do``` rule in runtime directiry.

Different experiemnts can be run by changing the test firmware and setting the desired parameteres. You can pass these arguments to the ```make do``` rule:
* <ins>DEST_DIR</ins>: sets the directory to look for the RISC-V C file.
* <ins>TEST</ins>: Name of the main C file for the test.
* <ins>RPUs</ins>: Passes the number of RPUs as a parameter to the host binaries.
* <ins>PKT_SIZE</ins>: Passes the packet size to the C file as a parameter.
* <ins>DEV</ins>: Sets the destination devices. If several FPGAs with Corundum interface are installed on the same machine, they can be addressed, e.g., <ins>mqnic0</ins> and <ins>mqnic1</ins>.
* <ins>ENABLE</ins>: Sets the active RPUs. This determines which RPUs get the firmware and load balancer considers them active. Can be used to disable some of the RPUs for the testing purposes.
* <ins>RECV</ins>: Sets the receiving RPUs in the load balancer. For instance, if we want to make a pipeline of two RPUs for each packet, we can set the first half of the RPUs to be receivers, which will receive the packets from the external interfaces, and then use the inter-core messaging to send the packets to the second half of the RPUs. Another example is if we want to use half of the cores to send data and half of them to receive data.
* <ins>BLOCK_INTS</ins>: Sets the Ethernet interface, whether physical or virtual, which do not receive any packets. For example, when using the Rosebud in packet generator mode while injecting traffic received from the host, we want to block packets coming from the physical Ethernet ports.
* <ins>DEBUG</ins>: Sets the debug register to look for. If a flag is raised within that debug register, from any RPU, the perf binary will print it. Used for debugging purposes.
* <ins>OUT_FILE</ins>: Sets the output for the accumulated results generated by the perf binary.

For instance, for the throughput test on a single machine with two Rosebud FPGAs we can run these in parallel:

```
make do TEST=basic_fw RECV=0xffff ENABLE=0xffff DEV=mqnic0
```

and 

```
make do TEST=pkt_gen RECV=0x0000 ENABLE=0xffff DEV=mqnic1 PKT_SIZE=1500
```

The first command loads the packet forwarding firmware on the first FPGA, and the second command loads the basic packet generator that generates same size packets on the second FPGA. For the packet generator FPGA we set the RPUs with incoming traffic to none (set RECV flag to 0), as we are only generating packets.
Now wait for the packets to flow for a minute to get a good average, and stop the process on the tester FPGA using Ctrl+C. The last print of the status table is the average values, and in the “RX bytes” field you can read the aggregate bytes per second for the physical and virtual Ethernet interfaces, which, on the forwarder FPGA, shows how much data could be absorbed and processed. To test different packet sizes, you can stop both commands, and rerun them by changing the packet size argument for the tester FPGA.

It's better to first run the basic_fw so the FPGA is ready to receive the packets, and then start the pkt_gen. This is not necessary, but for more consistent results you can run ```make reset_all``` to reset the FPGAs before each test.

If we want to see perfomance of 8 RPUs instead of 16 RPUs, we don't need to reload the FPGA with the 8RPU image, instead we can change the forwarder to do:

```
make do TEST=basic_fw RECV=0xaaaa ENABLE=0xaaaa DEV=mqnic0
```
where half of the RPUs are active.

If the firmware is already loaded, we can use ```make status``` which only runs the perf script according to the corresponding arguments. For the PR reload test, we can run ```make pr_test```. For reseting the FPGAs, the ```make reset_all``` rule resets all the FPGAs based on the vendor and device ID seen by the host system. ```make reset``` resets specific device set by <ins>DEV</ins>.

## Latency test scripts

To measure the forwarding latency, we have to measure the latency once with loopback transceiver in the ports (or running a 100G cable between them), and once by going from the packet generator FPGA to the forwarder FPGA and back, and compute the difference. To compute the forwarding latency value, we timestamp the packets
before sending them from the tester FPGA, and after they arrive after getting forwarded in the DUT FPGA (Timers in all RPUs are synced). This values are periodically sent to the host.  

When using a forwarding FPGA, do:
```make do TEST=basic\_fw RECV=0xaaaa ENABLE=0xffff DEV=mqnic0```.

The firmware for latency test uses half of the RPUs to generate the traffic, and half of them to receive the traffic. On the forwarder FPGA, we enable only half of the cores to be properly comparable and not underestimate the latency under high load.

For packet generator FPGA, run:
```sudo ./run_latency.sh mqnic1```

This script would run the test for different packet sizes, and use tcpdump to capture the latency values sent by the RPUs. Now replace the forwareder FPGA with a 100G cable and change the output directory by running ```sudo ./run_latency.sh mqnic1 1l```. 

Finally run ```latency_data_extractor.sh``` to extract the values reported by the RPUs from the pcaps. After this step, a unified file for the average values is generated pre experiment and across different packet sizes. The forwarding latency can be computed by deducting the values for each packet size.

## Running Firewall case study

To run the code for case studies, use ```make do``` similar to the previous step. For the firewall case study we run these two commands in 2 different shells:

```
make do TEST=pkt_gen RECV=0xffff ENABLE=0xffff DEV=mqnic1 BLOCK_INTS=3 PKT_SIZE=1024
```

and 

```
make do TEST=firewall DEST_DIR=../../fpga_src/accel/ip_matcher/c/ RECV=0xffff ENABLE=0xffff DEV=mqnic0
```

The first command is like before, just disabling the physical Ethernet ports to allow traffic injection only from the host. The second command sets the firmware to firewall and also requires the image with the firewall accelerator. 

Now to inject the attack traffic, from a different shell run ```make gen``` in <ins>fpga_src/accel/ip_matcher/python</ins> to create the desired traffic. The from the same directory do:

```make set_mtu DEV=mqnic1; make run DEV=mqnic1```

This will inject the trace at about 5 Gbps. You can keep this packet injector running, and similar to the forwarding throughput experiment, stop the other two ```make do``` shells to observe the RX Bytes on the forwarder FPGA, and set a different packet size for the packet generator FPGA. If ```make reset_all``` is used in any step, rerun the the injector script. 

For application verification, on the tester FPGA you can run:

```make do TEST=basic_corundum_fw RECV=0xffff ENABLE=0xffff DEV=mqnic1 BLOCK_INTS=3```

Now the tester FPGA will only forward packets received from the host to the DUT FPGA, and drop rate can be verified through the ratio of TX to RX frames. It should be close to the generated pcap with 1050 attack packets and only 4 safe packets. 


## Running Pigasus case study

For the Pigasus case study and in HW reordering mode, we program the FPGA, reset it, and then run the firmware:

```
./loadbit.sh prog ../../bitfiles/VCU1525_8RPU_Pigasus_RR_LB.bit
make reset_all
make do DEST_DIR=../../fpga_src/accel/pigasus_sme/c/ TEST=pigasus2 RECV=0xffff ENABLE=0xffff DEV=mqnic0 RPUS=8
```

For the packet generator, similar to the firewall case study run:

```
make do TEST=pkt_gen RECV=0xffff ENABLE=0xffff DEV=mqnic1 BLOCK_INTS=3 PKT_SIZE=1024
```

To generate the traces for this test, from a third shell and <ins>fpga_src/accel/pigasus_sme/python/</ins> directory, run ```make``` and then ```mv attack_pcap_* ../pcaps/```. Now from <ins>fpga_src/accel/pigasus_sme/pcaps/</ins> directory run:

```
make set_mtu DEV=mqnic1; make attack DEV=mqnic1 SIZE=1024
```

This script will adjust the attack rate to be close to one percent. Similar to the forwarding throughput experiment, you can pause the two ```make do``` runs and check the RX bytes.


For SW-based reordering results, change the image and firmware and repeat the same testing process. Fom <ins>host_utils/runtime</ins> run:

```
./loadbit.sh prog ../../bitfiles/VCU1525_8RPU_Pigasus_Hash_LB.bit
make reset_all
make do DEST_DIR=../../fpga_src/accel/pigasus_sme/c/ TEST=pigasus RECV=0xffff ENABLE=0xffff DEV=mqnic0 RPUS=8
```

In both tests, the matched packets in this case study are sent to the host and can be seen with tcp_dump.

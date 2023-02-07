# Directory structure
* c: Has the c files specific to use of this accelerator, alongside softlinks for the Rosebud C library. <ins>firewall.c</ins> is the base code, and <ins>firewall2.c</ins> is slightly optimized version with less call stack as an example.
* python: Has the scripts to generate an IP matching accelerator from a file containing list of rules. There is an script to generate a test pcap from that list as well.
* rtl: The generated Verilog files for the accelerator. Also there is the accelerator wrapper module to connect the accelerator within an RPU.
* tb: The testbench to use the accelerator, including the top-level test wrapper module in Verilog, and the testbench in Python.

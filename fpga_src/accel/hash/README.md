# Directory structure
* c: Has the c files specific to use of this accelerator, alongside softlinks for the Rosebud C library. <ins>basic_fw_hash.c</ins> is basic use of the accelerator, and <ins>basic_fw_hash2.c</ins> adds tables for different protocols to decide to forward or drop.
* rtl: Includes the Verilog files for the accelerator. Also there is the accelerator wrapper module to connect the accelerator within an RPU.

import re;

# extract first level modules
def extract (read_file,modules,avg,tot,avg_p,tot_p):
  count = 0

  LUT       = 0
  LGCLUT    = 0
  LUTRAM    = 0 
  SRL       = 0
  FF        = 0
  RAMB36    = 0 
  RAMB18    = 0 
  URAM      = 0 
  DSP       = 0
  
  LUT_P     = 0.0
  LGCLUT_P  = 0.0
  LUTRAM_P  = 0.0 
  SRL_P     = 0.0
  FF_P      = 0.0
  RAMB36_P  = 0.0 
  RAMB18_P  = 0.0 
  URAM_P    = 0.0 
  DSP_P     = 0.0
  
  # header = ['Instance', 'Module', 'PR Attribute', 'Total PPLOCs', 'Total LUTs', 'Logic LUTs', 
  #           'LUTRAMs', 'SRLs', 'FFs', 'RAMB36', 'RAMB18', 'URAM', 'DSP48 Blocks']

  for line in open (read_file,'r'):
    for m in modules:
      if re.match("^\|"+m,line):
        data = [x for x in re.split("\||\s*|,",line) if x]
        data = [re.split("\(|\)|%",x) for x in data]
        data = [(float(x[0]),float(x[1])) if len(x)==4 else x[0] for x in data]
        count += 1

        LUT    += data[4][0]
        LGCLUT += data[5][0]
        LUTRAM += data[6][0]
        SRL    += data[7][0]
        FF     += data[8][0]
        RAMB36 += data[9][0]
        RAMB18 += data[10][0]
        URAM   += data[11][0]
        DSP    += data[12][0]

        LUT_P    += data[4][1]
        LGCLUT_P += data[5][1]
        LUTRAM_P += data[6][1]
        SRL_P    += data[7][1]
        FF_P     += data[8][1]
        RAMB36_P += data[9][1]
        RAMB18_P += data[10][1]
        URAM_P   += data[11][1]
        DSP_P    += data[12][1]

  if (avg_p):
    print ("Average utilization percentage. LUT:%.2f%%\tLogic:%.2f%%\tLUTRAM:%.2f%%\tSRL:%.2f%%\tFF:%.2f%%\tRAMB36:%.2f%% RAMB18:%.2f%% URAM:%.2f%% DSP:%.2f%%"
            %(LUT_P/count, LGCLUT_P/count, LUTRAM_P/count, SRL_P/count, FF_P/count, RAMB36_P/count, RAMB18_P/count, URAM_P/count, DSP_P/count))
  if (avg):
    print ("Average utilization.            LUT:%.2f\tLogic:%.2f\tLUTRAM:%.2f\tSRL:%.2f\tFF:%.2f\tRAMB36:%.2f RAMB18:%.2f URAM:%.2f DSP:%.2f"
            %(LUT/count, LGCLUT/count, LUTRAM/count, SRL/count, FF/count, RAMB36/count, RAMB18/count, URAM/count, DSP/count))

  if (tot_p):
    print ("Total utilization percentage.   LUT:%.2f%%\tLogic:%.2f%%\tLUTRAM:%.2f%%\tSRL:%.2f%%\tFF:%.2f%%\tRAMB36:%.2f%% RAMB18:%.2f%% URAM:%.2f%% DSP:%.2f%%"
            %(LUT_P, LGCLUT_P, LUTRAM_P, SRL_P, FF_P, RAMB36_P, RAMB18_P, URAM_P, DSP_P))
  if (tot):
    print ("Total utilization.              LUT:%.2f\tLogic:%.2f\tLUTRAM:%.2f\tSRL:%.2f\tFF:%.2f\tRAMB36:%.2f RAMB18:%.2f URAM:%.2f DSP:%.2f"
            %(LUT, LGCLUT, LUTRAM, SRL, FF, RAMB36, RAMB18, URAM, DSP))

MAC_modules = [
"     MAC_async_FIFO\[0\]\.mac_rx_fifo_inst",
"     MAC_async_FIFO\[0\]\.mac_rx_pipeline",
"     MAC_async_FIFO\[0\]\.mac_tx_fifo_inst",
"     MAC_async_FIFO\[0\]\.mac_tx_pipeline",
"     MAC_async_FIFO\[1\]\.mac_rx_fifo_inst",
"     MAC_async_FIFO\[1\]\.mac_rx_pipeline",
"     MAC_async_FIFO\[1\]\.mac_tx_fifo_inst",
"     MAC_async_FIFO\[1\]\.mac_tx_pipeline",
"   qsfp0_cmac_inst",
"   qsfp0_cmac_pad_inst",
"   qsfp1_cmac_inst",
"   qsfp1_cmac_pad_inst"]

SW_n_stat_modules = [
"     \(core_inst\)",
"     core_stat_data_reg",
"     cores_to_broadcaster",
"     ctrl_in_sw",
"     ctrl_out_sw",
"     data_in_sw",
"     data_out_sw",
"     dram_ctrl_in_sw",
"     dram_ctrl_out_sw",
"     interface_incoming_stat",
"     interface_outgoing_stat",
"     loopback_msg_fifo_inst"]

PCIe_modules = [
"     pcie_config_inst",
"     pcie_controller_inst",
"   pcie4_uscale_plus_inst",
"   pcie_us_cfg_inst",
"   pcie_us_msi_inst"]

Core_wrappers = [
"     riscv_cores\[0\]\.core_wrapper", 
"     riscv_cores\[1\]\.core_wrapper",
"     riscv_cores\[2\]\.core_wrapper",
"     riscv_cores\[3\]\.core_wrapper",
"     riscv_cores\[4\]\.core_wrapper",
"     riscv_cores\[5\]\.core_wrapper",
"     riscv_cores\[6\]\.core_wrapper",
"     riscv_cores\[7\]\.core_wrapper",
"     riscv_cores\[8\]\.core_wrapper",
"     riscv_cores\[9\]\.core_wrapper",
"     riscv_cores\[10\]\.core_wrapper",
"     riscv_cores\[11\]\.core_wrapper",
"     riscv_cores\[12\]\.core_wrapper",
"     riscv_cores\[13\]\.core_wrapper",
"     riscv_cores\[14\]\.core_wrapper",
"     riscv_cores\[15\]\.core_wrapper"]

Gushehs = [
"     riscv_cores\[0\]\.pr_wrapper",
"     riscv_cores\[1\]\.pr_wrapper",
"     riscv_cores\[2\]\.pr_wrapper",
"     riscv_cores\[3\]\.pr_wrapper",
"     riscv_cores\[4\]\.pr_wrapper",
"     riscv_cores\[5\]\.pr_wrapper",
"     riscv_cores\[6\]\.pr_wrapper",
"     riscv_cores\[7\]\.pr_wrapper",
"     riscv_cores\[8\]\.pr_wrapper",
"     riscv_cores\[9\]\.pr_wrapper",
"     riscv_cores\[10\]\.pr_wrapper",
"     riscv_cores\[11\]\.pr_wrapper",
"     riscv_cores\[12\]\.pr_wrapper",
"     riscv_cores\[13\]\.pr_wrapper",
"     riscv_cores\[14\]\.pr_wrapper",
"     riscv_cores\[15\]\.pr_wrapper"]

Scheduler_module = ["     scheduler"]


mem_modules = ["         memories"]
riscv_modules = ["         core"]
hash_modules = ["           hash_acc_inst"]
acc_manager =   ["           \(accel_wrap_inst\)"]
regex_modules = [
"           genblk1\[0\]\.regex_acc_inst ",
"           genblk1\[1\]\.regex_acc_inst ",
"           genblk1\[2\]\.regex_acc_inst ",
"           genblk1\[3\]\.regex_acc_inst ",
"           genblk1\[4\]\.regex_acc_inst ",
"           genblk1\[5\]\.regex_acc_inst ",
"           genblk1\[6\]\.regex_acc_inst ",
"           genblk1\[7\]\.regex_acc_inst "]


f = "fpga_utilization_hierarchy_placed_full.rpt"

print ("Gusheh stats:")
extract(f,Gushehs, 1,1,1,0)
print ("Wrapper stats:")
extract(f,Core_wrappers,1,1,0,0)
print ("Scheduler stats:")
extract(f,Scheduler_module,0,1,0,0)
print ("MAC stats:")
extract(f,MAC_modules,0,1,0,0)
print ("SW stats:")
extract(f,SW_n_stat_modules,0,1,0,0)
print ("PCIe stats:")
extract(f,PCIe_modules,0,1,0,0)
print ("Full FPGA:")
extract(f,[" fpga"],0,1,0,0)

print ("\n\nmem_modules")
extract(f,mem_modules, 1,1,1,0)
print ("riscv_modules")
extract(f,riscv_modules, 1,1,1,0)
print ("regex_modules")
extract(f,regex_modules, 1,1,1,0)
print ("hash_modules")
extract(f,hash_modules, 1,1,1,0)
print ("accelerator manager")
extract(f,acc_manager, 1,1,1,0)


f = "fpga_utilization_hierarchy_placed_full_no_accel.rpt"

print ("\n\nGusheh raw stats:")
extract(f,Gushehs, 1,1,1,0)
print ("Full FPGA:")
extract(f,[" fpga"],0,1,0,0)


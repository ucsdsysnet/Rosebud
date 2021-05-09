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
        data = [x for x in re.split("\||\s+|,",line) if x]
        # print (data)
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
"     MAC_async_FIFO\[0\]\.mac_rx_async_fifo_inst",
"     MAC_async_FIFO\[0\]\.mac_rx_fifo_inst",
"     MAC_async_FIFO\[0\]\.mac_rx_pipeline",
"     MAC_async_FIFO\[0\]\.mac_tx_fifo_inst",
"     MAC_async_FIFO\[0\]\.mac_tx_pipeline",
"     MAC_async_FIFO\[1\]\.mac_rx_async_fifo_inst",
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

PR_regs = [
"       \(riscv_cores\[0\]\.pr_wrapper\) ",
"       \(riscv_cores\[1\]\.pr_wrapper\) ",
"       \(riscv_cores\[2\]\.pr_wrapper\) ",
"       \(riscv_cores\[3\]\.pr_wrapper\) ",
"       \(riscv_cores\[4\]\.pr_wrapper\) ",
"       \(riscv_cores\[5\]\.pr_wrapper\) ",
"       \(riscv_cores\[6\]\.pr_wrapper\) ",
"       \(riscv_cores\[7\]\.pr_wrapper\) ",
"       \(riscv_cores\[8\]\.pr_wrapper\) ",
"       \(riscv_cores\[9\]\.pr_wrapper\) ",
"       \(riscv_cores\[10\]\.pr_wrapper\) ",
"       \(riscv_cores\[11\]\.pr_wrapper\) ",
"       \(riscv_cores\[12\]\.pr_wrapper\) ",
"       \(riscv_cores\[13\]\.pr_wrapper\) ",
"       \(riscv_cores\[14\]\.pr_wrapper\) ",
"       \(riscv_cores\[15\]\.pr_wrapper\) "]

Scheduler_module = ["     scheduler"]


mem_modules = ["         memories"]
riscv_modules = ["         core"]
acc_manager =   ["           \(accel_wrap_inst\)"]
acc_dma =   ["           accel_dma_engine "]
fixed_sme = ["           fied_loc_sme\[12\]\.fixed_loc_sme_inst "]
http_sme = [
"           http_sme\[10\]\.http_sme_inst ",
"           http_sme\[11\]\.http_sme_inst ",
"           http_sme\[8\]\.http_sme_inst ",
"           http_sme\[9\]\.http_sme_inst "]

tcp_sme = [
"           tcp_sme\[0\]\.tcp_sme_inst ",
"           tcp_sme\[1\]\.tcp_sme_inst ",
"           tcp_sme\[2\]\.tcp_sme_inst ",
"           tcp_sme\[3\]\.tcp_sme_inst "]

udp_sme = [
"           udp_sme\[4\]\.udp_sme_inst ",
"           udp_sme\[5\]\.udp_sme_inst ",
"           udp_sme\[6\]\.udp_sme_inst ",
"           udp_sme\[7\]\.udp_sme_inst "]
width = [
"           width_converters_1B\[0\]\.accel_width_conv_inst ",
"           width_converters_1B\[10\]\.accel_width_conv_inst ",
"           width_converters_1B\[11\]\.accel_width_conv_inst ",
"           width_converters_1B\[1\]\.accel_width_conv_inst ",
"           width_converters_1B\[2\]\.accel_width_conv_inst ",
"           width_converters_1B\[3\]\.accel_width_conv_inst ",
"           width_converters_1B\[4\]\.accel_width_conv_inst ",
"           width_converters_1B\[5\]\.accel_width_conv_inst ",
"           width_converters_1B\[6\]\.accel_width_conv_inst ",
"           width_converters_1B\[7\]\.accel_width_conv_inst ",
"           width_converters_1B\[8\]\.accel_width_conv_inst ",
"           width_converters_1B\[9\]\.accel_width_conv_inst ",
"           width_converters_8B\[12\]\.accel_width_conv_inst "]
ip_match = ["           ip_match_inst "]

f = "fpga_utilization_hierarchy_placed_full.rpt"

print ("Gusheh stats:")
extract(f,Gushehs, 1,1,1,0)
print ("PR Regs stats:")
extract(f,PR_regs, 1,1,1,0)
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

print ("Gusheh stats:")
print ("\n\nmem_modules")
extract(f,mem_modules, 1,1,1,0)
print ("riscv_modules")
extract(f,riscv_modules, 1,1,1,0)
print ("fixed_sme")
extract(f,fixed_sme, 1,1,1,0)
print ("tcp_sme")
extract(f,tcp_sme, 1,1,1,0)
print ("udp_sme")
extract(f,udp_sme, 1,1,1,0)
print ("http_sme")
extract(f,http_sme, 1,1,1,0)
print ("ip_match")
extract(f,ip_match, 1,1,1,0)
print ("width")
extract(f,width, 0,1,0,1)
print ("accelerator manager")
extract(f,acc_manager, 1,1,1,0)
print ("accelerator DMA")
extract(f,acc_dma, 1,1,1,0)


f = "fpga_utilization_hierarchy_placed_raw.rpt"

print ("\n\nGusheh raw stats:")
extract(f,Gushehs, 1,1,1,0)
print ("Full FPGA:")
extract(f,[" fpga"],0,1,0,0)


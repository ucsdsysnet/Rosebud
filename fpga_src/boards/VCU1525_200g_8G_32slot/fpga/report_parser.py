from module_names import *
from util_extractor import *
from math import ceil
from glob import glob

csv_file           = "parsed_utilization_8G.csv"
Gousheh_pblock_pat = "fpga_utilization_Gousheh_*_PIG_HASH.rpt"
sched_pblock_rep   = "fpga_utilization_scheduler_PIG_HASH.rpt"
full_fpga_raw_rep  = "fpga_utilization_hierarchy_placed_raw.rpt"
full_fpga_acc_rep  = "fpga_utilization_hierarchy_placed_PIG_HASH.rpt"
Gousheh_count      = 8
FPGA_tot_resources = [1182240, 2364480, 2160, 960, 6840]

# LUTS, Registers, BRAM, URAM, DSP
Gousheh_pblock_rep = sorted(glob(Gousheh_pblock_pat), key=natural_keys)
Gousheh_tot_resources = [available (x) for x in Gousheh_pblock_rep]
Sched_tot_resources   = available (sched_pblock_rep)
Gousheh_avg_resources = \
    [ceil(sum(col)/float(len(col))) for col in zip(*Gousheh_tot_resources)]

print ("Available Resources:")
print ("Block       \tLUTS\tRegs\tBRAM\tURAM\tDSP")
print ("Avg Gousheh:\t"+"\t".join([str(x) for x in Gousheh_avg_resources]))
print ("Scheduler:\t"  +"\t".join([str(x) for x in Sched_tot_resources]))
print ("Full FPGA:\t"  +"\t".join([str(x) for x in FPGA_tot_resources]))

out_file = open(csv_file, 'w')
def printcsv(x):
  out_file.write(x+'\n')

def calc (vals, tots):
  sel = [vals[0], vals[4], vals[5]+ceil(vals[6]*1.0/2), vals[7], vals[8]]
  res = [str(x) for x in vals]
  for i in range(len(tots)):
    if (sel[i]==0):
      res.append("0")
    else:
      res.append(str(sel[i])+ " (" + "%.2f" % ((100.0*sel[i])/tots[i]) +")")
  return res

def calc_remain (vals, maxs, tots):
  sel = [vals[0], vals[4], vals[5]+ceil(vals[6]*1.0/2), vals[7], vals[8]]
  rem = [b - a for a, b in zip(sel, maxs)]
  res = ["-"]*len(vals)
  for i in range(len(tots)):
    res.append(str(rem[i])+ " (" + "%.2f" % ((100.0*rem[i])/tots[i]) +")")
  return res

# Naming of Modules and number of them for averaging
# Since a module could be set of different sub-modules we cannot
# just use occurences
Dastgah_mods = {"Gousheh": (Gushehs, Gousheh_count),
                "Scheduler": (Scheduler_module, 1),
                "Wrappers": (Core_wrappers, Gousheh_count),
                "MAC": (MAC_modules, 1),
                "PCIEe": (PCIe_modules, 1),
                "Switch and Debug": (SW_n_stat_modules, 1)}

Gousheh_mods = {"mem modules": (mem_modules, Gousheh_count),
                "riscv": (riscv_modules, Gousheh_count),
                "Pigasus": (pigasus, Gousheh_count),
                "Accel manager": (acc_manager, Gousheh_count)}

# CSV header
printcsv("Module, LUT, Logic, LUTRAM, SRL, Register, RAMB36, RAMB18, \
URAM, DSP, LUTs (%), Registers(%), BRAMs(%), URAMs(%), DSPs(%)\n")

printcsv ("Dastgah stats:")

acc_util = [0]*9
last_avg = []
last_tot = []
last_mod = ""

for mod in Dastgah_mods:
  (avg, tot, _, _) = extract(full_fpga_raw_rep, Dastgah_mods[mod][0], Dastgah_mods[mod][1])
  line = calc(avg, FPGA_tot_resources)
  acc_util = [a + b for a, b in zip(acc_util, tot)]
  printcsv(mod + ", " + ", ".join(line))
  if (mod == "Gousheh"):
    line = calc_remain(avg, Gousheh_avg_resources, FPGA_tot_resources)
    printcsv("Remaining Gousheh" + ", " + ", ".join(line))
  if (mod == "Scheduler"):
    line = calc_remain(tot, Sched_tot_resources, FPGA_tot_resources)
    printcsv("Remaining Scheduler" + ", " + ", ".join(line))
  last_tot = tot
  last_mod = mod

(avg, tot, _, _) = extract(full_fpga_raw_rep, [" fpga"], 1)
rest = [b - a for a, b in zip(acc_util, tot)]
line = calc(rest, FPGA_tot_resources)
printcsv("Rest" + ", " + ", ".join(line))
rest = [a + b for a, b in zip(rest, last_tot)]
line = calc(rest, FPGA_tot_resources)
printcsv(last_mod+"+, " + ", ".join(line))
line = calc(tot, FPGA_tot_resources)
printcsv("Full" + ", " + ", ".join(line))

printcsv ("\n\nGousheh with accelerator stats:")

acc_util = [0]*9
for mod in Gousheh_mods:
  (avg, tot, _, _) = extract(full_fpga_acc_rep, Gousheh_mods[mod][0], Gousheh_mods[mod][1])
  line = calc(avg, Gousheh_avg_resources)
  acc_util = [a + b for a, b in zip(acc_util, tot)]
  printcsv(mod + ", " + ", ".join(line))
  last_avg = avg
  last_mod = mod

(avg, tot, _, _) = extract(full_fpga_acc_rep, Gushehs, Gousheh_count)
rest = [b - a for a, b in zip(acc_util, tot)]
rest = [ceil(x/Gousheh_count) for x in rest]
line = calc(rest, Gousheh_avg_resources)
printcsv("Rest" + ", " + ", ".join(line))
rest = [a + b for a, b in zip(rest, last_avg)]
line = calc(rest, FPGA_tot_resources)
printcsv(last_mod+"+, " + ", ".join(line))
line = calc(avg, Gousheh_avg_resources)
printcsv("Full" + ", " + ", ".join(line))
line = calc_remain(avg, Gousheh_avg_resources, Gousheh_avg_resources)
printcsv("Remaining" + ", " + ", ".join(line))

out_file.close()

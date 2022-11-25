#!/usr/bin/env python
init_files_path = "./memory_init"

with open ("init_roms.v", "w") as f:
  for i in range (8):
    accel_top = "UUT.rpus[" + str(i) + "].rpu_PR_inst.rpu_inst.accel_wrap_inst.fast_pattern_sme_inst"
  
    for j in range (8):
      f.write("  $readmemh(\"" + init_files_path + "/match_table.mif\",\n")
      f.write("            " + accel_top + ".pigasus.front.filter_inst.match_table_"+str(j)+".mem);\n")
    f.write("\n")
    
    for j in range (2):
      f.write("  $readmemh(\"" + init_files_path + "/rule_2_pg_packed.mif\",\n")
      f.write("            " + accel_top + ".pg_inst.rule2pg_table_"+str(j*2)+"_"+str(j*2+1) + ".mem);\n")
    f.write("\n")
      
    f.write("  $readmemh(\"" + init_files_path + "/hashtable0_packed.mif\",\n")
    f.write("            " + accel_top + ".pigasus.back.hashtable_inst_0_0.mem);\n")
    f.write("  $readmemh(\"" + init_files_path + "/hashtable1_packed.mif\",\n")
    f.write("            " + accel_top + ".pigasus.back.hashtable_inst_1_0.mem);\n")
    f.write("\n")


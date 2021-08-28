import string
import time
import json
import itertools
import copy
import sys

# inp_file = 'google_2_ports_sorted_prefixes.json'
inp_file = 'firewall_2_ports_sorted_prefixes.json'
first_lvl_len = 9
# mod_name = 'ip_match'
mod_name = 'firewall'


def splitter (prefixes, offset):
  prefix = sorted(prefixes, key=lambda x: len(x), reverse=True)

  MSB_dict= {}
  first_lvl = []
  for x in prefix:
    k = x[0:offset]
    if k in MSB_dict:
      if (len(x)!=offset):
        MSB_dict[k].append(x[offset:])
      else:
        print("ERROR")
    else:
      if (len(x)==offset):
        # since list is sorted based on number of wildcards
        first_lvl.append(x)
      else:
        MSB_dict[k] = [x[offset:]]

  return (first_lvl, MSB_dict)

def table_writer (MSB_dict, fp, prefix):
  for k in sorted(MSB_dict):
    addr_len = max([len(x) for x in MSB_dict[k]])
    fp.write('module table_'+prefix+k+'(input clk, input rst, input ['+str(addr_len-1)+':0] addr, output reg match);\n')
    fp.write('  always@(posedge clk) begin\n')
    fp.write('    casex (addr)\n')
    for x in MSB_dict[k]:
      fp.write('      '+str(addr_len)+'\'b'+x+fill[addr_len-len(x)]+': '+'match <= 1\'b1;\n')
    fp.write('      default: match <= 1\'b0;\n')
    fp.write('    endcase\n')
    fp.write('\n')
    fp.write('    if(rst)\n')
    fp.write('      match <= 1\'b0;\n')
    fp.write('  end\n')
    fp.write('endmodule\n')
    fp.write('\n')

with open(inp_file, 'r') as f:
  prefix_table = [str(x) for (x,y) in json.load(f)]
f.close()

max_prefix_len = max([len(x) for x in prefix_table])

(first_lvl, MSB_dict) = splitter (prefix_table, first_lvl_len)

fill = ['']
for i in range (1, max_prefix_len):
  fill.append(i*'?')

# lprefix = 'lvl1_'
lprefix = ''

with open('../rtl/'+mod_name+'.v',"w") as f:

  table_writer (MSB_dict, f, lprefix)

  f.write('module '+mod_name+'(input wire clk, input wire rst, input wire [31:0] addr,\n')
  f.write('                input wire valid, output reg match, output reg done);\n')
  f.write('  reg [31:0] addr_r;\n')
  f.write('  reg        valid_r;\n')
  f.write('  reg        match_n;\n')
  f.write('\n')
  for k in sorted(MSB_dict):
    max_len = max([len(x) for x in MSB_dict[k]])
    f.write('  wire out_'+k+';\n')
    f.write('  table_'+lprefix+k+' m_'+lprefix+k+' (.clk(clk), .rst(rst), .addr(addr['+str(32-first_lvl_len-1)+':'+str(32-first_lvl_len-max_len+0)+']), .match(out_'+k+'));\n')
  f.write('\n')
  f.write('  always@(*)\n')
  f.write('    case (addr_r[31:'+str(32-first_lvl_len)+'])\n')
  for k in sorted(MSB_dict):
    f.write('      '+str(first_lvl_len)+'\'b'+k+': '+'match_n = out_'+k+';\n')
  for x in first_lvl:
    f.write('      '+str(first_lvl_len)+'\'b'+x+': '+'match_n = 1\'b1;\n')
  f.write('      default: match_n = 1\'b0;\n')
  f.write('    endcase\n')
  f.write('\n')
  f.write('  always@(posedge clk) begin\n')
  f.write('    addr_r  <= addr;\n')
  f.write('    valid_r <= valid;\n')
  f.write('    match   <= (match || match_n) && !valid;\n')
  f.write('    done    <= (done  || valid_r) && !valid;\n')
  f.write('\n')
  f.write('    if(rst) begin\n')
  f.write('      match   <= 1\'b0;\n')
  f.write('      done    <= 1\'b0;\n')
  f.write('      valid_r <= 1\'b0;\n')
  f.write('    end\n')
  f.write('  end\n')
  f.write('endmodule\n')
f.close()

print ([x for x in sorted(MSB_dict.keys())])
print ('max second stage ifs:', max([len(MSB_dict[x]) for x in sorted(MSB_dict.keys())]))
print (len(MSB_dict.keys()))

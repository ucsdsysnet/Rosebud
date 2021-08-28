import string
import time
import json
import itertools
import copy
import sys

inp_file = 'google_2_ports_sorted_prefixes.json'
max_prefix_len = 24
first_lvl_len = 14

prefix_table = []
fill = ['']
for i in range (1,max_prefix_len):
	fill.append(i*'?')

with open(inp_file, 'r') as f:
	prefix_table = [(str(x),int(y)) for (x,y) in json.load(f)]
f.close()

prefix_table = sorted(prefix_table, key=lambda x: len(x[0]), reverse=True)

MSB_dict= {}
first_lvl = []
for (x,y) in prefix_table:
	k = x[0:first_lvl_len]
	if k in MSB_dict:
		if (len(x)!=first_lvl_len):
			MSB_dict[k].append((x[first_lvl_len:],y))
	else:
		if (len(x)==first_lvl_len):
			# since list is sorted based on number of wildcards
			first_lvl.append((x,y))
		else:
			MSB_dict[k] = [(x[first_lvl_len:],y)]

with open("ip_match.v","w") as f:

  for k in sorted(MSB_dict):
  		f.write('module table_'+k+'(input clk, input rst, input ['+str(max_prefix_len-first_lvl_len-1)+':0] addr, output reg match);\n')
  		f.write('  always@(posedge clk) begin\n')
  		# f.write('  always@(addr) begin\n')
  		f.write('    casex (addr)\n')
  		for (x,y) in MSB_dict[k]:
  			f.write('      '+str(max_prefix_len-first_lvl_len)+'\'b'+x+fill[max_prefix_len-first_lvl_len-len(x)]+': '+'match <= 1\'b'+str(y)+';\n')
  		f.write('      default: match <= 1\'b0;\n')
  		f.write('    endcase\n')
  		f.write('\n')
  		f.write('    if(rst)\n')
  		f.write('      match <= 1\'b0;\n')
  		f.write('  end\n')
  		f.write('endmodule\n')
  		f.write('\n')

  f.write('module ip_match(input wire clk, input wire rst, input wire [31:0] addr,\n')
  f.write('                input wire valid, output reg match, output reg done);\n')
  f.write('  reg [31:0] addr_r;\n')
  f.write('  reg        valid_r;\n')
  f.write('  reg        match_n;\n')
  f.write('\n')
  for k in sorted(MSB_dict):
    f.write('  wire out_'+k+';\n')
    f.write('  table_'+k+' m_'+k+' (.clk(clk), .rst(rst), .addr(addr['+str(32-first_lvl_len-1)+':'+str(32-max_prefix_len)+']), .match(out_'+k+'));\n')
  f.write('\n')
  f.write('  always@(*)\n')
  f.write('    case (addr_r[31:'+str(32-first_lvl_len)+'])\n')
  for k in sorted(MSB_dict):
    f.write('      '+str(first_lvl_len)+'\'b'+k+': '+'match_n = out_'+k+';\n')
  for (x,y) in first_lvl:
    f.write('      '+str(first_lvl_len)+'\'b'+x+': '+'match_n = 1\'b'+str(y)+';\n')
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
print (len(MSB_dict.keys()))

import string
import time
import json
import itertools
import copy
import sys

inp_file = 'google_2_ports_sorted_prefixes.json'

def possible_MSBs (table, bits):
	prefix = {}
	for x in table:
		k = x[0][0:bits]
		if k in prefix:
			prefix[k].append((x[0][bits:],x[1]))
		else:
			prefix[k]=[(x[0][bits:],x[1])]
	return prefix

prefix_table = []
fill = ['']

with open(inp_file, 'r') as f:
	prefix_table = [(str(x),int(y)-1) for (x,y) in json.load(f)]
f.close()

prefix_table = sorted(prefix_table, key=lambda x: -len(x[0]))
more_than_24 = [x for x in prefix_table if len(x[0])>24]
less_than_25 = [x for x in prefix_table if len(x[0])<25]

print ('#of prefixes after /24:', len(more_than_24))
print ("# of possible first 24 bits for after /24:" , len(possible_MSBs(more_than_24,24).keys()))
print ("# of possible first 10 bits in after /24:",len(possible_MSBs(more_than_24,10).keys()))
print ("# of possible first 8 bits for prefixes before /25", len(possible_MSBs(less_than_25,8).keys()))

with open("prefix_dist", 'w') as f:
	f.write('Bits Occupancy\r\n')
	for i in range (1,33):
		print ("# of possible first",str(i),"bits:", len(possible_MSBs(prefix_table,i).keys()),"/",2**i)
		f.write(str(i)+' '+str(len(possible_MSBs(prefix_table,i).keys())*1.0/(2**i))+'\n')
f.close()

# for x in prefix_table:
#         k = x[0][0:10]
#         if k in pref10:
#                 pref10[k].append((x[0][10:],x[1]))
#         else:
#                 pref10[k]=[(x[0][10:],x[1])]
#
# print ("# of possible first 10 bits:",len(pref10.keys()))
#
# for x in more_than_24:
#         k = x[0][0:10]
#         if k in pref10_2:
#                 pref10_2[k].append((x[0][10:],x[1]))
#         else:
#                 pref10_2[k]=[(x[0][10:],x[1])]
#
# print ("# of possible first 10 bits in after /24:",len(pref10_2.keys()))
#

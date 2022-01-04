"""

Copyright (c) 2017-2021 Moein Khazraee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

"""

import string
import time
import sys
import random
from pytrie import SortedStringTrie as trie
import json

# number of address bits
address_bits = 32
# total number of ports, considered ports starting from 1
port_count = 2
# name of input file
# inp_file = "Google_ips.txt"
inp_file = "firewall.txt"
# common string in output file
# out_prefix = "google"
out_prefix = "firewall"

start_time = time.time()

rng = random.SystemRandom()

init_routing_table = []
routing_table = []
routing_trie = trie()
AS2port = {}
out_prefix += '_'+str(port_count)+'_ports'
prefix_dist = {}
port_dist = {}
AS2port_dist = {}
AS2prefix_dist = {}


def dict_sort (d):
	return sorted(d.items(), key=lambda x: x[1], reverse=True)

#############################################################
# Check if a prefix is covered by others, in a sorted table #
#############################################################
def covered_prefix (table, index):
	prefix = table[index][0]
	index +=1
	y = 0.0
	while (index<len(table) and table[index][0].startswith(prefix)):
		y += 1.0/(2**(len(table[index][0])-len(prefix)))
		index += 1
	if y > 0.99999 :
 		return True
	else:
		return False
#############################################################
with open(inp_file) as routes:
	reader = routes.read().splitlines()
	for line in reader:
		if (":" in line): # No support for ipv6
			continue
		row = line.replace('/',' ').split(' ') + ['1'] ### JUST FOR THIS GENERATOR
		prefix = ''.join([bin(int(x))[2:].zfill(8) for x in row[0].split('.')])[0:int(row[1])]
		if row[2] in AS2port:
			port = AS2port[row[2]]
			AS2prefix_dist [row[2]] += 1
		else:
			port = rng.randint(1,port_count-1)
			AS2port[row[2]] = port
			AS2prefix_dist [row[2]] = 1
		init_routing_table += [(prefix,port)]

load_time = time.time()
print ("load time:\t\t", 1000*(load_time-start_time), "ms")

init_routing_table.sort()

drops = 0
for i in range(len(init_routing_table)):
#if not covered_prefix(init_routing_table,i):
	routing_table.append((init_routing_table[i][0],init_routing_table[i][1]))
	routing_trie[init_routing_table[i][0]] = init_routing_table[i][1]
	port = init_routing_table[i][1]
	if port in port_dist:
		port_dist[port] += 1
	else:
		port_dist[port]  = 1

	length = len(init_routing_table[i][0])
	if length in prefix_dist:
		prefix_dist[length] += 1
	else:
		prefix_dist[length]  = 1
# else:
#	drops += 1

for x in AS2port:
	y = AS2port[x]
	if y in AS2port_dist:
		AS2port_dist[y] += 1
	else:
		AS2port_dist[y]  = 1

print ('prefix dist:', dict_sort(prefix_dist),'\n')
print ('port dist:', dict_sort(port_dist),'\n')
print ('AS to port dist:', dict_sort(AS2port_dist),'\n')
print ('AS to prefix dist:', dict_sort(AS2prefix_dist),'\n')

prune_time = time.time()
print ("sort and prune time:\t", 1000*(prune_time-load_time), "ms")

with open(out_prefix+'_sorted_prefixes.json', 'w') as f:
	json.dump(routing_table, f, ensure_ascii=False)
f.close()
with open(out_prefix+'_routing_trie.json','w') as f:
	json.dump(routing_trie.items(), f, ensure_ascii=False)
f.close()
with open(out_prefix+'_AS2port.json', 'w') as f:
	json.dump(AS2port, f, ensure_ascii=False)
f.close()

save_time = time.time()
print ("save time:\t\t", 1000*(save_time - prune_time), "ms")
print ()
print ("There were", drops, "drops and new length of table is", len(routing_table))


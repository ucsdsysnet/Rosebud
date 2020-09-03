import string
import time
import sys
import random
from Bio import trie
import json

# number of address bits
address_bits = 32
# total number of ports, considered ports starting from 1
port_count = 2
# name of input file
inp_file = "Google_ips.txt"
# common string in output file
out_prefix = "google"

start_time = time.time()

rng = random.SystemRandom()

init_routing_table = []
routing_table = []
routing_trie = trie.trie()
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
		row = line.replace('/',' ').split(' ')
		prefix = string.join([bin(int(x))[2:].zfill(8) for x in row[0].split('.')],sep='')[0:int(row[1])]
		if AS2port.has_key(row[2]):
			port = AS2port[row[2]]
			AS2prefix_dist [row[2]] += 1
		else:
			port = rng.randint(1,port_count-1)
			AS2port[row[2]] = port
			AS2prefix_dist [row[2]] = 1
		init_routing_table += [(prefix,port)]

load_time = time.time()
print "load time:\t\t", 1000*(load_time-start_time), "ms"

init_routing_table.sort()

drops = 0
for i in range(len(init_routing_table)):
#if not covered_prefix(init_routing_table,i):
	routing_table.append((init_routing_table[i][0],init_routing_table[i][1]))
	routing_trie[init_routing_table[i][0]] = init_routing_table[i][1]
	port = init_routing_table[i][1]
	if port_dist.has_key(port):
		port_dist[port] += 1
	else:
		port_dist[port]  = 1
	
	length = len(init_routing_table[i][0])
	if prefix_dist.has_key(length):
		prefix_dist[length] += 1
	else:
		prefix_dist[length]  = 1
# else:
#	drops += 1

for x in AS2port:
	y = AS2port[x]
	if AS2port_dist.has_key(y):
		AS2port_dist[y] += 1
	else:
		AS2port_dist[y]  = 1

print ('prefix dist:', dict_sort(prefix_dist),'\n')
print ('port dist:', dict_sort(port_dist),'\n')
print ('AS to port dist:', dict_sort(AS2port_dist),'\n')
print ('AS to prefix dist:', dict_sort(AS2prefix_dist),'\n')

prune_time = time.time()
print "sort and prune time:\t", 1000*(prune_time-load_time), "ms"

with open(out_prefix+'_sorted_prefixes.json', 'w') as f:
	json.dump(routing_table, f, ensure_ascii=False)
f.close()
with open(out_prefix+'_routing_trie.bin','wb') as f:
	trie.save(f, routing_trie)
f.close()
with open(out_prefix+'_AS2port.json', 'w') as f:
	json.dump(AS2port, f, ensure_ascii=False)
f.close()

save_time = time.time()
print "save time:\t\t", 1000*(save_time - prune_time), "ms"
print 
print "There were", drops, "drops and new length of table is", len(routing_table)


import json

id_map = {}
i = 1;
for line in open("rule_list","r"):
  id_map[int(line)] = i
  i += 1

rules = {}
for line in open("extracted.txt","r"):
  rule = line.split()
  if int(rule[0]) in id_map:
    src_port = rule[3]
    dst_port = rule[6]
    if (rule[1]=="tcp"):
      is_tcp = True
    else:
      is_tcp = False
    if (rule[4] == "<>"):
      bidirectional = True
    else:
      bidirectional = False
    
    if ("$HTTP_PORTS" in src_port):
      src_port = src_port.replace("$HTTP_PORTS","80")
    elif (src_port=="$FILE_DATA_PORTS"):
      src_port = "90"
    elif (src_port=="$FTP_PORTS"):
      src_port = "100"
    elif (src_port=="$ORACLE_PORTS"):
      src_port = "1100"

    if ("$HTTP_PORTS" in dst_port):
      dst_port = dst_port.replace("$HTTP_PORTS","80")
    elif (dst_port=="$FILE_DATA_PORTS"):
      dst_port = "90"
    elif (dst_port=="$FTP_PORTS"):
      dst_port = "100"
    elif (dst_port=="$ORACLE_PORTS"):
      dst_port = "1100"

    rules[id_map[int(rule[0])]] = [src_port, dst_port, is_tcp, bidirectional]

with open("final_mapping.txt","w") as f:
  f.write(json.dumps(rules))

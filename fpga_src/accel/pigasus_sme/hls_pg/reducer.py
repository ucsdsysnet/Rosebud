import json

HTTP_PORTS="[36,80,81,82,83,84,85,86,87,88,89,90,311,383,555,591,593,631,801,808,818,901,972,1158,1220,1414,1533,1741,1812,1830,1942,2231,2301,2381,2578,2809,2980,3029,3037,3057,3128,3443,3702,4000,4343,4848,5000,5117,5250,5450,5600,5814,6080,6173,6988,7000,7001,7005,7071,7144,7145,7510,7770,7777,7778,7779,8000,8001,8008,8014,8015,8020,8028,8040,8080,8081,8082,8085,8088,8090,8118,8123,8180,8181,8182,8222,8243,8280,8300,8333,8344,8400,8443,8500,8509,8787,8800,8888,8899,8983,9000,9002,9060,9080,9090,9091,9111,9290,9443,9447,9710,9788,9999,10000,11371,12601,13014,15489,19980,29991,33300,34412,34443,34444,40007,41080,44449,50000,50002,51423,53331,55252,55555,56712]"


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
    
    if (src_port=="$HTTP_PORTS"): 
      src_port = HTTP_PORTS
    elif (src_port=="$FILE_DATA_PORTS"):
      src_port = HTTP_PORTS[:-1]+",110,143]"
    elif (src_port=="$FTP_PORTS"):
      src_port = "21,2100,3535"
    elif (src_port=="$ORACLE_PORTS"):
      src_port = "[1024:]"
    elif ("$HTTP_PORTS" in src_port):
      src_port = src_port.replace("$HTTP_PORTS", HTTP_PORTS[1:-1])

    if (dst_port=="$HTTP_PORTS"): 
      dst_port = HTTP_PORTS
    elif (dst_port=="$FILE_DATA_PORTS"):
      dst_port = HTTP_PORTS[:-1]+",110,143]"
    elif (dst_port=="$FTP_PORTS"):
      dst_port = "21,2100,3535"
    elif (dst_port=="$ORACLE_PORTS"):
      dst_port = "[1024:]"
    elif ("$HTTP_PORTS" in dst_port):
      dst_port = dst_port.replace("$HTTP_PORTS", HTTP_PORTS[1:-1])

    rules[id_map[int(rule[0])]] = [src_port, dst_port, is_tcp, bidirectional]

with open("final_mapping.txt","w") as f:
  f.write(json.dumps(rules))

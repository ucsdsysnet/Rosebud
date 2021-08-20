import json

HTTP_PORTS=[36,80,81,82,83,84,85,86,87,88,89,90,311,383,555,591,593,631,801,808,818,901,972,1158,1220,1414,1533,1741,1812,1830,1942,2231,2301,2381,2578,2809,2980,3029,3037,3057,3128,3443,3702,4000,4343,4848,5000,5117,5250,5450,5600,5814,6080,6173,6988,7000,7001,7005,7071,7144,7145,7510,7770,7777,7778,7779,8000,8001,8008,8014,8015,8020,8028,8040,8080,8081,8082,8085,8088,8090,8118,8123,8180,8181,8182,8222,8243,8280,8300,8333,8344,8400,8443,8500,8509,8787,8800,8888,8899,8983,9000,9002,9060,9080,9090,9091,9111,9290,9443,9447,9710,9788,9999,10000,11371,12601,13014,15489,19980,29991,33300,34412,34443,34444,40007,41080,44449,50000,50002,51423,53331,55252,55555,56712]

def list_cond_gen (term, ports):
  if (len(ports)==1):
    return "("+term+"=="+str(ports[0])+")"
  else:
    res = "( ("+term+"=="+str(ports[0])+") || "
    for r in ports[1:-1]:
      res += "("+term+"=="+str(r)+") || "
    res+= "("+term+"=="+str(ports[-1])+") )"
    return res

if __name__ == "__main__":

  rule_conds = []
  rules = {}
  id_map = {}
  i = 1;
  for line in open("rule_list","r"):
    id_map[int(line)] = i
    i += 1

  # print("bool src_is_http, dst_is_http;\n")
  #
  # print("if "+list_cond_gen("src_port", HTTP_PORTS)+"{")
  # print("  src_is_http=true;")
  # print("} else {")
  # print("  src_is_http=false;")
  # print("}\n")
  #
  # print("if "+list_cond_gen("dst_port", HTTP_PORTS)+"{")
  # print("  dst_is_http=true;")
  # print("} else {")
  # print("  dst_is_http=false;")
  # print("}\n")

  for line in open("extracted.txt","r"):
    rule = line.split()
    if int(rule[0]) in id_map:
      rule_ID = id_map[int(rule[0])]
      src_port = rule[3]
      dst_port = rule[6]
      if (rule[1]=="tcp"):
        tcp_cond = "(is_tcp)"
        is_tcp = True
      else:
        tcp_cond = "(!is_tcp)"
        is_tcp = False

      # if (rule[4] == "<>"):

      if (("$HTTP_PORTS" in src_port) and (src_port!="$HTTP_PORTS")):
        src_port = src_port.replace("$HTTP_PORTS", str(HTTP_PORTS)[1:-1])
      if (src_port.startswith("[")):
        src_port = src_port[1:-1]

      if (("$HTTP_PORTS" in dst_port) and (dst_port!="$HTTP_PORTS")):
        dst_port = dst_port.replace("$HTTP_PORTS", str(HTTP_PORTS)[1:-1])
      if (dst_port.startswith("[")):
        dst_port = dst_port[1:-1]

      if (src_port=="$HTTP_PORTS"):
        src_port_cond=list_cond_gen("src_port", HTTP_PORTS)
      elif (src_port=="$FILE_DATA_PORTS"):
        src_port_cond=list_cond_gen("src_port", HTTP_PORTS+[110,143])
      elif (src_port=="$FTP_PORTS"):
        src_port_cond=list_cond_gen("src_port", [21,2100,3535])
      elif (src_port=="$ORACLE_PORTS"):
        src_port_cond="(src_port>=1024)"
      elif (":" in src_port):
        if (src_port[-1]==":"):
          ports = [int(x) for x in src_port[:-1].split(",")]
          if (len(ports)==1):
            src_port_cond = "(src_port>="+str(ports[0])+")"
          else:
            src_port_cond = list_cond_gen("src_port", ports[:-1])[:-1]+"|| (src_port>="+str(ports[-1])+") )"
        else:
          ports = src_port.split(",")
          if (len(ports)==1):
            [low, high] = ports[0].split(":")
            src_port_cond = "( (src_port>="+low+") && (src_port<="+high+") )"
          else: #limited implementation
            if (":" in ports[0]):
              [low, high] = ports[0].split(":")
              src_port_cond = "( ((src_port>="+low+") && (src_port<="+high+")) || (src_port=="+ports[1]+") )"
            else:
              [low, high] = ports[1].split(":")
              src_port_cond = "( ((src_port>="+low+") && (src_port<="+high+")) || (src_port=="+ports[0]+") )"
      elif (src_port=="any"):
        src_port_cond = "true"
      else:
        src_port_cond = list_cond_gen("src_port", [int(x) for x in src_port.split(",")])

      if (dst_port=="$HTTP_PORTS"):
        dst_port_cond=list_cond_gen("dst_port", HTTP_PORTS)
      elif (dst_port=="$FILE_DATA_PORTS"):
        dst_port_cond=list_cond_gen("dst_port", HTTP_PORTS+[110,143])
      elif (dst_port=="$FTP_PORTS"):
        dst_port_cond=list_cond_gen("dst_port", [21,2100,3535])
      elif (dst_port=="$ORACLE_PORTS"):
        dst_port_cond="(dst_port>=1024)"
      elif (":" in dst_port):
        if (dst_port[-1]==":"):
          ports = [int(x) for x in dst_port[:-1].split(",")]
          if (len(ports)==1):
            dst_port_cond = "(dst_port>="+str(ports[0])+")"
          else:
            dst_port_cond = list_cond_gen("dst_port", ports[:-1])[:-1]+"|| (dst_port>="+str(ports[-1])+") )"
        else:
          ports = dst_port.split(",")
          if (len(ports)==1):
            [low, high] = ports[0].split(":")
            dst_port_cond = "( (dst_port>="+low+") && (dst_port<="+high+") )"
          else: #limited implementation
            if (":" in ports[0]):
              [low, high] = ports[0].split(":")
              dst_port_cond = "( ((dst_port>="+low+") && (dst_port<="+high+")) || (dst_port=="+ports[1]+") )"
            else:
              [low, high] = ports[1].split(":")
              dst_port_cond = "( ((dst_port>="+low+") && (dst_port<="+high+")) || (dst_port=="+ports[0]+") )"
      elif (dst_port=="any"):
        dst_port_cond = "true"
      else:
        dst_port_cond = list_cond_gen("dst_port", [int(x) for x in dst_port.split(",")])

      rule_cond = "( (rule_ID_in=="+str(rule_ID)+") && "+tcp_cond+" && "+src_port_cond+" && "+dst_port_cond+" )"
      rule_conds.append(rule_cond)

      rules[rule_ID] = [src_port, dst_port, is_tcp]

  with open("final_mapping.txt","w") as f:
    f.write(json.dumps(rules))

  with open("port_group.cc","w") as f:
    f.write("#include \"ap_int.h\"\n")
    f.write("\n")
    f.write("bool port_group(bool is_tcp, ap_uint<16> src_port, ap_uint<16> dst_port, ap_uint<13> rule_ID_in) {\n")
    f.write("  #pragma HLS INTERFACE mode=ap_none port=src_port\n")
    f.write("  #pragma HLS INTERFACE mode=ap_none port=dst_port\n")
    f.write("  #pragma HLS INTERFACE mode=ap_none port=is_tcp\n")
    f.write("  #pragma HLS INTERFACE mode=ap_none port=rule_ID_in\n")
    f.write("  #pragma HLS INTERFACE ap_ctrl_none port=return\n")
    f.write("\n")
    f.write("  #pragma HLS PIPELINE II=1\n")
    f.write("\n")

    f.write("  if ( "+rule_conds[0]+" || \n")
    for r in rule_conds[1:-1]:
      f.write("    "+r+" || \n")
    f.write("    "+rule_conds[-1]+" ) {\n")
    f.write("        return true;\n")
    f.write("  } else {\n")
    f.write("        return false;\n")
    f.write("  }\n")
    f.write("\n")
    f.write("}\n")


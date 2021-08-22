import json

HTTP_PORTS=[36,80,81,82,83,84,85,86,87,88,89,90,311,383,555,591,593,631,801,808,818,901,972,1158,1220,1414,1533,1741,1812,1830,1942,2231,2301,2381,2578,2809,2980,3029,3037,3057,3128,3443,3702,4000,4343,4848,5000,5117,5250,5450,5600,5814,6080,6173,6988,7000,7001,7005,7071,7144,7145,7510,7770,7777,7778,7779,8000,8001,8008,8014,8015,8020,8028,8040,8080,8081,8082,8085,8088,8090,8118,8123,8180,8181,8182,8222,8243,8280,8300,8333,8344,8400,8443,8500,8509,8787,8800,8888,8899,8983,9000,9002,9060,9080,9090,9091,9111,9290,9443,9447,9710,9788,9999,10000,11371,12601,13014,15489,19980,29991,33300,34412,34443,34444,40007,41080,44449,50000,50002,51423,53331,55252,55555,56712]

def list_cond_gen (term, ports):
  if (len(ports)==1):
    return "("+term+"=="+str(ports[0])+")"
  else:
    res = "(("+term+"=="+str(ports[0])+") || "
    for r in ports[1:-1]:
      res += "("+term+"=="+str(r)+") || "
    res+= "("+term+"=="+str(ports[-1])+"))"
    return res

def port_parser (term, query):
  has_http = False
  if ("$HTTP_PORTS," in query):
    query = query.replace("$HTTP_PORTS,", "")
    has_http = True
  if (",$HTTP_PORTS" in query):
    query = query.replace(",$HTTP_PORTS", "")
    has_http = True
  if (query.startswith("[")):
    query = query[1:-1]

  if (query=="$HTTP_PORTS"):
    return term+"_is_http"
  elif (query=="$FILE_DATA_PORTS"):
    return term+"_is_file_data"
  elif (query=="$FTP_PORTS"):
    return term+"_is_ftp"
  elif (query=="$ORACLE_PORTS"):
    return "("+term+">=1024)"
  elif (":" in query):
    if (query[-1]==":"):
      ports = [int(x) for x in query[:-1].split(",")]
      if (len(ports)==1):
        if (has_http):
          return "("+term+"_is_http || ("+term+">="+str(ports[0])+"))"
        else:
          return "("+term+">="+str(ports[0])+")"
      else:
        if (has_http):
          return "("+term+"_is_http || "+list_cond_gen(term, ports[:-1])[1:-1]+" || ("+term+">="+str(ports[-1])+"))"
        else:
          return list_cond_gen(term, ports[:-1])[:-1]+"|| ("+term+">="+str(ports[-1])+"))"
    else:
      ports = query.split(",")
      if (len(ports)==1):
        [low, high] = ports[0].split(":")
        if (has_http):
          return "("+term+"_is_http || (("+term+">="+low+") && ("+term+"<="+high+")))"
        else:
          return "(("+term+">="+low+") && ("+term+"<="+high+"))"
      elif (len(ports)==2):
        if (has_http):
          print("case not supported")
          return "false"
        elif (":" in ports[0]):
          [low, high] = ports[0].split(":")
          return "( (("+term+">="+low+") && ("+term+"<="+high+")) || ("+term+"=="+ports[1]+") )"
        else:
          [low, high] = ports[1].split(":")
          return "( (("+term+">="+low+") && ("+term+"<="+high+")) || ("+term+"=="+ports[0]+") )"
      else:
        print("case not supported")
        return "false"

  elif (query=="any"):
    return "true"
  else:
    if (has_http):
      return "("+term+"_is_http || "+list_cond_gen(term, [int(x) for x in query.split(",")])[1:]
    else:
      return list_cond_gen(term, [int(x) for x in query.split(",")])

if __name__ == "__main__":

  rule_conds = []
  rules = {}
  id_map = {}
  i = 1;
  for line in open("rule_list","r"):
    id_map[int(line)] = i
    i += 1

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

      src_port_cond = port_parser("src_port", src_port)
      dst_port_cond = port_parser("dst_port", dst_port)
      rule_cond = "( (rule_ID_in=="+str(rule_ID)+") && "+tcp_cond+" && "+src_port_cond+" && "+dst_port_cond+" )"
      rule_conds.append(rule_cond)

      rules[rule_ID] = [src_port, dst_port, is_tcp]

  with open("final_mapping.txt","w") as f:
    f.write(json.dumps(rules))

  with open("../is_http.cc","w") as f:
    f.write("#include \"ap_int.h\"\n")
    f.write("\n")
    f.write("bool is_http(ap_uint<16> port){\n")
    f.write("  if "+list_cond_gen("port", HTTP_PORTS)+"{\n")
    f.write("    return true;\n")
    f.write("  } else {\n")
    f.write("    return false;\n")
    f.write("  }\n\n")
    f.write("}")

  with open("../port_group.cc","w") as f:
    f.write("#include \"ap_int.h\"\n")
    f.write("\n")
    f.write("bool is_http(ap_uint<16> port);\n")
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
    f.write("  // Common ports\n")
    f.write("  bool src_port_is_http = is_http(src_port);\n")
    f.write("  bool dst_port_is_http = is_http(dst_port);\n")
    f.write("  bool src_port_is_file_data = is_http(src_port) || (src_port==110) || (src_port==143);\n")
    f.write("  bool dst_port_is_file_data = is_http(dst_port) || (dst_port==110) || (dst_port==143);\n")
    f.write("  // bool src_port_is_ftp = (src_port==21) || (src_port==2100) || (src_port==3535);\n")
    f.write("  bool dst_port_is_ftp = (dst_port==21) || (dst_port==2100) || (dst_port==3535);\n")
    f.write("\n")

    for r in rule_conds:
      f.write("  if "+r+"\n")
      f.write("    return true;\n")
    f.write("  return false;\n")
    f.write("}\n")


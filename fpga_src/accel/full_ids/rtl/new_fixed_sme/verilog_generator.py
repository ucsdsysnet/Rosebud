import re
from idstools.rule import parse

write_errors = False
line_size = 8
max_len = 24

# in_rules = "rules/test"
in_rules = "rules/fixed_loc_rules"
out_verilog = "fixed_loc_sme_"+str(line_size)+".v"
problematic = "rules/problematic.rules"

if (write_errors):
  prob = open(problematic,'w')

def content_len(content):
  count = 0
  byte_mode = 0
  if content.startswith("!"):
    content = content[1:]
  for c in content[1:-1]:
    if (c=='|'):
      if (byte_mode==0):
        byte_mode = 1
      else:
        count += 1
        byte_mode = 0
    else:
      if (byte_mode==0):
        count += 1
      else:
        if (c==' '):
          count += 1
  return count

def content_conv(content, nocase, offset):
  byte_mode = 0
  loc = offset
  res = []
  temp = ""
  if content.startswith("!"):
    for c in content[2:-1]:
      if (c=='|'):
        if (byte_mode==0):
          byte_mode = 1
        else:
          res.append(("((s_axis_tdata[8*"+str(loc%line_size)+"+:8] != 8'h"+temp+") && s_axis_tkeep["+str(loc%line_size)+"])",loc,1))
          loc += 1
          temp = ""
          byte_mode = 0
      else:
        if (byte_mode==0):
          if (nocase==True):
            res.append(("(((s_axis_tdata[8*"+str(loc%line_size)+"+:8] != 8'd"+str(ord(c.lower()))+")||(s_axis_tdata[8*"+str(loc%line_size)+"+:8] == 8'd"+str(ord(c.upper()))+")) && s_axis_tkeep["+str(loc%line_size)+"])",loc,1))
          else:
            res.append(("((s_axis_tdata[8*"+str(loc%line_size)+"+:8] != 8'd"+str(ord(c))+") && s_axis_tkeep["+str(loc%line_size)+"])",loc,1))
          loc += 1
        else:
          if (c==' '):
            res.append(("((s_axis_tdata[8*"+str(loc%line_size)+"+:8] != 8'h"+temp+") && s_axis_tkeep["+str(loc%line_size)+"])",loc,1))
            loc += 1
            temp = ""
          else:
            temp = temp + c
  else:
    for c in content[1:-1]:
      if (c=='|'):
        if (byte_mode==0):
          byte_mode = 1
        else:
          res.append(("((s_axis_tdata[8*"+str(loc%line_size)+"+:8] == 8'h"+temp+") && s_axis_tkeep["+str(loc%line_size)+"])",loc,1))
          loc += 1
          temp = ""
          byte_mode = 0
      else:
        if (byte_mode==0):
          if (nocase==True):
            res.append(("(((s_axis_tdata[8*"+str(loc%line_size)+"+:8] == 8'd"+str(ord(c.lower()))+")||(s_axis_tdata[8*"+str(loc%line_size)+"+:8] == 8'd"+str(ord(c.upper()))+")) && s_axis_tkeep["+str(loc%line_size)+"])",loc,1))
          else:
            res.append(("((s_axis_tdata[8*"+str(loc%line_size)+"+:8] == 8'd"+str(ord(c))+") && s_axis_tkeep["+str(loc%line_size)+"])",loc,1))
          loc += 1
        else:
          if (c==' '):
            res.append(("((s_axis_tdata[8*"+str(loc%line_size)+"+:8] == 8'h"+temp+") && s_axis_tkeep["+str(loc%line_size)+"])",loc,1))
            loc += 1
            temp = ""
          else:
            temp = temp + c

  return res

bit_ops = ["&","^","!&","!^"]

def byte_conv(rule, offset):
  res = ""
  mask = ""
  endian = "big"

  rule_split = [x.strip() for x in rule.split(',')]
  num = rule_split[0]
  op  = rule_split[1]
  val = rule_split[2]
  off = rule_split[3]

  if ("relative" in rule_split):
    loc = int(off)+offset
  else:
    loc = int(off)

  # # Not sure the impact!
  # if ("string" in rule_split):
  #   val = "'"+val+"'"
  
  if '0x' in val:
    val = int(val,16)
  elif val.isnumeric():
    val = int(val)
  else:
    print ("ERROR: unknown value", rule, val)
    return[("",0,0)]

  if ("little" in rule_split) and (int(num)!=1):
    endian = "little"

    if int(num)==4:
      val = str(((val << 24) & 0xFF000000) | ((val << 8 ) & 0x00FF0000) |
                ((val >> 8 ) & 0x0000FF00) | ((val >> 24) & 0x000000FF));
    elif int(num)==2:
      val = str(((val << 8) & 0xFF00) | ((val >> 8)  & 0x00FF));
    else:
      print ("ERROR: little endian not yet supported for more than 4 bytes", rule)
      return[("",0,0)]

  for x in rule_split:
    if "bitmask" in x.split(' '):
      mask_raw = x.split(' ')[-1]
      if '0x' in mask_raw:
        mask_raw = int(mask_raw,16)
      elif mas_raw.isnumeric():
        mask_raw = int(mask_raw)
      else:
        print ("ERROR: unknown mask value", rule, mask_raw)
        return[("",0,0)]
      mask = " & "+str(mask_raw)

  if ("dce" in rule_split):
    print ("WARNING: assuming big endian for dce", rule)

  if op in bit_ops:
    if op[0]=="!":
      res = res + "((((s_axis_tdata[8*"+str(loc%line_size)+"+:8*"+num+"]"+mask+") "+op[1]+" "+str(val)+") == 0) && s_axis_tkeep["+str(loc%line_size)+"])"
    else:
      res = res + "((((s_axis_tdata[8*"+str(loc%line_size)+"+:8*"+num+"]"+mask+") "+op[0]+" "+str(val)+") != 0) && s_axis_tkeep["+str(loc%line_size)+"])"
  elif op=="=":
    res = res + "(((s_axis_tdata[8*"+str(loc%line_size)+"+:8*"+num+"]"+mask+") == "+str(val)+") && s_axis_tkeep["+str(loc%line_size)+"])"
  else:
    res = res + "(((s_axis_tdata[8*"+str(loc%line_size)+"+:8*"+num+"]"+mask+") "+op+" "+str(val)+") && s_axis_tkeep["+str(loc%line_size)+"])"

  start_line = int(loc/line_size)
  if ((loc+int(num))%line_size==0):
    end_line = int((loc+int(num))/line_size)-1
  else:
    end_line = int((loc+int(num))/line_size)

  if (start_line != end_line) and (loc < max_len):
    print ("ERROR: byte check on line boundary. ", rule, loc)
    return[("",0,0)]

  return [(res, loc, num)]

max_ptr = 0
ver_statements = []
rule_count = 0

for line in open(in_rules,'r'):
  if len(line.strip()) != 0 :

    ### remote unused s_axis_tdata ###
    rule    = parse(line)
    options = rule['options']

    ### group each content with its modifiers ###
    grouped = []
    for opt in options:
      name = opt['name']
      value = opt['value']

      if (name == 'content'):
        value = re.findall('"([^"]*)"', opt['value'])[0]
        flags_raw = opt['value'][len(value)+3:]
        modifiers = [x.split(' ') for x in flags_raw.split(',')]

        if opt['value'].startswith("!"):
          cont = opt['value'][0:len(value)+3]
        else:
          cont = opt['value'][0:len(value)+2]

        grouped.append([('content',cont)])
        for m in modifiers:
          if len(m)>1:
            grouped[-1].append((m[0], m[1]))
          else:
            grouped[-1].append((m[0], 0))

      elif(name == 'byte_test'):
        grouped.append([(name,value)])

    ### generate conditional statements ###
    statement = []
    cur_byte = 0
    for phrase in grouped:

      for (x,y) in phrase:
        if x=='content':
          is_cont = True
          nocase  = False
          value = y
        elif x=='byte_test':
          is_cont = False
          value = y
        elif x=='nocase':
          nocase = True
        elif x=='offset':
          cur_byte = int(y)
        elif x=='distance':
          cur_byte += int(y)
        # elif x=='within': nothing to do, already checked to have the same len
        # elif x=='depth': nothing to do, already checked to have the same len

      if (is_cont):
        statement += content_conv(value, nocase, cur_byte)
        cur_byte += content_len(value)
      else:
        temp2 = byte_conv(value, cur_byte)
        if temp2 == [("",0)]:
          if (write_errors):
            prob.write(line)
            break
        else:
          statement += temp2

    if max_ptr < (cur_byte):
      max_ptr = cur_byte;

    ### group statements based on read line size ###
    statement.sort(key = lambda x: x[1])
    verilog_phrase = []
    temp = "("
    line = 0
    last_temp = 0

    for (s,loc,length) in statement:
      if (loc < max_len):
        if (int(loc/line_size) == line):
          temp = temp + s + " && "
          last_temp  = 0
        else:
          line += 1
          verilog_phrase.append(temp[:-4]+")")
          temp = "(" + s + " && "
          last_temp = 1

    if (last_temp == 0):
      verilog_phrase.append(temp[:-4]+")")

    # if no entries in a line
    verilog_phrase = ["1'b1" if ph==')' else ph for ph in verilog_phrase]

    ver_statements.append(verilog_phrase)

    rule_count += 1


### Generate verilog output ###
tmp_signals = []
# do one path to find required tmp signals
for i in range(len(ver_statements)):
  s = ver_statements[i]
  if len(s)!=1:
    tmp_signals.append("tmp_"+str(i)+"_0")
    for j in range(1, len(s)-1):
      tmp_signals.append("tmp_"+str(i)+"_"+str(j))

ver_file = open(out_verilog,'w')

ver_file.write ("module fixed_loc_sme (input clk, input rst, input ["+str(line_size)+"*8-1:0] s_axis_tdata, input ["+str(line_size)+"-1:0] s_axis_tkeep, input s_axis_tvalid, output reg ["+str(rule_count)+"-1:0] match);\n\n")
for t in tmp_signals:
  ver_file.write ("reg "+t+";\n")
ver_file.write ("\n")

ver_file.write ("always @ (posedge clk) begin\n")
ver_file.write ("  if (s_axis_tvalid) begin\n")
ver_file.write ("    match <= 0;\n")
for t in tmp_signals:
  ver_file.write ("    "+t+" <= 1'b0;\n")
ver_file.write ("\n")

for i in range(len(ver_statements)):
  s = ver_statements[i]
  if len(s)==1:
    ver_file.write ("    match["+str(i)+"] <= "+s[0]+";\n")
  else:
    ver_file.write ("    tmp_"+str(i)+"_0 <= "+s[0]+";\n")
    for j in range(1, len(s)-1):
      ver_file.write ("    tmp_"+str(i)+"_"+str(j)+" <= tmp_"+str(i)+"_"+str(j-1)+" && "+s[j]+";\n")
    ver_file.write ("    match["+str(i)+"] <= tmp_"+str(i)+"_"+str(len(s)-2)+" && "+s[(len(s)-1)]+";\n")

ver_file.write ("  end\n")
ver_file.write ("  if (rst) begin\n")
ver_file.write ("    match <= 0;\n")
for t in tmp_signals:
  ver_file.write ("    "+t+" <= 1'b0;\n")
ver_file.write ("  end\n")
ver_file.write ("end\n")
ver_file.write ("\n")
ver_file.write ("endmodule")

# print ("longest check: ", max_ptr)

ver_file.close()
if (write_errors):
  prob.close()

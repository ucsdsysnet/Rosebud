from suricataparser import parse_rule, parse_file

line_size = 8

in_rules = "rules/fixed_loc_rules"
out_verilog = "fixed_loc_sme_"+str(line_size)+".v"

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
    print ("ERROR, ! not supported for content.")
  for c in content[1:-1]:
    if (c=='|'):
      if (byte_mode==0):
        byte_mode = 1
      else:
        res.append(("((s_axis_tdata[8*"+str(loc%line_size)+"+:8] == 8'h"+temp+") && s_axis_tkeep["+str(loc%line_size)+"])",loc))
        loc += 1
        temp = ""
        byte_mode = 0
    else:
      if (byte_mode==0):
        if (nocase==True):
          res.append(("(((s_axis_tdata[8*"+str(loc%line_size)+"+:8] == 8'd"+str(ord(c.lower()))+")||(s_axis_tdata[8*"+str(loc%line_size)+"+:8] == 8'd"+str(ord(c.upper()))+")) && s_axis_tkeep["+str(loc%line_size)+"])",loc))
        else:
          res.append(("((s_axis_tdata[8*"+str(loc%line_size)+"+:8] == 8'd"+str(ord(c))+") && s_axis_tkeep["+str(loc%line_size)+"])",loc))
        loc += 1
      else:
        if (c==' '):
          res.append(("((s_axis_tdata[8*"+str(loc%line_size)+"+:8] == 8'h"+temp+") && s_axis_tkeep["+str(loc%line_size)+"])",loc))
          loc += 1
          temp = ""
        else:
          temp = temp + c

  return res

bit_ops = ["&","^","!&","!^"]

def byte_conv(rule, offset):
  res = ""
  if (len(rule.split(','))==4):
    [num,op,val,off] = rule.split(',')
    rel = ""
  else:
    [num,op,val,off,rel] = rule.split(',')

  if (rel=="relative"):
    loc = int(off)+offset
  else:
    loc = int(off)

  if op in bit_ops:
    if op[0]=="!":
      res = res + "(((s_axis_tdata[8*"+str(loc%line_size)+"+:8*"+num+"] "+op[1]+" "+val+") == 0) && s_axis_tkeep["+str(loc%line_size)+"])"
    else:
      res = res + "(((s_axis_tdata[8*"+str(loc%line_size)+"+:8*"+num+"] "+op[0]+" "+val+") != 0) && s_axis_tkeep["+str(loc%line_size)+"])"
  elif op=="=":
    res = res + "((s_axis_tdata[8*"+str(loc%line_size)+"+:8*"+num+"] == "+val+") && s_axis_tkeep["+str(loc%line_size)+"])"
  else:
    res = res + "((s_axis_tdata[8*"+str(loc%line_size)+"+:8*"+num+"] "+op+" "+val+") && s_axis_tkeep["+str(loc%line_size)+"])"

  start_line = int(loc/line_size)
  if ((loc+int(num))%line_size==0):
    end_line = int((loc+int(num))/line_size)-1
  else:
    end_line = int((loc+int(num))/line_size)

  if start_line != end_line:
    print ("ERROR: byte check on line boundary. ", rule, offset)

  return [(res,loc)]

max_ptr = 0
ver_statements = []
rule_count = 0

for line in open(in_rules,'r'):
  if len(line.strip()) != 0 :

    ### remote unused s_axis_tdata ###
    rule = parse_rule(line).to_dict()
    options = rule['options']
    cleaned_options = []
    for opt in options:
      if opt['name'] not in ['msg','metadata', 'flow', 'sid', 'rev', 'reference', 'classtype', 'pcre', 'threshold', 'fast_pattern', 'dsize', 'flow', 'flowbits']:
        cleaned_options.append(opt)

    ### group each content with its modifiers ###
    grouped = []
    for opt in cleaned_options:
      name = opt['name']
      value = opt['value']

      if (name == 'content') or (name == 'byte_test') :
        grouped.append([(name,value)])
      else:
        grouped[-1].append((name,value))

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
        statement += byte_conv(value, cur_byte)

    if max_ptr < (cur_byte):
      max_ptr = cur_byte;

    ### group statements based on read line size ###
    verilog_phrase = []
    temp = "("
    line = 0
    last_temp = 0
    for (s,loc) in statement:
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

print ("longest check: ", max_ptr)


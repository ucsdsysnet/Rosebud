from suricataparser import parse_rule, parse_file

in_rules = "rules/orig_rules"
out_fixed_loc = "rules/fixed_loc_rules"
out_float_loc = "rules/float_loc_rules"
out_http_rules = "rules/http_rules"

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

fixed_f = open(out_fixed_loc,'w')
float_f = open(out_float_loc,'w')
http_f  = open(out_http_rules,'w')
   
for line in open(in_rules,'r'):
  if len(line.strip()) != 0 :
    rule = parse_rule(line).to_dict()
    if rule['header'].startswith('http'):
      http_f.write(line)
      continue
    options = rule['options']
    cleaned_options = []
    for opt in options:
      if opt['name'] not in ['msg','metadata', 'flow', 'sid', 'rev', 'reference', 'classtype', 'threshold', 'fast_pattern', 'dsize']:
        cleaned_options.append(opt)
    # print (cleaned_options)
    cont_len = 0
    cont_count = 0
    fixed = 0
    starting = 0
    cont_resolved = 1

    for opt in cleaned_options:
      name = opt['name']
      value = opt['value']
      if name == 'content':
        # not supported
        if value.startswith("!"):
          fixed = 0
          break;
        fixed = 1 # it would set zero otherwise, but at least one content
        cont_count += 1
        if cont_resolved==1:
          cont_len = content_len(value)
          cont_resolved = 0
        else:
          # two content after each other without depth or distance
          fixed = 0
          break;
      elif name == 'pcre':
          fixed = 0
          break;
      elif name == 'depth': 
        if (int(value) != cont_len):
          fixed = 0
          break;
        # First content should have depth
        elif (cont_count ==1): 
          starting = 1
          cont_resolved =1 
        else:
          cont_resolved = 1
      elif name == 'within':
        if (int(value) != cont_len):
          fixed = 0
          break;
        else:
          fixed = 1 
          cont_resolved = 1
      elif name == 'distance':
          # unless resolved with within
          fixed = 0
      # else if name == 'offset'

    # print (cleaned_options)

    if (fixed==1 and starting==1 and cont_resolved==1):
      fixed_f.write(line)
    elif (fixed==1 and cont_resolved==1 and starting==0):
      print (line.rstrip())
    else:
      float_f.write(line)

fixed_f.close()
float_f.close()
http_f.close()

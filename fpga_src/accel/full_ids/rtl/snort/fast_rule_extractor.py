from idstools.rule import parse
import re

in_rules = "all.rules"
pat_file = "fast_patterns.txt"

def content_len(content):
  count = 0
  byte_mode = 0
  # if content.startswith("!"):
  #   content = content[1:]
  for c in content:
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

fp = open(pat_file,'w')
   
for line in open(in_rules,'r'):
  if len(line.strip()) != 0 :
    fast_pattern = ""
    pattern_len = 0
    unknown_flag = False
    fast_flag = False

    rule = parse(line)
    options = rule['options']

    for opt in options:
      if opt['name'] == 'content':
        value = re.findall('"([^"]*)"', opt['value'])[0]
        flags = opt['value'][len(value)+3:]
        cont_len = content_len(value)
        
        if "fast_pattern" in flags: 
          fast_pattern = value[:]
          fast_flag = True
          if opt['value'].startswith("!"):
            unknown_flag = True
          break

        elif opt['value'].startswith("!"):
          
          # Not acceptable for fast pattern
          if (len(flags)!=0):
            if ("relative" in flags) or ("case" in flags) or ("offset" in flags) or \
              ("depth" in flags) or ("within" in flags) or ("distance" in flags):
              continue

          # Acceptable but not long enough
          elif (cont_len <= pattern_len):
              continue

          # Acceptable, not sure what to do for hardware check
          # might get overriden by a longer pattern
          else:
            unknown_flag = True
            pattern_len = cont_len
            continue

        else:
          # No \" in curent content rules, might not be always true
          # re strips of the ! and ""
          if (cont_len>pattern_len):
            unknown_flag = False
            fast_pattern = value[:]
            pattern_len = cont_len
    
    fp.write(fast_pattern+'\n')
    if unknown_flag:
      print ("used", fast_pattern, "for", line)

fp.close()

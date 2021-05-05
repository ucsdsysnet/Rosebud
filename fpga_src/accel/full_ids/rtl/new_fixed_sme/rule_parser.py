import re
from idstools.rule import parse

fixed_len_limit = 32

in_rules = "rules/orig_rules"
out_fixed_loc = "rules/fixed_loc_rules"
out_float_loc = "rules/float_loc_rules"

def content_len(content):
  count = 0
  byte_mode = 0
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

fixed_f = open(out_fixed_loc,'w')
float_f = open(out_float_loc,'w')
long_rules = 0

for line in open(in_rules,'r'):
  if len(line.strip()) != 0 :
    rule    = parse(line)
    options = rule['options']

    cont_len = 0
    cont_count = 0
    pcre_count = 0
    fixed = 0
    starting = 0
    cont_resolved = 1

    for opt in options:
      name = opt['name']
      # we only care about content and pcre, as byte has fixed location
      if name == 'content':
        value = re.findall('"([^"]*)"', opt['value'])[0] #drops !
        flags = opt['value'][len(value)+3:]

        cont_count += 1
        if cont_resolved==1:
          cont_len = content_len(value)
          cont_resolved = 0
        else:
          # two content after each other without depth or distance
          fixed = 0
          break;

        for flag in flags.split(','):
          x = flag.split(' ')
          if len(x)>1:

            keyword = x[0]
            if (x[1].isnumeric()):
              val = int(x[1])
            else:
              break

            if keyword == 'depth':
              if (val != cont_len):
                fixed = 0
                break
              # First content should have depth
              elif (cont_count ==1):
                fixed = 1
                starting = 1
                cont_resolved =1
              else:
                fixed = 1
                cont_resolved = 1
            elif keyword == 'within':
              if (val != cont_len):
                fixed = 0
                break
              else:
                fixed = 1
                cont_resolved = 1
            elif keyword == 'distance' or keyword == 'offset':
                if (val > fixed_len_limit):
                  long_rules += 1
                  fixed = 0
                  break
                else:
                  # unless resolved with within
                  continue

    if (fixed==1 and starting==1 and cont_resolved==1) or (cont_count==0): #Just byte check
      fixed_f.write(line)
    elif (fixed==1 and cont_resolved==1 and starting==0):
      print (line.rstrip())
    else:
      float_f.write(line)

print ("There were",long_rules,"long rules that might be potentially fixed, but ignored.")

fixed_f.close()
float_f.close()

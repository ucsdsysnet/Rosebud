from idstools.rule import parse, remove_option
import re

fn   = "trimmed_rules.txt"
trim = "new_trim.txt"

# to_remove = ['reference', 'dce_iface', 'dsize', 'metadata', 'sid', 'byte_extract', 'byte_math', 'base64_data', 'rev', 'dce_opnum', 'ssl_state', 'detection_filter', 'pcre', 'dce_stub_data', 'flags', 'ssl_version', 'isdataat', 'content', 'byte_test', 'bufferlen', 'classtype', 'pkt_data', 'byte_jump', 'base64_decode', 'msg', 'stream_size']
to_remove = ['byte_extract', 'isdataat', 'byte_test', 'byte_jump', 'byte_math',
             'pcre', 'dsize', 'bufferlen', 'stream_size',
             'base64_data', 'base64_decode', 'dce_opnum', 'dce_stub_data',
             'ssl_state', 'detection_filter','flags', 'ssl_version']

def extract_all_options():
    opset = set()
    with open(fn, 'r') as f:
        for line in f.read().splitlines():
            rule = parse(line)
            ops = rule['options']
            for op in ops:
              opset.add(op['name'])
    return opset

def remove_not_fast(rule, rm_flags):
    select = []
    count = 0
    cont_rules = []
    not_short = True
    for opt in rule["options"]:
        if (opt["name"]!='content'):
            select.append(opt)
        else:
            if opt['value'].startswith("!"):
                continue
            value = re.findall('"([^"]*)"', opt['value'])[0]
            cont_rules.append((opt,value))
            flags = opt['value'][len(value)+3:]
            if "fast_pattern" in flags:
                for f in rm_flags:
                    opt['value']=opt['value'].replace(f+",","")
                select.append(opt)
                count += 1
                if len(value)<8:
                    not_short = False


    # If there was no fast pattern, use the first content rule
    if (count==0):
        longest = max(cont_rules, key = lambda x: len(x[1]))
        select.append(longest[0])
        if len(longest[1])<8:
            not_short = False
        # if longest != cont_rules[0]:
        #     print("WARNING: first rule is not the longest rule:",
        #           [x[0] for x in cont_rules])

    rule["options"] = [x for x in select]
    new_rule_string = "%s%s (%s)" % (
        "" if rule.enabled else "# ",
        rule["header"].strip(),
        rule.rebuild_options());
    return parse(new_rule_string, rule["group"]), not_short

def main():
    trimf = open (trim, 'w')
    with open(fn, 'r') as f:
        for line in f.read().splitlines():
            if (len(line.strip()) != 0):
                rule = parse(line)
                for r in to_remove:
                    rule = remove_option(rule, r)
                rule,not_short = remove_not_fast(rule, ["within codeSize", "within obj_len"])

                # if not_short:
                trimf.write(rule.format()+"\n");
                # else:
                #     print ("Trimmed rule too short:", rule)
    trimf.close()

if __name__ == "__main__":
    # print (extract_all_options())
    main()


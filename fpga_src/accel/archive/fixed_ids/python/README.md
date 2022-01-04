rule_parser.py script reads a suricata ruleset and breaks it into rules with fixed_location, http_rules, and rest of the rules as floating rules.

verilog_generator.py reads the fixed_location rules from output of rule_parser.py and generates a hardware accelerator from it, in verilog. The input data width of verilog module can be given as number of bytes per line. 

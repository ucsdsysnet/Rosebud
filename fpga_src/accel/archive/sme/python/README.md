String Matching Engine



SME rule compiler

sme_rulecompiler.py is the rule compiler for the string matching engine.  The rule compiler converts a list of matches into a set of partitioned bit-split aho-corasick state machines.  It can generate both verilog and a bare state transition listing that can be loaded on to a reconfigurable matching engine.  

Command line options:

--split_width      Bit split width (bits)
--max_matches      Max matches per block
--max_states       Max states per block

--match_file       Match file
--rules_file       Rules file
--test_file        Test file

--module_name      Verilog module name
--output_verilog   Verilog output file name

--states_file      States output file name

--summary_file     Summary file
--stats_file       Statistics file


The rule compiler can read in one or more lists of matches or rules.  A match file contains one plain text string per line, delineated by new lines.  Hence a match file cannot contain matches that themselves match on newlines.  A rules file also contains one match per line, but matches can contain portions in hexadecimal delineated by pipe characters.  The --match_file and --rules_file options can be specified an unlimited number of times to combine matches from multiple files.  All matches will be combined into one list, de-duplicated, and sorted.  

The rule compiler can also read in a test file to check for matches using the final partitioned and bit-split state machines.  

The split_width, max_matches, and max_states parameters determine how the state machines are generated.  split_width is the number of bits that each state machine examples; valid values are 1, 2, 4, or 8.  max_matches and max_states determine how matches are partitioned.  Matches will be incrementally partitioned into blocks of up to max_matches in size, with matches removed to get the number of states in any of the associated state machines below max_states.  

The rule compiler can output the state machines either in the form of a verilog file or in the form of a list of states and state transitions.  The generated verilog files accept one byte per clock cycle on an AXI stream interface, and produce a one-hot match output indicating which rule is matched for the current byte.  

The states file is a list of states in csv format.  The columns are as follows:

partition - partition index
split - bit split index in partition
index - state index in state machine
next_state_* - next state index for each bit-split input value
match - one-hot match vector for state

The rule compiler can also output summary and statistics files.  The statistics file contains information about the configuration, matches, and state machines.  The summary file is a list of implemented matches in csv format, along with the associated partition and match bit indicies.  The columns are as follows:

index - match index
partition - partition index
bit - match bit index in partition
hex - match in hex
match - quoted original match string


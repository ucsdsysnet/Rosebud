MAX_STATE=256
MAX_LENGTH=8
STATE_LOAD=0
RULES_FILE=all.rules

all: fast_pattern_sme.v

clean:
	rm *.v *.txt

%_sme.v: $(RULES_FILE)
	python3 sme_rulecompiler.py --rules_file $(RULES_FILE) \
		--output_verilog $@ \
		--states_file $(basename $@)_states.txt \
		--summary_file $(basename $@)_summary.txt \
		--stats_file $(basename $@)_stats.txt \
		--split_width 2 \
		--max_states ${MAX_STATE} \
		--max_length ${MAX_LENGTH} \
		--enable_state_out ${STATE_LOAD} \
		--enable_state_in ${STATE_LOAD}

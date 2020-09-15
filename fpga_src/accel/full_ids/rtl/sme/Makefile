MAX_STATE=256

all: udp_sme.v tcp_sme.v http_sme.v

clean:
	rm *.v *.txt

%_sme.v: ./rules/%_content_rules
	python3 sme_rulecompiler.py --rules_file $< --output_verilog $@ --states_file $(basename $@)_states.txt --summary_file $(basename $@)_summary.txt --stats_file $(basename $@)_stats.txt --split_width 2 --max_states ${MAX_STATE}

NAME=udp
RULES=./rules/${NAME}_content_rules
OUT_V= ${NAME}_sme.v
STATES= ${NAME}_states.txt
SUMMARY= ${NAME}_summary.txt
STATS= ${NAME}_stats.txt
MAX_STATE=256

all:
	python3 sme_rulecompiler.py --rules_file ${RULES} --test_file ./rules/content_rules_test --output_verilog ${OUT_V} --states_file ${STATES} --summary_file ${SUMMARY} --stats_file ${STATS} --split_width 2 --max_states ${MAX_STATE}

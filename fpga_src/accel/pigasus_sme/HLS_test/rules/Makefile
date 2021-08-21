extract:
	# grep -h -v "^#" no_file_data_no_nocase/*.rules | grep -v "^$$" > all_rules.txt
	grep -o "sid:[[:digit:]]*;" all_rules.txt | grep -o "[[:digit:]]*" > sids.txt
	grep -o "alert [^\s]* [^\s]* [^\s]* [-|<]> [^\s]* [^\s]*" all_rules.txt | sed 's/alert //g' | sed 's/ ( m//g' > ports.txt
	paste -d "\t" sids.txt ports.txt > extracted.txt
	rm sids.txt
	rm ports.txt

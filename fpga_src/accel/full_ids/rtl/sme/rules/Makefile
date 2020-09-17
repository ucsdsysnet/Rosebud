

all: tcp_content_rules http_content_rules udp_content_rules

%_content_rules: %_rules
	./extract-content.sh $< > $@


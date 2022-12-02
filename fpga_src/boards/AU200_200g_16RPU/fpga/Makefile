.PHONY: all
all: 
	vivado -nojournal -nolog -mode batch -source create_project.tcl
	vivado -nojournal -nolog -mode batch -source run_synth.tcl
	vivado -nojournal -nolog -mode batch -source run_impl_1.tcl
	vivado -nojournal -nolog -mode batch -source generate_bit.tcl
	mkdir -p rev
	EXT=bit; COUNT=100; \
	while [ -e rev/$*_rev$$COUNT.$$EXT ]; \
	do COUNT=$$((COUNT+1)); done; \
	cp $@ rev/$*_rev$$COUNT.$$EXT; \
	echo "Output: rev/$*_rev$$COUNT.$$EXT";

.PHONY: clean
clean:
	rm -rf *.log *.jou *.cache *.hw *.ip_user_files *.runs *.xpr *.html *.xml *.sim *.srcs *.str .Xil defines.v rev *.rpt hd_visual fpga.hbs *.bit fpga.gen hd_visual

all:
	make -C ../../accel/full_ids/c/ NAME=full_ids
	COCOTB_ANSI_OUTPUT=1 ./test_fpga_core.py --waves=1 --reduced_log=1

clean:
	./test_fpga_core.py --clean
	rm -r __pycache__

NAME=default

compile:
	riscv32-unknown-elf-gcc -nostdlib -O2 -T link_option.ld -mbranch-cost=3 -o ${NAME}.o startup.S int_handler.c ${NAME}.c
	riscv32-unknown-elf-objcopy -O binary ${NAME}.o ${NAME}.bin
	riscv32-unknown-elf-objdump -d ${NAME}.o > ${NAME}.asm 
	./hex_gen.py -w 128 -i ${NAME}.bin > ${NAME}.hex
read_bin:
	xxd -e ${NAME}.bin

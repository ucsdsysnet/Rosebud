NAME=test

compile:
	riscv32-unknown-elf-gcc -nostdlib -O2 -T link_option.ld -mbranch-cost=3 -o ${NAME}.o startup.S ${NAME}.c
	riscv32-unknown-elf-objcopy -O binary ${NAME}.o ${NAME}.bin
	riscv32-unknown-elf-objdump -d ${NAME}.o > ${NAME}.asm 
	od -An -vtx8 -w8 ${NAME}.bin | sed 's/ //' > ${NAME}.hex
read_bin:
	xxd -e ${NAME}.bin

NAME=basic_fw_re
WIDTH=64

CC=riscv64-unknown-elf-gcc
CC = riscv64-unknown-elf-gcc
CXX = riscv64-unknown-elf-g++
OBJCOPY = riscv64-unknown-elf-objcopy
OBJDUMP = riscv64-unknown-elf-objdump
SIZE = riscv64-unknown-elf-size
NM = riscv64-unknown-elf-nm

compile:
	rm -f ${NAME}.bin ${NAME}.hex ${NAME}.o ${NAME}.asm
	$(CC) -march=rv32i -mabi=ilp32 -nostdlib -O2 -T link_option.ld -mbranch-cost=3 -o ${NAME}.o startup.S int_handler.c ${NAME}.c
	$(OBJCOPY) -O binary ${NAME}.o ${NAME}.bin
	$(OBJDUMP) -h -S ${NAME}.o > ${NAME}.asm 
	./hex_gen.py -w ${WIDTH} -i ${NAME}.bin > ${NAME}.hex
read_bin:
	xxd -e ${NAME}.bin
clean:
	rm -f *.bin *.hex *.o *.asm

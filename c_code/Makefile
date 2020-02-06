NAME=pkt_gen
WIDTH=128

CC=riscv32-unknown-elf-gcc
CC = riscv32-unknown-elf-gcc
CXX = riscv32-unknown-elf-g++
OBJCOPY = riscv32-unknown-elf-objcopy
OBJDUMP = riscv32-unknown-elf-objdump
SIZE = riscv32-unknown-elf-size
NM = riscv32-unknown-elf-nm

compile:
	rm -f ${NAME}.bin ${NAME}.hex ${NAME}.o ${NAME}.asm
	$(CC) -nostdlib -O2 -T link_option.ld -mbranch-cost=3 -o ${NAME}.o startup.S int_handler.c ${NAME}.c
	$(OBJCOPY) -O binary ${NAME}.o ${NAME}.bin
	$(OBJDUMP) -h -S ${NAME}.o > ${NAME}.asm 
	./hex_gen.py -w ${WIDTH} -i ${NAME}.bin > ${NAME}.hex
read_bin:
	xxd -e ${NAME}.bin
clean:
	rm -f *.bin *.hex *.o *.asm

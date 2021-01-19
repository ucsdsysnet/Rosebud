NAME=basic_fw_hash
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
	$(CC) -march=rv32i -mabi=ilp32 -nostdlib -fno-delete-null-pointer-checks -O2 -T link_option.ld -mbranch-cost=3 -o ${NAME}.o startup.S ${NAME}.c
	$(OBJCOPY) -R .text -O binary ${NAME}.o ${NAME}_data.bin
	$(OBJCOPY) -j .text -O binary ${NAME}.o ${NAME}_ins.bin
	$(OBJDUMP) -h -S ${NAME}.o > ${NAME}.asm
	# $(OBJDUMP) -h -D ${NAME}.o > ${NAME}_full.txt
	./hex_gen.py -w ${WIDTH} -i ${NAME}_data.bin > ${NAME}_data.hex
	./hex_gen.py -w ${WIDTH} -i ${NAME}_ins.bin > ${NAME}_ins.hex
read_bin:
	xxd -e ${NAME}_data.bin
clean:
	rm -f *.bin *.hex *.o *.asm

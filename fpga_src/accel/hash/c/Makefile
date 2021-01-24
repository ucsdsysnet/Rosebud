NAME=basic_fw_hash
WIDTH=128

CC=riscv64-unknown-elf-gcc
CC = riscv64-unknown-elf-gcc
CXX = riscv64-unknown-elf-g++
OBJCOPY = riscv64-unknown-elf-objcopy
OBJDUMP = riscv64-unknown-elf-objdump
SIZE = riscv64-unknown-elf-size
NM = riscv64-unknown-elf-nm

compile:
	rm -f ${NAME}.bin ${NAME}.hex ${NAME}.elf ${NAME}.asm
	$(CC) -march=rv32i -mabi=ilp32 -nostdlib -fno-delete-null-pointer-checks -O2 -T link_option.ld -mbranch-cost=3 -o ${NAME}.elf startup.S int_handler.c ${NAME}.c
	$(OBJCOPY) -R .text -O binary ${NAME}.elf ${NAME}_data.bin
	$(OBJCOPY) -j .text -O binary ${NAME}.elf ${NAME}_ins.bin
	$(OBJDUMP) -h -S ${NAME}.elf > ${NAME}.asm
	# $(OBJDUMP) -h -D ${NAME}.elf > ${NAME}_full.txt
	./hex_gen.py -w ${WIDTH} -i ${NAME}_data.bin > ${NAME}_data.hex
	./hex_gen.py -w ${WIDTH} -i ${NAME}_ins.bin > ${NAME}_ins.hex
read_bin:
	xxd -e ${NAME}_data.bin
clean:
	rm -f *.bin *.hex *.o *.elf *.asm

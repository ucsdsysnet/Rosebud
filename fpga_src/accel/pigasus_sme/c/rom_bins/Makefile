NAME=match_table

# Assuming mif file is already zero padded to DATA_WIDTH
convert:
	xxd -r -p $(NAME).mif $(NAME).bin
	xxd -e -g16 $(NAME).bin temp
	xxd -r temp $(NAME).bin
	rm -rf temp

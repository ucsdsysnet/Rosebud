NAME=basic_fw

# CPU options
ARCH = rv32i
ABI = ilp32

# Toolchain options
# CROSS_COMPILE = riscv32-unknown-elf-
# CROSS_COMPILE = riscv64-unknown-elf-
CROSS_COMPILE = riscv64-elf-

# Preprocessor defines
DEFINES = 

# Target file name
TARGET = $(NAME)

# C source files
SRC = $(TARGET).c
SRC += int_handler.c
SRC += pcg_basic.c
# SRC += ...

# Assembly source files
ASRC = startup.S
# ASRC += ...

# optimization level
OPT = 2

# Extra directories for include files
EXTRAINCDIRS =

# C standard level
CSTANDARD = -std=gnu99

# Place -D or -U options here
CDEFS = 

# Place -I options here
CINCS = 

# Compiler flags
COMMON_FLAGS = $(CDEFS) $(CINCS)
COMMON_FLAGS += -O$(OPT) -flto -mbranch-cost=3
# COMMON_FLAGS += -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
# COMMON_FLAGS += -ffunction-sections -fdata-sections
# COMMON_FLAGS += -Wall
# COMMON_FLAGS += -Wa,-adhlns=$(basename $<).lst
COMMON_FLAGS += $(patsubst %,-I%,$(EXTRAINCDIRS))
COMMON_FLAGS += -nostartfiles
# COMMON_FLAGS += ...

# C Specific flags
CFLAGS = $(COMMON_FLAGS)
# CFLAGS += -Wstrict-prototypes
CFLAGS += $(CSTANDARD)
# CFLAGS += ...

# C++ Specific flags
CXXFLAGS = $(COMMON_FLAGS)
# CXXFLAGS += ...

# Assembler flags
ASFLAGS = -Wa,-adhlns=$(<:.S=.lst),-gstabs

# Linker flags
# LDFLAGS = -Wl,-Map=$(TARGET).map,--cref
LDFLAGS += -Wl,--gc-sections
LDFLAGS += -T link_option.ld

# commands
SHELL = sh
CC = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
SIZE = $(CROSS_COMPILE)size
NM = $(CROSS_COMPILE)nm
REMOVE = rm -f
COPY = cp

OBJ = $(addsuffix .o,$(basename $(SRC) $(ASRC)))

LST = $(addsuffix .lst,$(basename $(SRC) $(ASRC)))

GENDEPFLAGS = -MD -MP -MF .dep/$(@F).d

ALL_CFLAGS = -march=$(ARCH) -mabi=$(ABI) -I. $(CFLAGS) $(GENDEPFLAGS) $(DEFINES)
ALL_CXXFLAGS = -march=$(ARCH) -mabi=$(ABI) -I. $(CXXFLAGS) $(GENDEPFLAGS) $(DEFINES)
ALL_ASFLAGS = -march=$(ARCH) -mabi=$(ABI) -I. -x assembler-with-cpp $(ASFLAGS) $(DEFINES)


# default make target
all: build size

build: elf bin lss sym

elf: $(TARGET).elf
bin: $(TARGET)_ins.bin $(TARGET)_data.bin
lss: $(TARGET).lss
sym: $(TARGET).sym


# Compile
%.o : %.c
	$(CC) -c $(ALL_CFLAGS) $< -o $@

%.o : %.cpp
	$(CXX) -c $(ALL_CXXFLAGS) $< -o $@

%.s : %.c
	$(CC) -S $(ALL_CFLAGS) $< -o $@

%.s : %.cpp
	$(CXX) -S $(ALL_CXXFLAGS) $< -o $@


# Assemble
%.o : %.S
	$(CC) -c $(ALL_ASFLAGS) $< -o $@


# Link
.SECONDARY: $(TARGET).elf
.PRECIOUS: $(OBJ)
%.elf: $(OBJ)
	$(CC) $(ALL_CFLAGS) $(OBJ) --output $@ $(LDFLAGS)


# assembly listing
%.lss: %.elf
	$(OBJDUMP) -h -S $< > $@

# symbol table
%.sym: %.elf
	$(NM) -n $< > $@


# output files
%_ins.bin: %.elf
	$(OBJCOPY) -j .text -O binary $< $@

%_data.bin: %.elf
	$(OBJCOPY) -R .text -O binary $< $@


# size information
ELFSIZE = $(SIZE) -x -A $(TARGET).elf
size:
	@if [ -f $(TARGET).elf ]; then echo; $(ELFSIZE); fi

clean:
	$(REMOVE) $(TARGET)_ins.bin
	$(REMOVE) $(TARGET)_data.bin
	$(REMOVE) $(TARGET).elf
	$(REMOVE) $(TARGET).map
	$(REMOVE) $(TARGET).sym
	$(REMOVE) $(TARGET).lss
	$(REMOVE) $(OBJ)
	$(REMOVE) $(LST)
	$(REMOVE) $(addsuffix .s,$(basename $(SRC)))
	$(REMOVE) $(addsuffix .d,$(basename $(SRC)))
	$(REMOVE) .dep/*

-include $(shell mkdir .dep 2>/dev/null) $(wildcard .dep/*)

.PHONY: all size build elf hex lss sym clean

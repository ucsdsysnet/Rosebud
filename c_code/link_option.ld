
OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv", "elf32-littleriscv")
OUTPUT_ARCH(riscv)

MEMORY
{
  IMEM (x!rwai) : ORIGIN = 0x02000000, LENGTH = 64k
  DMEM (rwa!xi) : ORIGIN = 0x00800000, LENGTH = 32k
  PMEM (rwa!xi) : ORIGIN = 0x01000000, LENGTH = 1m
}

ENTRY(_start)

SECTIONS
{
  .text :
  {
    _start_text = .;
    KEEP(*(.vectors))
    *(.text .text*)
    . = ALIGN(4);
    _end_text = .;
  } > IMEM

  .data :
  {
    _start_data = .;
    KEEP(*(.vectors))
    *(.data .data*)
    *(.rodata .rodata*)
    *(.srodata .srodata*)
    . = ALIGN(4);
    _end_data = .;
  } > DMEM

  .bss (NOLOAD) :
  {
    _start_bss = .;
    *(.bss*)
    *(.sbss*)
    *(COMMON)
    . = ALIGN(4);
    _end_bss = .;
    _end = .;
  } > DMEM

}

PROVIDE(_start_heap = _end);

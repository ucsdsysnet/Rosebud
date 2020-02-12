
OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv", "elf32-littleriscv")
OUTPUT_ARCH(riscv)

MEMORY
{
  IMEM (x!rwai) : ORIGIN = 0x02000000, LENGTH = 64k
  DMEM (rwa!xi) : ORIGIN = 0x00800000, LENGTH = 32k
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

  .bss (NOLOAD) :
  {
    _start_bss = .;
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _end_bss = .;
    _end = .;
  } > DMEM

}

PROVIDE(_start_heap = _end);
PROVIDE(_end_stack  = ORIGIN(DMEM) + (LENGTH(DMEM) - 8k));

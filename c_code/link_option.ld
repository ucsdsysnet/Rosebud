
OUTPUT_FORMAT("elf32-littleriscv")
OUTPUT_ARCH(riscv)

MEMORY
{
	MEM (rwx) : ORIGIN = 0x0, LENGTH = 8k
}

ENTRY(_start)

SECTIONS
{
  . = 0x00000;
  .text ALIGN(4) :
  {
    _start_text = .;
    KEEP(*(.vectors))
    *(.text .text*)
    . = ALIGN(4);
    _end_text = .;
  } > MEM

  .data :
  {
    _start_data = .;
    *(.data*)
    *(.sdata*)
    . = ALIGN(4);
    _end_data = .;
  } > MEM

  .bss :
  {
    _start_bss = .;
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _end_bss = .;
    _end = .;
  } > MEM

}

PROVIDE(_start_heap = _end);
PROVIDE(_end_stack  = ORIGIN(MEM) + LENGTH(MEM));

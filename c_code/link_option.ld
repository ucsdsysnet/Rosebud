MEMORY
{
	MEM (rwx) : ORIGIN = 0x0, LENGTH = 8k
}

ENTRY(_start)

SECTIONS
{
  . = 0x00000;
  .text ALIGN(32) : {
    *(.text .text*)
    . = 0x00200;
    *(.text.except)
  } >MEM

}

SECTIONS
{
  . = 0x00000;
  .text : { *(.text.startup);
              . = 0x00200;
            *(.text.except);}


}

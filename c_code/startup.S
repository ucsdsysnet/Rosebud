.global _start
_start:
  la sp,0x2000
	li a0, 0x880     //880 enable timer + external interrupts
  csrw mie,a0
  li a0, 0x1808     //1808 enable interrupts
  csrw mstatus,a0
  jal main


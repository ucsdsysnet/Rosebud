
test.o:     file format elf32-littleriscv


Disassembly of section .text.startup:

00000000 <main>:
   0:	000015b7          	lui	a1,0x1
   4:	80058793          	addi	a5,a1,-2048 # 800 <main+0x800>
   8:	fff00693          	li	a3,-1
   c:	00008737          	lui	a4,0x8
  10:	00d72023          	sw	a3,0(a4) # 8000 <main+0x8000>
  14:	00078513          	mv	a0,a5
  18:	000086b7          	lui	a3,0x8
  1c:	99058593          	addi	a1,a1,-1648
  20:	0037c703          	lbu	a4,3(a5)
  24:	00a78633          	add	a2,a5,a0
  28:	00478793          	addi	a5,a5,4
  2c:	00270713          	addi	a4,a4,2
  30:	00e62023          	sw	a4,0(a2)
  34:	0016c703          	lbu	a4,1(a3) # 8001 <main+0x8001>
  38:	fff70713          	addi	a4,a4,-1
  3c:	00e680a3          	sb	a4,1(a3)
  40:	feb790e3          	bne	a5,a1,20 <main+0x20>
  44:	0000006f          	j	44 <main+0x44>

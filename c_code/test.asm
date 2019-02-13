
test.o:     file format elf32-littleriscv


Disassembly of section .text.startup:

00000000 <main>:
   0:	050508b7          	lui	a7,0x5050
   4:	00008637          	lui	a2,0x8
   8:	ffff0e37          	lui	t3,0xffff0
   c:	50588893          	addi	a7,a7,1285 # 5050505 <main+0x5050505>
  10:	18000313          	li	t1,384
  14:	10000793          	li	a5,256
  18:	0007a703          	lw	a4,0(a5)
  1c:	04070463          	beqz	a4,64 <main+0x64>
  20:	0007a803          	lw	a6,0(a5)
  24:	0047a683          	lw	a3,4(a5)
  28:	00062583          	lw	a1,0(a2) # 8000 <main+0x8000>
  2c:	01c86733          	or	a4,a6,t3
  30:	fff74713          	not	a4,a4
  34:	00b77733          	and	a4,a4,a1
  38:	00e62023          	sw	a4,0(a2)
  3c:	10002023          	sw	zero,256(zero) # 100 <main+0x100>
  40:	0186a503          	lw	a0,24(a3)
  44:	01c6a583          	lw	a1,28(a3)
  48:	01150533          	add	a0,a0,a7
  4c:	011585b3          	add	a1,a1,a7
  50:	00a6ac23          	sw	a0,24(a3)
  54:	00b6ae23          	sw	a1,28(a3)
  58:	00062703          	lw	a4,0(a2)
  5c:	01076733          	or	a4,a4,a6
  60:	00e62023          	sw	a4,0(a2)
  64:	00878793          	addi	a5,a5,8
  68:	fa6798e3          	bne	a5,t1,18 <main+0x18>
  6c:	fa9ff06f          	j	14 <main+0x14>

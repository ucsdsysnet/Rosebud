
default.o:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start_text>:
   0:	00c0006f          	j	c <_start>

00000004 <int_vector>:
   4:	0300006f          	j	34 <int_handler>

00000008 <dummy_handler>:
   8:	0000006f          	j	8 <dummy_handler>

0000000c <_start>:
   c:	00002117          	auipc	sp,0x2
  10:	ff410113          	addi	sp,sp,-12 # 2000 <_end_stack>
  14:	00001537          	lui	a0,0x1
  18:	88050513          	addi	a0,a0,-1920 # 880 <_end_text+0x63c>
  1c:	30451073          	csrw	mie,a0
  20:	00002537          	lui	a0,0x2
  24:	80850513          	addi	a0,a0,-2040 # 1808 <_end_text+0x15c4>
  28:	30051073          	csrw	mstatus,a0
  2c:	164000ef          	jal	ra,190 <main>
  30:	0000006f          	j	30 <_start+0x24>

00000034 <int_handler>:
  34:	fe010113          	addi	sp,sp,-32
  38:	00c12e23          	sw	a2,28(sp)
  3c:	00d12c23          	sw	a3,24(sp)
  40:	00e12a23          	sw	a4,20(sp)
  44:	00f12823          	sw	a5,16(sp)
  48:	34202773          	csrr	a4,mcause
  4c:	000086b7          	lui	a3,0x8
  50:	05c6c783          	lbu	a5,92(a3) # 805c <_end_stack+0x605c>
  54:	0ff7f793          	andi	a5,a5,255
  58:	04074463          	bltz	a4,a0 <int_handler+0x6c>
  5c:	0017f713          	andi	a4,a5,1
  60:	02070263          	beqz	a4,84 <int_handler+0x50>
  64:	00100793          	li	a5,1
  68:	02f68ea3          	sb	a5,61(a3)
  6c:	01c12603          	lw	a2,28(sp)
  70:	01812683          	lw	a3,24(sp)
  74:	01412703          	lw	a4,20(sp)
  78:	01012783          	lw	a5,16(sp)
  7c:	02010113          	addi	sp,sp,32
  80:	30200073          	mret
  84:	0027f713          	andi	a4,a5,2
  88:	04071863          	bnez	a4,d8 <int_handler+0xa4>
  8c:	0047f713          	andi	a4,a5,4
  90:	0c070463          	beqz	a4,158 <int_handler+0x124>
  94:	00400793          	li	a5,4
  98:	02f68ea3          	sb	a5,61(a3)
  9c:	fd1ff06f          	j	6c <int_handler+0x38>
  a0:	00777613          	andi	a2,a4,7
  a4:	00060663          	beqz	a2,b0 <int_handler+0x7c>
  a8:	02000613          	li	a2,32
  ac:	02c68ea3          	sb	a2,61(a3)
  b0:	00b77713          	andi	a4,a4,11
  b4:	fa070ce3          	beqz	a4,6c <int_handler+0x38>
  b8:	01879713          	slli	a4,a5,0x18
  bc:	41875713          	srai	a4,a4,0x18
  c0:	02074c63          	bltz	a4,f8 <int_handler+0xc4>
  c4:	0407f793          	andi	a5,a5,64
  c8:	0a078263          	beqz	a5,16c <int_handler+0x138>
  cc:	000087b7          	lui	a5,0x8
  d0:	0007ac23          	sw	zero,24(a5) # 8018 <_end_stack+0x6018>
  d4:	f99ff06f          	j	6c <int_handler+0x38>
  d8:	00200793          	li	a5,2
  dc:	02f68ea3          	sb	a5,61(a3)
  e0:	01c12603          	lw	a2,28(sp)
  e4:	01812683          	lw	a3,24(sp)
  e8:	01412703          	lw	a4,20(sp)
  ec:	01012783          	lw	a5,16(sp)
  f0:	02010113          	addi	sp,sp,32
  f4:	30200073          	mret
  f8:	000087b7          	lui	a5,0x8
  fc:	0407a683          	lw	a3,64(a5) # 8040 <_end_stack+0x6040>
 100:	00d12423          	sw	a3,8(sp)
 104:	0447a683          	lw	a3,68(a5)
 108:	00b14703          	lbu	a4,11(sp)
 10c:	00d12623          	sw	a3,12(sp)
 110:	00100693          	li	a3,1
 114:	02d78ca3          	sb	a3,57(a5)
 118:	00200793          	li	a5,2
 11c:	06071063          	bnez	a4,17c <int_handler+0x148>
 120:	00f105a3          	sb	a5,11(sp)
 124:	00812703          	lw	a4,8(sp)
 128:	000087b7          	lui	a5,0x8
 12c:	00100693          	li	a3,1
 130:	00e7a023          	sw	a4,0(a5) # 8000 <_end_stack+0x6000>
 134:	00c12603          	lw	a2,12(sp)
 138:	00008737          	lui	a4,0x8
 13c:	00c7a223          	sw	a2,4(a5)
 140:	01000613          	li	a2,16
 144:	00c783a3          	sb	a2,7(a5)
 148:	04d74783          	lbu	a5,77(a4) # 804d <_end_stack+0x604d>
 14c:	fef69ee3          	bne	a3,a5,148 <int_handler+0x114>
 150:	02d70c23          	sb	a3,56(a4)
 154:	f19ff06f          	j	6c <int_handler+0x38>
 158:	0087f793          	andi	a5,a5,8
 15c:	f00788e3          	beqz	a5,6c <int_handler+0x38>
 160:	00800793          	li	a5,8
 164:	02f68ea3          	sb	a5,61(a3)
 168:	f05ff06f          	j	6c <int_handler+0x38>
 16c:	000087b7          	lui	a5,0x8
 170:	01000713          	li	a4,16
 174:	02e78ea3          	sb	a4,61(a5) # 803d <_end_stack+0x603d>
 178:	ef5ff06f          	j	6c <int_handler+0x38>
 17c:	00300793          	li	a5,3
 180:	fad700e3          	beq	a4,a3,120 <int_handler+0xec>
 184:	ffe70713          	addi	a4,a4,-2
 188:	00e037b3          	snez	a5,a4
 18c:	f95ff06f          	j	120 <int_handler+0xec>

00000190 <main>:
 190:	000087b7          	lui	a5,0x8
 194:	20000713          	li	a4,512
 198:	00e7aa23          	sw	a4,20(a5) # 8014 <_end_stack+0x6014>
 19c:	f9f00713          	li	a4,-97
 1a0:	02e78e23          	sb	a4,60(a5)
 1a4:	81006737          	lui	a4,0x81006
 1a8:	c0070713          	addi	a4,a4,-1024 # 81005c00 <_end_stack+0x81003c00>
 1ac:	00e7a823          	sw	a4,16(a5)
 1b0:	00100693          	li	a3,1
 1b4:	82006737          	lui	a4,0x82006
 1b8:	02d78da3          	sb	a3,59(a5)
 1bc:	c8070713          	addi	a4,a4,-896 # 82005c80 <_end_stack+0x82003c80>
 1c0:	00e7a823          	sw	a4,16(a5)
 1c4:	83006737          	lui	a4,0x83006
 1c8:	02d78da3          	sb	a3,59(a5)
 1cc:	d0070713          	addi	a4,a4,-768 # 83005d00 <_end_stack+0x83003d00>
 1d0:	00e7a823          	sw	a4,16(a5)
 1d4:	84006737          	lui	a4,0x84006
 1d8:	02d78da3          	sb	a3,59(a5)
 1dc:	d8070713          	addi	a4,a4,-640 # 84005d80 <_end_stack+0x84003d80>
 1e0:	00e7a823          	sw	a4,16(a5)
 1e4:	00008737          	lui	a4,0x8
 1e8:	02d78da3          	sb	a3,59(a5)
 1ec:	01001637          	lui	a2,0x1001
 1f0:	010007b7          	lui	a5,0x1000
 1f4:	090046b7          	lui	a3,0x9004
 1f8:	00a78793          	addi	a5,a5,10 # 100000a <_end_stack+0xffe00a>
 1fc:	03b70513          	addi	a0,a4,59 # 803b <_end_stack+0x603b>
 200:	00100593          	li	a1,1
 204:	80060613          	addi	a2,a2,-2048 # 1000800 <_end_stack+0xffe800>
 208:	00a68693          	addi	a3,a3,10 # 900400a <_end_stack+0x900200a>
 20c:	00f72823          	sw	a5,16(a4)
 210:	00b50023          	sb	a1,0(a0)
 214:	00c787b3          	add	a5,a5,a2
 218:	fed79ae3          	bne	a5,a3,20c <main+0x7c>
 21c:	000017b7          	lui	a5,0x1
 220:	80078793          	addi	a5,a5,-2048 # 800 <_end_text+0x5bc>
 224:	00f71023          	sh	a5,0(a4)
 228:	00800793          	li	a5,8
 22c:	00f70123          	sb	a5,2(a4)
 230:	03000793          	li	a5,48
 234:	00f703a3          	sb	a5,7(a4)
 238:	00100793          	li	a5,1
 23c:	02f70c23          	sb	a5,56(a4)
 240:	0000006f          	j	240 <main+0xb0>

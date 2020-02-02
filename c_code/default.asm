
default.o:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00002137          	lui	sp,0x2
   4:	00001537          	lui	a0,0x1
   8:	88050513          	addi	a0,a0,-1920 # 880 <int_handler+0x600>
   c:	30451073          	csrw	mie,a0
  10:	00002537          	lui	a0,0x2
  14:	80850513          	addi	a0,a0,-2040 # 1808 <int_handler+0x1588>
  18:	30051073          	csrw	mstatus,a0
  1c:	004000ef          	jal	ra,20 <main>

00000020 <main>:
  20:	000087b7          	lui	a5,0x8
  24:	20000713          	li	a4,512
  28:	00e7aa23          	sw	a4,20(a5) # 8014 <int_handler+0x7d94>
  2c:	f9f00713          	li	a4,-97
  30:	02e78e23          	sb	a4,60(a5)
  34:	81006737          	lui	a4,0x81006
  38:	c0070713          	addi	a4,a4,-1024 # 81005c00 <int_handler+0x81005980>
  3c:	00e7a823          	sw	a4,16(a5)
  40:	00100693          	li	a3,1
  44:	82006737          	lui	a4,0x82006
  48:	02d78da3          	sb	a3,59(a5)
  4c:	c8070713          	addi	a4,a4,-896 # 82005c80 <int_handler+0x82005a00>
  50:	00e7a823          	sw	a4,16(a5)
  54:	83006737          	lui	a4,0x83006
  58:	02d78da3          	sb	a3,59(a5)
  5c:	d0070713          	addi	a4,a4,-768 # 83005d00 <int_handler+0x83005a80>
  60:	00e7a823          	sw	a4,16(a5)
  64:	84006737          	lui	a4,0x84006
  68:	02d78da3          	sb	a3,59(a5)
  6c:	d8070713          	addi	a4,a4,-640 # 84005d80 <int_handler+0x84005b00>
  70:	00e7a823          	sw	a4,16(a5)
  74:	00008737          	lui	a4,0x8
  78:	02d78da3          	sb	a3,59(a5)
  7c:	01001637          	lui	a2,0x1001
  80:	010007b7          	lui	a5,0x1000
  84:	090046b7          	lui	a3,0x9004
  88:	00a78793          	addi	a5,a5,10 # 100000a <int_handler+0xfffd8a>
  8c:	03b70513          	addi	a0,a4,59 # 803b <int_handler+0x7dbb>
  90:	00100593          	li	a1,1
  94:	80060613          	addi	a2,a2,-2048 # 1000800 <int_handler+0x1000580>
  98:	00a68693          	addi	a3,a3,10 # 900400a <int_handler+0x9003d8a>
  9c:	00f72823          	sw	a5,16(a4)
  a0:	00b50023          	sb	a1,0(a0)
  a4:	00c787b3          	add	a5,a5,a2
  a8:	fed79ae3          	bne	a5,a3,9c <main+0x7c>
  ac:	000017b7          	lui	a5,0x1
  b0:	80078793          	addi	a5,a5,-2048 # 800 <int_handler+0x580>
  b4:	00f71023          	sh	a5,0(a4)
  b8:	00800793          	li	a5,8
  bc:	00f70123          	sb	a5,2(a4)
  c0:	03000793          	li	a5,48
  c4:	00f703a3          	sb	a5,7(a4)
  c8:	00100793          	li	a5,1
  cc:	02f70c23          	sb	a5,56(a4)
  d0:	0000006f          	j	d0 <main+0xb0>
	...

Disassembly of section except:

00000280 <int_handler>:
 280:	fe010113          	addi	sp,sp,-32 # 1fe0 <int_handler+0x1d60>
 284:	00c12e23          	sw	a2,28(sp)
 288:	00d12c23          	sw	a3,24(sp)
 28c:	00e12a23          	sw	a4,20(sp)
 290:	00f12823          	sw	a5,16(sp)
 294:	34202773          	csrr	a4,mcause
 298:	000086b7          	lui	a3,0x8
 29c:	05c6c783          	lbu	a5,92(a3) # 805c <int_handler+0x7ddc>
 2a0:	0ff7f793          	andi	a5,a5,255
 2a4:	04074463          	bltz	a4,2ec <int_handler+0x6c>
 2a8:	0017f713          	andi	a4,a5,1
 2ac:	02070263          	beqz	a4,2d0 <int_handler+0x50>
 2b0:	00100793          	li	a5,1
 2b4:	02f68ea3          	sb	a5,61(a3)
 2b8:	01c12603          	lw	a2,28(sp)
 2bc:	01812683          	lw	a3,24(sp)
 2c0:	01412703          	lw	a4,20(sp)
 2c4:	01012783          	lw	a5,16(sp)
 2c8:	02010113          	addi	sp,sp,32
 2cc:	30200073          	mret
 2d0:	0027f713          	andi	a4,a5,2
 2d4:	04071863          	bnez	a4,324 <int_handler+0xa4>
 2d8:	0047f713          	andi	a4,a5,4
 2dc:	0c070463          	beqz	a4,3a4 <int_handler+0x124>
 2e0:	00400793          	li	a5,4
 2e4:	02f68ea3          	sb	a5,61(a3)
 2e8:	fd1ff06f          	j	2b8 <int_handler+0x38>
 2ec:	00777613          	andi	a2,a4,7
 2f0:	00060663          	beqz	a2,2fc <int_handler+0x7c>
 2f4:	02000613          	li	a2,32
 2f8:	02c68ea3          	sb	a2,61(a3)
 2fc:	00b77713          	andi	a4,a4,11
 300:	fa070ce3          	beqz	a4,2b8 <int_handler+0x38>
 304:	01879713          	slli	a4,a5,0x18
 308:	41875713          	srai	a4,a4,0x18
 30c:	02074c63          	bltz	a4,344 <int_handler+0xc4>
 310:	0407f793          	andi	a5,a5,64
 314:	0a078263          	beqz	a5,3b8 <int_handler+0x138>
 318:	000087b7          	lui	a5,0x8
 31c:	0007ac23          	sw	zero,24(a5) # 8018 <int_handler+0x7d98>
 320:	f99ff06f          	j	2b8 <int_handler+0x38>
 324:	00200793          	li	a5,2
 328:	02f68ea3          	sb	a5,61(a3)
 32c:	01c12603          	lw	a2,28(sp)
 330:	01812683          	lw	a3,24(sp)
 334:	01412703          	lw	a4,20(sp)
 338:	01012783          	lw	a5,16(sp)
 33c:	02010113          	addi	sp,sp,32
 340:	30200073          	mret
 344:	000087b7          	lui	a5,0x8
 348:	0407a683          	lw	a3,64(a5) # 8040 <int_handler+0x7dc0>
 34c:	00d12423          	sw	a3,8(sp)
 350:	0447a683          	lw	a3,68(a5)
 354:	00b14703          	lbu	a4,11(sp)
 358:	00d12623          	sw	a3,12(sp)
 35c:	00100693          	li	a3,1
 360:	02d78ca3          	sb	a3,57(a5)
 364:	00200793          	li	a5,2
 368:	06071063          	bnez	a4,3c8 <int_handler+0x148>
 36c:	00f105a3          	sb	a5,11(sp)
 370:	00812703          	lw	a4,8(sp)
 374:	000087b7          	lui	a5,0x8
 378:	00100693          	li	a3,1
 37c:	00e7a023          	sw	a4,0(a5) # 8000 <int_handler+0x7d80>
 380:	00c12603          	lw	a2,12(sp)
 384:	00008737          	lui	a4,0x8
 388:	00c7a223          	sw	a2,4(a5)
 38c:	01000613          	li	a2,16
 390:	00c783a3          	sb	a2,7(a5)
 394:	04d74783          	lbu	a5,77(a4) # 804d <int_handler+0x7dcd>
 398:	fef69ee3          	bne	a3,a5,394 <int_handler+0x114>
 39c:	02d70c23          	sb	a3,56(a4)
 3a0:	f19ff06f          	j	2b8 <int_handler+0x38>
 3a4:	0087f793          	andi	a5,a5,8
 3a8:	f00788e3          	beqz	a5,2b8 <int_handler+0x38>
 3ac:	00800793          	li	a5,8
 3b0:	02f68ea3          	sb	a5,61(a3)
 3b4:	f05ff06f          	j	2b8 <int_handler+0x38>
 3b8:	000087b7          	lui	a5,0x8
 3bc:	01000713          	li	a4,16
 3c0:	02e78ea3          	sb	a4,61(a5) # 803d <int_handler+0x7dbd>
 3c4:	ef5ff06f          	j	2b8 <int_handler+0x38>
 3c8:	00300793          	li	a5,3
 3cc:	fad700e3          	beq	a4,a3,36c <int_handler+0xec>
 3d0:	ffe70713          	addi	a4,a4,-2
 3d4:	00e037b3          	snez	a5,a4
 3d8:	f95ff06f          	j	36c <int_handler+0xec>

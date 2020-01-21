
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
  20:	00008737          	lui	a4,0x8
  24:	20000793          	li	a5,512
  28:	00f72a23          	sw	a5,20(a4) # 8014 <int_handler+0x7d94>
  2c:	f9f00693          	li	a3,-97
  30:	02d70e23          	sb	a3,60(a4)
  34:	000087b7          	lui	a5,0x8
  38:	01002737          	lui	a4,0x1002
  3c:	01001637          	lui	a2,0x1001
  40:	090066b7          	lui	a3,0x9006
  44:	00a70713          	addi	a4,a4,10 # 100200a <int_handler+0x1001d8a>
  48:	03b78513          	addi	a0,a5,59 # 803b <int_handler+0x7dbb>
  4c:	00100593          	li	a1,1
  50:	80060613          	addi	a2,a2,-2048 # 1000800 <int_handler+0x1000580>
  54:	00a68693          	addi	a3,a3,10 # 900600a <int_handler+0x9005d8a>
  58:	00e7a823          	sw	a4,16(a5)
  5c:	00b50023          	sb	a1,0(a0)
  60:	00c70733          	add	a4,a4,a2
  64:	fed71ae3          	bne	a4,a3,58 <main+0x38>
  68:	00001737          	lui	a4,0x1
  6c:	80070713          	addi	a4,a4,-2048 # 800 <int_handler+0x580>
  70:	00e79023          	sh	a4,0(a5)
  74:	00800713          	li	a4,8
  78:	00e78123          	sb	a4,2(a5)
  7c:	03000713          	li	a4,48
  80:	00e783a3          	sb	a4,7(a5)
  84:	00100713          	li	a4,1
  88:	02e78c23          	sb	a4,56(a5)
  8c:	0000006f          	j	8c <main+0x6c>
	...

Disassembly of section except:

00000280 <int_handler>:
 280:	fd010113          	addi	sp,sp,-48 # 1fd0 <int_handler+0x1d50>
 284:	02b12623          	sw	a1,44(sp)
 288:	02c12423          	sw	a2,40(sp)
 28c:	02d12223          	sw	a3,36(sp)
 290:	02e12023          	sw	a4,32(sp)
 294:	00f12e23          	sw	a5,28(sp)
 298:	34202773          	csrr	a4,mcause
 29c:	000086b7          	lui	a3,0x8
 2a0:	05c6c783          	lbu	a5,92(a3) # 805c <int_handler+0x7ddc>
 2a4:	0ff7f793          	andi	a5,a5,255
 2a8:	06074063          	bltz	a4,308 <int_handler+0x88>
 2ac:	0017f713          	andi	a4,a5,1
 2b0:	02070863          	beqz	a4,2e0 <int_handler+0x60>
 2b4:	beef07b7          	lui	a5,0xbeef0
 2b8:	00f6ae23          	sw	a5,28(a3)
 2bc:	00100793          	li	a5,1
 2c0:	02f68ea3          	sb	a5,61(a3)
 2c4:	02c12583          	lw	a1,44(sp)
 2c8:	02812603          	lw	a2,40(sp)
 2cc:	02412683          	lw	a3,36(sp)
 2d0:	02012703          	lw	a4,32(sp)
 2d4:	01c12783          	lw	a5,28(sp)
 2d8:	03010113          	addi	sp,sp,48
 2dc:	30200073          	mret
 2e0:	0027f713          	andi	a4,a5,2
 2e4:	06071e63          	bnez	a4,360 <int_handler+0xe0>
 2e8:	0047f713          	andi	a4,a5,4
 2ec:	10070a63          	beqz	a4,400 <int_handler+0x180>
 2f0:	beef27b7          	lui	a5,0xbeef2
 2f4:	22278793          	addi	a5,a5,546 # beef2222 <int_handler+0xbeef1fa2>
 2f8:	00f6ae23          	sw	a5,28(a3)
 2fc:	00400793          	li	a5,4
 300:	02f68ea3          	sb	a5,61(a3)
 304:	fc1ff06f          	j	2c4 <int_handler+0x44>
 308:	00777613          	andi	a2,a4,7
 30c:	00060c63          	beqz	a2,324 <int_handler+0xa4>
 310:	deade637          	lui	a2,0xdeade
 314:	ead60613          	addi	a2,a2,-339 # deaddead <int_handler+0xdeaddc2d>
 318:	00c6ae23          	sw	a2,28(a3)
 31c:	02000613          	li	a2,32
 320:	02c68ea3          	sb	a2,61(a3)
 324:	00b77713          	andi	a4,a4,11
 328:	f8070ee3          	beqz	a4,2c4 <int_handler+0x44>
 32c:	01879713          	slli	a4,a5,0x18
 330:	41875713          	srai	a4,a4,0x18
 334:	04074e63          	bltz	a4,390 <int_handler+0x110>
 338:	0407f793          	andi	a5,a5,64
 33c:	0e078263          	beqz	a5,420 <int_handler+0x1a0>
 340:	5a5a6737          	lui	a4,0x5a5a6
 344:	000087b7          	lui	a5,0x8
 348:	a5a70713          	addi	a4,a4,-1446 # 5a5a5a5a <int_handler+0x5a5a57da>
 34c:	00e7ae23          	sw	a4,28(a5) # 801c <int_handler+0x7d9c>
 350:	0487a703          	lw	a4,72(a5)
 354:	00e7ae23          	sw	a4,28(a5)
 358:	0007ac23          	sw	zero,24(a5)
 35c:	f69ff06f          	j	2c4 <int_handler+0x44>
 360:	beef17b7          	lui	a5,0xbeef1
 364:	11178793          	addi	a5,a5,273 # beef1111 <int_handler+0xbeef0e91>
 368:	00f6ae23          	sw	a5,28(a3)
 36c:	00200793          	li	a5,2
 370:	02f68ea3          	sb	a5,61(a3)
 374:	02c12583          	lw	a1,44(sp)
 378:	02812603          	lw	a2,40(sp)
 37c:	02412683          	lw	a3,36(sp)
 380:	02012703          	lw	a4,32(sp)
 384:	01c12783          	lw	a5,28(sp)
 388:	03010113          	addi	sp,sp,48
 38c:	30200073          	mret
 390:	000087b7          	lui	a5,0x8
 394:	0547a583          	lw	a1,84(a5) # 8054 <int_handler+0x7dd4>
 398:	0407a683          	lw	a3,64(a5)
 39c:	00d12423          	sw	a3,8(sp)
 3a0:	0447a683          	lw	a3,68(a5)
 3a4:	00b14703          	lbu	a4,11(sp)
 3a8:	00d12623          	sw	a3,12(sp)
 3ac:	00100613          	li	a2,1
 3b0:	02c78ca3          	sb	a2,57(a5)
 3b4:	00200693          	li	a3,2
 3b8:	08071263          	bnez	a4,43c <int_handler+0x1bc>
 3bc:	00d105a3          	sb	a3,11(sp)
 3c0:	00812783          	lw	a5,8(sp)
 3c4:	00008637          	lui	a2,0x8
 3c8:	00008737          	lui	a4,0x8
 3cc:	00f62023          	sw	a5,0(a2) # 8000 <int_handler+0x7d80>
 3d0:	00c12783          	lw	a5,12(sp)
 3d4:	00100693          	li	a3,1
 3d8:	00f62223          	sw	a5,4(a2)
 3dc:	01000793          	li	a5,16
 3e0:	00f603a3          	sb	a5,7(a2)
 3e4:	04d74783          	lbu	a5,77(a4) # 804d <int_handler+0x7dcd>
 3e8:	fef69ee3          	bne	a3,a5,3e4 <int_handler+0x164>
 3ec:	02d70c23          	sb	a3,56(a4)
 3f0:	05472783          	lw	a5,84(a4)
 3f4:	40b787b3          	sub	a5,a5,a1
 3f8:	00f72e23          	sw	a5,28(a4)
 3fc:	ec9ff06f          	j	2c4 <int_handler+0x44>
 400:	0087f793          	andi	a5,a5,8
 404:	ec0780e3          	beqz	a5,2c4 <int_handler+0x44>
 408:	beef37b7          	lui	a5,0xbeef3
 40c:	33378793          	addi	a5,a5,819 # beef3333 <int_handler+0xbeef30b3>
 410:	00f6ae23          	sw	a5,28(a3)
 414:	00800793          	li	a5,8
 418:	02f68ea3          	sb	a5,61(a3)
 41c:	ea9ff06f          	j	2c4 <int_handler+0x44>
 420:	3b3b47b7          	lui	a5,0x3b3b4
 424:	00008737          	lui	a4,0x8
 428:	b3b78793          	addi	a5,a5,-1221 # 3b3b3b3b <int_handler+0x3b3b38bb>
 42c:	00f72e23          	sw	a5,28(a4) # 801c <int_handler+0x7d9c>
 430:	01000793          	li	a5,16
 434:	02f70ea3          	sb	a5,61(a4)
 438:	e8dff06f          	j	2c4 <int_handler+0x44>
 43c:	00300693          	li	a3,3
 440:	f6c70ee3          	beq	a4,a2,3bc <int_handler+0x13c>
 444:	ffe70713          	addi	a4,a4,-2
 448:	00e036b3          	snez	a3,a4
 44c:	f71ff06f          	j	3bc <int_handler+0x13c>

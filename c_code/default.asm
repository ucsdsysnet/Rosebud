
default.o:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00002137          	lui	sp,0x2
   4:	00001537          	lui	a0,0x1
   8:	88050513          	addi	a0,a0,-1920 # 880 <int_handler+0x680>
   c:	30451073          	csrw	mie,a0
  10:	00002537          	lui	a0,0x2
  14:	80850513          	addi	a0,a0,-2040 # 1808 <int_handler+0x1608>
  18:	30051073          	csrw	mstatus,a0
  1c:	004000ef          	jal	ra,20 <main>

00000020 <main>:
  20:	00008737          	lui	a4,0x8
  24:	20000793          	li	a5,512
  28:	00f72a23          	sw	a5,20(a4) # 8014 <int_handler+0x7e14>
  2c:	f9f00693          	li	a3,-97
  30:	02d70e23          	sb	a3,60(a4)
  34:	000087b7          	lui	a5,0x8
  38:	01002737          	lui	a4,0x1002
  3c:	01001637          	lui	a2,0x1001
  40:	090066b7          	lui	a3,0x9006
  44:	00a70713          	addi	a4,a4,10 # 100200a <int_handler+0x1001e0a>
  48:	03b78513          	addi	a0,a5,59 # 803b <int_handler+0x7e3b>
  4c:	00100593          	li	a1,1
  50:	80060613          	addi	a2,a2,-2048 # 1000800 <int_handler+0x1000600>
  54:	00a68693          	addi	a3,a3,10 # 900600a <int_handler+0x9005e0a>
  58:	00e7a823          	sw	a4,16(a5)
  5c:	00b50023          	sb	a1,0(a0)
  60:	00c70733          	add	a4,a4,a2
  64:	fed71ae3          	bne	a4,a3,58 <main+0x38>
  68:	00001737          	lui	a4,0x1
  6c:	80070713          	addi	a4,a4,-2048 # 800 <int_handler+0x600>
  70:	00e7a023          	sw	a4,0(a5)
  74:	00800713          	li	a4,8
  78:	00e78123          	sb	a4,2(a5)
  7c:	30000737          	lui	a4,0x30000
  80:	00e7a223          	sw	a4,4(a5)
  84:	00100713          	li	a4,1
  88:	02e78c23          	sb	a4,56(a5)
  8c:	0000006f          	j	8c <main+0x6c>
	...

Disassembly of section except:

00000200 <int_handler>:
 200:	fe010113          	addi	sp,sp,-32 # 1fe0 <int_handler+0x1de0>
 204:	00a12e23          	sw	a0,28(sp)
 208:	00b12c23          	sw	a1,24(sp)
 20c:	00c12a23          	sw	a2,20(sp)
 210:	00d12823          	sw	a3,16(sp)
 214:	00e12623          	sw	a4,12(sp)
 218:	00f12423          	sw	a5,8(sp)
 21c:	01012223          	sw	a6,4(sp)
 220:	01112023          	sw	a7,0(sp)
 224:	34202773          	csrr	a4,mcause
 228:	000086b7          	lui	a3,0x8
 22c:	05c6c783          	lbu	a5,92(a3) # 805c <int_handler+0x7e5c>
 230:	0ff7f793          	andi	a5,a5,255
 234:	06074663          	bltz	a4,2a0 <int_handler+0xa0>
 238:	0017f713          	andi	a4,a5,1
 23c:	02070e63          	beqz	a4,278 <int_handler+0x78>
 240:	beef07b7          	lui	a5,0xbeef0
 244:	00f6ae23          	sw	a5,28(a3)
 248:	00100793          	li	a5,1
 24c:	02f68ea3          	sb	a5,61(a3)
 250:	01c12503          	lw	a0,28(sp)
 254:	01812583          	lw	a1,24(sp)
 258:	01412603          	lw	a2,20(sp)
 25c:	01012683          	lw	a3,16(sp)
 260:	00c12703          	lw	a4,12(sp)
 264:	00812783          	lw	a5,8(sp)
 268:	00412803          	lw	a6,4(sp)
 26c:	00012883          	lw	a7,0(sp)
 270:	02010113          	addi	sp,sp,32
 274:	30200073          	mret
 278:	0027f713          	andi	a4,a5,2
 27c:	06071e63          	bnez	a4,2f8 <int_handler+0xf8>
 280:	0047f713          	andi	a4,a5,4
 284:	0e070a63          	beqz	a4,378 <int_handler+0x178>
 288:	beef27b7          	lui	a5,0xbeef2
 28c:	22278793          	addi	a5,a5,546 # beef2222 <int_handler+0xbeef2022>
 290:	00f6ae23          	sw	a5,28(a3)
 294:	00400793          	li	a5,4
 298:	02f68ea3          	sb	a5,61(a3)
 29c:	fb5ff06f          	j	250 <int_handler+0x50>
 2a0:	00777613          	andi	a2,a4,7
 2a4:	00060c63          	beqz	a2,2bc <int_handler+0xbc>
 2a8:	deade637          	lui	a2,0xdeade
 2ac:	ead60613          	addi	a2,a2,-339 # deaddead <int_handler+0xdeaddcad>
 2b0:	00c6ae23          	sw	a2,28(a3)
 2b4:	02000613          	li	a2,32
 2b8:	02c68ea3          	sb	a2,61(a3)
 2bc:	00b77713          	andi	a4,a4,11
 2c0:	f80708e3          	beqz	a4,250 <int_handler+0x50>
 2c4:	01879713          	slli	a4,a5,0x18
 2c8:	41875713          	srai	a4,a4,0x18
 2cc:	04074263          	bltz	a4,310 <int_handler+0x110>
 2d0:	0407f793          	andi	a5,a5,64
 2d4:	0c078263          	beqz	a5,398 <int_handler+0x198>
 2d8:	5a5a6737          	lui	a4,0x5a5a6
 2dc:	000087b7          	lui	a5,0x8
 2e0:	a5a70713          	addi	a4,a4,-1446 # 5a5a5a5a <int_handler+0x5a5a585a>
 2e4:	00e7ae23          	sw	a4,28(a5) # 801c <int_handler+0x7e1c>
 2e8:	0487a703          	lw	a4,72(a5)
 2ec:	00e7ae23          	sw	a4,28(a5)
 2f0:	0007ac23          	sw	zero,24(a5)
 2f4:	f5dff06f          	j	250 <int_handler+0x50>
 2f8:	beef17b7          	lui	a5,0xbeef1
 2fc:	11178793          	addi	a5,a5,273 # beef1111 <int_handler+0xbeef0f11>
 300:	00f6ae23          	sw	a5,28(a3)
 304:	00200793          	li	a5,2
 308:	02f68ea3          	sb	a5,61(a3)
 30c:	f45ff06f          	j	250 <int_handler+0x50>
 310:	000087b7          	lui	a5,0x8
 314:	0547a583          	lw	a1,84(a5) # 8054 <int_handler+0x7e54>
 318:	0407d883          	lhu	a7,64(a5)
 31c:	0427c503          	lbu	a0,66(a5)
 320:	0437c703          	lbu	a4,67(a5)
 324:	0447a803          	lw	a6,68(a5)
 328:	00100613          	li	a2,1
 32c:	02c78ca3          	sb	a2,57(a5)
 330:	00200693          	li	a3,2
 334:	08071063          	bnez	a4,3b4 <int_handler+0x1b4>
 338:	000087b7          	lui	a5,0x8
 33c:	0117a023          	sw	a7,0(a5) # 8000 <int_handler+0x7e00>
 340:	01000713          	li	a4,16
 344:	0107a223          	sw	a6,4(a5)
 348:	00d781a3          	sb	a3,3(a5)
 34c:	00e783a3          	sb	a4,7(a5)
 350:	00a78123          	sb	a0,2(a5)
 354:	00008737          	lui	a4,0x8
 358:	00100693          	li	a3,1
 35c:	04d74783          	lbu	a5,77(a4) # 804d <int_handler+0x7e4d>
 360:	fef69ee3          	bne	a3,a5,35c <int_handler+0x15c>
 364:	02d70c23          	sb	a3,56(a4)
 368:	05472783          	lw	a5,84(a4)
 36c:	40b787b3          	sub	a5,a5,a1
 370:	00f72e23          	sw	a5,28(a4)
 374:	eddff06f          	j	250 <int_handler+0x50>
 378:	0087f793          	andi	a5,a5,8
 37c:	ec078ae3          	beqz	a5,250 <int_handler+0x50>
 380:	beef37b7          	lui	a5,0xbeef3
 384:	33378793          	addi	a5,a5,819 # beef3333 <int_handler+0xbeef3133>
 388:	00f6ae23          	sw	a5,28(a3)
 38c:	00800793          	li	a5,8
 390:	02f68ea3          	sb	a5,61(a3)
 394:	ebdff06f          	j	250 <int_handler+0x50>
 398:	3b3b47b7          	lui	a5,0x3b3b4
 39c:	00008737          	lui	a4,0x8
 3a0:	b3b78793          	addi	a5,a5,-1221 # 3b3b3b3b <int_handler+0x3b3b393b>
 3a4:	00f72e23          	sw	a5,28(a4) # 801c <int_handler+0x7e1c>
 3a8:	01000793          	li	a5,16
 3ac:	02f70ea3          	sb	a5,61(a4)
 3b0:	ea1ff06f          	j	250 <int_handler+0x50>
 3b4:	00300693          	li	a3,3
 3b8:	f8c700e3          	beq	a4,a2,338 <int_handler+0x138>
 3bc:	ffe70713          	addi	a4,a4,-2
 3c0:	00e036b3          	snez	a3,a4
 3c4:	f75ff06f          	j	338 <int_handler+0x138>


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
 220:	34202773          	csrr	a4,mcause
 224:	000086b7          	lui	a3,0x8
 228:	05c6c783          	lbu	a5,92(a3) # 805c <int_handler+0x7e5c>
 22c:	0ff7f793          	andi	a5,a5,255
 230:	06074463          	bltz	a4,298 <int_handler+0x98>
 234:	0017f713          	andi	a4,a5,1
 238:	02070c63          	beqz	a4,270 <int_handler+0x70>
 23c:	beef07b7          	lui	a5,0xbeef0
 240:	00f6ae23          	sw	a5,28(a3)
 244:	00100793          	li	a5,1
 248:	02f68ea3          	sb	a5,61(a3)
 24c:	01c12503          	lw	a0,28(sp)
 250:	01812583          	lw	a1,24(sp)
 254:	01412603          	lw	a2,20(sp)
 258:	01012683          	lw	a3,16(sp)
 25c:	00c12703          	lw	a4,12(sp)
 260:	00812783          	lw	a5,8(sp)
 264:	00412803          	lw	a6,4(sp)
 268:	02010113          	addi	sp,sp,32
 26c:	30200073          	mret
 270:	0027f713          	andi	a4,a5,2
 274:	06071e63          	bnez	a4,2f0 <int_handler+0xf0>
 278:	0047f713          	andi	a4,a5,4
 27c:	0e070663          	beqz	a4,368 <int_handler+0x168>
 280:	beef27b7          	lui	a5,0xbeef2
 284:	22278793          	addi	a5,a5,546 # beef2222 <int_handler+0xbeef2022>
 288:	00f6ae23          	sw	a5,28(a3)
 28c:	00400793          	li	a5,4
 290:	02f68ea3          	sb	a5,61(a3)
 294:	fb9ff06f          	j	24c <int_handler+0x4c>
 298:	00777613          	andi	a2,a4,7
 29c:	00060c63          	beqz	a2,2b4 <int_handler+0xb4>
 2a0:	deade637          	lui	a2,0xdeade
 2a4:	ead60613          	addi	a2,a2,-339 # deaddead <int_handler+0xdeaddcad>
 2a8:	00c6ae23          	sw	a2,28(a3)
 2ac:	02000613          	li	a2,32
 2b0:	02c68ea3          	sb	a2,61(a3)
 2b4:	00b77713          	andi	a4,a4,11
 2b8:	f8070ae3          	beqz	a4,24c <int_handler+0x4c>
 2bc:	01879713          	slli	a4,a5,0x18
 2c0:	41875713          	srai	a4,a4,0x18
 2c4:	04074263          	bltz	a4,308 <int_handler+0x108>
 2c8:	0407f793          	andi	a5,a5,64
 2cc:	0a078e63          	beqz	a5,388 <int_handler+0x188>
 2d0:	5a5a6737          	lui	a4,0x5a5a6
 2d4:	000087b7          	lui	a5,0x8
 2d8:	a5a70713          	addi	a4,a4,-1446 # 5a5a5a5a <int_handler+0x5a5a585a>
 2dc:	00e7ae23          	sw	a4,28(a5) # 801c <int_handler+0x7e1c>
 2e0:	0487a703          	lw	a4,72(a5)
 2e4:	00e7ae23          	sw	a4,28(a5)
 2e8:	0007ac23          	sw	zero,24(a5)
 2ec:	f61ff06f          	j	24c <int_handler+0x4c>
 2f0:	beef17b7          	lui	a5,0xbeef1
 2f4:	11178793          	addi	a5,a5,273 # beef1111 <int_handler+0xbeef0f11>
 2f8:	00f6ae23          	sw	a5,28(a3)
 2fc:	00200793          	li	a5,2
 300:	02f68ea3          	sb	a5,61(a3)
 304:	f49ff06f          	j	24c <int_handler+0x4c>
 308:	000087b7          	lui	a5,0x8
 30c:	0547a603          	lw	a2,84(a5) # 8054 <int_handler+0x7e54>
 310:	0407d503          	lhu	a0,64(a5)
 314:	0427c683          	lbu	a3,66(a5)
 318:	0437c703          	lbu	a4,67(a5)
 31c:	0447a583          	lw	a1,68(a5)
 320:	00100813          	li	a6,1
 324:	03078ca3          	sb	a6,57(a5)
 328:	00a7a023          	sw	a0,0(a5)
 32c:	00173713          	seqz	a4,a4
 330:	00b7a223          	sw	a1,4(a5)
 334:	00e781a3          	sb	a4,3(a5)
 338:	01000713          	li	a4,16
 33c:	00d78123          	sb	a3,2(a5)
 340:	00e783a3          	sb	a4,7(a5)
 344:	00100693          	li	a3,1
 348:	00008737          	lui	a4,0x8
 34c:	04d74783          	lbu	a5,77(a4) # 804d <int_handler+0x7e4d>
 350:	fef69ee3          	bne	a3,a5,34c <int_handler+0x14c>
 354:	02d70c23          	sb	a3,56(a4)
 358:	05472783          	lw	a5,84(a4)
 35c:	40c787b3          	sub	a5,a5,a2
 360:	00f72e23          	sw	a5,28(a4)
 364:	ee9ff06f          	j	24c <int_handler+0x4c>
 368:	0087f793          	andi	a5,a5,8
 36c:	ee0780e3          	beqz	a5,24c <int_handler+0x4c>
 370:	beef37b7          	lui	a5,0xbeef3
 374:	33378793          	addi	a5,a5,819 # beef3333 <int_handler+0xbeef3133>
 378:	00f6ae23          	sw	a5,28(a3)
 37c:	00800793          	li	a5,8
 380:	02f68ea3          	sb	a5,61(a3)
 384:	ec9ff06f          	j	24c <int_handler+0x4c>
 388:	3b3b47b7          	lui	a5,0x3b3b4
 38c:	00008737          	lui	a4,0x8
 390:	b3b78793          	addi	a5,a5,-1221 # 3b3b3b3b <int_handler+0x3b3b393b>
 394:	00f72e23          	sw	a5,28(a4) # 801c <int_handler+0x7e1c>
 398:	01000793          	li	a5,16
 39c:	02f70ea3          	sb	a5,61(a4)
 3a0:	eadff06f          	j	24c <int_handler+0x4c>

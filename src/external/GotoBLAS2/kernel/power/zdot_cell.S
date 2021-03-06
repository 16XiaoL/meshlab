/*********************************************************************/
/*                                                                   */
/*             Optimized BLAS libraries                              */
/*                     By Kazushige Goto <kgoto@tacc.utexas.edu>     */
/*                                                                   */
/* Copyright (c) The University of Texas, 2009. All rights reserved. */
/* UNIVERSITY EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES CONCERNING  */
/* THIS SOFTWARE AND DOCUMENTATION, INCLUDING ANY WARRANTIES OF      */
/* MERCHANTABILITY, FITNESS FOR ANY PARTICULAR PURPOSE,              */
/* NON-INFRINGEMENT AND WARRANTIES OF PERFORMANCE, AND ANY WARRANTY  */
/* THAT MIGHT OTHERWISE ARISE FROM COURSE OF DEALING OR USAGE OF     */
/* TRADE. NO WARRANTY IS EITHER EXPRESS OR IMPLIED WITH RESPECT TO   */
/* THE USE OF THE SOFTWARE OR DOCUMENTATION.                         */
/* Under no circumstances shall University be liable for incidental, */
/* special, indirect, direct or consequential damages or loss of     */
/* profits, interruption of business, or related expenses which may  */
/* arise from use of Software or Documentation, including but not    */
/* limited to those resulting from defects in Software and/or        */
/* Documentation, or loss or inaccuracy of data of any kind.         */
/*********************************************************************/

#define ASSEMBLER
#include "common.h"
	
#if defined(F_INTERFACE) && defined(F_INTERFACE_F2C)
#define RESULT	r3
#define N	r4
#define X	r5
#define INCX	r6	
#define Y	r7
#define INCY	r8
#define PREA	r9
#else
#define N	r3
#define X	r4
#define INCX	r5	
#define Y	r6
#define INCY	r7
#define PREA	r8
#endif

#define INCXM1	r10
#define INCYM1	r11

#define FZERO	f0

#define STACKSIZE 160

	PROLOGUE
	PROFCODE

	addi	SP, SP, -STACKSIZE
	li	r0,   0

	stfd	f14,    0(SP)
	stfd	f15,    8(SP)
	stfd	f16,   16(SP)
	stfd	f17,   24(SP)

	stfd	f18,   32(SP)
	stfd	f19,   40(SP)
	stfd	f20,   48(SP)
	stfd	f21,   56(SP)

	stfd	f22,   64(SP)
	stfd	f23,   72(SP)
	stfd	f24,   80(SP)
	stfd	f25,   88(SP)

	stfd	f26,   96(SP)
	stfd	f27,  104(SP)
	stfd	f28,  112(SP)
	stfd	f29,  120(SP)

	stfd	f30,  128(SP)
	stfd	f31,  136(SP)

	stw	r0,   144(SP)
	lfs	FZERO,144(SP)

#ifdef F_INTERFACE
	LDINT	N,    0(N)
	LDINT	INCX, 0(INCX)
	LDINT	INCY, 0(INCY)
#endif

	slwi	INCX, INCX, ZBASE_SHIFT
	slwi	INCY, INCY, ZBASE_SHIFT

	subi	INCXM1, INCX, SIZE
	subi	INCYM1, INCY, SIZE

	fmr	f1,  FZERO
	fmr	f2,  FZERO
	fmr	f3,  FZERO
	fmr	f4,  FZERO
	fmr	f5,  FZERO
	fmr	f6,  FZERO
	fmr	f7,  FZERO

	fmr	f24,  FZERO
	fmr	f25,  FZERO
	fmr	f26,  FZERO
	fmr	f27,  FZERO
	fmr	f28,  FZERO
	fmr	f29,  FZERO
	fmr	f30,  FZERO
	fmr	f31,  FZERO

	li	PREA, 16 * 10 * SIZE

	cmpwi	cr0, N, 0
	ble-	LL(999)

	cmpwi	cr0, INCX, 2 * SIZE
	bne-	cr0, LL(100)
	cmpwi	cr0, INCY, 2 * SIZE
	bne-	cr0, LL(100)

	srawi.	r0, N, 3
	mtspr	CTR, r0
	beq-	cr0, LL(50)
	.align 4

	LFD	f8,     0 * SIZE(X)
	LFD	f9,     1 * SIZE(X)
	LFD	f10,    2 * SIZE(X)
	LFD	f11,    3 * SIZE(X)

	LFD	f16,    0 * SIZE(Y)
	LFD	f17,    1 * SIZE(Y)
	LFD	f18,    2 * SIZE(Y)
	LFD	f19,    3 * SIZE(Y)

	LFD	f12,    4 * SIZE(X)
	LFD	f13,    5 * SIZE(X)
	LFD	f14,    6 * SIZE(X)
	LFD	f15,    7 * SIZE(X)

	LFD	f20,    4 * SIZE(Y)
	LFD	f21,    5 * SIZE(Y)
	LFD	f23,    7 * SIZE(Y)
	bdz	LL(20)
	.align 4

LL(10):
	FMADD	f0, f8,  f16,  f0
	LFD	f22,   6 * SIZE(Y)
	FMADD	f3, f8,  f17,  f3
	LFD	f8,    8 * SIZE(X)
	FMADD	f1, f9,  f17,  f1
	LFD	f17,   9 * SIZE(Y)
	FMADD	f2, f9,  f16,  f2
	LFD	f9,    9 * SIZE(X)

	FMADD	f4, f10, f18,  f4
	LFD	f16,   8 * SIZE(Y)
	FMADD	f7, f10, f19,  f7
	LFD	f10,  10 * SIZE(X)
	FMADD	f5, f11, f19,  f5
	LFD	f19,  11 * SIZE(Y)
	FMADD	f6, f11, f18,  f6
	LFD	f11,  11 * SIZE(X)


	FMADD	f24, f12, f20,  f24
	LFD	f18,  10 * SIZE(Y)
	FMADD	f27, f12, f21,  f27
	LFD	f12,  12 * SIZE(X)
	FMADD	f25, f13, f21,  f25
	LFD	f21,  13 * SIZE(Y)
	FMADD	f26, f13, f20,  f26
	LFD	f13,  13 * SIZE(X)

	FMADD	f28, f14, f22,  f28
	LFD	f20,  12 * SIZE(Y)
	FMADD	f31, f14, f23,  f31
	LFD	f14,  14 * SIZE(X)
	FMADD	f29, f15, f23,  f29
	LFD	f23,  15 * SIZE(Y)
	FMADD	f30, f15, f22,  f30
	LFD	f15,  15 * SIZE(X)

	FMADD	f0, f8,  f16,  f0
	LFD	f22,  14 * SIZE(Y)
	FMADD	f3, f8,  f17,  f3
	LFD	f8,   16 * SIZE(X)
	FMADD	f1, f9,  f17,  f1
	LFD	f17,  17 * SIZE(Y)
	FMADD	f2, f9,  f16,  f2
	LFD	f9,   17 * SIZE(X)

	FMADD	f4, f10, f18,  f4
	LFD	f16,  16 * SIZE(Y)
	FMADD	f7, f10, f19,  f7
	LFD	f10,  18 * SIZE(X)
	FMADD	f5, f11, f19,  f5
	LFD	f19,  19 * SIZE(Y)
	FMADD	f6, f11, f18,  f6
	LFD	f11,  19 * SIZE(X)

	FMADD	f24, f12, f20,  f24
	LFD	f18,  18 * SIZE(Y)
	FMADD	f27, f12, f21,  f27
	LFD	f12,   20 * SIZE(X)
	FMADD	f25, f13, f21,  f25
	LFD	f21,   21 * SIZE(Y)
	FMADD	f26, f13, f20,  f26
	LFD	f13,   21 * SIZE(X)

	FMADD	f28, f14, f22,  f28
	LFD	f20,   20 * SIZE(Y)
	FMADD	f31, f14, f23,  f31
	LFD	f14,   22 * SIZE(X)
	FMADD	f29, f15, f23,  f29
	LFD	f23,   23 * SIZE(Y)
	FMADD	f30, f15, f22,  f30
	LFD	f15,   23 * SIZE(X)

	dcbt	X, PREA
	addi	X, X, 16 * SIZE
	dcbt	Y, PREA
	addi	Y, Y, 16 * SIZE
	bdnz	LL(10)
	.align 4

LL(20):
	FMADD	f0, f8,  f16,  f0
	LFD	f22,    6 * SIZE(Y)
	FMADD	f3, f8,  f17,  f3
	LFD	f8,    8 * SIZE(X)
	FMADD	f1, f9,  f17,  f1
	LFD	f17,   9 * SIZE(Y)
	FMADD	f2, f9,  f16,  f2
	LFD	f9,    9 * SIZE(X)

	FMADD	f4, f10, f18,  f4
	LFD	f16,   8 * SIZE(Y)
	FMADD	f7, f10, f19,  f7
	LFD	f10,  10 * SIZE(X)
	FMADD	f5, f11, f19,  f5
	LFD	f19,  11 * SIZE(Y)
	FMADD	f6, f11, f18,  f6
	LFD	f11,  11 * SIZE(X)

	FMADD	f24, f12, f20,  f24
	LFD	f18,  10 * SIZE(Y)
	FMADD	f27, f12, f21,  f27
	LFD	f12,  12 * SIZE(X)
	FMADD	f25, f13, f21,  f25
	LFD	f21,  13 * SIZE(Y)
	FMADD	f26, f13, f20,  f26
	LFD	f13,  13 * SIZE(X)

	FMADD	f28, f14, f22,  f28
	LFD	f20,  12 * SIZE(Y)
	FMADD	f31, f14, f23,  f31
	LFD	f14,  14 * SIZE(X)
	FMADD	f29, f15, f23,  f29
	LFD	f23,  15 * SIZE(Y)
	FMADD	f30, f15, f22,  f30
	LFD	f15,  15 * SIZE(X)

	FMADD	f0, f8,  f16,  f0
	LFD	f22,  14 * SIZE(Y)
	FMADD	f3, f8,  f17,  f3
	addi	X, X, 16 * SIZE
	FMADD	f1, f9,  f17,  f1
	addi	Y, Y, 16 * SIZE
	FMADD	f2, f9,  f16,  f2
	nop
	
	FMADD	f4, f10, f18,  f4
	FMADD	f7, f10, f19,  f7
	FMADD	f5, f11, f19,  f5
	FMADD	f6, f11, f18,  f6

	FMADD	f24, f12, f20,  f24
	FMADD	f27, f12, f21,  f27
	FMADD	f25, f13, f21,  f25
	FMADD	f26, f13, f20,  f26

	FMADD	f28, f14, f22,  f28
	FMADD	f31, f14, f23,  f31
	FMADD	f29, f15, f23,  f29
	FMADD	f30, f15, f22,  f30
	.align 4

LL(50):
	andi.	r0,  N, 7
	mtspr	CTR, r0
	beq	LL(999)
	.align 4

LL(60):
	LFD	f8,  0 * SIZE(X)
	LFD	f9,  1 * SIZE(X)
	LFD	f16, 0 * SIZE(Y)
	LFD	f17, 1 * SIZE(Y)

	addi	X, X,  2 * SIZE
	addi	Y, Y,  2 * SIZE

	FMADD	f0, f8,  f16,  f0
	FMADD	f3, f8,  f17,  f3
	FMADD	f1, f9,  f17,  f1
	FMADD	f2, f9,  f16,  f2

	bdnz	LL(60)
	b	LL(999)
	.align 4

LL(100):
#ifdef F_INTERFACE
	cmpwi	cr0, INCX, 0
	bge+	LL(102)

	subi	r0, N, 1
	mullw	r0, r0, INCX
	sub	X, X, r0
	.align 4

LL(102):
	cmpwi	cr0, INCY, 0
	bge+	LL(104)

	subi	r0, N, 1
	mullw	r0, r0, INCY
	sub	Y, Y, r0
	.align 4

LL(104):
#endif
	sub	X, X, INCXM1
	sub	Y, Y, INCYM1

	srawi.	r0, N, 3
	mtspr	CTR,  r0
	beq-	LL(150)

	LFDX	f8,   X, INCXM1
	LFDX	f16,  Y, INCYM1
	LFDUX	f9,   X, INCX
	LFDUX	f17,  Y, INCY

	LFDX	f10,  X, INCXM1
	LFDX	f18,  Y, INCYM1
	LFDUX	f11,  X, INCX
	LFDUX	f19,  Y, INCY

	LFDX	f12,   X, INCXM1
	LFDX	f20,   Y, INCYM1
	LFDUX	f13,   X, INCX
	LFDUX	f21,   Y, INCY

	LFDX	f14,   X, INCXM1
	LFDUX	f15,   X, INCX
	bdz	LL(120)
	.align 4

LL(110):
	FMADD	f0, f8,  f16,  f0
	LFDX	f22,   Y, INCYM1
	FMADD	f3, f8,  f17,  f3
	LFDX	f8,   X, INCXM1
	FMADD	f1, f9,  f17,  f1
	LFDUX	f23,   Y, INCY
	FMADD	f2, f9,  f16,  f2
	LFDUX	f9,   X, INCX

	FMADD	f4, f10, f18,  f4
	LFDX	f16,  Y, INCYM1
	FMADD	f7, f10, f19,  f7
	LFDX	f10,  X, INCXM1
	FMADD	f5, f11, f19,  f5
	LFDUX	f17,  Y, INCY
	FMADD	f6, f11, f18,  f6
	LFDUX	f11,  X, INCX

	FMADD	f24, f12, f20,  f24
	LFDX	f18,  Y, INCYM1
	FMADD	f27, f12, f21,  f27
	LFDX	f12,   X, INCXM1
	FMADD	f25, f13, f21,  f25
	LFDUX	f19,  Y, INCY
	FMADD	f26, f13, f20,  f26
	LFDUX	f13,   X, INCX

	FMADD	f28, f14, f22,  f28
	LFDX	f20,   Y, INCYM1
	FMADD	f31, f14, f23,  f31
	LFDX	f14,   X, INCXM1
	FMADD	f29, f15, f23,  f29
	LFDUX	f21,   Y, INCY
	FMADD	f30, f15, f22,  f30
	LFDUX	f15,   X, INCX

	FMADD	f0, f8,  f16,  f0
	LFDX	f22,   Y, INCYM1
	FMADD	f3, f8,  f17,  f3
	LFDX	f8,    X, INCXM1
	FMADD	f1, f9,  f17,  f1
	LFDUX	f23,   Y, INCY
	FMADD	f2, f9,  f16,  f2
	LFDUX	f9,    X, INCX

	FMADD	f4, f10, f18,  f4
	LFDX	f16,  Y, INCYM1
	FMADD	f7, f10, f19,  f7
	LFDX	f10,  X, INCXM1
	FMADD	f5, f11, f19,  f5
	LFDUX	f17,  Y, INCY
	FMADD	f6, f11, f18,  f6
	LFDUX	f11,  X, INCX

	FMADD	f24, f12, f20,  f24
	LFDX	f18,  Y, INCYM1
	FMADD	f27, f12, f21,  f27
	LFDX	f12,   X, INCXM1
	FMADD	f25, f13, f21,  f25
	LFDUX	f19,  Y, INCY
	FMADD	f26, f13, f20,  f26
	LFDUX	f13,   X, INCX

	FMADD	f28, f14, f22,  f28
	LFDX	f20,   Y, INCYM1
	FMADD	f31, f14, f23,  f31
	LFDX	f14,   X, INCXM1
	FMADD	f29, f15, f23,  f29
	LFDUX	f21,   Y, INCY
	FMADD	f30, f15, f22,  f30
	LFDUX	f15,   X, INCX

	bdnz	LL(110)
	.align 4

LL(120):
	FMADD	f0, f8,  f16,  f0
	LFDX	f22,   Y, INCYM1
	FMADD	f3, f8,  f17,  f3
	LFDX	f8,   X, INCXM1
	FMADD	f1, f9,  f17,  f1
	LFDUX	f23,   Y, INCY
	FMADD	f2, f9,  f16,  f2
	LFDUX	f9,   X, INCX

	FMADD	f4, f10, f18,  f4
	LFDX	f16,  Y, INCYM1
	FMADD	f7, f10, f19,  f7
	LFDX	f10,  X, INCXM1
	FMADD	f5, f11, f19,  f5
	LFDUX	f17,  Y, INCY
	FMADD	f6, f11, f18,  f6
	LFDUX	f11,  X, INCX

	FMADD	f24, f12, f20,  f24
	LFDX	f18,  Y, INCYM1
	FMADD	f27, f12, f21,  f27
	LFDX	f12,   X, INCXM1
	FMADD	f25, f13, f21,  f25
	LFDUX	f19,  Y, INCY
	FMADD	f26, f13, f20,  f26
	LFDUX	f13,   X, INCX

	FMADD	f28, f14, f22,  f28
	LFDX	f20,   Y, INCYM1
	FMADD	f31, f14, f23,  f31
	LFDX	f14,   X, INCXM1
	FMADD	f29, f15, f23,  f29
	LFDUX	f21,   Y, INCY
	FMADD	f30, f15, f22,  f30
	LFDUX	f15,   X, INCX

	FMADD	f0, f8,  f16,  f0
	LFDX	f22,   Y, INCYM1
	FMADD	f3, f8,  f17,  f3
	LFDUX	f23,   Y, INCY
	FMADD	f1, f9,  f17,  f1
	FMADD	f2, f9,  f16,  f2

	FMADD	f4, f10, f18,  f4
	FMADD	f7, f10, f19,  f7
	FMADD	f5, f11, f19,  f5
	FMADD	f6, f11, f18,  f6

	FMADD	f24, f12, f20,  f24
	FMADD	f27, f12, f21,  f27
	FMADD	f25, f13, f21,  f25
	FMADD	f26, f13, f20,  f26

	FMADD	f28, f14, f22,  f28
	FMADD	f31, f14, f23,  f31
	FMADD	f29, f15, f23,  f29
	FMADD	f30, f15, f22,  f30
	.align 4

LL(150):
	andi.	r0,  N, 7
	mtspr	CTR, r0
	beq	LL(999)
	.align 4

LL(160):
	LFDX	f8,    X, INCXM1
	LFDUX	f9,    X, INCX
	LFDX	f16,   Y, INCYM1
	LFDUX	f17,   Y, INCY

	FMADD	f0, f8,  f16,  f0
	FMADD	f3, f8,  f17,  f3
	FMADD	f1, f9,  f17,  f1
	FMADD	f2, f9,  f16,  f2
	bdnz	LL(160)
	.align 4

LL(999):
	FADD	f0, f0, f4
	FADD	f1, f1, f5
	FADD	f2, f2, f6
	FADD	f3, f3, f7

	FADD	f24, f28, f24
	FADD	f25, f29, f25
	FADD	f26, f30, f26
	FADD	f27, f31, f27

	FADD	f0, f0, f24
	FADD	f1, f1, f25
	FADD	f2, f2, f26
	FADD	f3, f3, f27

#ifndef CONJ
	FSUB	f1,  f0,  f1
	FADD	f2,  f2,  f3
#else
	FADD	f1,  f0,  f1
	FSUB	f2,  f3,  f2
#endif

#if defined(F_INTERFACE) && defined(F_INTERFACE_F2C)
	STFD	f1,    0 * SIZE(RESULT)
	STFD	f2,    1 * SIZE(RESULT)
#endif

#if defined(F_INTERFACE) && defined(F_INTERFACE_GFORT)
#ifndef __64BIT__
#ifndef DOUBLE
	stfs	f1,   144(SP)
	stfs	f2,   148(SP)
	lwz	r3,   144(SP)
	lwz	r4,   148(SP)
#else
	stfd	f1,   144(SP)
	stfd	f2,   152(SP)
	lwz	r3,   144(SP)
	lwz	r4,   148(SP)
	lwz	r5,   152(SP)
	lwz	r6,   156(SP)
#endif
#else
#ifndef DOUBLE
	stfs	f1,   144(SP)
	stfs	f2,   148(SP)
	ld	r3,   144(SP)
#else
	stfd	f1,   144(SP)
	stfd	f2,   152(SP)
	ld	r3,   144(SP)
	ld	r4,   152(SP)
#endif
#endif
#endif

	lfd	f14,    0(SP)
	lfd	f15,    8(SP)
	lfd	f16,   16(SP)
	lfd	f17,   24(SP)

	lfd	f18,   32(SP)
	lfd	f19,   40(SP)
	lfd	f20,   48(SP)
	lfd	f21,   56(SP)

	lfd	f22,   64(SP)
	lfd	f23,   72(SP)
	lfd	f24,   80(SP)
	lfd	f25,   88(SP)

	lfd	f26,   96(SP)
	lfd	f27,  104(SP)
	lfd	f28,  112(SP)
	lfd	f29,  120(SP)

	lfd	f30,  128(SP)
	lfd	f31,  136(SP)

	addi	SP, SP, STACKSIZE
	blr

	EPILOGUE

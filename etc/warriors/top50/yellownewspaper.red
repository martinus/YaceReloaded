;redcode-94nop
;author inversed
;name Yellowed Newspaper
;strategy Paper/Stone
;strategy With Paperone-style paper
;assert (CORESIZE==8000) && (MAXPROCESSES==8000)

;-------Paper--------
ofs	equ	219
bofs1	equ	1336
bofs2	equ	2244
;-------Stone--------
xzofs	equ	(-1-xh*xt)
xh	equ	3359
xt	equ	1920
xdjs	equ	278
;------Booting-------
xbd	equ	4567
xpd	equ	609
x0	equ	wgo
;------qScan---------
qf	equ	2713
qy	equ	4777
dq	equ	(qy+1)%CORESIZE
qa1	equ	(1+qf*(qt1-1-found))%CORESIZE
qa2	equ	(1+qf*(qt1  -found))%CORESIZE
qb1	equ	(1+qf*(qt2-1-found))%CORESIZE
qb2	equ	(1+qf*(qt2  -found))%CORESIZE
qb3	equ	(1+qf*(qt2+1-found))%CORESIZE
qc2	equ	(1+qf*(qt3  -found))%CORESIZE
qt3	equ	qbomb
qoff	equ	-86
qtime	equ	20
qstep	equ	7
;------Lables--------
org	qgo
;--------------------

	dat	0,	0
wgo	spl	1,	qb1
qt2	spl	1,	qb2
	mov.i	-1,	#qb3
	mov	<bptr,	{bptr
	mov	<pptr1,	{pptr1
	spl	*1,	0
bptr	spl	x0+xs+7+xbd,		bomb+2
pptr1	jmp	x0+silk+7+xpd,		silk+7
	
xs	spl	#0,	0
ptr	mov	bomb,	{xzofs
	mov	bomb,	@ptr
	add	#2*xh,	ptr
	djn.f	ptr,	<xs+xdjs
bomb	dat	xh+1,	>1
	dat	0,	0

silk	spl	@0, 	<ofs
	mov 	}silk, 	>silk
	mov	pbomb,	}bofs1
	mov	pbomb,	>bofs2
	add.b	{silk,	*0
	jmz.a	@0,	silk
pbomb	dat	<2667,	<5334

	for	9
	dat	0,	0
	rof

	dat	0,	qa1
qt1	dat	0,	qa2

	for	30
	dat	0,	0
	rof

	;q0 mutations 
qgo	sne	found+dq*qc2,	found+dq*qc2+qb2
	seq	<qt3,		found+dq*(qc2-1)+qb2
	jmp	q0,		}q0

	sne	found+dq*qa1,	found+dq*qa1+qb2
	seq	<qt1-1,		found+dq*(qa1-1)+qb2
        djn.a	q0,		{q0

	sne	found+dq*qa2,	found+dq*qa2+qb2
	seq	<qt1,		found+dq*(qa2-1)+qb2
	jmp	q0,		{q0

	;q1 mutations 
	sne	found+dq*qb1,	found+dq*qb1+qb1
	seq	<qt2-1,		found+dq*(qb1-1)+(qb1-1)
	jmp	q0,		{q1

	sne	found+dq*qb3,	found+dq*qb3+qb3
	seq	<qt2+1,		found+dq*(qb3-1)+(qb3-1)
	jmp	q0,		}q1

	;no mutation 
	sne	found+dq*qb2,	found+dq*qb2+qb2
        seq	<qt2,		found+dq*(qb2-1)+(qb2-1)
	jmp	q0,		0


	;dq mutation 
	seq	>found,		found+dq+(qb2-1)
	jmp	qsel,		<found

	;q0 mutation
	seq	found+(dq+1)*(qc2-1),	found+(dq+1)*(qc2-1)+(qb2-1)
	jmp	q0,			}q0

	seq	found+(dq+1)*(qa2-1),	found+(dq+1)*(qa2-1)+(qb2-1)
	jmp	q0,			{q0

	seq	found+(dq+1)*(qa1-1),	found+(dq+1)*(qa1-1)+(qb2-1)
	djn.a	q0,			{q0 

        ;free scan
	jmz.f	wgo,			found+(dq+1)*(qb2-1)+(qb2-1)
	
q0	mul.b	*q1,	 found
qsel	sne	<qt1,	@found
q1	add.b	qt2,	 found

qloop	mov	qbomb,	@found
found	mov	qbomb,	}dq
	add	#qstep,	found
	djn	qloop,	#qtime
	jmp	wgo,	0
qbomb	dat	{qoff,	qc2

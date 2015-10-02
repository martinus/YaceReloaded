;redcode-94nop
;name Burning Metal
;author inversed
;strategy Anti-imp paper/Imp paper 
;strategy Based on insights into heavily optimized anti-imp papers
;assert (CORESIZE==8000) && (MAXPROCESSES==8000)

ofs0	equ	1057
ofs1	equ	2001
bofs1	equ	5108
bofs2	equ	4530
len1	equ	7

iofs	equ	5255
aofs	equ	4510
zofs	equ	5302
istep	equ	1143
len2	equ	8

bdp	equ	5507
bdi	equ	4707

qf	equ	3553
qy	equ	5217
dq	equ	(qy+1)%CORESIZE
qa1	equ	(1+qf*(qt1-1-found))%CORESIZE
qa2	equ	(1+qf*(qt1  -found))%CORESIZE
qb1	equ	(1+qf*(qt2-1-found))%CORESIZE
qb2	equ	(1+qf*(qt2  -found))%CORESIZE
qb3	equ	(1+qf*(qt2+1-found))%CORESIZE
qc2	equ	(1+qf*(qt3  -found))%CORESIZE
qt1	equ	boot2
qt3	equ	qbomb

x0	equ	wgo

org	qgo
	
wgo	spl	1,	qb1
qt2	spl	1,	qb2
	spl	boot2,	qb3
	mov	-2,	0

	mov	{silk0,		{bpp
bpp	jmp	x0+bdp+len1,	qa1

boot2	spl	1,		qa2
	mov	{isilk,		{bpi
bpi	jmp	x0+bdi+len2,	0

	for	14
	dat	0,	0
	rof

silk0	spl	@len1,	<ofs0
	mov	}silk0,	>silk0
silk1	spl	@0,	<ofs1
	mov	}silk1,	>silk1
	mov	pbomb,	>bofs1
	mov	pbomb,	}bofs2
pbomb	dat	<2667,	<5334

	for	14
	dat	0,	0
	rof

isilk	spl	@len2,		>iofs
	mov	}isilk,		>isilk
clear	spl	#0,		0
	add.x	imp,		iptr
iptr	djn.f	imp-istep-1,	{aofs
	dat	0,		0
	dat	0,		0
imp	mov.i	#aofs,		istep

	for	12
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

qoff	equ	-86
qtime	equ	20
qstep	equ	7

qloop	mov	qbomb,	@found
found	mov	qbomb,	}dq
	add	#qstep,	found
	djn	qloop,	#qtime
	jmp	wgo,	0
qbomb	dat	{qoff,	{qc2

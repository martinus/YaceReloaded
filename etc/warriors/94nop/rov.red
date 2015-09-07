;redcode-94nop
;name Return of Vanquisher
;assert 1
;author Lukasz Grabun

; bomber constants 

sStp  	equ 1022
sLen	equ 7

; clear constants

cGate	equ (cClr-3)

; boot constants

bOff	equ (3408+sLoo)		; bomber boot distance
dOff	equ -252		; offset between bomber & bombs
cOff	equ (sStp*3+4853)	; offset between spare core clear & bomber 

; bomber code

bSrc	mov.i	{0		, #sLen
sLoo
	mov	sSb+dOff-2	, <sPtr
	mov	sJb+dOff-2	, *sPtr
sPtr    mov     sStp+1          , *sStp*3+1
	add	sInc		, sPtr
        mov     }sMb+dOff-2     , @sPtr
	jmz.a	sLoo		, {sMb+dOff-2
sSpr	jmz.f	cOff+4		, >cOff
sInc	jmz.f	sStp*3+4	, @sStp*3+1

; clear code

	spl	#0		, #0
cClr	mov	cBmb		, >cGate
	djn.f	cClr		, >cGate
cBmb	dat	>5335		, 2-cGate

	for   3
     	dat   0,0
     	rof

; incendiary bombs

sJb   	jmp   	@sStp		, sStp-1
sSb   	spl   	#1-sStp		, 8
sMb   	mov   	@0		, <sSb

; boot code
;-- boot bombs and extra lines
bBoo	mov	sMb		, bOff+17+dOff
	mov	sSb		, bOff+16+dOff
	mov	sJb		, bOff+15+dOff
	mov	sInc		, bOff+sLen+2
	mov	sSpr		, bOff+sLen+1
bDst	spl	1		, bOff+sLen+1
;-- boot clear
	mov	<cSrc		, {bOff+sLen+2
	mov	<cSrc		, {bOff+sLen+2
;-- boot spare clear
	mov	<cSpr		, {bOff+sLen+1
	mov	<cSpr		, {bOff+sLen+1
	spl	1		, }0
cSrc	spl	1		, cBmb+1
;-- boot bomber
	mov	<bSrc		, <bDst
cSpr	jmp	>bDst		, cBmb+1

; filler
   	for 32
	dat 0,0
	rof
; q-scan taken from Olivia
   	dat	$1234,	$  qA
qtb1:	dat	$1234,	$  qB
qwsh:	spl	#   0,	#  qF
qjmp:	djn.f	$  -1,	$  -1

; ----- q^4 scan -----
qX	equ	2414
qI	equ	5477	; (qX-1)*qI==1%8000
qA	equ	(((qX-1+(qtb1-1-qptr))*qI)%CORESIZE)
qB	equ	(((qX-1+(qtb1-0-qptr))*qI)%CORESIZE)
qC	equ	(((qX-1+(qtb2-1-qptr))*qI)%CORESIZE)
qD	equ	(((qX-1+(qtb2-0-qptr))*qI)%CORESIZE)
qE	equ	(((qX-1+(qtb2+1-qptr))*qI)%CORESIZE)
qF	equ	(((qX-1+(qwsh-0-qptr))*qI)%CORESIZE)

qinc	equ	(  -7)
qclk	equ	(  11)
qoff	equ	(qinc*qclk)

qscn:	sne	 qptr+qX*qE     ,  qptr+qX*qE+qE
	seq	<qtb2+1         ,  qptr+qX*(qE-1)+(qE-1)
	jmp	 qdec,	}qdec+2
	sne	 qptr+qX*qF     ,  qptr+qX*qF+qD
	seq	<qwsh           ,  qptr+qX*(qF-1)+qD
	jmp	 qdec,	}qdec
	sne	 qptr+qX*qA     ,  qptr+qX*qA+qD
	seq	<qtb1-1         ,  qptr+qX*(qA-1)+qD
	djn.a	 qdec,	{qdec
	sne	 qptr+qX*qB     ,  qptr+qX*qB+qD
	seq	<qtb1           ,  qptr+qX*(qB-1)+qD
	jmp	 qdec,	{qdec
	sne	 qptr+qX*qC     ,  qptr+qX*qC+qC
	seq	<qtb2-1         ,  qptr+qX*(qC-1)+(qC-1)
	jmp	 qdec,	{qdec+2
	seq	 qptr+qX*(qC-2) ,  qptr+qX*(qC-2)+(qC-2)
	djn	 qdec,	{qdec+2
	sne	 qptr+qX*qD     ,  qptr+qX*qD+qD
	jmz.f	 bBoo,	<qtb2

qdec:	mul.b	*   2,	 qptr
qfnd:	sne	*qtb1,	@qptr
	add.b	 qtb2,	 qptr
	mov	 qwsh,	>qptr
	mov	 qjmp,	>qptr
qptr:	mov	 qbmb,	*  qX
	sub	#qinc,	@qfnd
	mov	 qbmb,	@qptr
	djn	 qptr,	#qclk
	jmp	 bBoo,	<  qC
qtb2:	dat	 0,	#  qD
qbmb:	dat	{qoff,	#  qE

end	qscn


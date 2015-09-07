;redcode-94
;name Olivia
;author Ben Ford
;assert (CORESIZE==8000)
;strategy q^4 -> stone/imp
;strategy reworking an old favorite by Ian Oversby

; ----- imp launcher -----
ihop	equ	(2667)
iinc	equ	(-ihop-1)
idjn	equ	(ijmp+5800)
iorg	equ	(ijmp+1102)
ioff	equ	(iorg+iinc*2)

spin:	spl	#   0,	$   0
	sub.f	#iinc,	 ijmp
imov:	mov	 iimp,	}iimp
ijmp:	djn.f	 ioff,	{idjn
	dat	$   0,	$   0
iimp:	mov.i	#iorg,	 ihop

; ----- filler -----
for	42
	dat	$   0,	$   0
rof

	dat	$1234,	$  qA
qtb1:	dat	$1234,	$  qB
qwsh:	spl	#   0,	#  qF
qjmp:	djn.f	$  -1,	$  -1

; ----- stone -----
rptr	equ	(rock-5)	; -11 -5
rbmb	equ	(rock+7)	;  -3 +7
rinc	equ	(3315)	; 3315
rclk	equ	(1599)	; 1599
rorg	equ	(rmov-rinc*rclk)
rdjn	equ	(rock-rinc)

bsrc:	spl	#   7,	$   0
rock:	spl	#rinc,	<rdjn
rmov:	mov.i	{rorg,	 rhit-rorg
	add.f	 rock,	 rmov
rhit:	djn.f	 rmov,	<rdjn
	mov.i	 rbmb,	>rptr
rend:	djn.f	   -1,	>rptr
	dat	$   0,	$   0
rdat:	dat	<2667,	#rend-rptr+4

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
	jmz.f	 boot,	<qtb2

qdec:	mul.b	*   2,	 qptr
qfnd:	sne	*qtb1,	@qptr
	add.b	 qtb2,	 qptr
	mov	 qwsh,	>qptr
	mov	 qjmp,	>qptr
qptr:	mov	 qbmb,	*  qX
	sub	#qinc,	@qfnd
	mov	 qbmb,	@qptr
	djn	 qptr,	#qclk

; ----- boot -----
bdst	equ	(spin+5223)

boot:	mov	{bsrc,	<bptr
	mov	{bsrc,	<bptr
bptr:	mov	 rdat,	*bdst
	mov	{bsrc,	<bptr
	mov	{bsrc,	<bptr
	mov	{bsrc,	<bptr
	mov	{bsrc,	<bptr
	mov	{bsrc,	<bptr
	spl	@bptr,	<  qC
qtb2:	djn.f	 spin,	#  qD
qbmb:	dat	{qoff,	#  qE

end	qscn


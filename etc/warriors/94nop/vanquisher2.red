;redcode-94nop verbose
;author Lukasz Grabun
;name Vanquisher II
;strategy I name it so for Christoph's sake
;strategy q^4 -> suicidial stone + two independent dclears
;strategy slightly different from published version
;assert 1

	org	qGo
	
bOff	equ	19
bDist	equ	15
bStep	equ	159
bAway	equ	4000

cOff	equ	-15
cGate	equ	(cTop-4)
cAway	equ	(bAway+cOff)
bSpl	equ	(cOff+bMov)

dOff	equ	cOff-4301
dAway	equ	(bAway+dOff)

bBoot	mov	bIncen		, bOff+bAway-4-CURLINE
	mov	bSpare		, bAway-CURLINE
bSrc	spl	2		, bStart+5
bDest	spl	2		, bAway-CURLINE
cSrc	spl	1		, cStart+4
	mov	<bSrc		, <bDest
cBoot	mov	<cSrc		, <cDest
	mov	<dSrc		, <dDest
	djn	>bDest		, #5
cDest	jmp	bAway-CURLINE-4	, cAway-CURLINE

bStart	add	#bStep		, bPtr
bMov	mov	bOff		, @bPtr
bPtr	mov	>bEvac		, @2-bDist
	jmz.b	bStart		, <bEvac
bEvac	jmz.b	bSpl		, bSpl
;only difference is here
bSpare	jmz.b	dOff-5		, dOff-5

cTop	spl	1		, #-15
cStart	spl	#-bDist+1	, #0
	mov	cBmb		, >cGate
	djn.f	-1		, >cGate
cBmb	dat	>5335		, 2-cGate
for 5
	dat	0		, 0
rof
bIncen	mov	bDist		, }bDist
for 31
	dat	0		, 0
rof
qf 	equ 	qKil
qs 	equ 	200
qd 	equ 	4000
qi 	equ 	7
qr 	equ 	8

qBmb	dat   	{qi*qr-10	, {1
qGo  	seq   	qd+qf+qs	, qf+qs      ; 1
     	jmp   	qSki		, {qd+qf+qs+qi+2
     	sne   	qd+qf+5*qs	, qf+5*qs    ; B+1
     	seq   	qf+4*qs		, {qTab      ; B
	jmp   	qFas		, }qTab
     	sne   	qd+qf+8*qs	, qf+8*qs    ; A
     	seq   	qf+7*qs		, {qTab-1    ; A-1
     	jmp   	qFas		, {qFas
	sne   	qd+qf+10*qs	, qf+10*qs   ; C
     	seq   	qf+9*qs		, {qTab+1    ; C-1
	jmp   	qFas		, }qFas
	seq   	qd+qf+2*qs	, qf+2*qs    ; B-2
	jmp   	qFas		, {qTab
	seq   	qd+qf+6*qs	, qf+6*qs    ; A-2
	djn.a 	qFas		, {qFas
	seq   	qd+qf+3*qs	, qf+3*qs    ; B-1
        jmp   	qFas		, {qd+qf+3*qs+qi+2
	sne   	qd+qf+14*qs	, qf+14*qs   ; E+1
	seq   	qf+13*qs	, <qTab      ; E
	jmp   	qSlo		, >qTab
	sne   	qd+qf+17*qs	, qf+17*qs   ; D
	seq   	qf+16*qs	, <qTab-1    ; D-1
	jmp   	qSlo		, {qSlo
	seq   	qd+qf+11*qs	, qf+11*qs   ; E-2
	jmp   	qSlo		, <qTab
	seq   	qd+qf+15*qs	, qf+15*qs   ; D-2
	djn.b 	qSlo		, {qSlo
	sne   	qd+qf+12*qs	, qf+12*qs   ; E-1
	jmz   	bBoot		, qd+qf+12*qs-qi     ; Free Scan ;-)
qSlo  	mov.ba 	qTab		, qTab
qFas  	mul.ab 	qTab		, qKil
qSki  	sne   	qBmb-1		, @qKil
      	add   	#qd		, qKil
qLoo  	mov.i  	qBmb		, @qKil
qKil  	mov.i  	qBmb		, *qs
      	sub.ab 	#qi		, qKil
      	djn    	qLoo		, #qr
dDest  	jmp    	bBoot		, dAway-CURLINE
     	dat   	5408		, 7217       ; A*qs =  8*qs ,D*qs = 17*qs
qTab  	dat   	4804		, 6613       ; B*qs =  4*qs ,E*qs = 13*qs
dSrc   	dat   	5810		, cStart+5   ; C*qs = 10*qs ,F unused


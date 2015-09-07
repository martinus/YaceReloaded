;redcode-94nop
;author Lukasz Grabun
;name Candy
;assert CORESIZE==8000
;strategy MiniQ^3 -> Stone/Imp

	org	qGo

sStp	equ	4289
sTme	equ	1217
sHop	equ	17
sDjn	equ	4000
sAway	equ	6000

bOff	equ	6

iStp	equ	2667
iAway	equ	4779

bBot	mov	sBmb		, sAway-CURLINE+bOff
iSrc	spl	}2		, iImp+1
sDst	spl	*1		, sAway-CURLINE
iDst	spl	0		, iAway-CURLINE
	mov	<sSrc		, <sDst
	mov	<iSrc		, <iDst
	djn	@sDst		, #5
sSrc	jmp	@iDst		, sLoo+1
	
	spl	#0		, #0
sPtr	mov	sBmb+bOff	, }-(sStp*sTme)+1
sMov	mov	sBmb+bOff	, @sPtr
	add	#sStp		, @sMov
sLoo	djn.f	sPtr		, {sDjn
sBmb	dat	>sHop		, >1

;Uninvited's Imps

iPmp	spl   	#iImp		, >-20
     	sub.f 	#-iStp-1	, iJmp
     	mov   	iImp		, }iPmp
iJmp	jmp   	iImp-2*(iStp+1) , >iImp+2*iStp-1
iImp	mov.i 	#-1		, iStp

	for 54
	dat	0		, 0
	rof

qf  equ  qKil
qs  equ  200
qd  equ  4000
qi  equ  7
qr  equ  8

qGo   seq    qd+qf+qs    	, qf+qs           ; 1
      djn.f  qSki        	, {qd+qf+qs+qi+2
      sne    qd+qf+5*qs  	, qf+5*qs         ; B+1
      seq    qf+4*qs     	, <qTab           ; B
      jmp    qFas        	, >qTab
      sne    qd+qf+8*qs  	, qf+8*qs         ; A
      seq    qf+7*qs     	, <qTab-1         ; A-1
      jmp    qFas        	, {qFas
      sne    qd+qf+10*qs 	, qf+10*qs        ; C
      seq    qf+9*qs     	, <qTab+1         ; C-1
      jmp    qFas        	, }qFas
      seq    qd+qf+2*qs  	, qf+2*qs         ; B-2
      jmp    qFas        	, <qTab
      seq    qd+qf+6*qs  	, qf+6*qs         ; A-2
      djn.b  qFas        	, {qFas
      sne    qd+qf+3*qs  	, qf+3*qs         ; B-1
      jmz.f  bBot         	, qd+qf+12*qs-qi  ; Free Scan ;-)

qFas  mul.b  qTab        	, qKil
qSki  sne    <1000       	, @qKil
      add    #qd         	, qKil
qLoo  mov.i  qBmb        	, @qKil
qKil  mov.i  qBmb        	, *qs
      sub.ab #qi         	, qKil
      djn    qLoo        	, #qr
dDest djn.f  bBot        	, #5408  ; A*qs =  8*qs
qTab  dat    {qi*qr-10   	, 4804   ; B*qs =  4*qs
qBmb  dat    {qi*qr-10   	, 5810   ; C*qs = 10*qs
      end


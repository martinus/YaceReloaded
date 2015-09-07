;redcode-94nop
;author Lukasz Grabun
;name Candy II
;assert CORESIZE==8000
;strategy Q^4 -> Stone/Imp

	org	qGo

sStp	equ	4289
sTme	equ	1217
sHop	equ	17
sDjn	equ	4000
sAway	equ	6000

bOff	equ	6

iStp	equ	2667
iAway	equ	4779-3

qBomb	dat	{qOff  		, qF
bBot	mov	sBmb		, sAway-CURLINE+bOff
	spl	}2		, }qC
qTab2	spl	*1		, }qD
	spl	0		, }qE
	mov	<sSrc		, {sDst
	mov	<iPmp		, {iDst
sDst	djn	sAway-CURLINE	, #5
iDst	jmp	iAway-CURLINE	, #qA
qTab1	dat	1234		, #qB
		
sSrc	spl	#0		, #sBmb
sPtr	mov	sBmb+bOff	, }-(sStp*sTme)+1
sMov	mov	sBmb+bOff	, @sPtr
	add	#sStp		, @sMov
sLoo	djn.f	sPtr		, {sDjn
sBmb	dat	>sHop		, >1

;Uninvited's Imps

iPmp	spl   	#iImp		, #iImp+1
     	sub.f 	#-iStp-1	, iJmp
     	mov   	iImp		, }iPmp
iJmp	jmp   	iImp-2*(iStp+1) , >iImp+2*iStp-1
iImp	mov.i 	#iStp		, *0

	for 50
	dat	0		, 0
	rof

qX	equ 1034
qA	equ 2665
qB	equ 3362
qC	equ 6483
qD	equ 7180
qE	equ 7877
qF	equ 5089

qStep equ    7
qTime equ    16
qOff  equ    87

qGo   seq    qPtr+qX          , qPtr+qX+qD
      jmp    qSkip            , {qPtr+qX+qStep
      sne    qPtr+qX*qE       , qPtr+qX*qE+qE
      seq    <qTab2+1         , qPtr+qX*(qE-1)+(qE-1)
      jmp    qDec             , }qDec+2
      sne    qPtr+qX*qF       , qPtr+qX*qF+qD
      seq    <qBomb           , qPtr+qX*(qF-1)+qD
      jmp    qDec             , }qDec
      sne    qPtr+qX*qA       , qPtr+qX*qA+qD
      seq    <qTab1-1         , qPtr+qX*(qA-1)+qD
      djn.a  qDec             , {qDec
      sne    qPtr+qX*qB       , qPtr+qX*qB+qD
      seq    <qTab1           , qPtr+qX*(qB-1)+qD
      jmp    qDec             , {qDec
      sne    qPtr+qX*qC       , qPtr+qX*qC+qC
      seq    <qTab2-1         , qPtr+qX*(qC-1)+(qC-1)
      jmp    qDec             , {qDec+2
      seq    qPtr+qX*(qC-2)   , qPtr+qX*(qC-2)+(qC-2)
      djn    qDec             , {qDec+2
      sne    qPtr+qX*qD       , qPtr+qX*qD+qD
      jmz.f  bBot              , <qTab2

qDec  mul.b  *2               , qPtr
qSkip sne    *qTab1           , @qPtr
      add.b  qTab2            , qPtr
qLoop mov    qBomb            , @qPtr
qPtr  mov    qBomb            , }qX
      sub    #qStep           , @qSkip
      djn    qLoop            , #qTime
      djn.f  bBot              , #0

      end


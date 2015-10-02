;redcode-94nop
;author Lukasz Grabun
;name Pixie
;strategy Q^4 -> Stone/Imp
;assert (CORESIZE==8000)

; -- origin of code

orig z	for    0
	rof

; -- stone constants

sStp	equ    (107)		  ;
sFst	equ    (-115-1)		  ; first bomb is thrown here
sHop	equ    (6916+1)		  ; offset between bombs thrown in one loop
sGat	equ    (sHop+sMov-1)	  ; gate is formed here
sDjn	equ    (5500)		  ; start of djn stream

sBo1	equ    (3467+orig)  	  ; stone offset
sOff	equ    (6)		  ; offset between stone and bomb
sBo2	equ    (sBo1+sOff)	  ;
sBmb	equ    (sRck+sOff)	  ;

; -- imp constants

iStp	equ    (2667)		  ; 3-point imps
iSDc	equ    (-iStp-1)	  ;
iHp1	equ    (iImp-2*(iStp+1))  ;
iHp2	equ    (iImp+2*iStp-1)	  ;
iBoo	equ    (3818+5+orig)	  ; imp launcher offset

; -- qscan constants

qX	equ    6468
qA	equ    3320
qB	equ    1123
qC	equ    6352
qD	equ    4155
qE	equ    1958
qF	equ    2913

qStep 	equ    7
qTime 	equ    16
qOff  	equ    87

qBmb	dat    {qOff , #  qF

; -- imp launcher

iPmp	spl    #iImp , #sSrc
     	sub.f  #iSDc ,  iJmp
     	mov     iImp , }iPmp
iJmp	jmp     iHp1 , >iHp2
iImp	mov.i  #   0 , iStp

; -- stone

sSrc	spl    #sRck , <sGat	  ; based on skew dwarf
sPtr	mov     sBmb , {sFst	  ; but without hitting the
sMov	mov     sBmb , @sPtr	  ; djn line.
	sub    #sStp ,  sPtr
	djn.f   sPtr , <sDjn
sRck	dat    <sHop , >   1

; -- boot code

bBoo    mov     sRck ,  sBo2
   	spl    }   2 , }  qC
qTab2	spl    *   1 , }  qD
	spl        0 , }  qE
	mov    {sSrc , {qTab1	  ; boot stone
	mov    <iPmp , <iDst	  ; boot imp launcher
	djn    *qTab1, #   5	  ; start stone
iDst	jmp    @iDst ,  iBoo	  ; jump to imp launcher

	for    49
	dat    $   0 , $   0
	rof

; -- qscan

sDst  	dat     iBoo , #  qA
qTab1 	dat     sBo1 , #  qB

qGo   seq    qPtr+qX          , qPtr+qX+qD
      jmp    qSkip            , {qPtr+qX+qStep
      sne    qPtr+qX*qE       , qPtr+qX*qE+qE
      seq    <qTab2+1         , qPtr+qX*(qE-1)+(qE-1)
      jmp    qDec             , }qDec+2
      sne    qPtr+qX*qF       , qPtr+qX*qF+qD
      seq    <qBmb            , qPtr+qX*(qF-1)+qD
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
      jmz.f  bBoo             , <qTab2

qDec  mul.b  *2               , qPtr
qSkip sne    *qTab1           , @qPtr
      add.b  qTab2            , qPtr
qLoop mov    qBmb             , @qPtr
qPtr  mov    qBmb             , }qX
      sub    #qStep           , @qSkip
      djn    qLoop            , #qTime
      djn.f  bBoo             , #0

      end    qGo


;redcode-94nop
;name Preserver
;assert 1
;author Lukasz Grabun
;strategy Q^4 -> stun bomber
;strategy improved version of Return of Vanquisher

orig z for 0
     rof

; bomber constants 

step  	equ 1022
len	equ 8

; clear constants

gate	equ (clear-3)

; boot constants

boff	equ (5400+orig)		; bomber boot distance
doff	equ -252		; offset between bomber & bombs
coff	equ (step*3+4853)	; offset between spare core clear & bomber 

; bomber code

bSrc	MOV.I  {0	  , #len-1
sLoo
	MOV.I  ssb+doff-2 , <sPtr
	MOV.I  sjb+doff-2 , *sPtr
sPtr    MOV.I  step+1     , *step*3+1
	ADD.F  sInc	  , sPtr
        MOV.I  }smb+doff-2, @sPtr
	JMZ.A  sLoo       , {smb+doff-2
sSpr	JMZ.F  coff+4	  , }coff-1
sInc	JMZ.F  step*3+4	  , @step*3+1

; clear code

	SPL.B  #0         , #0
clear	MOV.I  dbomb	  , >gate
	DJN.F  -1	  , >gate
dbomb	DAT.F  <2667	  , 2-gate

	DAT.F  0	  , }qC
qTab2	DAT.F  0	  , }qD
	DAT.F  0	  , }qE
	
; incendiary bombs

sjb   	JMP.B  @step  	  , step-1
ssb   	SPL.B  #1-step    , 8
smb   	MOV.I  @0	  , <ssb

; boot code
;-- boot bombs and extra lines
boot	MOV.I  smb	  , boff+17+doff
	MOV.I  {boot      , <boot
	MOV.I  {boot	  , <boot
	MOV.I  sInc	  , boff+len+1
	MOV.I  sSpr	  , boff+len
bDst	SPL.B  1	  , boff+len
;-- boot clear
	MOV.I  <cSrc	  , {boff+len+1
	MOV.I  <cSrc	  , {boff+len+1
;-- boot spare clear
	MOV.I  <cSpr	  , {boff+len
	MOV.I  <cSpr	  , {boff+len
	SPL.B  1	  , }0
cSrc	SPL.B  1	  , dbomb+1
;-- boot bomber
	MOV.I  <bSrc	  , <bDst
cSpr	JMP.B  >bDst	  , dbomb+1

	for 36
	DAT.F 0,0
	rof

qX	equ 494
qA	equ 1072
qB	equ 1429
qC	equ 2727
qD	equ 3084
qE	equ 3441
qF	equ 6719

qStep equ    7
qTime equ    16
qOff  equ    87


qBomb DAT.F  {qOff	  , #qF
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
      jmz.f  boot             , <qTab2

qDec  mul.b  *2               , qPtr
qSkip sne    <qTab1           , @qPtr
      add.b  qTab2            , qPtr
qLoop mov    qBomb            , @qPtr
qPtr  mov    qBomb            , }qX
      sub    #qStep           , @qSkip
      djn    qLoop            , #qTime
      djn.f  boot             , #qA
qTab1 DAT.F  0		      , }qB

      end qGo


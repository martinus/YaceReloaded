;redcode-94nop
;author Lukasz Grabun
;assert (CORESIZE==8000)
;name Hammerhead
;strategy Q^4 -> Stone/Imp
;strategy improved version of Thunderstrike

orig  z for 0
        rof

; -- imp constants

istep	equ     (2667)		  ; 3-point imps
ioff	equ     (2038+orig)	  ; imp launcher offset
iskew	equ	(imp+250)	  ; imp offset

qBmb	DAT.F	{qOff   , #qF

; -- imp launcher

pump	SPL.B   #iskew 	, #imp+1
     	SUB.F   #-istep-1,  iloop
	MOV.I   imp 	, }pump
iloop	JMP.B   iskew-2*(istep+1) , >imp+2*istep-1
imp	MOV.I   #0      , istep

; -- stone constants

step	equ	(3510)
hop	equ	(46)

gate	equ	(inc-6)

from	equ	(0+step)
hit	equ	(loop-step-hop)

soff	equ	(2498+ioff)	; stone offset

; -- stone

inc	SPL.B	#step 	, <-step
	MOV.I	{from 	, <hit
	MOV.I	bomb 	, @-1
	ADD.F	inc  	, -2
loop	DJN.F	@-1 	, <-step+inc
	MOV.I	bomb 	, >gate
	DJN.F	-1 	, >gate
bomb	DAT.F	<2667 	, hop+1

; -- boot

boot 	MOV.I  bomb 	, soff
	MOV.I  {boot 	, <boot
	MOV.I  {boot	, <boot
	SPL.B  2 	, }qC
qTab2	SPL.B  2 	, }qD
	SPL.B  1 	, }qE
	MOV.I  {boot 	, <boot
	MOV.I  <pump 	, {qTab1
	DJN.B  @boot 	, #5
	JMP.B  ioff-5	, }qA
qTab1	DAT.F  ioff 	, #qB

for 46
dat 0,0
rof

; -- qscan constants

qX	equ 3404
qA	equ 7110
qB	equ 3177
qC	equ 6708
qD	equ 2775
qE	equ 6842
qF	equ 1569

qStep 	equ 7
qTime 	equ 16
qOff  	equ 87

; -- qscan

qGo     SEQ.I  qPtr+qX  , qPtr+qX+qD
        JMP.B  qSkip    , {qPtr+qX+qStep
        SNE.I  qPtr+qX*qE,qPtr+qX*qE+qE
        SEQ.I  <qTab2+1 , qPtr+qX*(qE-1)+(qE-1)
        JMP.B  qDec     , }qDec+2
        SNE.I  qPtr+qX*qF,qPtr+qX*qF+qD
        SEQ.I  <qBmb    , qPtr+qX*(qF-1)+qD
        JMP.B  qDec     , }qDec
        SNE.I  qPtr+qX*qA,qPtr+qX*qA+qD
        SEQ.I  <qTab1-1 , qPtr+qX*(qA-1)+qD
        DJN.A  qDec     , {qDec
        SNE.I  qPtr+qX*qB,qPtr+qX*qB+qD
        SEQ.I  <qTab1   , qPtr+qX*(qB-1)+qD
	DJN.A  qDec     , *0 
        SNE.I  qPtr+qX*qC,qPtr+qX*qC+qC
        SEQ.I  <qTab2-1 , qPtr+qX*(qC-1)+(qC-1)
        JMP.B  qDec     , {qDec+2
        SEQ.I  qPtr+qX*(qC-2), qPtr+qX*(qC-2)+(qC-2)
        DJN.B  qDec     , {qDec+2
        SNE.I  qPtr+qX*qD,qPtr+qX*qD+qD
        JMZ.F  boot     , <qTab2

qDec    MUL.B  *2       , qPtr
qSkip 	SNE.I  *qTab1   , @qPtr
      	ADD.B  qTab2    , qPtr
qLoop 	MOV.I  qBmb     , @qPtr
qPtr  	MOV.I  qBmb     , }qX
      	SUB.AB #qStep   , @qSkip
      	DJN.B  qLoop    , #qTime
	JMP.B  boot     , {400

	org	qGo


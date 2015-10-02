;redcode-94nop
;name Armadillo
;author Lukasz Grabun
;assert CORESIZE==8000

iX	equ	3380
sX	equ	2690

orig  z for 0
        rof

; -- boot

boot 	SPL.B  iboot	, bomb+1
	MOV.I  imp	, iorg+ioff-3
	SPL.B  1 	, {qA
qTab1	SPL.B  1 	, {qB
	MOV.I  <boot 	, {sptr
	MOV.I  <boot	, {sptr
sptr	JMP.B  soff+1 	, 0

for 7
dat 0,0
rof

qBmb	DAT.F  {qOff	, #qF

for 8
dat 0,0
rof

iboot	MOV.I  iloop	, {iptr
	MOV.I  {iboot	, {iptr
	MOV.I  {iboot	, {iptr
	MOV.I  {iboot	, {iptr
iptr	JMP.B  ioff-1	, 0

for 10
dat 0,0
rof

; -- stone constants
step	equ	(3510)
hop	equ	(56)
gate	equ	(inc-6)
from	equ	(0+step)
hit	equ	(loop-step-hop)
soff	equ	(6036+sX+orig)	; stone offset

; -- stone
inc	SPL.B	#step 	, <-step
	MOV.I	{from 	, <hit
	MOV.I	bomb 	, @-1
	ADD.F	inc  	, -2
loop	DJN.F	@-1 	, <-step+inc
	MOV.I	bomb 	, >gate
	DJN.F	-1 	, >gate
bomb	DAT.F	<1 	, hop+1

for 10
dat 0,0
rof

; -- imp constants
istep	equ     (2667)		  ; 3-point imps
ioff	equ     (3538+iX+orig)	  ; imp launcher offset
iskew	equ	(imp+50)	  ; imp offset
iorg	equ	(1000)

; -- imp launcher
pump	SPL.B   #iskew	, <-ioff-401
     	SUB.F   #-istep-1,  iloop
	MOV.I   iorg 	, }pump
iloop	JMP.B   iskew-2*(istep+1) , <-ioff-500
imp	MOV.I   #0, istep

   	DAT.F	0	, qC
qTab2	DAT.F	0 	, qD
	DAT.F	0	, qE
	
for 7
dat 0,0
rof
	
; -- qscan constants
qX	equ 452
qA	equ 1207
qB	equ 4258
qC	equ 5216
qD	equ 267
qE	equ 3318
qF	equ 5819

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
qSkip 	SNE.I  <qTab1   , @qPtr
      	ADD.B  qTab2    , qPtr
qLoop 	MOV.I  qBmb     , @qPtr
qPtr  	MOV.I  qBmb     , }qX
      	SUB.AB #qStep   , @qSkip
      	DJN.B  qLoop    , #qTime
	JMP.B  boot     , {400

        org    qGo


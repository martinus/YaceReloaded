;redcode-94nop
;name Harmony Snoot
;author Lukasz Grabun
;strategy scanner
;assert 1

step	equ	3056
gate	equ	(ptr-4)
decoy   equ     (ptr+1-1186)

ptr	JMP.B	spb	, -2991
atk	MOV.I	spb	, >ptr
scan	SEQ.I	}step	, }step+7
	MOV.AB	scan	, ptr
	ADD.F	spb	, scan
	JMN.A	atk	, scan
spb	SPL.B	#step	, #step
	MOV.I	bmb	, >gate
	DJN.F	-1	, >gate
bmb	DAT.F	<2667	, 2-gate

for 80
dat 0,0
rof

d       MOV.I   <decoy+0, {decoy+2
        MOV.I   <decoy+3, {decoy+5
        MOV.I   <decoy+6, {decoy+8
        DJN.F   scan  	, <decoy+10

        end    d
 

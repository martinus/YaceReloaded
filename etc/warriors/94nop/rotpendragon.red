;redcode-94nop
;name Return of the Pendragon
;author Christian Schmidt
;strategy mini Q^4 -> stone/imp
;strategy ultra fast design
;strategy combined with heavy imps
;strategy constants are not yet optimized 
;assert 1

sDist equ 6000
iDist equ 2000

istep equ 2667

dat 0, }qC
qTab2 dat 0, }qD
dat 0, }qE

cSp spl #0, <-1151+3
mov 197, cAd-(197*3500)
cAd add.ab {0, }0 
djn.f -2, <-1151
sEnd dat 0, 0

iStart spl #0, <-250
add.f imp, launch
launch spl imp-istep-1, <-250
djn sDist-iDist-3, <-400
iEnd dat 0, 0
imp mov.i #istep, *0

pGo mov cBomb, cSp+sDist+198+5
mov imp, imp+iDist
spl 1
spl 1
mov {sEnd, {sBoo
mov {iEnd, {iBoo
sBoo spl iEnd+sDist
iBoo jmp iEnd+iDist

for 22
dat 0,0
rof

cBomb dat >-1, >1
dat 0, }qA
qTab1 dat 0, }qB

for 27
dat 0, 0
rof

qX equ 3080
qA equ 3532
qB equ 2051
qC equ 6177
qD equ 4696
qE equ 3215
qF equ 583

qStep equ 7
qTime equ 16
qOff equ 87

qBomb dat {qOff , qF

qGo sne qPtr+qX*qE , qPtr+qX*qE+qE
seq <qTab2+1 , qPtr+qX*(qE-1)+(qE-1)
jmp qDec , }qDec+2
sne qPtr+qX*qF , qPtr+qX*qF+qD
seq <qBomb , qPtr+qX*(qF-1)+qD
jmp qDec , }qDec
sne qPtr+qX*qA , qPtr+qX*qA+qD
seq <qTab1-1 , qPtr+qX*(qA-1)+qD
djn.a qDec , {qDec
sne qPtr+qX*qB , qPtr+qX*qB+qD
seq <qTab1 , qPtr+qX*(qB-1)+qD
djn.a qDec , *0
sne qPtr+qX*qC , qPtr+qX*qC+qC
seq <qTab2-1 , qPtr+qX*(qC-1)+(qC-1)
jmp qDec , {qDec+2
sne qPtr+qX*qD , qPtr+qX*qD+qD
jmz.f pGo , <qTab2

qDec mul.b *2 , qPtr
qSkip sne <qTab1 , @qPtr
add.b qTab2 , qPtr
qLoop mov qBomb , @qPtr
qPtr mov qBomb , }qX
sub #qStep , @qSkip
djn qLoop , #qTime
djn.f pGo , #0

end qGo


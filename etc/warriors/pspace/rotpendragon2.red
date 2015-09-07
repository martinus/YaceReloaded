;redcode-94nop
;name RotPendragon 2
;author Christian Schmidt
;strategy mini Q^4 -> stone/imp
;strategy ultra fast design
;strategy combined with heavy imps 
;strategy and a new stone
;assert 1

iDist    equ    4859 
sDist    equ    681 
istep    equ    2667
dstep    equ    81
dhop     equ    5277
dtime    equ    1677

         dat    0,               }qC
qTab2    dat    0,               }qD
         dat    0,               }qE
dwarf    spl    #0,              <dhop+2
         mov    datb+3,          {(dstep*dtime)+1
         mov    datb+3,          @-1
         sub    #dstep,          -2
         djn.f  -3,              <dhop-2
datb     dat     <dhop+1,        >1
iStart   spl    #0,              <-250
         add.f  imp,             launch
launch   spl    imp-istep-1,     <-250
         djn    dwarf-iDist+sDist+5, <-400
iEnd     dat    0,               0
imp      mov.i  #istep,          *0
pGo      mov    <sBoo,           {sBoo
         mov    datb,            datb+sDist+8
         mov    imp,             imp+iDist
         spl    1
         spl    1
         mov    <sBoo,           {sBoo
         mov    {iEnd,           {iBoo
sBoo     spl    iEnd+sDist,      dwarf+5
iBoo     jmp    iEnd+iDist

for 21
dat 0,0
rof

         dat 0, }qA
qTab1    dat 0, }qB

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


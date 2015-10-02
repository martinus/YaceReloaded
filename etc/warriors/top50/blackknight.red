;redcode-94nop
;name Black Knight
;author Christian Schmidt
;strategy stone/imp
;assert 1
;optimax sai

sDist    equ     3486
iDist    equ     4676
iDist2   equ     750
iAwa     equ     3603
iAwa2    equ     427

istep    equ     2667
istep2   equ     2667

sOff     equ     -200
dStep    equ     197

xRef     equ     qbomb
zero     equ     qbomb
qtab3    equ     qbomb

qbomb    dat     >qoff,         >qc2
         dat     0,             0

pGo      spl     misc,          <qb1
qtab2    spl     1,             <qb2
         spl     1,             <qb3

         mov     <sBoo,         {sBoo
         mov     <iBoo,         {iBoo
         mov     <iBoo2,        {iBoo2
sBoo     spl     xRef+sDist+4,  dStart+4
iBoo     spl     xRef+iDist+4,  iStart+4
iBoo2    jmp     xRef+iDist2+4, iStart2+4

dStart   spl     #0,         <sOff+3
         mov     dStep,      1-(dStep*3500)
         add.ab  {0,         }0
         djn.f   -2,         <sOff

misc     mov     cBomb,      xRef+sDist+1+dStep
         mov     imp,        xRef+iDist+iAwa
         mov     imp2,       xRef+iDist2+iAwa2
cBomb    dat     >-1,        >1
imp      mov.i   #istep,     *0
imp2     mov.i   #1035,      istep2

         dat     zero-1,     qa1
qtab1    dat     zero-1,     qa2

 for 17
 dat 0, 0
 rof

iStart   spl     #0,         0
         add.a   #istep,     1
launch   spl     iStart+iAwa-(istep*4)
         djn.f   sDist-iDist-3, <2057

 for 5
 dat 0, 0
 rof

iStart2  spl     #0,         0
         add.a   #istep,     1
launch2  spl     iStart2+iAwa2-(istep*4)
         djn.f     sDist-iDist2-3, <288

 for 12
 dat 0, 0
 rof

qc2 equ ((1 + (qtab3-qptr)*qy) % CORESIZE)
qb1 equ ((1 + (qtab2-1-qptr)*qy) % CORESIZE)
qb2 equ ((1 + (qtab2-qptr)*qy) % CORESIZE)
qb3 equ ((1 + (qtab2+1-qptr)*qy) % CORESIZE)
qa1 equ ((1 + (qtab1-1-qptr)*qy) % CORESIZE)
qa2 equ ((1 + (qtab1-qptr)*qy) % CORESIZE)
qz equ 2108
qy equ 243
qgo sne qptr + qz*qc2, qptr + qz*qc2 + qb2
 seq <qtab3, qptr + qz*(qc2-1) + qb2
 jmp q0, }q0
 sne qptr + qz*qa2, qptr + qz*qa2 + qb2
 seq <qtab1, qptr + qz*(qa2-1) + qb2
 jmp q0, {q0
sne qptr + qz*qa1, qptr + qz*qa1 + qb2
 seq <(qtab1-1), qptr + qz*(qa1-1) + qb2
 djn.a q0, {q0
 sne qptr + qz*qb3, qptr + qz*qb3 + qb3
 seq <(qtab2+1), qptr + qz*(qb3-1) + (qb3-1)
 jmp q0, }q1
sne qptr + qz*qb1, qptr + qz*qb1 + qb1
 seq <(qtab2-1), qptr + qz*(qb1-1) + (qb1-1)
 jmp q0, {q1
 sne qptr + qz*qb2, qptr + qz*qb2 + qb2
 seq <qtab2, qptr + qz*(qb2-1) + (qb2-1)
 jmp q0
 seq >qptr, qptr + qz + (qb2-1)
 jmp q2, <qptr
seq qptr+(qz+1)*(qc2-1),qptr+(qz+1)*(qc2-1)+(qb2-1)
 jmp q0, }q0
seq qptr+(qz+1)*(qa2-1),qptr+(qz+1)*(qa2-1)+(qb2-1)
 jmp q0, {q0
seq qptr+(qz+1)*(qa1-1),qptr+(qz+1)*(qa1-1)+(qb2-1)
 djn.a q0, {q0
 jmz.f pGo, qptr + (qz+1)*(qb2-1) + (qb2-1)
qoff equ -87
qstep equ -7
qtime equ 14
q0 mul.b *2, qptr
q2 sne {qtab1, @qptr
q1 add.b qtab2, qptr
 mov qtab3, @qptr
qptr mov qbomb, }qz
 sub #qstep, qptr 
 djn -3, #qtime 
 jmp pGo 
end qgo


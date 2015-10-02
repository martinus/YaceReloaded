;redcode-94nop 
;name Last Judgement
;author Christian Schmidt 
;strategy stone/imp 
;assert 1 
;optimax sai

;------------ Qscan Constant ---------------

zero    equ     qbomb
qtab3   equ     qbomb
qz      equ     2108
qy      equ     243

qc2 equ ((1 + (qtab3-qptr)*qy) % CORESIZE)
qb1 equ ((1 + (qtab2-1-qptr)*qy) % CORESIZE)
qb2 equ ((1 + (qtab2-qptr)*qy) % CORESIZE)
qb3 equ ((1 + (qtab2+1-qptr)*qy) % CORESIZE)
qa1 equ ((1 + (qtab1-1-qptr)*qy) % CORESIZE)
qa2 equ ((1 + (qtab1-qptr)*qy) % CORESIZE)

qoff    equ    -88
qstep   equ    -7
qtime   equ    20

;-------Constants for optimization----------

sDist    equ     1745
iDist    equ     1048
iDist2   equ     931
iAwa     equ     6846
iAwa2    equ     2876

istep    equ     2667 

dstep    equ    81
dhop     equ    5277
dtime    equ    1677

;-------------------------------------------

        dat     0,              0
qbomb   dat     >qoff,          >qc2

;------ 45 instructions --------------------

pGo      spl     misc
         spl     1
         spl     1
         mov     <sBoo,         {sBoo 
         mov     <iBoo,         {iBoo 
         mov     <iBoo2,        {iBoo2 
sBoo     spl     zero+sDist+5,  dStart+5 
iBoo     spl     zero+iDist+4,  iStart+4 
iBoo2    jmp     zero+iDist2+4, iStart2+4 

dStart   spl    #0,              <dhop+2
         mov    7,               {(dstep*dtime)+1
         mov    6,               @-1
         sub    #dstep,          -2
         djn.f  -3,              <dhop-2

misc     mov     <sBoo,         {sBoo
         mov     datb,          zero+sDist+8
         mov     imp,           zero+iDist+iAwa 
         mov     imp2,          zero+iDist2+iAwa2 

for     9
        dat     0,              0 
rof 

datb    dat     <dhop+1,        >1
imp     mov.i   #istep,         *0 
imp2    mov.i   #1,             istep 

for     6
        dat     0,              0 
rof 

iStart  spl     #istep,         <7654 
        add.f   -1,             1 
launch  spl     iStart+iAwa-(istep*4), <4423
        djn.f   sDist-iDist-3,  <2211 

for     1
        dat     0,              0 
rof 

iStart2 spl     #istep,         <2068 
        add.f   -1,             1 
launch2 spl     iStart2+iAwa2-(istep*4), <6006
        djn.f   sDist-iDist2-3, <6835

;-------------------------------------------

        dat     0,              <qb1
qtab2   dat     0,              <qb2
        dat     0,              <qb3


        dat     0,              0
        dat     0,              0
        dat     0,              0
        dat     0,              0

        dat     zero-1,         qa1
qtab1   dat     zero-1,         qa2

        dat     0,              0
        dat     0,              0
        dat     0,              0
        dat     0,              0
        dat     0,              0


qgo sne qptr+qz*qc2, qptr+qz*qc2+qb2
    seq <qtab3,      qptr+qz*(qc2-1)+qb2
    jmp q0,          }q0
    sne qptr+qz*qa2, qptr + qz*qa2 + qb2
    seq <qtab1,      qptr+qz*(qa2-1)+qb2
    jmp q0,          {q0
    sne qptr+qz*qa1, qptr+qz*qa1+qb2
    seq <(qtab1-1),  qptr+qz*(qa1-1)+qb2
    djn.a q0,        {q0
    sne qptr+qz*qb3, qptr+qz*qb3+qb3
    seq <(qtab2+1),  qptr+qz*(qb3-1)+(qb3-1)
    jmp q0,          }q1
    sne qptr+qz*qb1, qptr+qz*qb1+qb1
    seq <(qtab2-1),  qptr+qz*(qb1-1)+(qb1-1)
    jmp q0,          {q1
    sne qptr+qz*qb2, qptr+qz*qb2+qb2
    seq <qtab2,      qptr+qz*(qb2-1)+(qb2-1)
    jmp q0,          }4443              ;extra attack
    seq >qptr,       qptr+qz+(qb2-1)
    jmp q2,          <qptr
seq qptr+(qz+1)*(qc2-1),qptr+(qz+1)*(qc2-1)+(qb2-1)
    jmp q0,          }q0
seq qptr+(qz+1)*(qa2-1),qptr+(qz+1)*(qa2-1)+(qb2-1)
    jmp q0,          {q0
seq qptr+(qz+1)*(qa1-1),qptr+(qz+1)*(qa1-1)+(qb2-1)
    djn.a q0,        {q0
    jmz.f pGo,       qptr+(qz+1)*(qb2-1)+(qb2-1)

q0      mul.b   *2,             qptr
q2      sne     {qtab1,         @qptr
q1      add.b   qtab2,          qptr
        mov     qtab3,          @qptr
qptr    mov     qbomb,          }qz
        sub     #qstep,         qptr
        djn     -3,             #qtime
        jmp     pGo,            }3256   ;extra attack

        dat     0,              0
        dat     0,              0
        dat     0,              0
        dat     0,              0

end qgo


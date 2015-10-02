;redcode-94nop
;name Elven King
;author Christian Schmidt
;strategy q^4.5, stone, imp
;assert 1

;-------imp constants------------------------
iStep   equ     2667

;-------stone constants----------------------
sStep    equ    3630
sHop     equ    46
sGate    equ    (sIncr-2)
sHit     equ    (sLoop-sStep-sHop)

;-------boot constants-----------------------
ioff    equ     (qbomb + 4805)
soff    equ     (qbomb + 5133)
iSep    equ     (qbomb + 7080)

;-------qscan constants----------------------
zero    equ     qbomb
qtab3   equ     qbomb

qbomb   dat     >qoff,          >qc2

iBoot   mov.i   iImp,           ioff
        spl     1,              <qb1
qtab2   spl     1,              <qb2
        spl     2,              <qb3
        mov.i   {iBoot,         <iBoot
        mov.i   <sboot,         {saway
saway   djn     soff,           #8
sboot   jmp     @iBoot,         sBomb+1

        for     4
        dat     0,              0
        rof

sIncr   spl     #sStep,         <-sStep
        mov.i   {sStep,         <sHit
        mov.i   sBomb,          @-1
        add.f   sIncr,          -2
sLoop   djn.f   @-1,            <-sStep+sIncr
        mov.i   sBomb,          >sGate
        djn.f   -1,             >sGate
sBomb   dat     <2667,          sHop+1

        dat     zero-1,         qa1
qtab1   dat     zero-1,         qa2

        for     6
        dat     0,              0
        rof

iGo     spl     #iSep,          #iImp+1
        sub.f   #-iStep-1,      iLoop
        mov.i   iImp,           }iGo
iLoop   jmp     iSep-2*(iStep+1), >iImp+2*iStep-1
iImp    mov.i   #iStep,         *0


        for     31
        dat     0,              0
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
 jmz.f iBoot, qptr + (qz+1)*(qb2-1) + (qb2-1)

qoff  equ -87
qstep equ -7
qtime equ 14

q0   mul.b  *2,     qptr
q2   sne    {qtab1, @qptr
q1   add.b  qtab2,  qptr
     mov    qtab3,  @qptr
qptr mov    qbomb,  }qz
     sub    #qstep, qptr
     djn    -3,     #qtime
     djn.f  iBoot,  {5234

end qgo


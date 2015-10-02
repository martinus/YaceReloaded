;redcode-94nop
;name Borgir
;author Christian Schmidt
;strategy qscanner, stone/paper
;assert 1
;optimax pws

pStep1  equ    552
pStep2  equ    7061
sAwa    equ    1806
dAwa    equ    1001

dStep   equ    2862
dOff    equ    4655

zero    equ    qbomb
qtab3   equ    qbomb

qbomb   dat    >qoff,           >qc2
wGo     mov    >dLoop,          >dBoo

        spl    2,               <qb1
qtab2   spl    1,               <qb2
        spl    1,               <qb3

        mov    >dLoop,          >dBoo
        mov    <pEnd,           {pBoo
dBoo    spl    @pBoo,           wGo+sAwa
        spl    @pBoo,           >dBoo
pBoo    djn    wGo+dAwa+6,      #wGo+sAwa


dGo     spl    #2*dStep,        {2*dStep
        mov    dBmb,            *2
        add.f  -2,              1
        mov    dOff,            dOff+dStep
dLoop   jmp    -3,              dGo
        dat    0,               0
dBmb    dat    }1,              >1

        for    4
        dat    0,               0
        rof

        dat    zero-1,          qa1
qtab1   dat    zero-1,          qa2


for 11
dat 0, 0
rof


pGo     spl    pStep1,          {3
        mov    }2,              }-1
        mov    pBmb,            >pStep2
        mov    3,               }-3
        jmz.f  -4,              *-1
pBmb    dat    <2667,           <5334
pEnd    dat    0,               0

for 24
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
 jmz.f wGo, qptr + (qz+1)*(qb2-1) + (qb2-1)
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
 jmp wGo
end qgo


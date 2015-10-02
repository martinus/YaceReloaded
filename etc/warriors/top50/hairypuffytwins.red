;redcode-94nop
;name Hairy Puffy Twins
;author Roy van Rijn
;assert 1

;optimax 1234
;optimax work test
;optimax rounds 1 100 100 300
;optimax suite fsh94nop0.2
;optimax phase2 fsh94nop0.2/pws/Metal.red
;optimax phase2 95%
;optimax phase3 top15
;optimax phase3 clr:cds:stn
;optimax phase3 98%
;optimax phase4 top15
;optimax phase4 100%

bDist1  equ     1645
bDist2  equ     1258

zero    equ     qbomb

qtab3   equ     qbomb
qbomb   dat     >qoff           , >qc2
        dat     0               , 0

pGo     spl     1               , <qb1
qtab2   spl     1               , <qb2
        spl     1               , <qb3

        mov     {pap2           , {1
pBoot1  spl     bDist1          , }7391

        mov     }-1             , >1
pBoot2  jmp     bDist2          , bDist2

for     8
        dat     0               , 0
rof

        dat    zero-1           , qa1
qtab1   dat    zero-1           , qa2

for     5
        dat     0               , 0
rof

pap2    spl     @8		, <7205
        mov.i   }-1		, >-1
        spl     @0		, <984
        mov.i   }-1		, >-1
        spl     @0		, <2001
        mov.i   }-1		, >-1
        mov.i   #7285           , {1
        mov.i   256             , }1352


for     33
        dat     0               , 0
rof

qc2     equ ((1+(qtab3-qptr)*qy)%CORESIZE)
qb1     equ ((1+(qtab2-1-qptr)*qy)%CORESIZE)
qb2     equ ((1+(qtab2-qptr)*qy)%CORESIZE)
qb3     equ ((1+(qtab2+1-qptr)*qy)%CORESIZE)
qa1     equ ((1+(qtab1-1-qptr)*qy)%CORESIZE)
qa2     equ ((1+(qtab1-qptr)*qy)%CORESIZE)

qy      equ 5931
qz      equ 3972

;q0 mutation
qgo

        sne     qptr+qz*qa1     , qptr+qz*qa1+qb2
        seq     <(qtab1-1)      , qptr+qz*(qa1-1)+qb2
        djn.a   q0              , {q0
        sne     qptr+qz*qc2     , qptr+qz*qc2+qb2
        seq     <qtab3          , qptr+qz*(qc2-1)+qb2
        jmp     q0              , }q0
        sne     qptr+qz*qa2     , qptr+qz*qa2+qb2
        seq     <qtab1          , qptr+qz*(qa2-1)+qb2
        jmp     q0              , {q0
                                        ;q1 mutation
        sne     qptr+qz*qb3     , qptr+qz*qb3+qb3
        seq     <(qtab2+1)      , qptr+qz*(qb3-1)+(qb3-1)
        jmp     q0              , }q1
        sne     qptr+qz*qb1     , qptr+qz*qb1+qb1
        seq     <(qtab2-1)      , qptr+qz*(qb1-1)+(qb1-1)
        jmp     q0              , {q1
        sne     qptr+qz*qb2     , qptr+qz*qb2+qb2
        seq     <qtab2          , qptr+qz*(qb2-1)+(qb2-1)
        djn.f   q0              , <6127

                                        ;qz mutation
        seq     >qptr           , qptr+qz+(qb2-1)
        jmp     q2              , <qptr
                                        ;q0 mutation
        seq     qptr+(qz+1)*(qc2-1),qptr+(qz+1)*(qc2-1)+(qb2-1)
        jmp     q0              , }q0
        seq     qptr+(qz+1)*(qa2-1),qptr+(qz+1)*(qa2-1)+(qb2-1)
        jmp     q0              , {q0
        seq     qptr+(qz+1)*(qa1-1),qptr+(qz+1)*(qa1-1)+(qb2-1)
        djn.a   q0              , {q0
        jmz.f   pGo             , qptr+(qz+1)*(qb2-1)+(qb2-1)

qoff    equ     -87
qstep   equ     -7
qtime   equ     19

q0      mul.b   *2              , qptr
q2      sne     {qtab1          , @qptr
q1      add.b   qtab2           , qptr
        mov     qtab3           , @qptr
qptr    mov     qbomb           , }qz
        sub     #qstep          , qptr
        djn     -3              , #qtime
        jmp     pGo             , <4598
end qgo


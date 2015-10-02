;redcode-94nop
;name For John
;author Roy van Rijn
;strategy qScan into imp paper
;assert 1

bDist1  equ     394;525;4178
bDist2  equ     7956;945;3018

zero    equ     qbomb

qtab3   equ     qbomb
qbomb   dat     >qoff           , >qc2

dat 0 , 0
wGo     spl     1               , }qb1
qtab2   spl     1               , }qb2
        spl     1               , }qb3

        mov     {pap2           , {1
pBoot1  spl     bDist1          , }1218;1747;3804

        mov     {pap            , {1
pBoot2  jmp     bDist2          , }5962;6985;1855

for     8
        dat     0               , 0
rof
        dat     zero-1          , qa1
qtab1   dat     zero-1          , qa2

for     5
        dat     0               , 0
rof

iStep   equ     1143
pStep   equ     2863;1500
sStep   equ     866;95

pap2    spl     @8              , <pStep
        mov.i   }-1             , >-1
pStone  spl     #0
        mov     bomb            , >ptr
        add.x   imp             , ptr
ptr     jmp     imp-iStep*8     , >sStep-6
bomb    dat     >1              , }1
imp     mov.i   #sStep-1        , iStep

for     5
        dat     0               , 0
rof

pStep1  equ     697;6963
pStep2  equ     3446;4657
pStep3  equ     1188;1899

sStep1  equ     3845;3552
sStep2  equ     2662;1393
sStep3  equ     6547;6676

pap     spl     @8              , }pStep1
        mov.i   }-1             , >-1

        spl     @0              , >pStep2
        mov.i   }-1             , >-1

        mov.i   #sStep1         , {1
        mov.i   sStep2          , }sStep3

        mov.i   {-4             , <1
        jmz.a   @0              , pStep3

for     20
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
        djn.f   q0              , <6907

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
        jmz.f   wGo             , qptr+(qz+1)*(qb2-1)+(qb2-1)

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
        jmp     wGo             , <855
end qgo

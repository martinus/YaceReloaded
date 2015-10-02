;redcode-94nop
;name Devilstick
;author Roy van Rijn
;strategy Another warrior based on Dawn, but getting better all the time (?)
;assert 1

bDist1  equ     6133
bDist2  equ     4122

zero    equ     qbomb

qtab3   equ     qbomb
qbomb   dat     >qoff           , >qc2
        dat     0               , 0

pGo     spl     1               , <qb1
qtab2   spl     1               , <qb2
        spl     1               , <qb3

        mov     {pap2           , {1
pBoot1  spl     bDist1          , >5747

        mov     {pap            , {1
pBoot2  djn.f   bDist2          , >4584

for     8
        dat     0               , 0
rof

        dat    zero-1           , qa1
qtab1   dat    zero-1           , qa2

for     2
        dat     0               , 0
rof

nstep1  equ     2413;851
cstep1  equ     4704;5170
tstep1  equ     3278;3218

pap     spl     @8      , }tstep1
        mov.i   }pap    , >pap
nothA   spl     @nothA  , }cstep1
        mov.i   }nothA  , >nothA
nothB   spl     @nothB  , }nstep1
        mov.i   }nothB  , >nothB
        mov.i   #1138   , <1
        djn     -2      , <1618;973

for     14
        dat     0               , 0
rof

iStep   equ     1143
pStep   equ     7342
sStep   equ     5965

pap2    spl     @8              , }pStep
        mov.i   }-1             , >-1
pStone  spl     #0              , 0
        mov     bomb            , >ptr
        add.x   imp             , ptr
ptr     jmp     imp-iStep*8     , >sStep-6
bomb    dat     >1              , }1
imp     mov.i   #sStep-1        , iStep

for     14
        dat     0               , 0
rof

qc2     equ ((1+(qtab3-qptr)*qy)%CORESIZE)
qb1     equ ((1+(qtab2-1-qptr)*qy)%CORESIZE)
qb2     equ ((1+(qtab2-qptr)*qy)%CORESIZE)
qb3     equ ((1+(qtab2+1-qptr)*qy)%CORESIZE)
qa1     equ ((1+(qtab1-1-qptr)*qy)%CORESIZE)
qa2     equ ((1+(qtab1-qptr)*qy)%CORESIZE)
qz      equ 2108
qy      equ 243         ;qy*(qz-1)=1

;q0 mutation
qgo     sne     qptr+qz*qc2     , qptr+qz*qc2+qb2
        seq     <qtab3          , qptr+qz*(qc2-1)+qb2
        jmp     q0              , }q0
        sne     qptr+qz*qa2     , qptr+qz*qa2+qb2
        seq     <qtab1          , qptr+qz*(qa2-1)+qb2
        jmp     q0              , {q0
        sne     qptr+qz*qa1     , qptr+qz*qa1+qb2
        seq     <(qtab1-1)      , qptr+qz*(qa1-1)+qb2
        djn.a   q0              , {q0
                                        ;q1 mutation
        sne     qptr+qz*qb3     , qptr+qz*qb3+qb3
        seq     <(qtab2+1)      , qptr+qz*(qb3-1)+(qb3-1)
        jmp     q0              , }q1
        sne     qptr+qz*qb1     , qptr+qz*qb1+qb1
        seq     <(qtab2-1)      , qptr+qz*(qb1-1)+(qb1-1)
        jmp     q0              , {q1

        sne     qptr+qz*qb2     , qptr+qz*qb2+qb2
        seq     <qtab2          , qptr+qz*(qb2-1)+(qb2-1)
        jmp     q0
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

qoff    equ     -86
qstep   equ     -7
qtime   equ     19

q0      mul.b   *2              , qptr
q2      sne     {qtab1          , @qptr
q1      add.b   qtab2           , qptr
        mov     qtab3           , @qptr
qptr    mov     qbomb           , }qz
        sub     #qstep          , qptr
        djn     -3              , #qtime
        djn.f   pGo             , 0

end qgo


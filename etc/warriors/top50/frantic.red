;redcode-94nop
;name Frantic
;author Roy van Rijn
;strategy Stone with seperate dclear and imps
;assert 1

zero    equ     qbomb

qtab3   equ     qbomb
qbomb   dat     >qoff           , >qc2

hDist   equ     5321
iDist   equ     hDist-1520
cDist   equ     hDist-3245

        dat     0               , 0
sBoot   mov     sBmb            , hBoot+hDist+5
        spl     2               , <qb1
qtab2   spl     2               , <qb2
        spl     1               , <qb3
        mov     {sBoot          , {hBoot
        mov     <iBoot          , {iBoot
        mov     {cGate          , <cBoot
hBoot   djn     hDist           , #5
bBoot   mov     cGate           , cBoot+cDist-10
iBoot   spl     hBoot+iDist     , #iImp+1
cBoot   jmp     cDist-5         , cDist

for     5
        dat     0               , 0
rof
        dat     zero-1          , qa1
qtab1   dat     zero-1          , qa2

for     4
        dat     0               , 0
rof

iStep   equ     2667
iPmp    spl     #iImp           , >-20
        sub.f   #-iStep-1       , iJmp
        mov     iImp            , }iPmp
iJmp    jmp     iImp-2*(iStep+1), >iImp+2*iStep-1
iImp    mov.i   #iStep          , *0

for     8
        dat     0               , 0
rof

sStep   equ     1653
sStart  spl     #3*sStep        , 3*sStep
        mov     sBmb+5          , @sPtr
        add     sStart          , @-1
sPtr    mov     4+(2*sStep)     , *4
        djn.f   -3              , *sPtr
sBmb    dat     <sStep          , >1

for     8
        dat     0               , 0
rof

cGate   dat     cBomb+1         , 1264
cStart  spl     #0              , 0
        mov     cBomb           , >cGate-4
        djn.f   -1              , >cGate-4
        dat     0               , 0
cBomb   dat     <2667           , >8

for     8
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
        jmz.f   sBoot           , qptr+(qz+1)*(qb2-1)+(qb2-1)

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
        djn.f   sBoot           , #0

end qgo


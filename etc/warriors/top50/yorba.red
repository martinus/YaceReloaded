;redcode-94nop
;name Yorba
;author Roy van Rijn
;assert 1

zero    equ     qbomb

qtab3   equ     qbomb
qbomb   dat     >qoff           , >qc2
        dat     0               , 0

cStep1  equ     5382
cStep2  equ     2471
cStep3  equ     3428

bStep1  equ     6964
bStep2  equ     1200

bDist1  equ     3640
bDist2  equ     4631

pGo     spl     1               , <qb1
qtab2   spl     1               , <qb2
        spl     1               , <qb3

        mov     <pEnd   , {1
pBoot1  spl     bDist1  , >5747

        mov     {pEnd   , {1
pBoot2  djn.f   bDist2  , >4584

for     8
        dat     0               , 0
rof

        dat    zero-1           , qa1
qtab1   dat    zero-1           , qa2

        spl     @0      , >cStep1
        mov.i   }-1     , >-1
        spl     @0      , >cStep2
        mov.i   }-1     , >-1
        mov.i   pBomb   , >bStep1
        mov.i   {-3     , {1
        djn.f   cStep3  , >bStep2
pBomb   dat     >5334   , >2667
pEnd    dat     0       , 0

for     21
        dat     0       , 0
rof

hStep equ    3039
hTime equ    3360
hDjn  equ    2813
hOff  equ    5
sOff  equ    686

bBoot   mov     stone   , sOff-6-CURLINE
        mov     hBomb   , sOff+5-CURLINE
        spl     2       , >2689
        spl     2       , >6562
sDst    spl     1       , sOff-CURLINE
        mov     <sSrc   , <sDst
        djn     @bBoot  , #5
sSrc    jmp     pGo     , hLoo+1

stone spl    #0               , 0
hLoop mov    hBomb+hOff       , @hPtr
hHit  add    #hStep*2         , hPtr
hPtr  mov    hBomb+hOff       , }hHit-hStep*hTime
hLoo  djn.f  hLoop            , <hDjn
hBomb dat    hStep            , >1

        dat     0               , 0
        dat     0               , 0

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
        jmz.f   bBoot           , qptr+(qz+1)*(qb2-1)+(qb2-1)

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
        djn.f   bBoot           , #0
end qgo


;redcode-94nop
;name Halcyon
;author Roy van Rijn
;strategy Q4.5 -> Stone+Paper
;assert 1

zero    equ     qbomb

qtab3   equ     qbomb
qbomb   dat     >qoff           , >qc2
        dat     0               , 0
wGo     spl     1               , }qb1
qtab2   spl     1               , }qb2
        spl     1               , }qb3

cStep1  equ     1313
cStep2  equ     2900
cStep3  equ     4129

bStep1  equ     7482

pStart  spl     @0              , >cStep1
        mov.i   }-1             , >-1
        spl     cStep2
        mov.i   >-1             , }-1
        mov.i   pBomb           , >bStep1
        mov.i   <-3             , <1
        djn.f   @0              , >cStep3
pBomb   dat     >5334           , >2667

for     4
        dat     0               , 0
rof

        dat    zero-1           , qa1
qtab1   dat    zero-1           , qa2

for     6
        dat     0               , 0
rof


sOff    equ     7377

bBoot   mov     sStart  , sOff-6-CURLINE
        mov     sBmb    , sOff+hOff-CURLINE
        spl     2       , >2406
        spl     2       , >2838
sDst    spl     1       , sOff-CURLINE
        mov     <sSrc   , <sDst
        djn     @bBoot  , #5
sSrc    jmp     wGo     , sBmb

for     2
        dat     0               , 0
rof

hStep equ    3039
hTime equ    3360
hDjn  equ    7603
hOff  equ    6864

sStart spl    #0               , 0
       mov    sBmb+hOff        , @hPtr
hHit   add    #hStep*2         , hPtr
hPtr   mov    sBmb+hOff        , }hHit-hStep*hTime
       djn.f  -3               , <hDjn
sBmb   dat    #hStep           , >1


for     24
        dat     0               , 0
rof

qc2     equ ((1+(qtab3-qptr)*qy)%CORESIZE)
qb1     equ ((1+(qtab2-1-qptr)*qy)%CORESIZE)
qb2     equ ((1+(qtab2-qptr)*qy)%CORESIZE)
qb3     equ ((1+(qtab2+1-qptr)*qy)%CORESIZE)
qa1     equ ((1+(qtab1-1-qptr)*qy)%CORESIZE)
qa2     equ ((1+(qtab1-qptr)*qy)%CORESIZE)
qz      equ 2108 ;3592;2108
qy      equ 243  ;3511;243         ;qy*(qz-1)=1


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
        jmp     q0              , 0

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
        jmp     bBoot           , <3623
end qgo


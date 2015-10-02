;redcode-94nop
;name Reepicheep
;author Grabun/Metcalf
;strategy Q^4 -> Stone/Paper
;assert CORESIZE==8000

org qGo

sOff    equ     3941
pHit0   equ     7599
pDst0   equ     535
pDst1   equ     3875
pDst2   equ     5160

pGo     spl     1       , }qC
qTab2   spl     1       , }qD
        spl     1       , }qE

pSilk0  spl     @0      , >pDst0
        mov     }pSilk0 , >pSilk0
pSilk1  spl     pDst1   , 0
        mov     >pSilk1 , }pSilk1
        mov     pBmb    , >pHit0
        mov     <pSilk1 , <pSilk2
pSilk2  djn.f   @0      , >pDst2
pBmb    dat     >5334   , >2667

        for     20
        dat     0       , 0
        rof

step    equ     2777
time    equ     1425
hop     equ     31
bOff    equ     5

sSpl    spl     #0      , #0
ptr     mov     bomb    , }-(step*time)+1
        mov     bomb    , @ptr
a       add     #step   , @-1
sLoo    djn.f   ptr     , {-1500

        for     5
        dat     0       , 0
        rof

bomb    dat     >hop    , >1

        dat     0       , 0

bBoot   mov     sSpl    , sOff-6-CURLINE
        mov     bomb    , sOff+5-CURLINE
        spl     2       , }qA
qTab1   spl     2       , }qB
sDst    spl     1       , sOff-CURLINE
        mov     <sSrc   , <sDst
        djn     @bBoot  , #5
sSrc    jmp     pGo     , sLoo+1

        for     23
        dat     0       , 0
        rof

        qX      equ     3080
        qA      equ     3532
        qB      equ     2051
        qC      equ     6177
        qD      equ     4696
        qE      equ     3215
        qF      equ     583

        qStep   equ     7
        qTime   equ     16
        qOff    equ     87

qBomb   dat     {qOff   , qF

qGo     sne     qPtr+qX*qE      , qPtr+qX*qE+qE
        seq     <qTab2+1        , qPtr+qX*(qE-1)+(qE-1)
        jmp     qDec            , }qDec+2
        sne     qPtr+qX*qF      , qPtr+qX*qF+qD
        seq     <qBomb          , qPtr+qX*(qF-1)+qD
        jmp     qDec            , }qDec
        sne     qPtr+qX*qA      , qPtr+qX*qA+qD
        seq     <qTab1-1        , qPtr+qX*(qA-1)+qD
        djn.a   qDec            , {qDec
        sne     qPtr+qX*qB      , qPtr+qX*qB+qD
        seq     <qTab1          , qPtr+qX*(qB-1)+qD
        djn.a   qDec            , *0
        sne     qPtr+qX*qC      , qPtr+qX*qC+qC
        seq     <qTab2-1        , qPtr+qX*(qC-1)+(qC-1)
        jmp     qDec            , {qDec+2
        sne     qPtr+qX*qD      , qPtr+qX*qD+qD
        jmz.f   bBoot           , <qTab2

qDec    mul.b   *2      , qPtr
qSkip   sne     <qTab1  , @qPtr
        add.b   qTab2   , qPtr
qLoop   mov     qBomb   , @qPtr
qPtr    mov     qBomb   , }qX
        sub     #qStep  , @qSkip
        djn     qLoop   , #qTime
        djn.f   bBoot   , #0

        end

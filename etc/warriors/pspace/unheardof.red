;redcode-94nop
;name unheard-of
;author Christian Schmidt
;strategy ****************
;strategy * - quickscan  *
;strategy * - boot       *
;strategy * - silk-dwarf *
;strategy * - paper/imps *
;strategy ****************
;strategy test version only
;assert 1

pStep  equ    558
sStep  equ    2579
iStep  equ    286
bStep  equ    4419
iSize  equ    2667

org qGo

pGo     spl     2,              }qC
qTab2   spl     1,              }qD
        spl     1,              }qE

        mov.i   <pBo,           {pBo
pBo     spl     pGo+955,       pEnd+1
        mov.i   <iBo,           {iBo
iBo     jmp     pGo+1566,       iEnd+1

        for     5
        dat     0,              0
        rof

        spl     @0,             <pStep
        mov.i   }-1,            >-1
        spl     #sStep,         >-sStep
        mov     {sStep,         {-sStep+1
        add     -2,             -1
pEnd    djn.f   @0,             {-2

        for     11
        dat     0,              0
        rof

        spl     @0,             >iStep
        mov     }-1,            >-1
        spl     @0,             <iSize+1
        mov     }-1,            >-1
        mov.i   #bStep,         {0
iEnd    mov.i   #iSize,         *0

        for     10
        dat     0,              0
        rof

        dat     0,              }qA
qTab1   dat     0,              }qB

        for     27
        dat     0,              0
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

qBomb   dat     {qOff,          qF

qGo     sne     qPtr+qX*qE,     qPtr+qX*qE+qE
        seq     <qTab2+1,       qPtr+qX*(qE-1)+(qE-1)
        jmp     qDec,           }qDec+2

        sne     qPtr+qX*qF,     qPtr+qX*qF+qD
        seq     <qBomb,         qPtr+qX*(qF-1)+qD
        jmp     qDec,           }qDec

        sne     qPtr+qX*qA,     qPtr+qX*qA+qD
        seq     <qTab1-1,       qPtr+qX*(qA-1)+qD
        djn.a   qDec,           {qDec

        sne     qPtr+qX*qB,     qPtr+qX*qB+qD
        seq     <qTab1,         qPtr+qX*(qB-1)+qD
        djn.a   qDec,           *0

        sne     qPtr+qX*qC,     qPtr+qX*qC+qC
        seq     <qTab2-1,       qPtr+qX*(qC-1)+(qC-1)
        jmp     qDec,           {qDec+2

        sne     qPtr+qX*qD,     qPtr+qX*qD+qD
        jmz.f   pGo,            <qTab2

qDec    mul.b   *2,             qPtr
qSkip   sne     <qTab1,         @qPtr
        add.b   qTab2,          qPtr
qLoop   mov     qBomb,          @qPtr
qPtr    mov     qBomb,          }qX
        sub     #qStep,         @qSkip
        djn     qLoop,          #qTime
        djn.f   pGo,            #0

        end

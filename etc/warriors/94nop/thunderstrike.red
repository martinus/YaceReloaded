;redcode-94nop
;author Lukasz Grabun
;assert (CORESIZE==8000)
;name Thunderstrike
;strategy Q^4 -> Stone/Imp

orig  z for 0
        rof

; -- imp constants

istep   equ     (2667)            ; 3-point imps
ioff    equ     (6338+orig)       ; imp launcher offset

qBmb    dat     {qOff , #qF

; -- imp launcher

pump    SPL.B   #imp            , #imp+1
        SUB.F   #-istep-1       , iloop
        MOV.I   imp             , }pump
iloop   JMP.B   imp-2*(istep+1) , >imp+2*istep-1
imp     MOV.I   #0              , istep

; -- stone constants

step    equ     (3510)
hop     equ     (46)

gate    equ     (inc-6)

from    equ     (0+step)
hit     equ     (loop-step-hop)

soff    equ     (2498+ioff)     ; stone offset

; -- stone

inc     SPL.B   #step   , <-step
        MOV.I   {from   , <hit
        MOV.I   bomb    , @-1
        ADD.F   inc     , -2
loop    DJN.F   -3      , <-step+inc
        MOV.I   bomb    , >gate
        DJN.F   -1      , >gate
bomb    DAT.F   >5335   , hop+1

; -- boot

boot    MOV.I  bomb     , soff
        MOV.I  {boot    , <boot
        MOV.I  {boot    , <boot
        SPL.B  }2       , }qC
qTab2   SPL.B  *1       , }qD
        SPL.B  0        , }qE
        MOV.I  {boot    , <boot
        MOV.I  <pump    , {qTab1
        DJN.B  @boot    , #5
        JMP.B  ioff-5   , #qA
qTab1   DAT.F  ioff     , #qB

for 46
dat 0,0
rof

; -- qscan constants

qX      equ 6844
qA      equ 6390
qB      equ 5097
qC      equ 6148
qD      equ 4855
qE      equ 3562
qF      equ 4129

qStep   equ         7
qTime   equ        16
qOff    equ        87

; -- qscan

qGo   seq    qPtr+qX          , qPtr+qX+qD
      jmp    qSkip            , {qPtr+qX+qStep
      sne    qPtr+qX*qE       , qPtr+qX*qE+qE
      seq    <qTab2+1         , qPtr+qX*(qE-1)+(qE-1)
      jmp    qDec             , }qDec+2
      sne    qPtr+qX*qF       , qPtr+qX*qF+qD
      seq    <qBmb            , qPtr+qX*(qF-1)+qD
      jmp    qDec             , }qDec
      sne    qPtr+qX*qA       , qPtr+qX*qA+qD
      seq    <qTab1-1         , qPtr+qX*(qA-1)+qD
      djn.a  qDec             , {qDec
      sne    qPtr+qX*qB       , qPtr+qX*qB+qD
      seq    <qTab1           , qPtr+qX*(qB-1)+qD
      jmp    qDec             , {qDec
      sne    qPtr+qX*qC       , qPtr+qX*qC+qC
      seq    <qTab2-1         , qPtr+qX*(qC-1)+(qC-1)
      jmp    qDec             , {qDec+2
      seq    qPtr+qX*(qC-2)   , qPtr+qX*(qC-2)+(qC-2)
      djn    qDec             , {qDec+2
      sne    qPtr+qX*qD       , qPtr+qX*qD+qD
      jmz.f  boot             , <qTab2

qDec    mul.b  *   2 ,  qPtr
qSkip   sne    *qTab1, @qPtr
        add.b   qTab2,  qPtr
qLoop   mov     qBmb , @qPtr
qPtr    mov     qBmb , }qX
        sub    #qStep, @qSkip
        djn     qLoop, #qTime
        jmp     boot , 0

        end     qGo


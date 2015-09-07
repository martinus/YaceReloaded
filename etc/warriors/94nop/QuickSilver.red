;redcode-94
;name Quicksilver
;author Michal Janeczek
;strategy Q^4 -> stone/imp
;assert 1

      org    qGo

hStep equ    3039
hTime equ    3360
hDjn  equ    2813
hOff  equ    5
hDist equ    2868

iStep equ    2667
iTime equ    101
iDjn  equ    4774
iOff  equ    hDist+398-iDist
iDist equ    (hDist+2+hStep*(iTime-hTime))

qX    equ    2922
qA    equ    5673
qB    equ    1154
qC    equ    787
qD    equ    4268
qE    equ    7749
qF    equ    1825

qStep equ    7
qTime equ    16
qOff  equ    87

qBomb dat    {qOff            , qF

pGo   mov    hBomb            , hBoot+hDist+hOff
      spl    2                , }qC     
qTab2 spl    2                , }qD     
      spl    1                , }qE     
      mov    {pGo             , {hBoot
      mov    {pGo             , {iBoot
hBoot djn    hDist            , #5
iBoot djn.f  hBoot+iDist      , #qA

qTab1 spl    #iPump+iOff      , }qB
      sub.f  #-(iStep+1)      , iJump
iPump mov    iImp             , }qTab1
iJump djn.f  iOff-2*(iStep+1) , {iDjn
iImp  mov.i  #0               , iStep

      spl    #0               , 0
hLoop mov    hBomb+hOff       , @hPtr
hHit  add    #hStep*2         , hPtr
hPtr  mov    hBomb+hOff       , }hHit-hStep*hTime
      djn.f  hLoop            , <hDjn
hBomb dat    hStep            , >1

      for    51
      dat    0                , 0
      rof

qGo   seq    qPtr+qX          , qPtr+qX+qD
      jmp    qSkip            , {qPtr+qX+qStep
      sne    qPtr+qX*qE       , qPtr+qX*qE+qE
      seq    <qTab2+1         , qPtr+qX*(qE-1)+(qE-1)
      jmp    qDec             , }qDec+2
      sne    qPtr+qX*qF       , qPtr+qX*qF+qD
      seq    <qBomb           , qPtr+qX*(qF-1)+qD
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
      jmz.f  pGo              , <qTab2

qDec  mul.b  *2               , qPtr
qSkip sne    *qTab1           , @qPtr
      add.b  qTab2            , qPtr
qLoop mov    qBomb            , @qPtr
qPtr  mov    qBomb            , }qX
      sub    #qStep           , @qSkip
      djn    qLoop            , #qTime
      djn.f  pGo              , #0

      end

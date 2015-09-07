;redcode-94
;name Behemot
;author Michal Janeczek
;strategy MiniQ^3 -> Stun bomber
;assert CORESIZE==8000

       org   qGo

bStep  equ   2223
bDrop  equ   382

bDist  equ   3250
bcOff  equ   51
bgOff  equ   17

bRun   equ   (bHit-bInc*bDrop)
bGate  equ   (bClr-bgOff)
bSpl   equ   (bHit-2*bInc)+1
bJmp   equ   (bHit-2*bInc)-1
bInc   equ   3*bStep

bStart mov.i {0             , #0
bLoop  mov   bSpl           , <bPtr
       mov   bJmp           , *bPtr
bPtr   mov   bRun-bStep     , @bRun+bStep+1
bHit   add   *bEvac         , bPtr
       mov   >bJmp          , @bPtr
       jmz.a bLoop          , <bJmp
bEvac  jmp   -bcOff         , <1-bcOff-bgOff

bGo    spl   1              , bWipe+5
bcDst  spl   1              , bDist+4+bEvac-bcOff
       mov   <bGo           , <bbDst
       mov   <bGo           , <bcDst
       mov   <bBoot         , {bBoot
       mov   <bBoot         , {bBoot
bbDst  mov.i bGo            , #bDist+2+bSpl
bBoot  jmp   >bDist+bEvac+1 , bEvac+1

       spl   #bInc          , <bInc+1
bClr   mov   bWipe          , >bGate
       djn.f bClr           , >bGate
bWipe  dat   <2667          , 2-bGate

       jmp   bStep          , {1
       mov   @0             , }-1
       spl   #2             , -bStep

       for   35
       dat   0              , 0
       rof

qf     equ   qKil
qs     equ   222
qd     equ   322
qi     equ   7
qr     equ   11

qGo    seq   qd+qf+qs       , qf+qs
       jmp   qSki           , {qd+qf+qs+qi
       seq   qd+qf+6*qs     , qf+6*qs
       jmp   qFas           , {qd+qf+6*qs+qi
       seq   qd+qf+5*qs     , qf+5*qs
       jmp   qFas           , <qBmb
       seq   qd+qf+7*qs     , qf+7*qs
       jmp   qFas           , >qBmb
       seq   qd+qf+9*qs     , qf+9*qs
       djn   qFas           , {qFas
       seq   qd+qf+10*qs    , qf+10*qs
       jmp   qFas           , {qFas
       seq   qd+qf+3*qs     , qf+3*qs
       jmp   >qFas          , {qd+qf+3*qs+qi
       seq   qd+qf+2*qs     , qf+2*qs
       jmp   >qFas          , {qSlo
       seq   qd+qf+4*qs     , qf+4*qs
       jmp   >qFas          , }qSlo
       seq   qd+qf+12*qs    , qf+12*qs
       jmp   qSlo           , {qSlo
       seq   qd+qf+15*qs    , qf+15*qs
       jmp   qSlo           , <qBmb
       seq   qd+qf+21*qs    , qf+21*qs
       jmp   qSlo           , >qBmb
       seq   qd+qf+24*qs    , qf+24*qs
       jmp   qSlo           , }qSlo
       seq   qd+qf+27*qs    , qf+27*qs
       djn   qSlo           , {qFas
       seq   qd+qf+30*qs    , qf+30*qs
       jmp   qSlo           , {qFas
       sne   qd+qf+18*qs    , qf+18*qs
       jmz.f bGo            , qd+qf+18*qs-10
qSlo   mul.ab #3            , qKil
qFas   mul.b qBmb           , @qSlo
qSki   sne   >3456          , @qKil
       add   #qd            , qKil
qLoo   mov   qBmb           , @qKil
qKil   mov   qBmb           , *qs
       sub   #qi            , qKil
       djn   qLoo           , #qr
       jmp   bGo            , >10
qBmb   dat   {qi*qr-10      , {6

       end


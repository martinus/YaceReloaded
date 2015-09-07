;redcode-94nop
;name Firestorm
;author John Metcalf
;strategy MiniQ^3 -> Paper
;assert CORESIZE==8000

iStep equ 1143
pStep equ 2044
sStep equ 1819

pGo2:spl 1
     spl 1
     spl 1
pap1:spl   @0,          }pStep
     mov.i }pap1,       >pap1
     spl   #0,          0
     mov   bomb,        >ptr
     add.x imp,         ptr
ptr: jmp   imp-iStep*8, >sStep-6
bomb:dat   <1,          {1
imp: mov.i #sStep-1,    iStep


     for   15
     dat   0,0
     rof

     qf equ qKil
     qs equ (-250)
     qd equ (-125)
     qi equ 7
     qr equ 11

qGo: seq   qd+qf+qs,    qf+qs
     djn.f qSki,        {qd+qf+qs+qi
     seq   qd+qf+6*qs,  qf+6*qs
     djn.f qFas,        {qd+qf+6*qs+qi
     seq   qd+qf+5*qs,  qf+5*qs
     jmp   qFas,        <qBmb
     seq   qd+qf+7*qs,  qf+7*qs
     jmp   qFas,        >qBmb
     seq   qd+qf+9*qs,  qf+9*qs
     djn   qFas,        {qFas
     seq   qd+qf+10*qs, qf+10*qs
     jmp   qFas,        {qFas
     seq   qd+qf+3*qs,  qf+3*qs
     djn.f >qFas,       {qd+qf+3*qs+qi
     seq   qd+qf+2*qs,  qf+2*qs
     jmp   >qFas,       {qSlo
     seq   qd+qf+4*qs,  qf+4*qs
     jmp   >qFas,       }qSlo
     seq   qd+qf+12*qs, qf+12*qs
     jmp   qSlo,        {qSlo
     seq   qd+qf+15*qs, qf+15*qs
     jmp   qSlo,        <qBmb
     seq   qd+qf+21*qs, qf+21*qs
     jmp   qSlo,        >qBmb
     seq   qd+qf+24*qs, qf+24*qs
     jmp   qSlo,        }qSlo
     seq   qd+qf+27*qs, qf+27*qs
     djn   qSlo,        {qFas
     seq   qd+qf+30*qs, qf+30*qs
     jmp   qSlo,        {qFas
     sne   qd+qf+18*qs, qf+18*qs
     jmz.f pGo,         qd+qf+18*qs-10

qSlo:mul.ab #3,         qKil
qFas:mul.b qBmb,        @qSlo
qSki:sne   >594,        @qKil
     add   #qd,         qKil
qLoo:mov   *qKil,       @qKil
qKil:mov   qBmb,        *qs
     sub   #qi,         qKil
     djn   qLoo,        #qr
     djn.f pGo,         <10
qBmb:dat   {qi*qr-10,   {6

        for     20
        dat     0,0
        rof

sOff    equ     3941
pHit0   equ     7599
pDst0   equ     535
pDst1   equ     3875
pDst2   equ     5160

pGo     spl     pGo2
        spl     1
        spl     1
        spl     1

pSilk0  spl     @0      , >pDst0
        mov     }pSilk0 , >pSilk0
pSilk1  spl     pDst1   , 0
        mov     >pSilk1 , }pSilk1
        mov     pBmb    , >pHit0
        mov     <pSilk1 , <pSilk2
pSilk2  djn.f   @0      , >pDst2
pBmb    dat     >5334   , >2667

        end qGo


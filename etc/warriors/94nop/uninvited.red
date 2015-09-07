;redcode-94 quiet
;name Uninvited
;author John Metcalf
;strategy Mini-Q^3 -> Stone / Delayed Imp
;assert CORESIZE==8000

     org qGo

     sBoot equ (uPtr+2093)
     iBoot equ (sBoot+uStp)

pGo: spl   2,           >-200      ; 6 processes
     spl   1,           >-350
     spl   1,           {-500
     mov   <uBmb,       {iPos      ; launch imp
     mov   {sPtr,       {sPos      ; launch stone
sPos:djn   sBoot+6,     #6         ; 5 processes for the stone
iPos:jmp   iBoot+6,     >-650      ; and 1 process for the imp

     uStp equ 703
     uTim equ 1183

     spl   #0,       #0
uLp: mov   uBmb,     @uPtr
uHit:sub.x #uStp*2,  @uLp
uPtr:mov   {3582,    }uHit+2*uStp*uTim
     djn.f @uHit,    }uPtr
uBmb:dat   <uStp,    >1+6

     iStep equ 2667                ; 3-point imps

sPtr:djn   #0,          #5         ; wait a while
iPmp:spl   #iImp,       >-20
     sub.f #-iStep-1,   iJmp
     mov   iImp,        }iPmp
iJmp:jmp   iImp-2*(iStep+1),>iImp+2*iStep-1
iImp:mov.i #iStep/2,    iStep

     for   39
     dat   0,0
     rof

     qf equ qKil
     qs equ 222
     qd equ 322
     qi equ 7
     qr equ 11

;    -+)>] 0/1 cycles [(<+-

qGo: seq   qd+qf+qs,    qf+qs      ; 1
     djn.f qSki,        {qd+qf+qs+qi
     seq   qd+qf+6*qs,  qf+6*qs    ; B
     djn.f qFas,        {qd+qf+6*qs+qi
     seq   qd+qf+5*qs,  qf+5*qs    ; B-1
     jmp   qFas,        <qBmb
     seq   qd+qf+7*qs,  qf+7*qs    ; B+1
     jmp   qFas,        >qBmb
     seq   qd+qf+9*qs,  qf+9*qs    ; A-1
     djn   qFas,        {qFas
     seq   qd+qf+10*qs, qf+10*qs   ; A
     jmp   qFas,        {qFas

;    -+>)] 2 cycles [(<+-

     seq   qd+qf+3*qs,  qf+3*qs    ; C
     djn.f >qFas,       {qd+qf+3*qs+qi
     seq   qd+qf+2*qs,  qf+2*qs    ; C-1
     jmp   >qFas,       {qSlo
     seq   qd+qf+4*qs,  qf+4*qs    ; C+1
     jmp   >qFas,       }qSlo
     seq   qd+qf+12*qs, qf+12*qs   ; B*C-B
     jmp   qSlo,        {qSlo
     seq   qd+qf+15*qs, qf+15*qs   ; B*C-C
     jmp   qSlo,        <qBmb
     seq   qd+qf+21*qs, qf+21*qs   ; B*C+C
     jmp   qSlo,        >qBmb
     seq   qd+qf+24*qs, qf+24*qs   ; B*C+B
     jmp   qSlo,        }qSlo
     seq   qd+qf+27*qs, qf+27*qs   ; A*C-C
     djn   qSlo,        {qFas
     seq   qd+qf+30*qs, qf+30*qs   ; A*C
     jmp   qSlo,        {qFas
     sne   qd+qf+18*qs, qf+18*qs   ; B*C
     jmz.f pGo,         qd+qf+18*qs-10

qSlo:mul   #3,          qKil       ; C=3
qFas:mul.b qBmb,        @qSlo
qSki:sne   >qf+23*qs,   >qKil
     add   #qd,         qKil
qLoo:mov   *qKil,       <qKil
qKil:mov   qBmb,        }qs
     sub   #qi-1,       @qLoo
     djn   qLoo,        #qr
     djn.f pGo,         #10        ; A=10
qBmb:dat   {qi*qr-10,   {6         ; B=6
     end


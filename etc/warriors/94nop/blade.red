;redcode-94
;name Blade
;author Fizmo
;strategy Q^3 -> scanner
;assert 1
 
step EQU 5620
gate EQU top
away EQU (clr+363) 

ptr:  mov.i  inc+1,>step
top:  mov.i  bomb,>ptr
scan: seq.i  2*step,2*step+8
      mov.ab scan,@top
a:    sub.f  inc,scan
      jmn.b  top,@top
inc:  spl.i  #-step,>-step
      mov.i  clr,>gate
btm:  djn.f  -1,>gate
clr:  dat.f  <2667,clr-gate+2
      dat 0,0
      spl.i  #-step,>-step
      dat 0,0
bomb: spl #1, #1
      dat 0,0
      dat 0,0
      mov.i  {-3,<6
      dat 0,0

 for 40
     dat   0,0
  rof

org qGo

qf     equ qKil
qs     equ (qd*2)
qd     equ 107
qi     equ 7
qr     equ 11

qGo: seq   qd+qf+qs,    qf+qs 
     jmp   qSki,        {qd+qf+qs+qi
     seq   qd+qf+6*qs,  qf+6*qs 
     jmp   qFas,        {qd+qf+6*qs+qi
     seq   qd+qf+5*qs,  qf+5*qs
     jmp   qFas,        <qBmb
     seq   qd+qf+7*qs,  qf+7*qs
     jmp   qFas,        >qBmb
     seq   qd+qf+9*qs,  qf+9*qs
     djn   qFas,        {qFas
     seq   qd+qf+10*qs, qf+10*qs
     jmp   qFas,        {qFas
     seq   qd+qf+3*qs,  qf+3*qs
     jmp   >qFas,       {qd+qf+3*qs+qi
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
     jmz.f scan,         qd+qf+18*qs-10

qSlo:mul.ab #3,         qKil
qFas:mul.b qBmb,        @qSlo
qSki:sne   >3456,       @qKil
     add   #qd,         qKil
qLoo:mov   qBmb,        @qKil
qKil:mov   qBmb,        *qs
     sub   #qi,         qKil
     djn   qLoo,        #qr
     jmp   scan,         >10
qBmb:dat   {qi*qr-10,   {6 

end


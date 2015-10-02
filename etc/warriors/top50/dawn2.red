;redcode-94nop
;name Dawn 2
;author Roy van Rijn
;assert 1

bDist1  equ     6133
bDist2  equ     4122

pGo
        spl     1       , <3555
        spl     1       , <5335
        spl     1       , <2363

        mov     {pap1   , {1
pBoot1  spl     bDist1  , >5747

        mov     {pap    , {1
pBoot2  djn.f   bDist2  , >4584

for     14
        dat     0       , 0
rof

nstep1  equ     851
cstep1  equ     5170
tstep1  equ     3218

pap     spl     @8      , }tstep1
        mov.i   }pap    , >pap
nothA   spl     @nothA  , }cstep1
        mov.i   }nothA  , >nothA
nothB   spl     @nothB  , }nstep1
        mov.i   }nothB  , >nothB
        mov.i   #1138   , <1
        djn     -2      , <973

for     14
        dat     0               , 0
rof

iStep   equ     1143
pStep   equ     2044
sStep   equ     4903

pap1    spl     @8              , }pStep
        mov.i   }pap1           , >pap1
        spl     #0              , 0
        mov     bomb            , >ptr
        add.x   imp             , ptr
ptr     jmp     imp-iStep*8     , >sStep-6
bomb    dat     >1              , }1
imp     mov.i   #sStep-1        , iStep

for     7
        dat     0               , 0
rof

;constants for the quickscanner
qf 	equ 	qKil
qs      equ     200
qd 	equ 	4000
qi      equ     14
qr      equ     8
qBmb	dat    {qi*qr-10, {1
qGo  	seq    qd+qf+qs, qf+qs
     	jmp    qSki, {qd+qf+qs+qi+2
     	sne    qd+qf+5*qs, qf+5*qs
     	seq    qf+4*qs, {qTab
	jmp    qFas, }qTab
     	sne    qd+qf+8*qs, qf+8*qs
     	seq    qf+7*qs, {qTab-1
     	jmp    qFas, {qFas
	sne    qd+qf+10*qs, qf+10*qs
     	seq    qf+9*qs, {qTab+1
	jmp    qFas, }qFas
	seq    qd+qf+2*qs, qf+2*qs
	jmp    qFas, {qTab
	seq    qd+qf+6*qs, qf+6*qs
	djn.a  qFas, {qFas
	seq    qd+qf+3*qs, qf+3*qs
      jmp    qFas, {qd+qf+3*qs+qi+2
	sne    qd+qf+14*qs, qf+14*qs
	seq    qf+13*qs, <qTab
	jmp    qSlo, >qTab
	sne    qd+qf+17*qs, qf+17*qs
	seq    qf+16*qs, <qTab-1
	jmp    qSlo, {qSlo
	seq    qd+qf+11*qs, qf+11*qs
	jmp    qSlo, <qTab
	seq    qd+qf+15*qs, qf+15*qs
	djn.b  qSlo, {qSlo
	sne    qd+qf+12*qs, qf+12*qs
	jmz    pGo, qd+qf+12*qs-qi

qSlo  mov.ba qTab,   qTab
qFas  mul.ab qTab,   qKil
qSki  sne    qBmb-1, @qKil
      add    #qd,    qKil
qLoo  mov.i  qBmb,   @qKil
qKil  mov.i  qBmb,   *qs
      sub.ab #qi,    qKil
      djn    qLoo,   #qr
      jmp    pGo,    <-4000
      dat    5408,   7217
qTab  dat    4804,   6613
dSrc  dat    5810,   qBmb-5
end   qGo


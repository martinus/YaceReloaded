;redcode-94nop
;name HazyLazy C 11
;author CS SG
;strategy Mod 10 cmp scanner shifting to D-Clear
;strategy Q4(?) scan an constants by Christian
;assert 1
 
step    equ    7170
gate    equ    top
pBoot   equ    1820
 
zero    equ     qbomb
qtab3   equ     qbomb
 
qbomb   dat     >qoff,          >qc2
        dat     0,              0
 
bPtr    dat     clr+1,          }qb1
qtab2   dat     clr+pBoot+1,    }qb2
pGo     spl     1,              }qb3

    for 5
        mov.i   {bPtr,          {qtab2
    rof
        djn     scan+pBoot,     #1
        mov.i   bomb,           bomb+pBoot
 
    for 9
        dat 0, 0
    rof
 
        dat     zero - 1,       qa1
qtab1   dat     zero - 1,       qa2
 
ptr   mov.i  inc+1,   >step
top   mov.i  bomb,    >ptr
scan  seq.i  2*step,  2*step+8
      mov.ab scan,    @top
a     sub.f  inc,     scan
      jmn.b  top,     @top
inc   spl.i  #-step,  >-step
      mov.i  clr,     >gate
btm   djn.f  -1,      >gate
clr   dat.f  <2667,   clr-gate+2
 
for   3
      dat    0,       0
rof
 
bomb  spl    #1,      #1
 
 for 28
 dat 0, 0
 rof
 
qc2 equ ((1 + (qtab3-qptr)*qy) % CORESIZE)
qb1 equ ((1 + (qtab2-1-qptr)*qy) % CORESIZE)
qb2 equ ((1 + (qtab2-qptr)*qy) % CORESIZE)
qb3 equ ((1 + (qtab2+1-qptr)*qy) % CORESIZE)
qa1 equ ((1 + (qtab1-1-qptr)*qy) % CORESIZE)
qa2 equ ((1 + (qtab1-qptr)*qy) % CORESIZE)
qz equ 2108
qy equ 243
; qy * (qz-1) = 1
 
;q0 mutation
qgo sne qptr + qz*qc2, qptr + qz*qc2 + qb2
 seq <qtab3, qptr + qz*(qc2-1) + qb2
 jmp q0, }q0
 sne qptr + qz*qa2, qptr + qz*qa2 + qb2
 seq <qtab1, qptr + qz*(qa2-1) + qb2
 jmp q0, {q0
 sne qptr + qz*qa1, qptr + qz*qa1 + qb2
 seq <(qtab1-1), qptr + qz*(qa1-1) + qb2
 djn.a q0, {q0
;q1 mutation
 sne qptr + qz*qb3, qptr + qz*qb3 + qb3
 seq <(qtab2+1), qptr + qz*(qb3-1) + (qb3-1)
 jmp q0, }q1
 sne qptr + qz*qb1, qptr + qz*qb1 + qb1
 seq <(qtab2-1), qptr + qz*(qb1-1) + (qb1-1)
 jmp q0, {q1
;no mutation
 sne qptr + qz*qb2, qptr + qz*qb2 + qb2
 seq <qtab2, qptr + qz*(qb2-1) + (qb2-1)
 jmp q0
;qz mutation
 seq >qptr, qptr + qz + (qb2-1)
 jmp q2, <qptr
;q0 mutation
seq qptr+(qz+1)*(qc2-1),qptr+(qz+1)*(qc2-1)+(qb2-1)
 jmp q0, }q0
seq qptr+(qz+1)*(qa2-1),qptr+(qz+1)*(qa2-1)+(qb2-1)
 jmp q0, {q0
seq qptr+(qz+1)*(qa1-1),qptr+(qz+1)*(qa1-1)+(qb2-1)
 djn.a q0, {q0
;no mutation
 jmz.f pGo, qptr + (qz+1)*(qb2-1) + (qb2-1)
 
qoff equ -87
qstep equ -7
qtime equ 14
 
q0 mul.b *2, qptr
q2 sne {qtab1, @qptr
q1 add.b qtab2, qptr
 mov qtab3, @qptr
qptr mov qbomb, }qz
 sub #qstep, qptr
 djn -3, #qtime
 jmp pGo
 
end qgo
 

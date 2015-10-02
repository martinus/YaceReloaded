;redcode-94nop
;name DanceOfFallenAngels
;author Nenad Tomasev
;assert CORESIZE==8000
;strategy stone/paper
;strategy a improved Starfall

ps1 equ 1082
ps2 equ 2877
ps3 equ 4043
bs equ 3850

step equ 1471
ini equ (step-2)
ds equ 3323

pbd equ 737
sdist equ 4754
sbd equ (pbd+sdist)
c1 equ 6144
c2 equ 4146

zero equ qbomb
qtab3 equ qbomb


 org qgo
qbomb   dat >qoff, >qc2
 dat 0, 0
boot spl 1, {qb1
qtab2 spl 1, {qb2
 spl 1, {qb3
 mov <sgo, {sgo
sgo spl sbomb+sbd+1, sbomb+1
 spl *sgo, }c1
 mov {p, {pgo
pgo djn.f (b+1+pbd), {c2
 for 7
 dat 0, 0
 rof
        dat zero-1, qa1
qtab1   dat zero-1, qa2
 for 9
 dat 0, 0
 rof
p spl @(b+1), >ps1
 mov }-1, >-1
p1 spl @0, >ps2
 mov }-1, >-1
 mov.i b, >bs
 mov {p1, {1
 jmz.a ps3, *0
b dat <2667, <5334
 for 5
 dat 0, 0
 rof
stone spl #-3*step, >-3*step
 mov.i sbomb, @shoot
 sub.f stone, @-1
shoot mov.i }ini, }ini+step
 djn.f (stone+1), <ds
 for 2
 dat 0, 0
 rof
sbomb dat >step, >1
 for 16
 dat 0, 0
 rof


qc2 equ ((1+(qtab3-qptr)*qy)%CORESIZE)
qb1 equ ((1+(qtab2-1-qptr)*qy)%CORESIZE)
qb2 equ ((1+(qtab2-qptr)*qy)%CORESIZE)
qb3 equ ((1+(qtab2+1-qptr)*qy)%CORESIZE)
qa1 equ ((1+(qtab1-1-qptr)*qy)%CORESIZE)
qa2 equ ((1+(qtab1-qptr)*qy)%CORESIZE)
qz equ 2108
qy equ 243         ;qy*(qz-1)=1


;q0 mutation
qgo     sne qptr+qz*qc2, qptr+qz*qc2+qb2
        seq <qtab3, qptr+qz*(qc2-1)+qb2
        jmp q0, }q0
        sne qptr+qz*qa2, qptr+qz*qa2+qb2
        seq <qtab1, qptr+qz*(qa2-1)+qb2
        jmp q0, {q0
        sne qptr+qz*qa1, qptr+qz*qa1+qb2
        seq <(qtab1-1), qptr+qz*(qa1-1)+qb2
        djn.a q0, {q0
                                        ;q1 mutation
        sne qptr+qz*qb3, qptr+qz*qb3+qb3
        seq <(qtab2+1), qptr+qz*(qb3-1)+(qb3-1)
        jmp q0, }q1
        sne qptr+qz*qb1, qptr+qz*qb1+qb1
        seq <(qtab2-1), qptr+qz*(qb1-1)+(qb1-1)
        jmp q0, {q1

        sne qptr+qz*qb2, qptr+qz*qb2+qb2
        seq <qtab2, qptr+qz*(qb2-1)+(qb2-1)
        jmp q0
                                        ;qz mutation
        seq >qptr, qptr+qz+(qb2-1)
        jmp q2, <qptr
                                        ;q0 mutation
        seq qptr+(qz+1)*(qc2-1), qptr+(qz+1)*(qc2-1)+(qb2-1)
        jmp q0, }q0
        seq qptr+(qz+1)*(qa2-1), qptr+(qz+1)*(qa2-1)+(qb2-1)
        jmp q0, {q0
        seq qptr+(qz+1)*(qa1-1), qptr+(qz+1)*(qa1-1)+(qb2-1)
        djn.a q0, {q0
        jmz.f boot, qptr+(qz+1)*(qb2-1)+(qb2-1)

qoff equ -86
qstep equ -7
qtime equ 19

q0      mul.b *2, qptr
q2      sne {qtab1, @qptr
q1      add.b qtab2, qptr
        mov qtab3, @qptr
qptr    mov qbomb, }qz
        sub #qstep, qptr
        djn -3, #qtime
        djn.f boot, #0
 end


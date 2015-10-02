;redcode-94nop verbose
;name Gods Of Destiny
;author Nenad Tomasev
;assert CORESIZE==8000
;strategy stone/paper
;strategy high expectations
;strategy I hope I won't get
;strategy disappointed this time
;strategy CoreRW + qsilver stone

ps1 equ 4143
ps2 equ 1011
ps3 equ 7321
bs1 equ 5700
bs2 equ 3823

pbd equ 1208
c1 equ 3182
c2 equ 1092
sdist equ 3526

zero equ qbomb
qtab3 equ qbomb

hStep equ 3039
hTime equ 3360
hDjn equ 2813
hOff equ 5
hDist equ pbd+sdist



 org qgo
qbomb   dat >qoff, >qc2
boot mov hBomb, sgo+hDist+hOff
 spl 1, {qb1
qtab2 spl 1, {qb2
 spl 1, {qb3
 mov <sgo, {sgo
sgo spl hDist, hBomb
 spl *sgo, }c1
 mov {p1, {pgo
pgo djn.f (p3+1+pbd), {c2
 for 7
 dat 0, 0
 rof
        dat zero-1, qa1
qtab1   dat zero-1, qa2
 for 8
 dat 0, 0
 rof
p1 spl @(p3+1), >ps1
 mov }p1, >p1
p2 spl @0, >ps2
 mov }p2, >p2
 mov.i #1, {1
 mov.i bs1, }bs2
 mov {p2, {p3
p3 jmz.a ps3, *0
 for 8
 dat 0, 0
 rof
stone spl #0, 0
hLoop mov hBomb+hOff, @hPtr
hHit add #hStep*2, hPtr
hPtr mov hBomb+hOff, }hHit-hStep*hTime
 djn.f hLoop, <hDjn
 for 3
 dat 0, 0
 rof
hBomb dat hStep, >1
 for 13
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



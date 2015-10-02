;redcode-94nop verbose
;name LuckyMisfortune
;author Nenad Tomasev
;assert CORESIZE==8000
;strategy paper
;strategy suggested by Roy van Rijn
;strategy thanks, Roy!
;strategy not very original, I admit
;strategy but it seems to be efficient
;strategy I think that it'll score well
;strategy on the hill

ps1 equ 5529
ps2 equ 735
i1 equ 3343
i2 equ 1252
i3 equ 3495
istep equ 2667
ps3 equ istep+1
c1 equ 5976
c2 equ 5299
mbd equ 640
impbd equ 6295

zero equ qbomb
qtab3 equ qbomb


 org qgo
qbomb   dat >qoff, >qc2
 dat 0, 0
boot spl 1, {qb1
qtab2 spl 1, {qb2
 spl 1, {qb3
 mov {mp, {go1
go1 spl (mend+1+mbd), }c1
 mov {p1, {go2
go2 djn.f (imp+1+impbd), {c2
 for 8
 dat 0, 0
 rof
        dat zero-1, qa1
qtab1   dat zero-1, qa2
 for 8
 dat 0, 0
 rof
mp spl.b @(mend+1), >286
 mov.i }-1, >-1
 spl.b @0, <1040
 mov.i }-1, >-1
 spl.b @0, }1879
 mov.i }-1, >-1
 mov.i #-3581, {1
mend mov.i >705, }-10
 for 8
 dat 0, 0
 rof
p1 spl @(imp+1), >ps1
 mov }-1, >-1
p2 spl @0, >ps2
 mov }-1, >-1
 spl @0, >ps3
 mov }-1, >-1
 mov.i #i1, }i2
imp mov.i #i3, istep
 for 14
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



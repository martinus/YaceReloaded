;redcode-94nop verbose
;name WaterDragon
;author Nenad Tomasev
;assert CORESIZE==8000
;strategy stone/paper
;strategy based on my DifferentialOperatorWS
;strategy a test version... but nice scores.
;strategy this is my first optimaxed warrior
;strategy entered 94nop as 3. on 09.08.2005.
;strategy only three points behind HullaTwo :-)
;strategy died at age 50 :-(
;strategy because of the attack of several
;strategy s/d clear + imps (+stone) that did very well
;strategy against s/p's
;strategy well, I guess it wasn't optimized against
;strategy bad luck... but it's still one of my
;strategy favorites... I wonder how it'll score at
;strategy 94nop Koenigstuhl.

numproc equ 6
ps1 equ 1107
ps2 equ 1893
bs1 equ 6681

c1 equ 4855
c2 equ 5477
sbd equ 3904
pbd equ 698

sstep equ 6567
ini equ (sstep+3)
ds equ 3244
sptr equ (sbomb + sboff)
sboff equ 4

zero equ qbomb
qtab3 equ qbomb

 org qgo
qbomb   dat >qoff, >qc2
boot mov sbomb, (sbomb+sboff+sbd)
 spl 1, {qb1
qtab2 mov.i -1, #qb2
 spl 1, {qb3
 mov <sgo, {sgo
sgo spl (sbomb+sbd), sbomb
 spl *sgo, }c1
 mov {p1, {pgo
 mov {p1, {pgo
pgo djn.f (pbomb+4+pbd), {c2
 for 6
 dat 0, 0
 rof
        dat zero-1, qa1
qtab1   dat zero-1, qa2
 for 5
 dat 0, 0
 rof
stone spl #2*sstep, <2*sstep
 mov ini, ini+sstep
 mov sptr, *-1 ; hit with dat >-1, >1
 add.f stone, @-1
 djn.f @-2, <ds
 dat 0, 0
sbomb dat >-1, >1
 for 5
 dat 0, 0
 rof
p1 spl @(pbomb+4), >ps1
 mov }p1, >p1
 mov }p1, >p1
p2 spl ps2, {cpy
 mov }cpy, }p2
 mov pbomb, >bs1
cpy mov p2+numproc, }p2
 jmz.f p2, *cpy
pbomb dat <2667, <5334
 for 20
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


;redcode-94nop verbose
;name KryneLamiya_revisited
;author Nenad Tomasev
;assert CORESIZE==8000
;strategy oneshot

step equ 2005
ini equ 107

sbd equ 4000
moff equ 4

zero equ qbomb
qtab3 equ qbomb

 org qgo
qbomb   dat >qoff, >qc2
 dat 0, 0
 dat cend+1, {qb1
qtab2 dat cend+1+sbd, {qb2
 dat 0, {qb3
boot mov more, more+sbd+moff
 mov <sgo, {sgo
 mov {(qtab2-1), {qtab2
 mov <sgo, {sgo
 mov {(qtab2-1), {qtab2
 mov <sgo, {sgo
 mov {(qtab2-1), {qtab2
 djn.b boot+1, #2
sgo jmp more+sbd, more
 for 3
 dat 0, 0
 rof
        dat zero-1, qa1
qtab1   dat zero-1, qa2

 for 9
 dat 0, 0
 rof

pok dat ini+9, ini
b dat 1, 10
clr spl #400, 10
 mov *b, >pok
 mov *b, >pok
cend djn.f -2, }clr

 for 6
 dat 0, 0
 rof

inc add.f more+moff, @2
scan seq }pok, >pok
 sne *pok, @pok
 djn.f inc, *pok
 jmp clr, <pok

 dat 0, 0

more dat step, step

 for 18
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



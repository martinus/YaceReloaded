;redcode-94nop
;name Mascafe
;author G.Labarga
;assert 1
;Qscan -> Anti A-imp paper + bombing paper/imp

;----- Anti-imp paper:
dest1 equ 4723
dest2 equ 2803
dest3 equ 4135
x equ 3388
y equ 3870
;----- Paper/imp:
dest4 equ 6065
dec equ 5905
trail equ 6876
bstep equ 5353
;----- booot:
piloc equ boot+6133     ;927
ailoc equ boot+4122     ;2661-1000

zero equ qbomb
qtab3 equ qbomb

qbomb:  dat >qoff, >qc2
        dat 0,0
        dat 0,0

boot:   spl 1,<qb1
qtab2:  spl 1,<qb2
        spl 1,<qb3

        mov {pap2,{1
p1go:   spl *piloc,<-510
        mov {pap1,{1
p2go:   jmz.a *ailoc,*0

pap1:   spl @8,{dest1
        mov }-1,>-1
        spl @0,{dest2
        mov }-1,>-1
        mov.i #1,{1
        mov x,{y
        mov {-4,{1
        jmz.a *dest3,*0
for 3
        dat 0,0
rof
        dat zero-1,qa1
qtab1:  dat zero-1,qa2
for 19
        dat 0, 0
rof 
 pap2:   spl @8,<dest4
        mov }-1,>-1
head:   spl #-1143,<dec
        mov bmb,@igo
        sub.f head,igo
igo:    djn.f imp-(8*1143),{trail
bmb:    dat {bstep,<1
imp:    mov.i #3,1143
for 12+3
        dat 0,0
rof
qc2 equ ((1 + (qtab3-qptr)*qy) % CORESIZE)
qb1 equ ((1 + (qtab2-1-qptr)*qy) % CORESIZE)
qb2 equ ((1 + (qtab2-qptr)*qy) % CORESIZE)
qb3 equ ((1 + (qtab2+1-qptr)*qy) % CORESIZE)
qa1 equ ((1 + (qtab1-1-qptr)*qy) % CORESIZE)
qa2 equ ((1 + (qtab1-qptr)*qy) % CORESIZE)
qz equ 2108
qy equ 243

Qgo:    sne qptr + qz*qc2, qptr + qz*qc2 + qb2
        seq <qtab3, qptr + qz*(qc2-1) + qb2
        jmp q0, }q0
        sne qptr + qz*qa2, qptr + qz*qa2 + qb2
        seq <qtab1, qptr + qz*(qa2-1) + qb2
        jmp q0, {q0
        sne qptr + qz*qa1, qptr + qz*qa1 + qb2
        seq <(qtab1-1), qptr + qz*(qa1-1) + qb2
        djn.a q0, {q0
        sne qptr + qz*qb3, qptr + qz*qb3 + qb3
        seq <(qtab2+1), qptr + qz*(qb3-1) + (qb3-1)
        jmp q0, }q1
        sne qptr + qz*qb1, qptr + qz*qb1 + qb1
        seq <(qtab2-1), qptr + qz*(qb1-1) + (qb1-1)
        jmp q0, {q1
        sne qptr + qz*qb2, qptr + qz*qb2 + qb2
        seq <qtab2, qptr + qz*(qb2-1) + (qb2-1)
        jmp q0
        seq >qptr, qptr + qz + (qb2-1)
        jmp q2, <qptr
        seq qptr+(qz+1)*(qc2-1),qptr+(qz+1)*(qc2-1)+(qb2-1)
        jmp q0, }q0
        seq qptr+(qz+1)*(qa2-1),qptr+(qz+1)*(qa2-1)+(qb2-1)
        jmp q0, {q0
        seq qptr+(qz+1)*(qa1-1),qptr+(qz+1)*(qa1-1)+(qb2-1)
        djn.a q0, {q0
        jmz.f boot, qptr + (qz+1)*(qb2-1) + (qb2-1)

qoff equ -87
qstep equ -7
qtime equ 14 

q0:     mul.b *2, qptr
q2:     sne {qtab1, @qptr
q1:     add.b qtab2, qptr
        mov qtab3, @qptr
qptr:   mov qbomb, }qz
        sub #qstep, qptr
        djn -3, #qtime
        jmp boot,{0
end Qgo 


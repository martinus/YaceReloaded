;redcode-94nop
;name paper(paper(paper(clear)))
;author Sascha Zapf
;strategy Q4.5 -> Coreclearing Paper's
;assert 1

;optimax 1234
;optimax work ppp
;optimax suite fsh94nop0.2
;optimax rounds 1 200 200 200

;optimax phase2 fsh94nop0.2/pwi/unheard.red
;optimax phase2 110
;optimax phase2 0%

;optimax phase3 138
;optimax phase3 0%
;optimax phase3 top15
;optimax phase3 phase3.lst

;optimax phase4 100%
;optimax phase4 top15

zero    equ     qbomb
qtab3   equ     qbomb

qbomb   dat     >qoff,          >qc2

;constants for the coreclear paper
nstep1 equ 1469;1319
cstep1 equ 2861;1871
tstep1 equ 1835;1471

cstep2 equ 539;1871

; decoys
adec EQU 8;8
bdec EQU 13;8

pAw1   equ 2237;6000
pAw2   equ 6305;2000

pgo   spl    1,    <qb1
qtab2 spl    1,    <qb2
      spl    1,    <qb3

      mov    {cp,    {pBo1
pBo1  spl    pEnd+pAw1,{2093

      mov    }pBo1,    >pBo2    ;pBo1
pBo2  jmp    pEnd+pAw2,pEnd+pAw2

 for adec
    dat 0,0
    rof

cp    spl    @pEnd,  <tstep1
      mov.i  }cp,    >cp
nothA spl    @nothA, <cstep1
      mov.i  }nothA, >nothA
nothB spl    @nothB, <nstep1
      mov.i  }nothB, >nothB
bomb  mov.i  #1,     <1
cc    djn.b    -2,   #cstep2

pEnd  dat    0,      0

 for bdec
    dat 0,0
    rof

        dat     zero - 1,       qa1
qtab1   dat     zero - 1,       qa2

for 46-adec-bdec
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
qgo sne qptr + qz*qc2, qptr + qz*qc2 + qb2
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
 jmz.f pgo, qptr + (qz+1)*(qb2-1) + (qb2-1)
qoff equ -87
qstep equ -6;7
qtime equ 19;14
q0 mul.b *2, qptr
q2 sne {qtab1, @qptr
q1 add.b qtab2, qptr
 mov qtab3, @qptr
qptr mov qbomb, }qz
 sub #qstep, qptr
 djn -3, #qtime
 jmp pgo
end qgo


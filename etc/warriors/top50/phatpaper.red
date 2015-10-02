;redcode-94nop
;name PhatPaper
;author inversed
;strategy qScan -> paper
;assert (CORESIZE==8000) && (MAXPROCESSES==8000)

ofs0    equ     1129
ofs1    equ     1960
ofs2    equ     1294

a1      equ     6837
a2      equ     3786
a3      equ     2344

bd1     equ     2013
bd2     equ     4011

f       equ     3953
y       equ     1617    ;f*y=1

dq      equ     (y+1)%CORESIZE
qa1     equ     (1+f*(qt1-1-found))%CORESIZE
qa2     equ     (1+f*(qt1  -found))%CORESIZE
qb1     equ     (1+f*(qt2-1-found))%CORESIZE
qb2     equ     (1+f*(qt2  -found))%CORESIZE
qb3     equ     (1+f*(qt2+1-found))%CORESIZE
qc2     equ     (1+f*(qt3  -found))%CORESIZE

qt3     equ     qbomb

org     qgo
        
wgo     spl     1,      {qb1
qt2     spl     1,      {qb2
        spl     1,      {qb3

        spl     pb2,    0

pb1     mov     <bp1,   {bp1
bp1     jmp     silk2+1+bd1,    silk2+1

pb2     mov     <bp2,   {bp2
bp2     jmp     silk2+1+bd2,    silk2+1

silk0   spl     @0,     <ofs0
        mov     }silk0, >silk0
silk1   spl     @0,     <ofs1
        mov     }silk1, >silk1
        mov     {silk1, {silk2  ;this kind of end-silk arrangement
        mov.i   #a1,    {1      ;allows to use both types
        mov.i   #a2,    <1      ;of anti-imp mov.i bombs
silk2   djn.f   ofs2,   <a3     ;not in CC paper with 8 processes

        for     12
        dat     0,      0
        rof

        dat     0,      qa1
qt1     dat     0,      qa2

        for     34
        dat     0,      0
        rof

        ;q0 mutations 
qgo     sne     found+dq*qc2,   found+dq*qc2+qb2
        seq     <qt3,           found+dq*(qc2-1)+qb2
        jmp     q0,             }q0

        sne     found+dq*qa1,   found+dq*qa1+qb2
        seq     <qt1-1,         found+dq*(qa1-1)+qb2
        djn.a   q0,             {q0

        sne     found+dq*qa2,   found+dq*qa2+qb2
        seq     <qt1,           found+dq*(qa2-1)+qb2
        jmp     q0,             {q0

        ;q1 mutations 
        sne     found+dq*qb1,   found+dq*qb1+qb1
        seq     <qt2-1,         found+dq*(qb1-1)+(qb1-1)
        jmp     q0,             {q1

        sne     found+dq*qb3,   found+dq*qb3+qb3
        seq     <qt2+1,         found+dq*(qb3-1)+(qb3-1)
        jmp     q0,             }q1

        ;no mutation 
        sne     found+dq*qb2,   found+dq*qb2+qb2
        seq     <qt2,           found+dq*(qb2-1)+(qb2-1)
        jmp     q0,             0


        ;dq mutation 
        seq     >found,         found+dq+(qb2-1)
        jmp     qsel,           <found

        ;q0 mutation
        seq     found+(dq+1)*(qc2-1),   found+(dq+1)*(qc2-1)+(qb2-1)
        jmp     q0,                     }q0

        seq     found+(dq+1)*(qa2-1),   found+(dq+1)*(qa2-1)+(qb2-1)
        jmp     q0,                     {q0

        seq     found+(dq+1)*(qa1-1),   found+(dq+1)*(qa1-1)+(qb2-1)
        djn.a   q0,                     {q0 

        ;free scan
        jmz.f   wgo,                    found+(dq+1)*(qb2-1)+(qb2-1)
        
q0      mul.b   *q1,     found
qsel    sne     <qt1,   @found
q1      add.b   qt2,     found

qoff    equ     -86
qtime   equ     20
qstep   equ     7

qloop   mov     qbomb,  @found
found   mov     qbomb,  }dq
        add     #qstep, found
        djn     qloop,  #qtime
        jmp     wgo,    0
qbomb   dat     {qoff,  qc2


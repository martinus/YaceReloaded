;redcode-94nop 
;author inversed 
;name Neith
;strategy pws 
;assert (CORESIZE==8000) && (MAXPROCESSES==8000) 

;;paper 

ofs0    equ     1873 
ofs1    equ     3353 
b1      equ     7146 
b2      equ      917 

;;stone 

hop     equ     473 
step    equ     hop*2 
time    equ     2520 
djs     equ     2087 

;;boot 

d2      equ     3135 
bds     equ     (6036+d2) 
bdp     equ     (6259+d2) 

;;qscan 

qf      equ     2713 
qy      equ     4777 

dq      equ     (qy+1)%CORESIZE 
qa1     equ     (1+qf*(qt1-1-found))%CORESIZE 
qa2     equ     (1+qf*(qt1  -found))%CORESIZE 
qb1     equ     (1+qf*(qt2-1-found))%CORESIZE 
qb2     equ     (1+qf*(qt2  -found))%CORESIZE 
qb3     equ     (1+qf*(qt2+1-found))%CORESIZE 
qc2     equ     (1+qf*(qt3  -found))%CORESIZE 
qt3     equ     qbomb 

;;misc 

x0      equ     wgo 
org     qgo 

;; 

        dat     0,              0 
wgo     spl     1,              qb1 
qt2     spl     1,              qb2 
        spl     1,              qb3 
        mov     <bptr,               {bptr 
        mov     {silk0,         {pptr 
        spl     *bptr,          0 
bptr    spl     x0+bds+8,       s0+8 
pptr    jmz.a   x0+bdp+8,       *0 

s0      spl     #0,             0 
loop    mov     bomb,           @ptr 
hit     add     #step,          ptr 
ptr     mov     bomb,           }hit-hop*time 
        djn.f   loop,           <djs 
        dat     0,              0 
        dat     0,              0 
bomb    dat     hop,            >1 

silk0   spl     @8,     <ofs0 
        mov     }silk0, >silk0 
to      spl     ofs1,   <from 
        mov     >from,       }to 
        mov     pbomb,  >b1 
        mov     pbomb,  }b2 
from    djn.f   to,     >to+8 
pbomb   dat     <2667,       <5334 

        for     7 
        dat     0,      0 
        rof 

        dat     0,      qa1 
qt1     dat     0,      qa2 

        for     30 
        dat     0,      0 
        rof 

        ;q0 mutations 
qgo     sne     found+dq*qc2,   found+dq*qc2+qb2 
        seq     <qt3,                found+dq*(qc2-1)+qb2 
        jmp     q0,             }q0 

        sne     found+dq*qa1,   found+dq*qa1+qb2 
        seq     <qt1-1,              found+dq*(qa1-1)+qb2 
        djn.a   q0,             {q0 

        sne     found+dq*qa2,   found+dq*qa2+qb2 
        seq     <qt1,                found+dq*(qa2-1)+qb2 
        jmp     q0,             {q0 

        ;q1 mutations 
        sne     found+dq*qb1,   found+dq*qb1+qb1 
        seq     <qt2-1,              found+dq*(qb1-1)+(qb1-1) 
        jmp     q0,             {q1 

        sne     found+dq*qb3,   found+dq*qb3+qb3 
        seq     <qt2+1,              found+dq*(qb3-1)+(qb3-1) 
        jmp     q0,             }q1 

        ;no mutation 
        sne     found+dq*qb2,   found+dq*qb2+qb2 
        seq     <qt2,                found+dq*(qb2-1)+(qb2-1) 
        jmp     q0,             0 

        ;dq mutation 
        seq     >found,              found+dq+(qb2-1) 
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
qsel    sne     <qt1,        @found 
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

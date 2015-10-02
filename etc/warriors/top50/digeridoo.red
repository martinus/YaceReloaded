;redcode-94nop 
;author inversed 
;name Digeridoo
;strategy qS, Paper/Stone 
;strategy Featuring partly evolved Moore paper 
;strategy Especially good against weak papers 
;strategy But has no anti-imping and not oneshot-resistant 
;assert (CORESIZE==8000) && (MAXPROCESSES==8000) 

;----harsh paper----- 
pofs    equ     4616 
a1      equ     1984 
b1      equ     2645 
a2      equ     3993 
b2      equ     4008 

;-------stone-------- 
zofs    equ     (-1-h*t) 
h       equ     3359 
t       equ     1920 
djs     equ     3271 
bo      equ     6 

;------booting------- 
bd      equ     1840 
pd1     equ     3844 

;-------qscan-------- 
f       equ     2713 
y       equ     4777 

dq      equ     (y+1)%CORESIZE 
qa1     equ     (1+f*(qt1-1-found))%CORESIZE 
qa2     equ     (1+f*(qt1  -found))%CORESIZE 
qb1     equ     (1+f*(qt2-1-found))%CORESIZE 
qb2     equ     (1+f*(qt2  -found))%CORESIZE 
qb3     equ     (1+f*(qt2+1-found))%CORESIZE 
qc2     equ     (1+f*(qt3  -found))%CORESIZE 
qt3     equ     qbomb 

org     qgo 

wgo     mov     bomb,   bomb+bd+bo 

        spl     1,      {qb1 
qt2     mov.i   -1,     #qb2 
        spl     1,      {qb3 

        mov     <bptr,               {bptr 
sgo     spl     *1,             0 
bptr    spl     bomb+bd,        bomb 
pgo     mov     <pptr1,              {pptr1 
pptr1   jmp     to+pd1,         to+6 

s       spl     #0,     <djs 
ptr     mov     bomb+bo,{zofs 
        mov     bomb+bo,@ptr 
        add     #2*h,   ptr 
        djn.f   ptr,    <s+djs 
        dat     0,      0 
bomb    dat     h+1,    >1 

to      spl     pofs,   {from 
        mov     }from,  }to 
        mov     }a1,    {b1 
from    mov     }pbomb+1,}to 
        jmz.b   to,     *from 
pbomb   dat     }a2,    >b2 

        for     10 
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

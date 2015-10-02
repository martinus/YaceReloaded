;redcode-94nop
;author inversed
;name Rust
;strategy qS -> anti-imp paper / imp launcher
;assert (CORESIZE==8000) && (MAXPROCESSES==8000)

; My first warrior that entered HoF
; Lived to age of 350 at 94nop
; In Rust We Trust :)

;.....P a p e r....;
ofs0    equ     7472
ofs1    equ     5987
ofs2    equ     2935
bofs1   equ     6830
bofs2   equ     3824

;......I m p.......;
idj     equ     6865
dji     equ     407
istep   equ     1143
iofs    equ     5770
io      equ     4719

;.....q S c a n....;
qf      equ     4873
qy      equ     2937
dq      equ     (qy+1)%CORESIZE
qa1     equ     (1+qf*(qt1-1-found))%CORESIZE
qa2     equ     (1+qf*(qt1  -found))%CORESIZE
qb1     equ     (1+qf*(qt2-1-found))%CORESIZE
qb2     equ     (1+qf*(qt2  -found))%CORESIZE
qb3     equ     (1+qf*(qt2+1-found))%CORESIZE
qc2     equ     (1+qf*(qt3  -found))%CORESIZE
qt3     equ     qbomb

;......M i s c.....;
org     qgo
        
;..................;

        dat     0,      {qb1
qt2     spl     1,      {qb2
        mov.i   -1,     #qb3

silk0   spl     @0,     <ofs0
        mov     }silk0, >silk0
        mov     }silk0, >silk0
silk1   spl     @0,     <ofs1
        mov     }silk1, >silk1
        mov     pbomb,  >bofs1
        mov     pbomb,  }bofs2
        mov     {silk1, <silk2
silk2   jmp     @0,     >ofs2
pbomb   dat     <2667,  <5334

        for     15
        dat     0,      0
        rof

wgo     mov     imp,    imp+iofs+io
        spl     1,      qa1
qt1     spl     1,      qa2
        mov     <bp1,   {bp1
        spl     silk0-1,0
        spl     1,      0
bp1     jmp     imp+iofs,       imp

        spl     #0,     0
        add.x   imp+io, iptr
iptr    djn.f   imp-istep-1+io, {idj
        dat     0,      0
imp     mov.i   #dji,   istep

        for     24
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
qbomb   dat     {qoff,  {qc2


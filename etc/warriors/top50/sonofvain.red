;redcode-94nop
;name Son of Vain
;author Oversby/Pihlaja
;assert 1
load0 z for 0
        rof

ofs equ (-2)                            ; offset boot distances by this much.

; stone constants
step    equ     6457                    ; primary step
hop     equ     3643                    ; decr. ofs from bomb
dbofs   equ     9                       ; bomb distance from stone
tgt     equ     2                       ; first mutation target
time    equ     2293                    ; bombs before first mutation
sdist   equ     (2599+ofs)              ; boot distance

; clear constants
dgate   equ     (dclr-9)
dwipeofs equ    (-947)                  ; offset of clear trail from stone
ddist   equ     (7328+ofs)              ; boot distance
dmopa   equ     <2667                   ; mop a-field

; spin constants
ldist   equ     (7426+ofs)              ; boot distance
ldecoy  equ     (5956+ofs)              ; decoy distance
idist   equ     (7471+ofs)              ; imp trail dist.

; qscan constants

a1      equ     3922                    ; factors and scan offsets
a2      equ     1999
b1      equ     609
b2      equ     6686
b3      equ     4763
c2      equ     2149
d       equ     5014

; qbomb constants

qrep    equ     13                      ; repeats of bomb loop
qinc1   equ     7                       ; attack step
qhop    equ     60                      ; offset of bomb


;;-- primary boot
;;

boot    spl     misc    ,       >b1     ; start secondary boot
t2      spl     1       ,       >b2     ; t2 = qscan decode table
        spl     1       ,       >b3
        mov     <dsrc   ,       <ddst
        mov     <ssrc   ,       {sdst
        mov     <lsrc   ,       {ldst
sdst ddst spl   load0+sdist+4,  load0+ddist+4
ldst    jmp     load0+ldist+4,  <chk_flag

        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
;;-- imp launcher
;;
lsrc
spin    spl     #1      ,       4       ; the a-field is checked by misc boot.
        add.a   #2667   ,       1
        djn.f   spin+idist-ldist-1-2667,<spin-ldist+ldecoy
        dat     0       ,       0

        dat     0,0
        dat     0,0
t3      dat.a   qhop    ,       c2      ; t3 = qscan decode table
        dat     0,0                     ;      & attack bomb.
        dat     0,0
        dat     0,0
        dat     0,0

;;-- clear
;;

imp     mov.i   #10     ,       2667
db      dat.a   >hop    ,       >1      ; dat bomb for stone
dmop    dat.a   dmopa   ,       dclr+8-dgate ; dat bomb for clear
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
dsrc
dclr    spl     #0      ,       4
        spl     #0      ,       {dgate
        mov     dgate+2 ,       >dgate
        djn.f   -1      ,       >dgate

        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
;;-- qscan body
;;
qscan   seq     qb + d  ,       qb + d + b2
        jmp     q1

        sne     qb + d * a1,    qb + d * a1 + b2
        seq     <t1-1   ,       qb + d * (a1-1) + b2    ; t1-1 + a1-1
        djn.a   q0      ,       {q0                     ; == qb+d*(a1-1)

        sne     qb + d * a2,    qb + d * a2 + b2
        seq     <t1     ,       qb + d * (a2-1) + b2    ; t1 + a2-1
        jmp     q0      ,       {q0                     ; == qb+d*(a2-1)

        sne     qb + d * b1,    qb + d * b1 + b1
        seq     <t2-1   ,       qb + d * (b1-1) + (b1-1); t2-1 + b1-1
        jmp     q0      ,       {q2                     ; == qb+d*(b1-1)

        sne     qb + d * b3,    qb + d * b3 + b3
        seq     <t2+1   ,       qb + d * (b3-1) + (b3-1); t2+1 + b3-1
        jmp     q0      ,       }q2                     ; == qb+d*(b3-1)

        seq     qb + d * (b1-2),qb + d * (b1-2) + (b1-2); must follow the
        djn     q0      ,       {q2                     ; <t2-1 scan

        sne     qb + d * c2,    qb + d * c2 + b2
        seq     <t3     ,       qb + d * (c2-1) + b2    ; t3 + c2-1
        jmp     q0      ,       }q0                     ; == qb+d*(c2-1)

        sne     qb + d * b2,    qb + d * b2 + b2
        seq     <t2     ,       qb + d * (b2-1) + (b2-1); t2 + b2-1
                                                        ; == qb+d*(b2-1)
        jmp     q0      ,       >a1                     ; q0-1 and boot-1
t1      jmp     boot    ,       >a2                     ; must be dat 0,0's.

;;-- stone
;;
spl0
ssrc    ;spl    0       ,       0
st      spl     0       ,       4
        mov     -1+dbofs,       @2
        add     #step   ,       @-1
        djn.a   @-1     ,       *st+(tgt-hop)-(step*time)

        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0
        dat     0,0

;;-- misc. boot
;;
        ; bmbdist: address of stone bomb.
        ; gatedist: address of clear gate.
        ; wipedist: address of clear wipe start.
bmbdist equ     (sdist+dbofs)
gatedist equ    (ddist+dgate-dclr)
wipedist equ    (sdist+dwipeofs-ddist+dclr-dgate)

misc    mov     imp     ,       load0+idist
        mov     db      ,       load0+bmbdist
pmop    mov     dmop    ,       load0+gatedist+2
        mov     spl0    ,       {sdst
        mov     dmop    ,       <pmop
        mov.x   #wipedist,      <pmop
        spl     @ddst                   ; start clear.
chk_flag djn.a  dclr+1  ,       *ldst+4
        dat     0,0

;;-- qbomb
;;
;       dat     0,0                     ; dat be here.
q0      mul.b   *2      ,       qb
q1      sne     {t1     ,       @qb
q2      add.b   t2      ,       qb
        mov     t3      ,       @qb
qb      mov     t3      ,       *d
        sub     #qinc1  ,       qb
        djn     -3      ,       #qrep
        jmp     boot

        end     qscan


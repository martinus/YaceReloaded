;redcode-94nop
;author inversed
;name Eternal Exile
;strategy q^i -> Scanner with fixed length wipe
;assert (CORESIZE==8000) && (MAXPROCESSES==8000)

org     qscan

;---------------<< mini q^i quickscanner >>------------------------------------;

qbstep  equ     7
qbhop   equ    -87
qbcnt   equ     20

qxa     equ     6980
qxb     equ     6810
qa1     equ     5354
qa2     equ     5514
qb1     equ     5824
qb2     equ     1712
qstep   equ     2379

qa2qb2  equ     ((qa2*qb2)%CORESIZE)
qa2p1qb equ     (((qa2+1)*qb2)%CORESIZE)
qa2m1qb equ     (((qa2-1)*qb2)%CORESIZE)
nil     equ     (-CURLINE-1)
X       equ     found

        ;             --------~~~~~~~~([ instant ])~~~~~~~~--------            ;
qscan   sne     X + qxa                         , X + qxb
        seq     X + qxa + qstep                 , X + qxb + qstep
        jmp     decide                          , 0

        ;             --------~~~~~~~~([+0 cycles])~~~~~~~~--------            ;
        sne     X + qxa * qa2                   , X + qxb * qb2
        seq     X + qxa * qa2 + qstep           , X + qxb * qb2 + qstep
        jmp     dec0de                          , 0

        sne     X + qxa * qa1                   , X + qxb * qb1
        seq     X + qxa * qa1 + qstep           , X + qxb * qb1 + qstep
        jmp     dec0de                          , < dec1

        sne     X + qxa * (qa2 - 1)             , X + qxb * (qb2 - 1)
        seq     X + qxa * (qa2 - 1) + qstep     , X + qxb * (qb2 - 1) + qstep
        djn.f   dec0de                          , qtab

        sne     X + (qxa - 1) * qa2             , X + (qxb - 1) * qb2
        seq     X + (qxa - 1) * qa2 + qstep     , X + (qxb - 1) * qb2 + qstep
        djn.f   dec0de                          , found

        ;             --------~~~~~~~~([+1 cycle ])~~~~~~~~--------            ;
        sne     X + qxa * qa2qb2                , X + qxb * qa2qb2
        seq     X + qxa * qa2qb2 + qstep        , X + qxb * qa2qb2 + qstep
        jmp     dec1                            , 0

        jmp     boot                            , 0

dec1    mul.x     qtab      ,   qtab
dec0de  mul     @ dec1      ,   found
decide  sne     * found     , @ found
        add       qinc      ,   found
        seq       nil       , * found
        mov.x     found     ,   found

qbloop  mov       qbomb     , @ found
found   mov       qxa       , } qxb
        add     # qbstep    ,   found
        djn       qbloop    , # qbcnt
        jmp       boot      ,   0
qbomb   dat     > qbhop     , > 1

        dat       qa1       ,   qb1
qtab    dat       qa2       ,   qb2
qinc    dat       qstep     ,   qstep

        for       27
        dat       0         ,   0
        rof

;---------------<< Boot >>-----------------------------------------------------;

bdist   equ     4774
clen    equ     14
x0      equ     qscan

copy    mov     < bp                    , { bp
        mov     < bp                    , { bp
boot    mov     < bp                    , { bp
        mov     < bp                    , { bp
        djn       copy                  , # 4
bp      spl     @ x0 + bdist + clen     ,   loop + clen
        mov.i   # 0                     , { 0
        dat       0                     ,   0

;---------------<< Scanner >>--------------------------------------------------;

hop     equ     8
step    equ    -101
time    equ     712
zo      equ    -88      ; = 0 - step * time
wlen    equ     8
wptr    equ     ptr - 3
dcgap   equ     10
ikill   equ     2667

; Alternative (step, time) pair = (-371, 735)

loop    add       inc   ,   ptr
ptr     sne       zo    ,   zo + hop
j1      jmn.a   @ j2    , @ loop
t1      mov.ab    ptr   , @ wipe
cnt     mov     # wlen  , @ jw
wipe    mov       inc   , > wptr
gate    mov       inc   , > wptr
jw      djn     @ t1    ,   cnt
j2      jmn.a   @ j1    , @ loop
inc     spl     # step  ,   step
clear   mov       kill  , > gate
        djn.f     clear , > gate
        dat       0     ,   0
kill    dat     < ikill ,   dcgap

;------------------------------------------------------------------------------;


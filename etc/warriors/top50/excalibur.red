;redcode-94nop
;name Excalibur
;author inversed
;strategy Completely reworked Agony II
;assert CORESIZE == 8000

hop     equ     8
wlen    equ     16
step    equ     3147
sofs    equ     scan
stream  equ     (-344)
ssafe   equ     27
csafe   equ     10
dsafe   equ     3
bd      equ     1423
org     bp-11

        ;; Decoy
for     6
        spl.a   # 1         ,     1
        spl.b   # 1         ,     1
        spl.ab  # 1         ,     1
        spl.ba  # 1         ,     1
        spl.f   # 1         ,     1
        spl.x   # 1         ,     1
        spl.i   # 1         ,     1
        spl.i   $ 1         ,     1
rof
        spl.a   # 1         ,     1
        spl.b   # 1         ,     1
        spl.ab  # 1         ,     1
        
        ;; Boot
        mov     > 9         ,   } 9             ; mirror
        mov     > 8         ,   } 8             ;
        mov     > 7         ,   } 7             ;
for     3
        dat       0         ,     0
rof
for     11
        mov     > bp        ,   } bp
rof
bp      spl       scan+bd   ,     scan
for     5
        mov     > bp        ,   } bp
rof
        dat     } bp        ,   } bp
        mov     > 1         ,   } 1             ; mirror

        ;; Scanner
scan    sub     * y         ,   @ x
ptr     sne       sofs-hop  ,     sofs
        sub     * y         ,     ptr
x       seq     * ptr       ,   @ ptr
        slt     # ssafe     ,   @ x
        djn.f     scan      ,   < scan+stream
bptr    mov.b   @ x         ,   # 0
        mov     # wlen/2    ,     count
wipe    mov       inc       ,   < bptr
y       mov       inc       ,   < bptr
count   djn       wipe      ,   # 0
        jmz.a     scan      ,     scan-1
inc     spl     #-step      ,    -step
clear   mov       kill      ,   > y
        djn.f     clear     ,   { y
kill    dat       dsafe     ,     csafe

        mov       4         ,   <-2             ; mirror
        mov       3         ,   <-3             ;
        djn      -2         ,   # 0             ;
        jmz.a    -11        ,    -12            ;
        spl     #-step      ,    -step          ;
        mov       2         ,   >-4             ;
        djn.f    -1         ,   {-5             ;
        dat       dsafe     ,     csafe         ;


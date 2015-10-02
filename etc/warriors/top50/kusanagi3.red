;redcode-94nop
;name Kusanagi
;author inversed
;strategy Agony-style scanner
;assert (CORESIZE==8000) && (MAXPROCESSES==8000)

step    equ     2851
sofs    equ     step
hop     equ     18
wlen    equ     8
ssafe   equ     18+hop
dsafe   equ     12
gap     equ     80
ikill   equ     2667
decoy   equ     6700
dex     equ     loop+decoy
bptr    equ     loop-1
org     dmake

loop    add     * y     ,   @ x
ptr     sne       sofs  ,     sofs+hop
        add     * y     ,   @ x
c       seq     * ptr   ,   @ ptr
x       slt     # ssafe ,     ptr
        jmn.a     loop  ,   @ x
z       mov     @ x     ,   @ y
        mov     # wlen  ,     cnt
wipe    mov       inc   ,   } bptr
y       mov       inc   ,   > bptr
cnt     djn       wipe  ,   # 0
        jmn.a     loop  ,   * c
inc     spl     # step  ,     step
clear   mov       kill  ,   } cnt
        djn       clear ,   { z
kill    dat       dsafe ,   < ikill

for     gap
        dat       0     ,     0
rof

dmake   nop     } dex   ,   > dex+1
        mov     { dex+2 ,   < dex+4
        mov     < dex+5 ,   { dex+8
        jmp       loop+1,   } dex+6


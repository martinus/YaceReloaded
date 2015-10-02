;redcode-94nop
;name Infravision
;author inversed
;strategy .80c scan -> wipe -> .66c scan -> SSD clear
;strategy (Read: oneshot with prescan)
;strategy Not fooled by huge decoys
;assert (CORESIZE==8000) && (MAXPROCESSES==8000)

;----- [ Global ]------------------------------------------------------;

gap1    equ     4
gap2    equ     10
gap3    equ     38
org     pre + 1

;----- [ Scan ]--------------------------------------------------------;

step    equ     24
hop     equ     12
safe    equ     16
djs     equ     100
zofs    equ     -125

cptr    dat       zofs          ,   zofs + phop

       for     gap1
       dat       0             ,   0
       rof

bptr    dat       1             ,   safe
cs0     spl     # step + 1      ,   step
clear   mov     * bptr          , > cptr
       mov     * bptr          , > cptr
       djn.f     clear         , } cs0

       for     gap2
       dat     0               ,   0
       rof

loop    add       cs0           ,   cptr
       sne     * cptr          , @ cptr
       djn.f     loop          , { cptr
       jmp       cs0           , < cptr

       for     gap3
       dat     0,      0
       rof

;----- [ Prescan ]-----------------------------------------------------;

pstep   equ     -(step*5)
phop    equ     hop/2
precnt  equ     27      ;-(3900/pstep)

preinc  spl     # pstep         ,   pstep
pre     add       preinc        ,   cptr
       sne     * cptr          , @ cptr
       add       preinc        ,   cptr
       sne     * cptr          , @ cptr
       djn       pre           , # precnt
wipe    mov       preinc        , } cptr
       djn       wipe          , # hop + phop
       sub       preinc        ,   cptr
       jmp       loop + 1      ,   0

;---------------------------------------------------------------------;


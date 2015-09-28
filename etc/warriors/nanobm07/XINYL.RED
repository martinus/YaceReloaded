;redcode-nano
;name Xinyl
;author inversed
;strategy Scanner/Imp
;assert CORESIZE==80

step    equ     -5
zofs    equ     -9
aval    equ     4
bval    equ     27

x0      equ     loop
org     loop+1

loop    add     #step,          ptr
ptr     jmz.f   loop,           x0+zofs

        mov.i   #aval,          >ptr
        spl     ptr,            >bval
        mov.i   #1,             1

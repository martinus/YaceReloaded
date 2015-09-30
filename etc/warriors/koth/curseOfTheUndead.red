;redcode-94nop
;name Curse of the Undead
;author John Metcalf
;strategy vampire
;assert CORESIZE == 8000

        org    vamp+1

        step   equ 5904 ; 2768

vamp    add    inc,       fang
        mov    fang,      @fang
        jmz.f  vamp,      *fang
        mov    fang,      *fang
        mov.a  #0,        *fang
        jmz.f  vamp,      trap
        jmp    clear-1

        for    10
        dat    0,0
        rof

        gate   equ clear-4
        dec    equ 1700 ; 3100

bptr    dat    1,         11
dptr    spl    #dec,      13
clear   mov    *bptr,     >gate
        mov    *bptr,     >gate
        djn.f  clear,     }dptr

        for    9
        dat    0,0
        rof

fang    jmp    @step,     trap-step
inc     dat    step,      -step

        for    54
        dat    0,0
        rof

trap    spl    #0,        {0
        spl    {0,        }0
        jmn.a  trap+1,    trap

        end
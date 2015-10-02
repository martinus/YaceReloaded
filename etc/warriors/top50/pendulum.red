;redcode-94nop
;name Pendulum
;author John Metcalf
;strategy .75c scanner
;url http://corewar.co.uk/pendulum.htm
;assert CORESIZE==8000

        step   equ 17
        first  equ 1188 ; 3417

ptr     dat    first+step, first

        for    9
        dat    0,          0
        rof

bomb    spl    #0,         {0

wipe    mov    bomb,       <ptr
        mov    >ptr,       >ptr
        jmn.f  wipe,       >ptr

reset   mov.ab ptr,        ptr

scan    sub    inc,        ptr
        sne.x  *ptr,       @ptr
inc     sub.x  #-2*step,   ptr
        jmz.f  scan,       @ptr

        slt    ptr,        #last-ptr+4
        djn    wipe,       ptr
        djn    reset,      #18
last    jmp    reset,      {wipe

        end    scan+1


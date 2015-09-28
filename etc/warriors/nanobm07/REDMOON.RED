;redcode-nano verbose
;date Tue Jan 16 03:33:39 UTC 2007
;name Red Moon
;author Fluffy
;strategy Watch the Moon!
;assert CORESIZE == 80

        ORG start

start   mov.i   < 25, $ 41
        spl.x   # 8, < 76
        mov.i   } 1, } 79
        mov.i   < 22, < 74
        djn.i   $ 78, < 51

        END


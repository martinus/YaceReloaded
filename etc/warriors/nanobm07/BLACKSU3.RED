;redcode-nano verbose
;date Sun Jan 21 01:11:55 UTC 2007
;name Black Sun III
;author Fluffy
;strategy Watch the Sun!
;assert CORESIZE == 80

        ORG start

start   spl.x   # 0, > 21
        mov.i   } 79, > 79
        mov.i   < 73, < 37
        mov.i   < 36, < 72
        djn.i   } 18, < 49

        END


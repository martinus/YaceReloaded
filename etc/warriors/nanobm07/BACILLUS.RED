;redcode-nano verbose
;name Bacillus anthracis
;author Fluffy
;strategy It can wait years ...
;assert CORESIZE == 80

        ORG start

start   spl.b   # 48, { 71
        mov.i   > 50, { 79
        mov.i   > 52, { 36
        mov.i   > 14, { 68
        djn.f   $ 78, { 34

        END



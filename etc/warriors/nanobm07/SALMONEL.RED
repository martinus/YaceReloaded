;redcode-nano verbose
;name Salmonella enterica
;author Fluffy
;strategy Is it the right time?
;assert CORESIZE == 80

        ORG start

start   mov.i   > 52,   $ 37
        spl.b   # 65,   < 28
        mov.i   $ 75,   { 79
        mov.i   > 39,   < 26
        djn.f   $ 78,   < 46

        END

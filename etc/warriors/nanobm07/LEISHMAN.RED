;redcode-nano verbose
;name Leishmania deanei
;author Fluffy
;strategy Don't use antimony!
;assert CORESIZE == 80

        ORG start

start   spl.b  # 0, { 49
        mov.i  > 57, { 48
        mov.i  > 63, < 31
        mov.i  > 13, { 72
        djn.x  $ 78, < 58

        END

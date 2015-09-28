;redcode-nano
;name rumpelstiltskin
;author gnik
;strategy Today I bake tomorrow brew
;strategy The next I'll have the young Queen's child.
;strategy Ha! glad am I that no one knew
;strategy That Rumpelstiltskin I am styled."
;assert CORESIZE==80

s1 EQU 14
s2 EQU 46
s3 EQU 18
s4 EQU 3
s5 EQU 10
istep EQU 27

        org     go
first   spl     imp+2*istep, >s1
go      spl     1,           >s2
        spl     first,       >s3
        spl     imp+istep,   <s4
imp     mov.i   #s5,         istep

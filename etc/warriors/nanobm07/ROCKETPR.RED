;redcode-nano
;name Rocket propelled monkey II
;author G.Labarga
;assert CORESIZE==80
;strategy scanner

loo:    add #5,#9
        jmz.f loo,@loo
        mov bm,>loo
        jmp -2,<-8
bm:     mov.i #1,-1
end loo+1

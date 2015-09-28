;redcode-nano
;author Roy van Rijn
;name Subterranean Homesick Alien
;strategy Highly optimized version
;strategy Part of the clear is evolved then hand optimized
;strategy  using the whole Koenigstuhl nano hill
;strategy Dropped in my new imp-framework
;assert 1

pAttack1        equ     cGo+37
pAttack2        equ     cGo+56
pAttack3        equ     cGo+63

cGo     spl     #-5             , {pAttack1
        mov.i   >pAttack2       , {cGo
        mov.i   {cGo+1          , {pAttack1
        mov.i   >pAttack3       , {cGo+1
cImp    mov.i   #1              , 1


end

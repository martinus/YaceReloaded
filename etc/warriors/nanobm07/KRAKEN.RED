;redcode-nano
;name the kraken awakes
;author Metcalf/Fernandes
;strategy clear/imp
;assert CORESIZE==80

clr  spl   #23,      }-1
loop mov   @clr,     }clr
     djn.f loop,     }clr
less spl   clr,      <-27
     mov.i #1,       1
     end   less

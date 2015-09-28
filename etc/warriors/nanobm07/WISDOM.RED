;redcode-nano
;name wisdom of the grasshoppers 
;author Simon Wainwright
;strategy clear
;assert CORESIZE==80

gate    mov          >13,     <-20
        spl           #0,    }gate
clear   mov       squash,    }gate
        djn.f      clear,    }gate
squash  dat       3-gate,        0
        end

;redcode-nano
;name Stegodon Aurorae
;author S.Fernandes
;strategy spl/mov/mov/mov/djn
;assert CORESIZE==80

START  SPL.B  #    10, >    36
       MOV.I  <    46, }    -1
       MOV.I  }    -1, }    -2
       MOV.I  #     8, }    -3
       DJN.F  $    -3, }    -4
       END

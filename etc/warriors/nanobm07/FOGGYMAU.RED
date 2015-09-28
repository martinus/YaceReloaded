;redcode-nano
;name Foggy Maus (beta)
;author The MicroGP Corewars Collective
;assert CORESIZE==80

       org start
start:
       spl.a #45, <35
       mov.i >56, {79
       mov.i >59, <33
       mov.i @75, {72
       djn.i $78, <50
       end

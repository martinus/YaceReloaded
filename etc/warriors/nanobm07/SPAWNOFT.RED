;redcode-nano
;name spawn of the dark core
;author John Metcalf
;strategy clear/imp
;assert CORESIZE==80

clr: spl   #40,        >-39
     mov.i >-22,       -6
     djn.f <0,         >0
star:spl   clr,        >-35
     mov.i #1,         1
     end   star

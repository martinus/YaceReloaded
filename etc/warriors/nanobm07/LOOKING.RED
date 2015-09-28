;redcode-nano
;name looking glass
;author John Metcalf
;strategy clear

     wipe  equ (gate-5)

gate:spl   #10,      <wipe
loop:mov   db,       }gate
     mov   >wipe+38, <wipe
     djn.f loop,     }gate
db:  dat   5,        0
     end


;redcode-nano
;name written in the dust
;author John Metcalf
;strategy clear
;assert CORESIZE==80

     spl   #51,      >23
loop:mov   db,       <ptr
     mov   db,       <ptr
ptr: djn   loop,     #62
db:  dat   {12,      {-6
     end

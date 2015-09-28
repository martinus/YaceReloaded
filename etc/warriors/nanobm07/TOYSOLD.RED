;redcode-nano
;name toy soldier
;author John Metcalf
;strategy nano qscan
;assert CORESIZE==80

     scan equ (ptr+18)
     clear equ (ptr+30)
     db equ (ptr+57)

     seq   scan+5,  scan
ptr  mov   #scan-3, #clear
     spl   #59,     >db
loop mov   db,      >ptr
     djn.f loop,    >ptr

     end

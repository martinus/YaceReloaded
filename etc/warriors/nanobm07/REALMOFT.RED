;redcode-nano
;name realm of the fire flower
;author John Metcalf
;strategy imp spirals
;assert CORESIZE==80

     istep equ 27

     spl   #9,           >-10
     spl   istep+1,      >-15
     mov   -1,           istep
     mov   -1,           istep
imp: mov.i #14,          istep

     end

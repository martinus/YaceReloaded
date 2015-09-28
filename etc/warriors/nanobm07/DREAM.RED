;redcode-nano
;name written in a dream
;author John Metcalf
;strategy imp rings
;strategy dreaming about corewar on the bus!
;assert CORESIZE==80

     istep equ 27

     spl   #imp+istep*2, >15
     mov.i #-12,         {-1
     spl   imp-istep,    >18
     spl   imp+istep,    >15
imp: mov.i #-38,         istep

     end

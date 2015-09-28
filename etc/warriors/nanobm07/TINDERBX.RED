;redcode-nano
;name tinderbox
;author John Metcalf
;strategy imp rings
;assert CORESIZE==80

     istep equ 27

     mov   boot,         imp-istep*2
     mov.i #1,           <1
boot:spl   imp-istep*2,  20
     spl   -2,           <-27
imp: mov.i #5,           istep

     end

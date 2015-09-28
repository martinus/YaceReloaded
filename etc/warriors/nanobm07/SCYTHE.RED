;redcode-nano
;name scythe
;author John Metcalf
;strategy imp rings
;assert CORESIZE==80

     istep equ 27

     mov   <37,          18
     mov   boot,         >imp-istep*2
boot:spl   imp-istep*2,  <12
     spl   -2,           <-32
imp: mov.i #10,          istep

     end

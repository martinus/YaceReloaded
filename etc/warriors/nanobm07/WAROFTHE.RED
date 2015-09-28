;redcode-nano
;name war of the snowflakes
;author John Metcalf
;strategy imp rings
;assert CORESIZE==80

     istep equ 27

clr: mov.i #1,           <1
     spl   clr,          55
boot:spl   imp-istep*2,  >41
     mov   boot,         imp-istep*2
imp: mov.i #13,          istep
     end   boot-1


;redcode-nano
;name girl from the underworld
;author John Metcalf
;strategy scanner
;assert CORESIZE==80

     step  equ 5
     first equ wipe-13

scan:sub   #step,    wipe
wipe:jmz.f scan,     first
     mov.i #9,       >wipe
     djn.f wipe,     <wipe-9
     mov.i #-18,     1
     end   wipe

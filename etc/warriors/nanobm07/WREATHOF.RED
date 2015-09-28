;redcode-nano
;name wreath of thistles
;author John Metcalf
;strategy qscan
;assert CORESIZE==80

     x     equ 17
     y     equ 61

     sne   ptr+x*y-5,  ptr+x*y-10
     seq   {adj,       ptr+x*y-y-6
adj: mul   #x,         ptr
ptr: mov   >-35,       y
     djn.f <0,         >0
     end

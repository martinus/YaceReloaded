;redcode-nano
;name victim of the night
;author John Metcalf
;strategy oneshot v2

scan add   #-6,      ptr
star jmz.f scan,     >ptr
     spl   #0,       0
ptr  mov   <-48,     -16
     djn.f {0,       }0
     end   star

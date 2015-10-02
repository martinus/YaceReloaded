;redcode-94
;name HazyLazy A 70
;author Steve Gunnell
;strategy Optimized and marginally altered version of 'The Machine' 
;strategy by Anton Marsden.
;strategy Especially hostile to anything with a DJN stream.
;strategy Mod 10 scanning!
;assert 1

step EQU 290
gate EQU top
away EQU (clr+4670)
G1   EQU 8
G2   EQU 3

ptr:  mov.i  inc+1,>step
top:  mov.i  bomb,>ptr          
scan: seq.i  2*step,2*step+7 
      mov.ab scan,@top
a:    sub.f  inc,scan
      jmn.b  top,@top
inc:  spl.i  #-step,>-step
      mov.i  clr,>gate
btm:  djn.f  -1,>gate
clr:  dat.f  <2667,clr-gate+2
      for G1
      dat 0,0
      rof
bomb: spl #1, #1
      for G2
      dat 0,0
      rof
boot: mov.i  clr,<dest
FOR 8
      mov.i  {boot,<dest
ROF
dest: mov.i  bomb,*away
      spl @dest,{-1000
      mov.i  {boot,<dest
      dat <dest,<dest
FOR 9
  spl.b  #1,1
spl.ab #1,1
spl.ba #1,1
spl.i  #1,1
spl.a  #1,*1
spl.b  #1,*1
spl.ab #1,*1
ROF

END boot


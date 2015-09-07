;redcode-94
;name The Machine
;author Anton Marsden
;strategy Blur 2 with some anti-stone improvements
;assert CORESIZE==8000

step EQU 70                   ; mod-10
gate EQU top
away EQU (clr+1995+660)       ; not really :-)

      mov.i  bomb-top,>-1
FOR 3
      dat 0,0
ROF
ptr:  mov.i  inc+1,>step
top:  mov.i  bomb,>ptr          
scan: seq.i  2*step,2*step+5 
      mov.ab scan,@top
a:    sub.f  inc,scan
      jmn.b  top,@top
inc:  spl.i  #-step,>-step
      mov.i  clr,>gate
btm:  djn.f  -1,>gate
clr:  dat.f  <2667,clr-gate+2
      dat 0,0
      spl.i  #-step,>-step
      dat 0,0
bomb: spl.i  #1,#1
      dat 0,0
      dat 0,0
      mov.i  {-3,<6
      dat 0,0
boot: mov.i  clr,<dest
FOR 8
      mov.i  {boot,<dest
ROF
dest: mov.i  bomb,*away
      spl @dest,{-1000
      mov.i  {boot,<dest
      dat <dest,<dest
      mov.i  {-8,<1
FOR 12
      spl.a  #1,*1
      spl.b  #1,1
      spl.ab #1,@1
      spl.ba #1,}1
      spl.i  #1,#1
ROF
FOR 4      
      spl.i  #1,#1
ROF

END boot

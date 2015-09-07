;redcode 
;name procoptodon
;author Steve Gunnell
;strategy Hazy lazy ... reborn with the serial numbers filed off. 
;assert 1 

step EQU 5690 
gate EQU top 
away EQU (clr+1801) 
G1 EQU 4 
G2 EQU 1 

ptr: mov.i inc+1,>step 
top: mov.i bomb,>ptr 
scan: seq.i 2*step,2*step+5 
mov.ab scan,@top 
a: sub.f inc,scan 
jmn.b top,@top 
inc: spl.i #-step,>-step 
mov.i clr,>gate 
btm: djn.f -1,>gate 
clr: dat.f <2667,clr-gate+2 
for G1 
dat 0,0 
rof 
bomb: spl #1, #1 
for G2 
dat 0,0 
rof 
boot: mov.i clr,<dest 
FOR 8 
mov.i {boot,<dest 
ROF 
dest: mov.i bomb,*away 
spl @dest,{-1000 
mov.i {boot,<dest 
dat <dest,<dest 
FOR 4 
spl.b #1,1 
spl.ab #1,1 
spl.ba #1,1 
spl.i #1,1 
spl.a #1,*1 
ROF 

END boot 

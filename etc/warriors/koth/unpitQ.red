;redcode-94nop
;name unpitQ
;author P.Kline
;assert CORESIZE == 8000
;strategy vampire
;strategy smaller and with djn-resistance

vboot  equ    (vamp+3100+201*3)
first  equ    (-step*498)
wboot  equ    (unpit+first+step*8)
step   equ    (8*(10*2+1))
unpit  equ    (vboot+2-step)

       dat    0                 ,0
vGo    mov    fang              ,unpit-1   ; after qscan boot fang, vamp, wipe
       mov    <wfr              ,<bptr
       spl    }2                ,}1
       spl    0                 ,0
       spl    0                 ,0
       mov    <wfr              ,<bptr
       mov    <vfr              ,{bptr
       djn    }bptr             ,#6        ; jmp 5 procs into airbagged vamp
bptr   dat    #vboot+(vfr-vamp) ,#wboot+(wfr-wipeg)
       dat    0                 ,0
       dat    0                 ,0
       mov.i  {0                ,#0
vamp   mov    {2-step           ,<vamp-vboot+unpit-1
       mov    @0                ,*vamp-vboot+unpit-1
       sub.x  #step-1           ,}-step           ; -step = unpit
       jmz.f  vamp              ,*vamp
       jmp    vamp-vboot+wboot+(wipes-wipeg) ,}1  ; djn-resistance
vfr    dat    0                 ,0

wipeg  dat    0             ,0
wiped  dat    #9            ,9
wipes  spl    #10           ,#10
wipem  mov    wipes         ,>wipeg
       mov    *wipem        ,*wipeg
       add.a  #381          ,@-1
       djn    wipem         ,#5000
       dat    {wipem        ,{0
wfr    dat    0             ,0

   for 16+wipeg
       dat    0             ,0
   rof
fang   djn.a  >1-first      ,>first+1
       dat    0             ,0
qBmb   dat    <-3           ,{3
null   dat    0             ,0

   for 59-CURLINE
       dat 0,0
   rof
qM       equ (5901+1)
qMod     equ 4101

ptABCD   equ 12
ptScan   equ 17
ptDecode equ 0
ptLaunch equ 70
qStep    equ (106)

qA equ ((qMod*(tA-qPtr))%CORESIZE+1)
qB equ ((qMod*(tB-qPtr))%CORESIZE+1)
qC equ ((qMod*(tC-qPtr))%CORESIZE+1)
qD equ ((qMod*(tD-qPtr))%CORESIZE+1)
qE equ ((qMod*(tE-qPtr))%CORESIZE+1)
qF equ ((qMod*(tF-qPtr))%CORESIZE+1)

q0     equ     (qPtr-5)
decode mul.b   *tB       ,@2
       sne     null      ,@qPtr
       add.ab  #qStep    ,qPtr
       add.ba  qPtr      ,qPtr
       mov     qBmb      ,*qPtr
qPtr   mov     -4        ,}qM
       mov     qBmb      ,>qPtr
       sub.f   #7        ,@-4
       djn.b   -4        ,#15
       jmp     vGo       ,{1600

   for ptABCD+q0
       dat 0,0
   rof
tA     spl     #tE   ,{qA
tB     spl     #1    ,{qB
tC     spl     #tF   ,{qC
tD     spl     #0    ,{qD

   for ptScan+q0
       dat  0 ,0
   rof
qGo    seq    qPtr+qM    ,qPtr+qM+qStep
       djn.f  decode+1   ,{3000
       sne    qPtr+qA*qM ,qPtr+qA*qM+qStep
       seq    <tA        ,qPtr+(qA-1)*qM+qStep
       djn.a  decode     ,{tB
       sne    qPtr+qB*qM ,qPtr+qB*qM+qStep
       seq    <tB        ,qPtr+(qB-1)*qM+qStep
       jmp    decode     ,{tB
       sne    qPtr+qC*qM ,qPtr+qC*qM+qStep
       seq    <tC        ,qPtr+(qC-1)*qM+qStep
tE     djn.f  decode     ,{qE
       sne    qPtr+qD*qM ,qPtr+qD*qM+qStep
       seq    <tD        ,qPtr+(qD-1)*qM+qStep
       jmp    decode     ,}tB
       sne    qPtr+qE*qM ,qPtr+qE*qM+qStep
       seq    <tE        ,qPtr+(qE-1)*qM+qStep
       jmp    decode     ,{decode
       sne    qPtr+qF*qM ,qPtr+qF*qM+qStep
       seq    <tF        ,qPtr+(qF-1)*qM+qStep
       jmp    decode     ,}decode
tF     djn.f  vGo        ,{qF
       mov.i  #1         ,1

       end    qGo

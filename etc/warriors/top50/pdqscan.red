;redcode-94
;name pdQscan
;author P.Kline
;assert CORESIZE == 8000

qM       equ    (6249+1)
qMod     equ    4249
ptScan   equ    8
ptDecode equ    51
ptLaunch equ    81
qStep    equ    (250/2-1)

qA      equ     ((qMod*(tA-qPtr))%CORESIZE+1)
qB      equ     ((qMod*(tB-qPtr))%CORESIZE+1)
qC      equ     ((qMod*(tC-qPtr))%CORESIZE+1)
qD      equ     ((qMod*(tD-qPtr))%CORESIZE+1)
qE      equ     ((qMod*(tE-qPtr))%CORESIZE+1)
qF      equ     ((qMod*(tF-qPtr))%CORESIZE+1)
qG      equ     ((qMod*(tG-qPtr))%CORESIZE+1)
qH      equ     ((qMod*(tH-qPtr))%CORESIZE+1)
qI      equ     ((qMod*(tI-qPtr))%CORESIZE+1)
qJ      equ     ((qMod*(tJ-qPtr))%CORESIZE+1)

tA       dat     tE           ,qA
tB       dat     1            ,qB
tC       dat     tF           ,qC
tD       dat     tJ           ,qD
bM       dat     0            ,-67
     for ptScan-CURLINE
         dat     0,0
     rof
qGo      sne     qPtr+qA*qM   ,qPtr+qA*qM+qStep
         seq     <tA          ,qPtr+(qA-1)*qM+qStep
         djn.a   decode       ,{tB
         sne     qPtr+qB*qM   ,qPtr+qB*qM+qStep
         seq     <tB          ,qPtr+(qB-1)*qM+qStep
         jmp     decode       ,{tB
         sne     qPtr+qC*qM   ,qPtr+qC*qM+qStep
         seq     <tC          ,qPtr+(qC-1)*qM+qStep
tE       jmp     decode       ,qE
         sne     qPtr+qD*qM   ,qPtr+qD*qM+qStep
         seq     <tD          ,qPtr+(qD-1)*qM+qStep
         jmp     decode       ,}tB

         sne     qPtr+qE*qM   ,qPtr+qE*qM+qStep
         seq     <tE          ,qPtr+(qE-1)*qM+qStep
         jmp     decode       ,{decode
         sne     qPtr+qF*qM   ,qPtr+qF*qM+qStep
         seq     <tF          ,qPtr+(qF-1)*qM+qStep
jJ       jmp     decode       ,}decode

         sne     qPtr+qG*qM   ,qPtr+qG*qM+qStep
         seq     <tG          ,qPtr+(qG-1)*qM+qStep
         jmp     decode-1     ,{pH
         sne     qPtr+qH*qM   ,qPtr+qH*qM+qStep
pH       seq     <tH          ,qPtr+(qH-1)*qM+qStep
tF       jmp     decode-1     ,qF
         sne     qPtr+qI*qM   ,qPtr+qI*qM+qStep
         seq     <tI          ,qPtr+(qI-1)*qM+qStep
         jmp     decode-1     ,}pH

         sne     qPtr+qJ*qM   ,qPtr+qJ*qM+qStep
         seq     <tJ          ,qPtr+(qJ-1)*qM+qStep
         jmp     jJ           ,}decode
tJ       jmp     pGo          ,qJ
     for ptDecode-CURLINE
         dat     0,0
     rof
         mov.a   #pH-decode   ,decode
decode   mul.b   *tB          ,qPtr
         sne     null         ,@qPtr
         add.ab  #qStep       ,qPtr
         mov     bM           ,@qPtr
qPtr     mov     bM           ,@qM
         add.ab  #6           ,qPtr
         djn.b   -3           ,#16
         jmp     pGo
     for ptLaunch-CURLINE
         dat     0,0
     rof
pStep    equ     (7*3754)
pStep2   equ     (1303+7*1021)
pGo      mov     <pCopy       ,{pCopy
tG       spl     2            ,qG
tH       spl     1            ,qH
tI       spl     1            ,qI
         mov     <pCopy       ,{pCopy
pCopy    spl     1+7+4000     ,1+7
         mov     <1           ,{1
         spl     2000+7       ,7
pPap     spl     @0           ,>pStep
         mov     }pPap        ,>pPap
         mov     {pPap        ,<1
         spl     @0           ,>pStep2
         mov.i   #6000-1-2667 ,}2667
         mov.i   >0           ,}0

null     dat     0            ,0
         end     qGo


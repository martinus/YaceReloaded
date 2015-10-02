;redcode-94nop
;name SnowScan
;author P.Kline
;assert CORESIZE == 8000
;kill SnowScan

qM equ (5901+1)
qMod equ 4101
ptABCD equ 12
ptScan equ 17
ptDecode equ 0
ptLaunch equ 78
qStep equ (212/2-1)

qA equ ((qMod*(tA-qPtr))%CORESIZE+1)
qB equ ((qMod*(tB-qPtr))%CORESIZE+1)
qC equ ((qMod*(tC-qPtr))%CORESIZE+1)
qD equ ((qMod*(tD-qPtr))%CORESIZE+1)
qE equ ((qMod*(tE-qPtr))%CORESIZE+1)
qF equ ((qMod*(tF-qPtr))%CORESIZE+1)
qG equ ((qMod*(tG-qPtr))%CORESIZE+1)
qH equ ((qMod*(tH-qPtr))%CORESIZE+1)
qI equ ((qMod*(tI-qPtr))%CORESIZE+1)

 mov.a #pH-decode ,decode
decode mul.b *tB ,qPtr
 sne null ,@qPtr
 add.ab #qStep ,qPtr
 add.ba qPtr ,qPtr
 mov tA ,*qPtr
qPtr mov -4 ,qM
 sub.f #12 ,@-5
 djn.b -3 ,#(7)
 jmp pGo ,{qPtr-(200*13)+qStep/4+1300-430

 for ptABCD-CURLINE
 dat 0,0
 rof

tA dat tE ,qA
tB dat 1 ,qB
tC dat tF ,qC
tD dat 0 ,qD

 for ptScan-CURLINE
 dat 0,0
 rof

qGo
 seq qPtr+qM , qPtr+qM+qStep
 jmp decode+1
sne qPtr+qA*qM ,qPtr+qA*qM+qStep
 seq <tA ,qPtr+(qA-1)*qM+qStep
 djn.a decode ,{tB
 sne qPtr+qB*qM ,qPtr+qB*qM+qStep
 seq <tB ,qPtr+(qB-1)*qM+qStep
 jmp decode ,{tB
 sne qPtr+qC*qM ,qPtr+qC*qM+qStep
 seq <tC ,qPtr+(qC-1)*qM+qStep
tE jmp decode ,qE
 sne qPtr+qD*qM ,qPtr+qD*qM+qStep
 seq <tD ,qPtr+(qD-1)*qM+qStep
 jmp decode ,}tB

 sne qPtr+qE*qM ,qPtr+qE*qM+qStep
 seq <tE ,qPtr+(qE-1)*qM+qStep
 jmp decode ,{decode
 sne qPtr+qF*qM ,qPtr+qF*qM+qStep
 seq <tF ,qPtr+(qF-1)*qM+qStep
 jmp decode ,}decode

 sne qPtr+qG*qM ,qPtr+qG*qM+qStep
 seq <tG ,qPtr+(qG-1)*qM+qStep
 jmp decode-1 ,{pH
 sne qPtr+qH*qM ,qPtr+qH*qM+qStep
pH seq <tH ,qPtr+(qH-1)*qM+qStep
tF jmp decode-1 ,qF
 sne qPtr+qI*qM ,qPtr+qI*qM+qStep
 seq <tI ,qPtr+(qI-1)*qM+qStep
 jmp decode-1 ,}pH
 jmp pGo ,{qPtr-(200*13)+qStep/4+1300-430

 for ptLaunch-CURLINE
 dat 0,0
 rof

pStep   equ   (2946)
pStep2  equ   (-200+355)
pInd    equ   (3472)

pGo
tG      spl    2            ,}qG
tH      spl    1            ,}qH
tI      spl    1            ,}qI
       spl    pB           ,0
       mov    <pAj         ,{pAj
pAj     jmp    pPap-2667+6  ,pPap+6
pB      mov    @pAj         ,{pBj
pBj     spl    pPap+2667+6  ,0

pPap    spl    @0           ,>pStep
       mov    }pPap        ,>pPap
       mov    {pPap        ,<1
       spl    @0           ,>pStep2
       mov.i  #-2668-pInd  ,}pInd
null    dat    0            ,0

 end qGo


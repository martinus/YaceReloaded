;redcode-94nop 
;name Cheep! Half-Off!
;author Ben Ford
;strategy tiny q-scan -> stone/paper 
;strategy based on Digital Swarm and Reepicheep 
;assert CORESIZE==8000 

org qGo 

sOff    equ     3941 
pHit0   equ     7599 
pDst0   equ     535 
pDst1   equ     3875 
pDst2   equ     5160 

pGo   spl     $   1,  {   0 
     spl     $   1,  }2345 
     spl     $   1,  }3456 

slk0  spl     @   0,  >pDst0 
     mov     }slk0,  >slk0 
slk1  spl     pDst1,  0 
     mov     >slk1,  }slk1 
     mov      pBmb,  >pHit0 
     mov     <slk1,  <slk2 
slk2  djn.f   @   0,  >pDst2 
pBmb  dat     >5334,  >2667 

      for     5 
      dat     0       , 0 
      rof 

step    equ     2777 
time    equ     1425 
hop     equ     31 
bOff    equ     5 

sSpl  spl     #   0,  #   0 
ptr   mov      bomb,  }-(step*time)+1 
     mov      bomb,  @ ptr 
a     add     #step,  @  -1 
sLoo  djn.f     ptr,  {6500 

      for     5 
      dat     0       , 0 
      rof 

bomb    dat     >hop    , >1 

      dat     0       , 0 

; [ QSCAN ] 
qA equ 750 
qB equ 4129 

qW1 equ 3872 ;((qA-1)*(qB-1)) 
qW2 equ 4256 ;((qW1*(qW1+1))%CORESIZE) 
qW3 equ 5792 ;((qW2*(qW2+1))%CORESIZE) 
qW4 equ 1056 ;((qW3*(qW3+1))%CORESIZE) 

qX1 equ 4621 ;(((qA-1)*qB)%CORESIZE) 
qX2 equ 6262 ;((qX1*(qX1+1)%CORESIZE) 

qY1 equ 750 ;((qA*qB)%CORESIZE) ; equ qA 
qY2 equ 3250 ;((qY1*(qY1+1)%CORESIZE) 

qZ1 equ 4879 ;(((qA+1)*qB)%CORESIZE) 
qZ2 equ 1520 ;((qZ1*(qZ1+1))%CORESIZE) 

qV1 equ 4128 ;(((qA+1)*(qB-1))%CORESIZE) ; equ qB-1 

qGo  sne.x qf+qW3,   qf+qW4 ; scan 
    seq.x qf+qW1,   qf+qW2 
    djn.f @qlo+1,   @qlo+1 
    sne.x qf+qX2,   qf+qX1 
    seq.x qf+qY2,   }qf ; qY1 
    jmp   @qlo+1,   {qf 
    sne.x qf+qZ2,   qf+qZ1 
    jmz.f bBoot,      <qf ; qV1 

qf:  mul.x #qA,      #qB   ; decode 
    jmz.f @qlo+1,   >qf 

qlo: mov   {519,     >qf    ; attack 
    mov   }qlo,     {qf 
    seq   {qf,      >qf 
    djn.f qlo,      >qf 

bBoot   mov     sSpl    , sOff-6-CURLINE 
      mov     bomb    , sOff+5-CURLINE 
      spl     2       , }4567 
qTab1   spl     2       , }5678 
sDst    spl     1       , sOff-CURLINE 
      mov     <sSrc   , <sDst 
      djn     @bBoot  , #5 
sSrc    jmp     pGo     , sLoo+1 

      end 


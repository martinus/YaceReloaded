;redcode-94nop
;name 2by4k
;author P.Kline
;strategy binary spl-resistant silk
;strategy added a crude qscan
;assert 1

aSkip    equ (2362)
aBomb    dat     -70          ,1
aIncr    dat     aSkip        ,aSkip

         dat     2            ,aSkip*20
aTab     dat     4            ,aSkip*4
         dat     3            ,aSkip*24

aStart   sne     aAttack+aSkip*1 ,aAttack+aSkip*2
         seq     aAttack+aSkip*3 ,aAttack+aSkip*4
         jmp     aLoc            ,             >qDecoy*8
         sne     aAttack+aSkip*5 ,aAttack+aSkip*6
         seq     aAttack+aSkip*7 ,aAttack+aSkip*8
         jmp     aDecode+1       ,             >qDecoy*9
         sne     aAttack+aSkip*21,aAttack+aSkip*22
         seq     aAttack+aSkip*23,aAttack+aSkip*24
         jmp     aDecode+1       ,<aDecode
         sne     aAttack+aSkip*25,aAttack+aSkip*26
         seq     aAttack+aSkip*27,aAttack+aSkip*28
         jmp     aDecode+1       ,>aDecode
         sne     aAttack+aSkip*9 ,aAttack+aSkip*10
         seq     aAttack+aSkip*11,aAttack+aSkip*12
         jmp     aDecode         ,{aDecode
         sne     aAttack+aSkip*13,aAttack+aSkip*14
         seq     aAttack+aSkip*15,aAttack+aSkip*16
         jmp     aDecode         ,}aDecode
         sne     aAttack+aSkip*17,aAttack+aSkip*18
         seq     aAttack+aSkip*19,aAttack+aSkip*20
         jmp     aDecode         ,             >qDecoy*7
         sne     aAttack+aSkip*41,aAttack+aSkip*42
         seq     aAttack+aSkip*43,aAttack+aSkip*44
         djn.f   aDecode         ,aDecode
         sne     aAttack+aSkip*81,aAttack+aSkip*82
         seq     aAttack+aSkip*83,aAttack+aSkip*84
         jmp     aDecode         ,<aDecode
         sne     aAttack+aSkip*97,aAttack+aSkip*98
         seq     aAttack+aSkip*99,aAttack+aSkip*100
         jmp     aDecode         ,>aDecode
         jmp     pStart          ,             >qDecoy*6

aDecode  mul.ab  aTab         ,aTab
         add.b   @-1          ,aAttack
aLoc     sne     aBomb-1      ,@aAttack
         add     #aSkip       ,aAttack
         sne     aBomb-1      ,@aAttack
         add     #aSkip       ,aAttack
         sne     aBomb-1      ,@aAttack
         add     #aSkip       ,aAttack

         mov     aBomb        ,@1
aAttack  mov     aBomb        ,*aSkip
         add     #6           ,-1
         djn     -3           ,#15
         jmp     pStart       ,>qDecoy*6
     for 17
         dat     0            ,0
     rof
qEnd     equ     (qPap+6)
qStep    equ     (2940)
qStep2   equ     184
qRetinA  equ     (qStep2+950)
qSpace   equ     (2667)
qDecoy   equ     (-11*13)

pStart   spl    rStart        ,>qDecoy*9
         spl    sStart        ,>qDecoy*10
qStart   spl     1            ,>qDecoy*11
         mov.i   -1           ,#0
         spl     1            ,>qDecoy*12
         mov     <rCopy       ,{rCopy

qPap     spl     @0           ,>qStep
         mov     }-1          ,>-1
         mov     {-2          ,<1
         spl     @0           ,>qStep2
         mov.i   #qRetinA     ,}qSpace-qRetinA-3
         dat     0            ,0
     for qPap+12
         dat     0            ,0
     rof
rStart   spl     1            ,>qDecoy*13
         mov.i   sStart       ,#0
         spl     1            ,>qDecoy*14
         mov     <sCopy       ,{sCopy
rCopy    jmp     qEnd+qSpace*2,qEnd
     for rStart+12
         dat     0            ,0
     rof
sStart   spl     1            ,>qDecoy*15
         mov.i   rStart       ,#0
         spl     1            ,>qDecoy*16
sCopy    jmp     qEnd+qSpace*1,qEnd

         end     aStart


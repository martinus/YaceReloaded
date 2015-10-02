;redcode-94
;name Froth and Fizzle
;author P.Kline
;assert 1

qDecoy   equ     (-11*13)
aSkip    equ     (10+7*1810)
;        dat     0            ,0   precedes aBomb
aBomb    dat     -70          ,1
         dat     aSkip        ,aSkip
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
     for 37
         dat     0            ,0
     rof
qStep    equ     (7*3754)
qStep2   equ     (1303+7*1021)
pStart   mov     <rCopy       ,{rCopy
         spl     2            , }qDecoy*11
qtab2    spl     1            , }qDecoy*12
         spl     1            , }qDecoy*13
         mov     <rCopy       ,{rCopy
rCopy    spl     rPap+7+4000  ,rPap+7
rPap     mov     <1           ,{1
         spl     2000+7       ,7
qPap     spl     @0           ,>qStep
         mov     }qPap        ,>qPap
         mov     {qPap        ,<1
         spl     @0           ,>qStep2
         mov.i   #6000-1-2667 ,}2667
         mov.i   >0           ,>0

         end     aStart


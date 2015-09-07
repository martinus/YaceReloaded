;redcode-94
;assert CORESIZE==8000
;name Sunset
;author David Moore
;strategy P^3
;strategy Recon 2 or paper + stone

;---------
; Recon 2
;---------

; Recon 2 looks at pairs of cells that are 6 apart.
; When something is found, it gets wiped with 14 SPLs like this:
; ..X.....X.....

; distance between scanned pairs:
rStep equ 6557   ; overcomes 3, 7, 9, and 11 point imps

; 6557 * 231 = 2667   (2667 *  3 = 1)
; 6557 *  99 = 1143   (1143 *  7 = 1)
; 6557 *  77 =  889   ( 889 *  9 = 1)
; 6557 *  63 = 5091   (5091 * 11 = 1)

; use different boot locations to throw off one-shot scanners
rPlaceA equ 1282
rPlaceB equ 6800

rDestB  nop (rPlaceB - rPlaceA), (rPlaceB-rPlaceA)

reconB  add.f rDestB, rDest   ; boot to location B
reconA  mov  rEnd,   <rDest   ; boot to location A
        mov {reconA, <rDest
        mov {reconA, <rDest
        mov {reconA, <rDest
        mov {reconA, <rDest
rSrc    jmn  reconA, {reconA
rDest   spl  rPlaceA+5, rPlaceA+15
        mov  2, rDest   ; hide boot pointer

    for 5
        dat 0, 0
    rof

rPtr equ (rScan-8)

        dat      19,  19
rDiff   spl #-rStep, #-rStep
rWipe   mov   rDiff, >rPtr    ; hit 'em with SPLs
rW2     mov  *rWipe, >rPtr    ; later, this becomes a DAT clear
        djn.a rWipe,  rLength

rLoop   sub   rDiff, @rS2
rScan   sne rStep-1,  rStep-7 ; check a pair
        sub   rDiff,  rScan
rS2     seq  *rScan, @rScan   ; check another pair
        slt.a   #20,  rScan   ; ignore self
rTimer  djn   rLoop, #4800    ; count down to DAT phase

rLength sub.ba   #0,   #-7     ; set up for SPL wipe
rTweak  mov.ab @rS2,   @rWipe
rT2     jmn    *rW2,    rTimer ; when timer expires,
rEnd    djn.a <rTweak, {rT2    ; go to DAT clear mode

;---------
; P-space
;---------

    for 12
        dat 0,0
    rof

storage equ 234

think   ldp.a  #0,      mtab
        ldp.ba  2,      table
        mod.ba *mtab,   table
        stp.b  *table, #storage
table   jmp }0,     724 ; =  80*9 + 4 = 65*11 +  9 = 72*10 + 4
        jmp paper,  130 ; =  14*9 + 4 = 11*11 +  9 = 13*10 + 0
        dat reconB, 666 ; =  74*9 + 0 = 60*11 +  6 = 66*10 + 6
        dat paper,  835 ; =  92*9 + 7 = 75*11 + 10 = 83*10 + 5
        dat reconA, 448 ; =  49*9 + 7 = 40*11 +  8 = 44*10 + 8
        dat paper,  857 ; =  95*9 + 2 = 77*11 + 10 = 85*10 + 7
        dat reconB, 776 ; =  86*9 + 2 = 70*11 +  6 = 77*10 + 6
        dat paper,  362 ; =  40*9 + 2 = 32*11 + 10 = 36*10 + 2
        dat reconA, 778 ; =  86*9 + 4 = 70*11 +  8 = 77*10 + 8
        dat paper,  801 ; =  89*9 + 0 = 72*11 +  9 = 80*10 + 1
        dat paper,  923 ; = 102*9 + 5 = 83*11 + 10 = 92*10 + 3
mtab    dat 0,  9
        dat 0, 11
        dat 0, 10
        DAT.F $-52, $778   ; mirror - used by Recon 2

    for 17
        dat 0,0
    rof

;---------------
; paper + stone
;---------------

pStone  spl #2 * 2862, {2 * 2862
        mov pAmmo, *2
        add.f pStone, 1    ; <- hit to start core clear
        mov 4655, 4655 + 2862
pSrcS   jmp -3, pStone
        dat 0,0
pAmmo   dat }1, >1

; This replicator fills the core with code that can't be run
; by other replicators.

pNext   spl   4200,  {pThis
        mov  }pThis, }pNext
        mov   pDat,  >5200
pThis   mov pNext+6, }pNext
        jmz.f pNext, *pThis
pDat    dat  <2667,  <5334
;;;     dat      0,   0      ; dat 0,0 must be there after boot

placeS equ 5300     ; stone boot location
placeP equ (placeS + 223)   ; paper boot location

paper   mov >pSrcS, >pDestS
        spl  2, >3988
        spl  1, >4191
pSrcP   spl  1,  pNext+6
        mov >pSrcS,  >pDestS
        mov <pSrcP,  {pDestP
pDestS  spl @pDestP,  paper+placeS  ; the stone needs 6+6 processes
        spl @pDestP, >pDestS        ; to work properly
pDestP  djn  paper+placeP+6, #paper+placeS  ; the paper needs 6

end think


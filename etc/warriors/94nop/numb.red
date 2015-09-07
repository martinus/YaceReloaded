;redcode-94
;name Numb
;author Roy van Rijn
;strategy Q^4 -> Stone/Paper
;assert 1

;It can runs nop and draft
;Scores better in the draft hill (2nd place when submitted, yay!)

;The paper was made very quickly, its basic...
;and not so anti imp as I wanted it to be.
;And the constants came after 2 days of constant optimization
;I first randomly chose all constants, stone/paper/decoys etc etc
;and then I created 100 warriors for all constants after eachother.
;Long and hard job, but it worked for Dawn, and also Numb! :)

load0 z for 0
        rof

;Paper constants:
cstep1  equ    3137
nstep1  equ    705
tstep1  equ    1601

;Stone/Boot Constants
hStep   equ    6046
hTime   equ    2627
hDjn    equ    4277
hOff    equ    5
sOff    equ    1398

;Paper boot constants
pAw1   equ 5567
pAw2   equ 472

pGo     spl     1       , B1
t2      spl     1       , B2
        spl     1       , B3

      mov    {cp        , {pBo1
pBo1  spl    pEnd+pAw1  , {5747

      mov    {pEnd      , {pBo2
pBo2  jmp    pEnd+pAw2  , {4584

;Paper makes three copies and bombs (8x) with a anti-imp bomb
cp    spl    @pEnd      , <tstep1
      mov.i  }cp        , >cp
nothA spl    @nothA     , <cstep1
      mov.i  }nothA     , >nothA
      mov.i  bomb       , <641
      mov    {nothA     , {nothB
nothB djn.f  nstep1     , >4228
bomb  dat    <5334      , <2667
pEnd  dat    0          , 0

;Some spacing:
      for    31
      dat    0          , 0
      rof

;Pretty normal stone boot
bBoot   mov     stone   , sOff-6-CURLINE
        mov     hBomb   , sOff+5-CURLINE
        spl     2       , >2689
        spl     2       , >6562
sDst    spl     1       , sOff-CURLINE
        mov     <sSrc   , <sDst
        djn     @bBoot  , #5
sSrc    jmp     pGo     , hLoo+1

;And the normal quicksilver stone, just as it is...
stone   spl     #0      , 0
hLoop   mov     hBomb+hOff, @hPtr
hHit    add     #hStep*2  , hPtr
hPtr    mov     hBomb+hOff, }hHit-hStep*hTime
hLoo    djn.f   hLoop     , <hDjn
hBomb   dat     hStep     , >1

;and ofcourse the qscan that does wonders with my warriors
;although there is a better version (Reepicheep for example)
;but I don't know how to calculate the stepsizes there... :(

        dat     dat0+1  , A1
t1      dat     dat0+1  , A2

dat0    equ     (load0-123)

M equ 8000

invert equ iA+iB+iC
iA equ (a=x*x%M)+(a=a*x%M)+(a=a*a%M)+(a=a*x%M)+(b=a*a%M)+(b=b*b%M)
iB equ (b=b*b%M)+(c=b*b%M)+(c=c*b%M)+(d=c*c%M)+(d=d*d%M)+(d=d*d%M)
iC equ (d=d*c%M)+(d=d*d%M)+(d=d*c%M)+(y=a*d%M)

FACTOR  equ     1283

        dat     0*((x=FACTOR) + invert)         ; y = FACTOR^{-1} (mod 8000)

D       equ     (y+1)                           ; decoding factor
A1      equ     (1 + FACTOR * (t1-1 - qb))      ; t1 entry
A2      equ     (1 + FACTOR * (t1   - qb))
B1      equ     (1 + FACTOR * (t2-1 - qb))      ; t2 entries
B2      equ     (1 + FACTOR * (t2   - qb))
B3      equ     (1 + FACTOR * (t2+1 - qb))
C2      equ     (1 + FACTOR * (t3   - qb))      ; t3 entry

t3      dat     qb      ,       C2

        ; -- Decoding phase --
decode
q0      mul.b   *2      ,       qb
decide  sne     {t1     ,       @qb     ; \  The A-fields are pointers to
q1      add.b   t2      ,       qb      ;  } decoding tables.
        add.ba  *t3     ,       qb      ; /

        ; -- Attack phase --
        mov     qdat    ,       *qb
        mov     qdat    ,       @qb
qb      mov     24      ,       *D
        sub     qsub    ,       qb
        djn     -4      ,       #6
        jmp     bBoot

qsub    dat     -15     ,       21
qdat    dat     10      ,       0

        ; no decoder mutations
qscan   seq     qb + D  ,       qb + D + B2             ; 664412947495
        jmp     decide

        ; q0 mutations
        sne     qb + D * C2,    qb + D * C2 + B2
        seq     <t3     ,       qb + D * (C2-1) + B2
        jmp     decode  ,       }q0             ; t3 + C2-1 = qb+D*(C2-1)

        sne     qb + D * A1,    qb + D * A1 + B2
        seq     <t1-1   ,       qb + D * (A1-1) + B2
        djn.a   decode  ,       {q0             ; t1-1 + A1-1 = qb+D*(A1-1)

        sne     qb + D * A2,    qb + D * A2 + B2
        seq     <t1     ,       qb + D * (A2-1) + B2
        jmp     decode  ,       {q0             ; t1 + A2-1 = qb+D*(A2-1)

        ; q1 mutations
        sne     qb + D * B1,    qb + D * B1 + B1
        seq     <t2-1   ,       qb + D * (B1-1) + (B1-1)
        jmp     decode  ,       {q1             ; t2-1 + B1-1 = qb+D*(B1-1)

        seq     qb + D * (B1-2),qb + D * (B1-2) + (B1-2)
        djn     decode  ,       {q1

        sne     qb + D * B3,    qb + D * B3 + B3
        seq     <t2+1   ,       qb + D * (B3-1) + (B3-1)
        jmp     decode  ,       }q1             ; t2+1 + B3-1 = qb+D*(B3-1)

        ; no mutations
        sne     qb + D * B2,    qb + D * B2 + B2        ; 369320886854
        seq     <t2     ,       qb + D * (B2-1) + (B2-1)
        jmp     decode                          ; t2 + B2-1 = qb+D*(B2-1)

        jmp     bBoot
end     qscan


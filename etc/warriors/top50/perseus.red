;redcode-94nop
;name Perseus
;author Anton Marsden
;strategy Bomb-resistant Blur-style scanner -> Crystal Clear
;strategy Crystal Clear is a SPL/DAT clear that has some spiral killing ability
;strategy v7: Slightly improved clear
;strategy v9: Tweaking to reduce some weaknesses
;assert CORESIZE==8000
;kill Perseus

step  EQU    (-112)  ;; 112 seems ok, should be low to retain spiral killing power

OFFSET EQU (btm-ptr)

gate EQU ptr

ptr   dat  OFFSET+2667+112-35, -step
      dat    OFFSET+3, 0        ;; must have a DAT after the gate to deal with 7 pt imps
cc    spl    #OFFSET+4, <2667
scan  seq.i  2*step, 2*step+8
chg   mov.ab scan, ptr            ;; SCANNED B
a     sub.f  inc, }chg
sw    mov.i  cc, >ptr
      jmn.a  scan, {chg   ;; poor man's Air Bag - falls through if:
                          ;; - scan is hit with (0, X)
                          ;; - chg is hit with (X, Y) (sometimes)
                          ;;   (this could be effective against dat X, 1 bombs) 
inc   spl.a  #-step, -step
      mov.i  *sw, }gate   ;; The combination of > and } seems to improve the score
btm   djn.f  -1, >inc     ;; against Impfinity (sometimes catches the imp at the second gate)

away  dat   0,0


      mov.ab  -1, -4              ;; SCANNED B
      dat   0,0


dest EQU (boot+2099-5)

decoyOff EQU (dest+50+48+2)
decOff EQU (boot+200+4)

boot
      mov  <away, <bb
      mov  <away, <bb
      mov  <away, <bb
      mov  <away, <bb
      mov  <away, <bb
      mov  <away, <bb
      mov  <away, <bb   ;; SCANNED A
      mov  <away, <bb
      spl @bb,           <decoyOff+208*1
      mov  <away, <bb
      mov  <away, <bb
      mov  <away, <bb

bb      div.f #10, #dest
      mov {decoyOff+208*2, {decoyOff+208*2+104
      mov <-9,<6        ;; SCANNED A
     
;;;------------------------------------------------------
     
n FOR 7
      mov {decoyOff+208*(n+2), {decoyOff+208*(n+2)+104
ROF

      mov <decOff, <decOff              ;; scanned
     
n FOR 7
      mov {decoyOff+208*(n+9), {decoyOff+208*(n+9)+104
ROF

      mov <decOff+8, <decOff+8             ;; scanned

;;;------------------------------------------------------

n FOR 3
      mov {decoyOff+208*(n+16), {decoyOff+208*(n+16)+104
ROF
      mov <-96,<-48
     
n FOR 3
      mov {decoyOff+208*(n+20), {decoyOff+208*(n+20)+104
ROF

      mov <decOff+104, <decOff+104             ;; scanned
     
n FOR 7
      mov {decoyOff+208*(n+23), {decoyOff+208*(n+23)+104
ROF

      mov <decOff+104+8, <decOff+104+8            ;; scanned

;;;------------------------------------------------------

n FOR 7
      mov {decoyOff+208*(n+30), {decoyOff+208*(n+30)+104
ROF

      mov <decOff+208, <decOff+208             ;; scanned
     
n FOR 7
      mov {decoyOff+208*(n+37), {decoyOff+208*(n+37)+104
ROF

      mov <decOff+208+8, <decOff+208+8             ;; scanned

;;;------------------------------------------------------

n FOR 7
      mov {decoyOff+208*(n+44), {decoyOff+208*(n+44)+104
ROF

      mov <decOff+312, <decOff+312             ;; scanned
     
n FOR 7
      mov {decoyOff+208*(n+51), {decoyOff+208*(n+51)+104
ROF

      mov <decOff+312+8, <decOff+312+8             ;; scanned

   dat <616, <616
   dat #1, 1
   dat #1, 1
   dat #1, 1
   dat #1, 1
   dat #1, 1
   dat 0,0

END boot


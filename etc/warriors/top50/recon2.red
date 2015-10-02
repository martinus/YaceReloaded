;redcode-94
;assert CORESIZE==8000
;name Recon 2
;author David Moore
;strategy SNE scanner / SPL wiper

; Look at pairs of cells that are 6 apart.
; When something is found, wipe it with 14 SPLs like this:
; ..X.....X.....

; distance between scanned pairs:
step equ 6557   ; overcomes 3, 7, 9, and 11 point imps
;; step equ 2727  ; alternative; works on 3, 13, and 17 pt imps

; 6557 * 231 = 2667   (2667 *  3 = 1)
; 6557 *  99 = 1143   (1143 *  7 = 1)
; 6557 *  77 =  889   ( 889 *  9 = 1)
; 6557 *  63 = 5091   (5091 * 11 = 1)

; 2727 * 221 = 2667   (2667 *  3 = 1)
; 2727 *  51 = 3077   (3077 * 13 = 1)
; 2727 *  39 = 2353   (2353 * 17 = 1)

ptr equ (scan-8)

        dat      19,  19
diff    spl  #-step, #-step
wipe    mov    diff, >ptr     ; hit 'em with SPLs
w2      mov   *wipe, >ptr     ; later, this becomes a DAT clear
        djn.a  wipe,  length

loop    sub    diff, @s2
scan    sne (step*2) - 1, (step*2) - 7   ; check a pair
        sub    diff,  scan
s2      seq   *scan, @scan    ; check another pair
        slt.a   #20,  scan    ; ignore self
timer   djn    loop, #4800    ; count down to DAT phase

length  sub.ba #0,  #-7      ; set up for SPL wipe
tweak   mov.ab @s2, @wipe
t2      jmn    *w2,  timer   ; when timer expires,
        djn.a  <tweak, {t2   ; go to DAT clear mode

end scan


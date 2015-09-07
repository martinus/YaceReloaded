;redcode-94
;name Silver Talon 1.2
;author Edgar
;strategy scan with transparent decoy
;assert 1

;My best single-strategy warrior to date. It uses continous carpet and
;scanning much like many other scanners on the hill, but the thing I
;think makes it different is that the carpet itself is composed of 
;SPLs with differing b-fields, what (at least in theory) should enable
;Silver Talon to score better against other scanners (it triggers their 
;bombing routines, and one-shots are mostly helpless agains Silver 
;Talon), but at the cost of 
;reduced effectiveness against stones (SPL #1,#1 would slow them down...)
;but this warrior is going to lose against stones anyway, and with my 
;luck the hill is crawling with stones at the moment :(

        org boot

;the decoy

for 9
        spl #1,#1
        spl #1,@1
        spl #1,}1
        spl #1,{1
        spl #-4,#1      ;transparence!
        spl #1,<1
        spl #1,*1
        spl #1,>1
rof

;the actual warrior. Execution starts at loop

head    spl #-4,5000            ;not to be executed, except when hit by DJN
                                ;       in which case I'm dead anyways
loop    mov head,>head          ;place carpet
        add.f step,scan         ;move scan window
scan    cmp.i }4,0              ;found something?
        mov.b scan,@loop        ;       Yes. adjust carpet pointer.
        djn loop,#999           ;fall through to d-clear after 1000 scans
step    spl #-152,>-152         ;standard d-clear
        mov clr,>head-5
        djn.f -1,>head-5
clr     dat 1,#18               ;d-clear bomb


;boot pointers

bp      dat -2000+5,-2000-9+5
wp      dat 0,clr+1

boot    mov <wp,{bp             ;the boot, neat and fast.
for 9
        mov <wp,{bp
rof
        spl @bp                 ;split to target
        mov 0,bp                ;erase destination pointer
                                ;and die

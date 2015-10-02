;redcode-94nop quiet
;assert CORESIZE==8000
;name Forgotten Lore II
;author David Moore
;strategy Scanning vamp which multitasks between two forms of attack.
;strategy First, DJNs are delivered throughout the core in an effort
;strategy to immobilize typical stones and core clears.
;strategy Second, scan for anything nonzero and drop a JMP on it.
;strategy The JMP points to a trap.
;strategy Next, we wipe the core with SPLs, starting with the trap.
;strategy Finally, the SPL clear is converted to a DAT clear.
;strategy Version II strategy: Instead of using pspace to switch
;strategy between a vamp and a 1-shot SPL/DAT clear, combine them into
;strategy the same warrior. Rather than jumping to the SPL clear
;strategy as soon as something is scanned, wait until weÕve actually
;strategy captured a process.

first equ (-117)
tptr equ 218  ; position of pointer to trap, relative to bite.

flag  dat 0, 0  ; When this gets hit, go to the core clear.
bite  jmp @tptr-first, first  ; This is used to send opponents to trap.

; Note the use of @ indirection (in the JMP attack, in the line above)
; which helps to protect the trap. This helps when one of the JMPs
; lands next to something like MOV.I >-1, }-1 in the opponent's code.
; Processes that are already in the trap won't get overwritten
; by such a MOV. Only the pointer to the trap gets overwritten.
; 
; After the initial phase (in which the JMPs are deployed),
; a core-clear will start.
; When the pointer to the trap gets overwritten by the core clear,
; it will then point to a second trap. In case the original trap
; is damaged, the core clear provides a new one.
; Another benefit of @ indirection: When silks get hit with a JMP
; and they copy the JMP to later generations, they are less likely
; to jump into my own code with @ than with $ (direct).
;
; The close proximity of "flag" to "bite" is intended as an
; anti-silk measure. If a silk hits the JMP at bite,
; then chances are pretty good that it hits flag as well.
; This allows us to skip the vamp phase (which is no longer
; effective due to the damaged JMP) and proceed directly
; to the SPL/DAT clear.

   for 19
      dat 0,0
   rof

boot  mov.x #(trap-bite)-(tptr+1), bite+tptr+1  ; Copy a pointer to trap
      mov.x #(trap-bite)-(tptr), }bp  ; plus extras in case of +1/-1 hit
      mov >tsrc, >tdest;  Create decoy & 2nd trap.
      mov -5, }lj  ; Hide boot code.

loop  sub.x #-bite-1, bite
      mov  b2, *bite
lj    jmz.f boot, <bite ; Scan at a rate of .33c (after boot).
      mov  @-2, @bite  ; Found something; let's hit it.
      jmz.f loop, flag  ; Stop if opponent caught already.
tdest jmp  clear, <6619  ; Go to SPL/DAT core clear.

   for 16
      dat 0,0
   rof

; This core clear can often beat 3 point imps (3 * 2667) without the
; need to meet them at the gate.
; The gate stops imps of the form MOV.I #1143, *0.
; If an imp of the form MOV.I #2, 1143 reaches the gate, the core clear
; will self destruct.

gate  dat 25, 3987
      dat 0, 0
      dat <2667, 9
clear spl #11, {6568  ; This will become spl #11, {1
      mov  -1, >gate  ; Then this will become mov -2, >gate
      mov *-1, }gate
      jmp  -2, <-3

   for 22
      dat 0,0
   rof

b2    djn.f #1, 1   ; These get thrown around at .33c.

; Using DJN.F #1, 1 is intended to disable self-splitting loops
; of the form:
; ;    SPL 0, 0
; ;    MOV
; ;    DJN.F -1, > X

   for 17
      dat 0,0
   rof

bp    spl #bite+tptr-1, <flag
trap  spl -1, <flag  ; The trap, executed by the opponent.
      spl #4000, }1    ; Count the number of proceses entering here.
tsrc  jmn.a #0-MAXPROCESSES, #-3  ; When every process is trapped,
      dat 0, 0  ; they move from the last line (tsrc) to this DAT.
      dat 0, 0

end boot

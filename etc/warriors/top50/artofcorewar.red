;redcode-94nop verbose
;name The Art of CoreWar
;author Fluffy/Sascha Zapf
;strategy qBob -> paper
;date Sat Jun 23 11:33:26 UTC 2007
;assert CORESIZE == 8000

        ORG     qBob

; --=| qBob |-----------------------------------------------------
;
; New quickscanner completely written from scratch.
;
; Scanned locations (relative to start of warrior):
;         336,  436,  536,  686,  786,  893, 1143, 1536, 1643, 1786, 1893,
;        2093, 2393, 2536, 2786, 3036, 3393, 3536, 4036, 4193, 4293, 4393,
;        4543, 4643, 5036, 5286, 5393, 5643, 5786, 6036, 6236, 6393, 6536,
;        6643, 6893, 7393, 7536, 7893
;
; Requirements:
;        qTab1@42, qTab2@94, qFound@36

        ; Constants for qBob chosen to have at least a minimal distance
        ; of 100 between all scanned locations.

        qA      EQU     1496
        qB      EQU     2746
        qC      EQU     4995
        qD      EQU      750
        qE      EQU      494
        qF      EQU      644
        qG      EQU     5694
        qH      EQU     5550
        qI      EQU     5192

        qHop    EQU     3857

        ; --=| qG mutation |------------------------------------

        ; sne.i qFound+qG*qD,            qFound+qG*qD+qHop
        ; seq.i < (qTab2-1),             qFound+(qG-1)*qD+qHop

        qOff01  EQU     ((qG * qD) % CORESIZE)
        qOff02  EQU     (((qG-1) * qD) % CORESIZE)

qBob    sne.i   qFound + qOff01,                qFound + qOff01 + qHop
        seq.i   < (qTab2 - 1),                  qFound + qOff02 + qHop
        jmp     qDec0,                          { qDec0

        ; --=| qI mutation |-----------------------------------

        ; sne.i qFound+qI*qD,            qFound+qI*qD+qHop
        ; seq.i < (qTab2+1),             qFound+(qI-1)*qD+qHop

        qOff03  EQU     ((qI * qD) % CORESIZE)
        qOff04  EQU     (((qI-1) * qD) % CORESIZE)

        sne.i   qFound + qOff03,                qFound + qOff03 + qHop
        seq.i   < (qTab2 + 1),                  qFound + qOff04 + qHop
        jmp     qDec0,                          } qDec0

        ; --=| qB mutation |------------------------------

        ; sne.i qFound+qB*qH,            qFound+qB*qH+qHop
        ; seq.i < (qTab1-1),             qFound+(qB-1)*qH+qHop

        qOff05  EQU     ((qB * qH) % CORESIZE)
        qOff06  EQU     (((qB-1) * qH) % CORESIZE)

        sne.i   qFound + qOff05,                qFound + qOff05 + qHop
        seq.i   < (qTab1 - 1),                  qFound + qOff06 + qHop
        jmp     qDec0,                          < qDec1

        ; --=| qF mutation |---------------------------------

        ; sne.i qFound+qF*qH,            qFound+qF*qH+qHop
        ; seq.i < (qTab1+1),             qFound+(qF-1)*qH+qHop

        qOff07  EQU     ((qF * qH) % CORESIZE)
        qOff08  EQU     (((qF-1) * qH) % CORESIZE)

        sne.i   qFound + qOff07,                qFound + qOff07 + qHop
        seq.i   < (qTab1 + 1),                  qFound + qOff08 + qHop
        jmp     qDec0,                          > qDec1

        ; --=| qC mutation |--------------------------------

        ; sne.i qFound+qC*qD*qH,         qFound+qC*qD*qH+qHop
        ; seq.i { qTab1,                 qFound+(qC-1)*qD*qH+qHop

        qOff09  EQU     ((((qC * qD) % CORESIZE) * qH) % CORESIZE)
        qOff10  EQU     (((((qC-1) * qD) % CORESIZE) * qH) % CORESIZE)

        sne.i   qFound + qOff09,                qFound + qOff09 + qHop
        seq.i   { qTab1,                        qFound + qOff10 + qHop
        jmp     qDec1,                          } qFound + qOff09 - 4

        ; --=| qE mutation |---------------------------------

        ; sne.i qFound+qE*qD*qH,         qFound+qE*qD*qH+qHop
        ; seq.i { (qTab1 + 1),           qFound+(qE-1)*qD*qH+qHop

        qOff11  EQU     ((((qE * qD) % CORESIZE) * qH) % CORESIZE)
        qOff12  EQU     (((((qE-1) * qD) % CORESIZE) * qH) % CORESIZE)

        sne.i   qFound + qOff11,                qFound + qOff11 + qHop
        seq.i   { (qTab1 + 1),                  qFound + qOff12 + qHop
        jmp     qDec1,                          } qDec1

        ; --=| qA mutation |----------------------------------

        ; sne.i qFound+qA*qD*qH,         qFound+qA*qD*qH+qHop
        ; seq.i { (qTab1 - 1),           qFound+(qA-1)*qD*qH+qHop

        qOff13  EQU     ((((qA * qD) % CORESIZE) * qH) % CORESIZE)
        qOff14  EQU     (((((qA-1) * qD) % CORESIZE) * qH) % CORESIZE)

        sne.i   qFound + qOff13,                qFound + qOff13 + qHop
        seq.i   { (qTab1 - 1),                  qFound + qOff14 + qHop
        jmp     qDec1,                          { qDec1

        ; --=| qH mutation with a trick |----------------------

        ; sne.i qFound+qD*qH,            qFound+qD*qH+qHop
        ; seq.i qFound+qD*(qH-1),        < qTab2

        qOff15  EQU     ((qD * qH) % CORESIZE)
        qOff16  EQU     ((qD * (qH-1)) % CORESIZE)

        sne.i   qFound + qOff15,                qFound + qOff15 + qHop
        seq.i   qFound + qOff16,                < qTab2
        jmp     qDec0,                          } qFound + qOff15 - 4

        ; --=| free scan |----------------------------------

        qOff17  EQU     qFree

        seq.i   qFound + qOff17,                qFound + qOff17 + qHop
        jmp     qSelect,                        } qFound + qOff17 - 4

        ; --=| fast scan |-------------------------------------

        qOff18  EQU     qD

        seq.i   qFound + qOff18,                qFound + qOff18 + qHop
        jmp     qSetup,                         } qFound + qOff18 - 4

        ; --=| fallthrough scan |------------------------

        ; sne.i qFound+(qC-1)*qD*(qH-1), qFound+(qC-1)*qD*(qH-1)

        qOff19  EQU     (((((qC-1) * qD) % CORESIZE) * (qH-1)) % CORESIZE)

        sne.i   qFound + qOff19,                qFound + qOff19 + qHop
        jmz.f   boot,                           qFound + qOff19 + qHop + 1

        ; --=| decoder |-------------------------------------

qDec1   mul.ab  qTab1,                          qTab1
qDec0   mul.b   qTab2,                          @ qDec1
qSetup  mov.b   @ qDec1,                        qFound

        ; --=| choose between the two possible locations |-------------

qSelect sne.i   qEmpty,                         @ qFound
        add.ab  # qHop,                         qFound

        ; --=| bombing engine |-----------------------------

        ; Altough possible the engine from Tornado has been proven to be less
        ; effective here.

        qOffset EQU      -80
        qTimes  EQU       19
        qStep   EQU        6
        qFree   EQU      400

qAttack mov.i   qBomb,                          @ qFound
qFound  mov.i   qBomb,                          } qFree
        add.ab  # qStep,                        qFound
        djn     qAttack,                        # qTimes

        ; --=| start warrior |---------------------------------

        jmp     boot

qEmpty  dat.f   0,                              0

        ; --=| decoder table |-------------------------------

        dat.f   qA,                             qB
qTab1   dat.f   qC,                             qD
        dat.f   qE,                             qF

qBomb   dat.f   > qOffset,                      > 1

; --=| some empty space between qBob and paper code |---------------

        pOffset EQU       40

FOR pOffset
        dat.f   0,                              0
ROF

; --=| paper |------------------------------------------------

        ; Heavily optimized paper constants.

        pStep1  EQU      939
        pStep2  EQU     1928
        pStep3  EQU      241

        iStep   EQU     6332
        x       EQU      174
        y       EQU     6853

        ; Paper structure taken from nPaper II after testing several dozens
        ; of different structures.

silk1   spl     @ silk1 + 8,                    } pStep1
        mov.i   } silk1,                        > silk1

silk2   spl     @ silk2,                        > pStep2
        mov.i   } silk2,                        > silk2

        ; Attack code taken from Harmless Fluffy Bunny and The Human Machine.

        mov.i   # iStep,                        { 1
        mov.i   x,                              } y

        mov.i   { silk2,                        < silk3
silk3   jmz.a   @ silk3,                        pStep3

FOR (40 - pOffset)
        dat.f   0,                              0
ROF

; --=| boot |--------------------------------------------------

        ; Heavily optimized boot constants.

        awayOff EQU     4425
        pAway1  EQU     (awayOff + 5199)
        pAway2  EQU     (awayOff + 4078)
        decoy   EQU     4856

        ; Create 8 processes.

boot    spl     } 1,                            < qG
qTab2   spl     0,                              < qH
        spl     1,                              < qI

        ; Create and start two copies of the paper.
        ; Idea taken from paper(paper(paper(clear))).

        mov.i   { silk1,                        { pBoot1
pBoot1  spl     pAway1,                         { pAway2 + pBoot2

        mov.i   } pBoot1,                       > pBoot1
pBoot2  djn.f   pAway2,                         { decoy

        END


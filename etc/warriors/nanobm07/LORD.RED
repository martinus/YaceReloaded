;redcode-nano
;name lord of the digital swamp
;author Metcalf/Fluffy
;strategy scanner/imp
;assert CORESIZE==80

      step  equ 75
      first equ ptr+72

      add    # step,    ptr
ptr:  jmz.f  -1,        first
      mov.i  # 1,       @ ptr
      spl    ptr,       > ptr
      mov.i  # 1,       1

      end    ptr

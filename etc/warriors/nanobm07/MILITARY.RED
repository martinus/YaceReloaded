;redcode-nano
;assert CORESIZE == 80
;name Military Grade Nano
;author Ken Hubbard
;strategy  RedRace assisted in making this d-clear variant w/incendiary bomb.

spl.i  #     9, }     0
mov.i  <    52, }    -1			;evolved as >-32, }-1
mov.i  $     2, }    -2
djn.i  $    -1, }    -3
mov.i  *     5, <     0
end   0

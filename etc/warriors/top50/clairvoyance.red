;redcode-94
;name Clairvoyance
;author inversed
;strategy .80c prescan -> wipe -> .66c scan -> SSD clear
;strategy Based on Infravision
;assert 1

;-----[ Global ]-------------------------------------------------------;

gap1	equ	8
gap2	equ	8
gap3	equ	15
org	pre + 1

;-----[ Scan ]---------------------------------------------------------;

step	equ	24
hop	equ	(step/2)
safe	equ	16
zofs	equ	1583

cptr	dat	  zofs + hop	,   zofs

	for	gap1
	dat	  0		,   0
	rof

bptr	dat	  1		,   safe
cs0	spl	# step + 1	,   step
clear	mov	* bptr		, > cptr
	mov	* bptr		, > cptr
	djn.f	  clear		, } cs0

	for	gap2
	dat	  0	,   0
	rof

loop	add	  cs0	,   cptr
	sne	* cptr	, @ cptr
	djn.f	  loop	, { cptr
	jmp	  cs0	, < cptr

	for	gap3
	dat	  0		,   0
	rof

;-----[ Prescan ]------------------------------------------------------;

phop	equ	10
zpre	equ	7894
over	equ	6
djs	equ	1513

pre	add	  pinc	,   pptr
pptr	sne	  zpre	,   zpre + phop
	add	  pinc	,   pptr
	sne	* pptr	, @ pptr
	djn.f	  pre	, < djs
wipe	mov	  cs0	, } pptr
	djn	  wipe	, # phop + over
pinc	jmp	  loop	,   loop

;----------------------------------------------------------------------;


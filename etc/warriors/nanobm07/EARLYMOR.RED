;redcode-nano
;name early morning view
;author Neogryzor/FatalC
;strategy double clear
;assert CORESIZE == 80

        mov.i   clear+1     ,    {boot
        mov.i   clear       ,    {boot
boot    spl     clear+40    ,    }15
clear   mov.i   >-19        ,    -2
        djn.f   <0          ,    >0
        end

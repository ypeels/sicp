; The order is right to left
; argl is built up using cons
    ; 5.5.3 p. 582: they choose to have the resulting argl match the source code's argument list order
    
; to modify this, you would override/rewrite construct-arglist p. 583 and its helper
    ; aha, you could just remove the "reverse" on p. 583. that's what makes things go right to left!
    ; i suppose if the (reverse) is expensive, efficiency would be improved.


; the 5.4.1 reference is on p. 553? seems kinda pointless
    ; i guess their point is that you can actually find mechanistic code for order of evaluation?
        ; you don't have to figure things out empirically, like in chapter 1

(define (foo a b c)

    ; oh my, you can't do procedural stuff directly, like setting local variables...
        ; EDIT: apparently, you CAN use local variables using "let" and "set!", but they aren't anywhere near introducing those (esp the latter)
    ; you have to think in terms of return values...
    ; i would RATHER compute the full sum and then subtract the square of the min...
    (cond 
    
        ; EACH predicate/consequent pair must be enclosed by parens
        ((and (<= a b) (<= a c))   (+ (* b b) (* c c)))    ; a is the min (presumed positive?)    
        ((and (<= b a) (<= b c))   (+ (* a a) (* c c)))
        ( else                   (+ (* a a) (* b b)))   ; how friggin impenetrable is THAT??

    )
    
)
; you've been using these all along (+, -, *, /)
; but here is how you actually IMPLEMENT them.
; note that *args (in Python terms) is a LIST, so this had to be postponed till here.
    ; but still, you don't have to relegate it to a friggin exercise...
    
(define (g2 . w) (newline) (display w))     
(g2 1 2 3)  ; (1 2 3)
    
; (define g (lambda ( . w) (display w))) ; no, lambda taking 0+ arguments has WEIRDLY INCONSISTENT SYNTAX
(define g (lambda w (newline) (display w)))   ; if you added parens, it'd be ONE mandatory argument, and no variable argument list
(g 1 2 3)   ; (1 2 3)



; the point of variable arguments is that (same-parity) will take MANY INTEGERS as input, NOT a list
; performance seems to be the name of the game, so let's not call (element-of-set?, duplicated code be damned
(define (adjoin-set x set)
    (cond
        ((null? set)
            (cons x set))
        ((= x (car set))
            set)            ; already included in set, so sweep on by
        ((< x (car set))
            (cons x set))   ; insert
        (else
            (cons (car set) (adjoin-set x (cdr set))))))    ; this part MIGHT be inefficient though... 
            
            
; (adjoin-set will be COSTLIER for x already in set, since this is (element-of-set? + an extra (cons
; still, on average, only needs to scan HALF the set
; you COULD use (element-of-set?, but then you scan half the set TWICE

; note also that (adjoin-set is written entirely in terms of PRIMITIVES - so (adjoin is on the same level as (element-of...
; the original unordered implementation, on the other hand, has a MIX of cons/cdr and (element-of-set?...
            
            
            
(define (test-2.61)
    
    (define (test x set)
        (newline) (display set) (display " + ") (display x) (display " = ") (display (adjoin-set x set))
    )
    
    (test 1 '())
    (test 1 '(2 3))
    (test 2 '(2 3))
    (test 2 '(1 3))
    (test 5 '(1 3))
    (test -1 '(1 3))
    
    (test 7 '(1 2 6 10))
    
)
            
; (test-2.61)
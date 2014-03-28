(load "2.58a-infix.scm")    ; but override everything except (make-sum and (make-product...?

; after some mulling, i think the easiest way is to take advantage of memq.
    ; (memq item x)
    ; returns #f if item is not an item of list x
    ; otherwise returns the sublist beginning with the first occurrence of item

(define (sum? x)
    (not (equal? #f (memq '+ x))))
    
; really this should also check that it's not a sum, but (deriv only calls (product? AFTER ruling out (sum?
    ; i.e., i think order of operations is ALREADY enforced by (deriv; no need to worry about it here
(define (product? x)
    (not (equal? #f (memq '* x))))
    
    
    
(define (augend s)
    (post-memq '+ s))
(define (multiplicand p)
    (post-memq '* p))
(define (post-memq sym x)           ; don't include the operator
    (let ((tail (cdr (memq sym x))))
        (if (= 1 (length tail))     ; this does not bode well either (see pre-memq...)
            (car tail)
            tail
        )
    )
)
    
    
(define (addend s)
    (pre-memq '+ s))
(define (multiplier p)
    (pre-memq '* p))
(define (pre-memq sym x)            ; returns the REST of the list (contents preceding (memq x))
    (let ((target-tail (memq sym x)))

        (define (iter result tail)
            (if (equal? target-tail tail)
                result
                (iter 
                    (append result (list (car tail)))
                    (cdr tail)
                )
            )
        )
        
        (let ((result-list (iter() x))) ; hmm, need to hack the single-term case... this does not bode well...
            ;(display "pre-memq: ") (display result-list)
            (if (= 1 (length result-list))
                (car result-list)
                result-list
            )
        )
    )
)

(define (test-2.58b)
    
    ; first make sure there's no regressions
    (test-2.58a)                                            ; 2x and then 4
    
    ; then test the new form, very quickly
    (newline) (display (deriv '(x + 3 * (x + y + 2)) 'x))   ; should be 4
)
; (test-2.58b)

; see http://community.schemewiki.org/?sicp-ex-2.58 for more/better solutions
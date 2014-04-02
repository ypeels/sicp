(load "2.87-91-polynomial-algebra.scm")

; ugh once again the need for private code (just "(variable"!) means the implementation must go in the installer 

(define (test-2.88)

    (define (test p q)
        (newline) (display p) (display q)
        (display "\nsub: ") (display (sub p q))
    )
    
    (let (  (p1 (make-polynomial 'x '((1 1) (0 -1))))
            (p2 (make-polynomial 'x '((1 1) (0 +1))))
            )
        (test p1 p1)    ; (polynomial x). this is because (adjoin-term SKIPS zero terms.
        (test p1 p2)    ; (polynomial x (0 -2))
        (test p2 p2)    ; (polynomial x)
    )
)
(test-2.88)
(load "2.87-91-polynomial-algebra.scm")

(define (test-2.91)
    
    (define (test p1 p2)
        (newline)
        (newline) (display p1) (display p2)
        (display "\ndiv: ") (display (div p1 p2))
    )
    
    (let (  (p1 (make-polynomial 'x '((5 1) (0 -1))))
            (p2 (make-polynomial 'x '((2 1) (0 -1))))
            )
        (test p1 p1)    ; 1
        (test p2 p2)    ; 1
        (test p2 p1)    ; x**2 - 1
        (test p1 p2)    ; x^3 + x, remainder x-1
    )
)
(test-2.91)
            
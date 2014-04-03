(load "2.87-91-polynomial-algebra.scm")


(define (test-2.94)
    (define (test p1 p2)
        (newline)
        (newline) (display p1) (display p2)
        (display "\ngcd: ") (display (greatest-common-divisor p1 p2))
    )
    
            ; p1 and p2 constructors from problem statement.
    (let (  (p1 (make-polynomial 'x '((4 1) (3 -1) (2 -2) (1 2))))  ; x**4 - x**3 - 2x**2 + 2x = (x-1) (x**3 - 2x) = x(x-1)(x**2-2)
            (p2 (make-polynomial 'x '((3 1) (1 -1))))               ; x**3 - x = x(x-1)(x+1)
            (p3 (make-polynomial 'x '((2 1) (0 -1))))               ; x**2 - 1
            (p4 (make-polynomial 'x '((1 1) (0 1))))                ; x + 1
            (x  (make-polynomial 'x '((1 1))))
            )
        (test p1 p1)
        (test p2 p2)
        (test p3 p3)
        (test p4 p4)
        (test p1 p2)                                                ; '((2 -1) (1 1)) = x**2 - x (well, to within a sign)
        (test p2 p1)                     
        (test p3 p4)                                                ; '((1 1) (1 1)) = x+1
        (test p3 x)
        
    )

)
(test-2.94)
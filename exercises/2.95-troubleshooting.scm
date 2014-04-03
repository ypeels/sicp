(load "2.87-91-polynomial-algebra.scm")
    
(define (test-2.95 gcd-version)

    (define (greatest-common-divisor p1 p2)
        (apply-generic gcd-version p1 p2))

    ; polynomials from problem statement
    (define p1 (make-polynomial 'x '((2 1) (1 -2) (0 1))))
    (define p2 (make-polynomial 'x '((2 11) (0 7))))
    (define p3 (make-polynomial 'x '((1 13) (0 5))))

    (define q1 (mul p1 p2))
    (define q2 (mul p1 p3))

    (display "\np1: ") (display p1)
    (display "\np2: ") (display p2)    
    (display "\nq1: ") (display q1)  ; '((4 11) (3 -22) (2 18) (1 -14) (0 7))
    (display "\nq2: ") (display q2)  ; '((3 13) (2 -21) (1 3) (0 5))
    
    
    (display "\n(gcd p1 p1): ") (display (greatest-common-divisor p1 p1))   ; '((2 1) (1 -2) (0 1))
    (display "\n(gcd q1 q2): ") (display (greatest-common-divisor q1 q2))   ; '((2 1458/169) (1 -2916/169) (0 1458/169))

    ; so it's off by a constant factor. big whoop.
    ; but end users want answers to look CLEAN... sheesh

    ; should i trace gcd-terms by hand?
    ; gcd-terms -> remainder-terms
    ; remainder-terms -> div-terms
    ; div-terms -> (div (coeff a) (coeff b)), hence the rational numbers

)

; (test-2.95 'gcd-2.94) ; original
(load "2.87-91-polynomial-algebra.scm")

(define (test-2.93)
    
    (define (test L1 L2)
        (let ((p1 (make-polynomial 'x L1)) (p2 (make-polynomial 'x L2)))
            (let ((rf (make-rational p1 p2)))
                (newline)
                (newline) (display rf)
                (display "\nadded to itself: ") (display (add rf rf))
            )
        )
    )
    
    (define (regression-test x1 y1 x2 y2)
        (let ((r1 (make-rational x1 y1)) (r2 (make-rational x2 y2)))
            (newline)
            (newline) (display r1) (display r2)
            (display "\nadd: ") (display (add r1 r2))
            (display "\nsub: ") (display (sub r1 r2))
            (display "\nmul: ") (display (mul r1 r2))
            (display "\ndiv: ") (display (add r1 r2))
        )
    )
    
    (display "\nExercise 2.93 starting regression tests...")
    (regression-test 1 1 1 1)
    (regression-test 1 2 1 3)
    (regression-test 1 2 1 2)
    
    
    ; data from problem statement
    (let ((L1 '((2 1)(0 1))) (L2 '((3 1)(0 1))))
        (test L1 L1)                                ; far from the simplified answer (2) before gcd-terms is implemented
        (test L2 L2)                                ; unfortunately, "broken" by Exercise 2.97    
        (test L1 L2)
    )
)
;(test-2.93)

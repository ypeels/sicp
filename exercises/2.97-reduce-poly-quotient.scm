(load "2.87-91-polynomial-algebra.scm")

(define (reduce x y)
    (apply-generic 'reduce x y))
    
    
    
(define (test-2.97)

    (define (test p1 p2)
        (newline)
        (newline) (display p1) (display p2)
        (display "\nreduce: ")
        (display (reduce p1 p2))
    )

    (let (  (p1 (make-polynomial 'x '((1 1)(0 1))))
            (p2 (make-polynomial 'x '((3 1)(0 -1))))
            (p3 (make-polynomial 'x '((1 1))))
            (p4 (make-polynomial 'x '((2 1)(0 -1))))
            )
        (test p1 p1)
        (test p3 p3)
        (test p1 p3)
        (test p1 p4)
    )
)
(test-2.97)

             
             
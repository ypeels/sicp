(load "2.87-91-polynomial-algebra.scm")


    
    
    
(define (test-2.97)

    (define (test p1 p2)
        (newline)
        (newline) (display p1) (display p2)
        (display "\nreduce: ")
        (display (reduce p1 p2))
    )
    
    (define (test-sum q1 q2)
        (newline)
        (newline) (display q1) (display q2)
        (display "\nadd: ")
        (display (add q1 q2))
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
        
        ; (load "2.93-make-rat-polynomial.scm") (test-2.93) ; meh
        (let (  (rf1 (make-rational p1 p2)) ; (x+1) / (x**3 - 1)
                (rf2 (make-rational p3 p4)) ; x / (x^2 - 1)
                )
            (test-sum rf1 rf1)      ; unlike exercise 2.93, this is just 2*rf1 now
            (test-sum rf2 rf2)
            
            
            (test-sum rf1 rf2)
            ; should be (x**3 + 2x**2 + 3x + 1) / (x**4 + x**3 - x - 1)
            ; (rational (polynomial x (3 -1) (2 -2) (1 -3) (0 -1)) polynomial x (4 -1) (3 -1) (1 1) (0 1))

            
        )
    )
)
(test-2.97)

             
             

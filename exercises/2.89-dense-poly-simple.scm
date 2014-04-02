(load "2.87-91-polynomial-algebra.scm")

; once again, changes were made to the private members of the installer

(define (test-2.89)

    (install-polynomial-package-2.89 'dense)

    (define (test p1 p2)
        (newline) (display p1) (display p2)
        (display "\nadd: ") (display (add p1 p2))
        (display "\nmul: ") (display (mul p1 p2))
    )
    
    (let (  (p1 (make-polynomial 'x '(1 -1)))
            (p2 (make-polynomial 'x '(1 1)))
            )
        (test p1 p1)
        (test p2 p2)
        (test p1 p2)
    )
)

(test-2.89)   




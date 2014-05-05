; takes as arguments a variable and a compile-time environment
(define (find-variable var compile-time-env)

    (define (find-frame ctenv frame-number)
        (cond
            ((null? ctenv)
                false)
            ((memq var (car ctenv))
                frame-number)
            (else
                (find-frame (cdr ctenv) (+ frame-number 1)))
        )
    )
    
    (define (find-displacement frame)
        (define (iter fr val)
            (if (eq? var (car fr))
                val
                (iter (cdr fr) (+ val 1))
            )
        )
        (iter frame 0)
    )
    
    (let ((frame-number (find-frame compile-time-env 0)))
        (if frame-number        
            ; returns the lexical address of the variable with respect to that environment
            (list 
                frame-number
                (find-displacement (list-ref compile-time-env frame-number))
            )
            'not-found
        )
    )
)


(define (test-5.41)

    (newline) (display (find-variable 'c '((y z) (a b c d e) (x y)))) ; should be (1 2)
    (newline) (display (find-variable 'x '((y z) (a b c d e) (x y)))) ; should be (2 0)
    (newline) (display (find-variable 'w '((y z) (a b c d e) (x y)))) ; should be 'not-found
)
(test-5.41)


; remember, the COMPILER need not be blazing fast, as long as the resulting OBJECT code is fast!
(define (union-set set1 set2)
    (cond
        ((null? set1) set2)
        ((null? set2) set1)
        (else (let ((x1 (car set1)) (x2 (car set2)))
            (cond 
                ((= x1 x2)                                      ; found in both sets; step both sets forward
                    (cons x1 (union-set (cdr set1) (cdr set2))))
                ((< x1 x2)
                    (cons x1 (union-set (cdr set1) set2)))
                ((< x2 x1)
                    (cons x2 (union-set set1 (cdr set2))))
                (else (error "unreachable case - union-set"))
            )
        ))
    )
)
          

(define (test-2.62)

    (define (test s1 s2)
        (newline)
        (display s1)
        (display " + ")
        (display s2)
        (display " = ")
        (display (union-set s1 s2))
    )
    
    (test '() '())
    (test '() '(1))
    (test '() '(1 2))
    (test '(1) '())
    (test '(1) '(1))
    (test '(1 2) '(1))
    (test '(1 2) '(1 2))
    (test '(1 2 4) '(3 4 5))
)

;(test-2.62)
    
            
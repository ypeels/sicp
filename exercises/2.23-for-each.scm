(define (for-each-2.23 proc items)
    (cond 
        ((null? items)
            "unused return value")
        (else
            (proc (car items))    ; not sure how to perform a non-returning action inside an (if)...
            (for-each-2.23 proc (cdr items))
        )
    )
)


(define (test-2.23)

    (define (test proc)
        (proc
            (lambda (x) (newline) (display x))
            (list 57 321 88)
        )
    )
    
    (test for-each)
    (test for-each-2.23)
)
        
; (test-2.23)
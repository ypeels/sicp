(load "4.51-53-permanent-set-and-if-fail.scm")

(define (test-4.52)

    (load "4.35-37-require.scm")
    (install-require) ; needed for (an-element-of)
    
    (install-element-of)

    (ambeval-batch
    
        ; testing code from problem statement
        '(define (t1)
            (if-fail (let ((x (an-element-of '(1 3 5))))
                       (require (even? x))
                       x)
                     'all-odd)
        )
        ; should evaluate to 'all-odd
        
        '(define (t2)
            (if-fail (let ((x (an-element-of '(1 3 5 8))))
                       (require (even? x))
                       x)
                     'all-odd)
        )
        ; should evaluate to 8, then 'all-odd 
        
        '(define (t3)
            (if-fail (let ((x (an-element-of '(1 3 5 8 9 10 11 13 16 17))))
                       (require (even? x))
                       x)
                     'all-odd)
        )
        ; 8 10 16 'all-odd "no more values" "no current problem"
    
    
    )
    (driver-loop)
)
(define analyze analyze-4.52) (test-4.52)

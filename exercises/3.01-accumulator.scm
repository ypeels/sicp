(define (make-accumulator sum)

    ; you COULD wrap this with a let block, but there's NO POINT. see notes on section 3.1.1
    (lambda (x) 
        (begin
            (set! sum (+ x sum))    ; don't forget that the return value of set! is IMPLEMENTATION DEPENDENT (i.e., undefined by whatever standard exists for this godforsaken language)
            sum
        )
    )
)
    
    
(define (test-3.01)
    
    (define A (make-accumulator 5))
    (define (test n)
        (newline) (display (A n))
    )
    (test 10)   ; 15
    (test 15)   ; 30
)
;(test-3.01)
    
    
    
    
(load "3.53-62-stream-operations.scm")

; from problem statement
(define factorials (cons-stream 1 (mul-streams factorials integers)));<??> <??>)))
   

; this is just factorials, but with addition and a flexible input stream
(define (partial-sums input-stream)

; in fact, you should be able to re-define factorials in terms of "partial-products"


    (cons-stream
        (stream-car input-stream)
        (add-streams
            (partial-sums input-stream)     ; i can't believe this works...
            (stream-cdr input-stream)
        )
    )
)
            
            






(define (test-3.55)

    (define (test-sums n)
        (test n partial-sums))
    (define (test-products n)
        (test n partial-products))
    
    (define (test n proc)
        (let ((result (proc integers)))
            (newline) (display (stream-ref result n))
        )
    )
    
    
    (display "\nPartial sums of the integers:")
    (test-sums 0)    ; 1
    (test-sums 1)    ; 3
    (test-sums 2)    ; 6
    (test-sums 3)    ; 10
    (test-sums 4)    ; 15
    (test-sums 5)    ; 21
    
    ;(display "\n\nFactorials:")
    ;(test-products 0)
    ;(test-products 1)    
    ;(test-products 2)    
    ;(test-products 3)    
    ;(test-products 4)    
    ;(test-products 5)    
    
    
)

(test-3.55)
(load "3.53-62-stream-operations.scm")
(load "3.54-mul-streams.scm")

   

; this is just factorials, but with addition and a flexible input stream
(define (partial-sums input-stream)
    (partial-accum add-streams input-stream))
(define (partial-products input-stream)
    (partial-accum mul-streams input-stream))

; in fact, you should be able to re-define factorials in terms of "partial-products"
(define (partial-accum stream-op input-stream)
    (cons-stream
        (stream-car input-stream)
        (stream-op
            (partial-accum stream-op input-stream)     ; i can't believe this works... oh it's accessing old results via MEMOIZATION
            (stream-cdr input-stream)
        )
    )
)
            
            






(define (test-3.55)

    (define (test-sums n)
        (test n partial-sums))
    (define (test-products n)
        (test n partial-products))
    
    (define (test-n n proc)
        (let ((result (proc integers)))
            (newline) (display (stream-ref result n))
        )
    )
    
    (define (test proc name)
        (newline)
        (newline)
        (display name)
        (test-n 0 proc)
        (test-n 1 proc)
        (test-n 2 proc)
        (test-n 3 proc)
        (test-n 4 proc)
        (test-n 5 proc)
        (test-n 6 proc)
        (test-n 7 proc)
        (test-n 8 proc)
    )
    
    (test partial-sums "Partial sums of the integers")          ; 1 3 6 10 15 21 28 36 45
    (test partial-products "Factorials via partial products")   ; 1 2 6 24 120 720 5040 40320 362880
        
    
  
    
    
)

; (test-3.55)
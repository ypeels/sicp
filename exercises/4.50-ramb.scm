; a new special form ramb that is like amb except that it searches alternatives in a random order, 
; rather than from left to right


; overrides must be done at global scope... oh well, let's hope other files don't need to (load) ramb...
; alternatives
    ; copy-paste (analyze) into here and be careful about load order
    ; modify (analyze) in upstream code
(load "ch4-ambeval.scm")
(define analyze-ambeval analyze)
(define (analyze-4.50 expr) 
    (if (ramb? expr)
        (analyze-ramb expr)
        (analyze-ambeval expr)
    )
)

(define (ramb? expr) (tagged-list? expr 'ramb))

(define (analyze-ramb expr)

    ; shuffle the arguments and pass to (analyze-amb)
    (analyze 
        (cons 
            'amb 
            (shuffle-list (amb-choices expr))
        )
    )
)


; to be safe, don't make it (shuffle!)
; COULD make this internal to (analyze-ramb), but this is easier to test, and possibly reusable...
(define (shuffle-list L)    
    (let ((N (length L)))    
        (define (iter index-history result)            
            (let ((random-index (random N)))                
                (cond 
                    ((>= (length index-history) N)      ; termination condition
                        result)
                    ((memq random-index index-history)  ; already drew that card! try again.
                        (iter index-history result))
                    (else
                        (iter
                            (cons random-index index-history)
                            (cons (list-ref L random-index) result)
                        )
                    )
                )
            )
        )
        (iter '() '())
    )
)

(define (test-4.50)

    (ambeval-batch
        '(define (test) (ramb 1 2 3 4 5 6 7 8 9 10))
    )
    
    (driver-loop)
)
;(define analyze analyze-4.50) (test-4.50)

; for 4.49, you SHOULD NOT change all the "amb" statements in the parser to "ramb"
    ; you only need to change alyssa's modified (parse-word)
    ; the way i have it set up, it'd be easier to use (list-ref (shuffle-list word-list) )
    

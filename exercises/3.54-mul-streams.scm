(load "3.53-62-stream-operations.scm")

; analogously to add-streams
(define (mul-streams s1 s2)
    (stream-map * s1 s2))
   
; from problem statement
(define factorials (cons-stream 1 (mul-streams factorials integers)));<??> <??>)))
   
    
(define (test-3.54)
    

    
    (define (test n)
        (newline)
        (display (stream-ref factorials n))
    )
    
    (test 0)    ; 1 == 0!
    (test 1)    ; 1
    (test 2)    ; 2
    (test 3)    ; 6
    (test 4)    ; 24
    (test 5)    ; 120
)
; (test-3.54)
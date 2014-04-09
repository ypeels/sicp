(load "3.53-62-stream-operations.scm")

; skeleton from problem statement
(define (mul-series s1 s2)
  (cons-stream 
    ; <??> - a0 b0. by construction, this MUST be the first term in the product series.
    (* (stream-car s1) (stream-car s2))
    
    
    ;(scale-stream s2 (stream-car s1))
    
    (add-streams 

        ; <??> break symmetry and decide to iterate down s1.
        (scale-stream (stream-cdr s2) (stream-car s1))
        
        ; <??>  - there's GOTTA be some recursion here... 
        (mul-series (stream-cdr s1) s2)
        
        ; this is TOO symmetrical, and it only works for the first couple terms
        ;(mul-series (stream-cdr s1) s2) 
        ;(mul-series s1 (stream-cdr s2))   
    )
  )
)

; s1 = a0 + a1 x + a2 x**2 + ...
; s2 = b0 + b1 x + b2 x**2 + ...

(define (test-3.60)
    (load "3.59-integrate-series.scm")
    
    (let ((result (add-streams (mul-series cosine-series cosine-series) (mul-series sine-series sine-series))))
        (define (test n)
            (define (iter i)
                (newline) (display (stream-ref result i))
                (if (< i n)
                    (iter (+ i 1))
                )
            )
            (iter 0)
        )
        (test 20); 1 0 0 0 0 0 0 0 ...
    )
)
; (test-3.60)
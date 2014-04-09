(load "3.60-mul-series.scm")

; "Let S be a power series (exercise 3.59) whose constant term is 1. Suppose
; we want to find the power series 1/S, that is, the series X such that S · X = 1.
; Write S = 1 + SR where SR is the part of S after the constant term."

(define (sub-streams s1 s2)
    (add-streams 
        s1
        (scale-stream s2 -1)
    )
)

(define (invert-unit-series S)
    (if (not (= 1 (stream-car S)))
        (error "First term must be 1 -- INVERT-UNIT-SERIES" (stream-car S))        
        (let (  (Sr (stream-cdr S));(cons-stream 0 (stream-cdr S))) - don't construct "proper" series
                (one (sub-streams ones (cons-stream 0 ones)))
                )
                
            ;(let ((X (sub-streams one (mul-streams Sr X))))     ; really, just write down X = 1 - Sr X and let it run!?
            
            ; a LET won't LET you be recursive, haha
            ; but we know from exp-series that define CAN be recursive
            ;(define X (sub-streams one (mul-streams Sr X)))
            ; this doesn't work. need to stick X into the stream-cdr portion...            
            
            ; really, just write down X = 1 - Sr X and let it run!? i canNOT believe this works
            (define X 
                (cons-stream 
                    1 
                    (mul-series 
                        (scale-stream Sr -1)    ; Sr STARTS with its x**1 coeff, so its evaluation can be deferred
                        X
                    )
                )
            )
            
            X
            
        )
    )
)

                    
(define (test-3.61)
    (load "3.59-integrate-series.scm")

    (define exp-series
      (cons-stream 1 (integrate-series exp-series)))
      
    (define (test series n)
        (let ((result (invert-unit-series series)))
        
            (define (iter i)
                (newline) (display (stream-ref result i))
                (if (< i n)
                    (iter (+ i 1))
                )
            )
            (iter 0)
        )
    )
    
    (display "\n\npower series coefficients for e**-x")
    (test exp-series 6)
    ; 1, -1, 1/2, -1/6, 1/24, -1/120, 1/720, ...
    
    (display "\n\npower series coefficients for (cos x) (sec x) - should be 1 0 0 0 0 0...")
    (test (mul-series (invert-unit-series cosine-series) cosine-series) 10)
    
)
;(test-3.61)
            
        
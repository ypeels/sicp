(load "3.60-mul-series.scm")
(load "3.61-invert-unit-series.scm")

(define (div-series s1 s2)

    (if (= 0 (stream-car s2))
        (error "Denominator with zero leading coefficient -- DIV-SERIES"))
        
    (let ((normalization (/ 1 (stream-car s2))))
    
        (mul-series
            (scale-stream s1 normalization)
            (invert-unit-series (scale-stream s2 normalization))
        )        
    )
)


(define (test-3.62)

    (load "3.59-integrate-series.scm")
    
    (define (test stream n)
        (if (<= n 0)
            'done
            (begin
                (newline) (display (stream-car stream))
                (test (stream-cdr stream) (- n 1))
            )
        )
    )
    
    (let ((tangent-series (div-series sine-series cosine-series)))
        (test tangent-series 10)
        ; the result checks with mathworld.
        ; 0
        ; 1
        ; 0
        ; 1/3
        ; 0
        ; 2/15
        ; 0
        ; 17/315
        ; 0
        ; 62/2835
    )
)
; (test-3.62)
    
        
        
        

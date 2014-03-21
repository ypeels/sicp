(load "1.37-continued-fractions.scm")

(define (tan-cf x k)
    
    ;(define (D i) (- (* 2 i) 1))
    ;(define (N i)
        
    (/  (cont-frac-iter
            (lambda (i) (- 0 (square x)))   ; N(i) = -x^2
            (lambda (i) (- (* 2 i) 1.))     ; D(i) = 2i - 1
            k)
        x))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;            
(define (test-1.39)

    (define (test x)
        
        (define (test-k k)
            (display "\nk = ")
            (display k)
            (display ": ")
            (display (tan-cf x k)))
        
        (display "\n\nx =")
        (display x)
        (test-k 2)
        (test-k 4)
        (test-k 8)
        (test-k 16)
        (display "\nExact: ")
        (display (tan x)))
        
    (test 0.1)
    (test 0.2)
    (test 0.4)
    (test 1.0)
)

(test-1.39)


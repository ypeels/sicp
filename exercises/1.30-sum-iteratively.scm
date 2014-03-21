; semms kinda trivial, but useful for future exercises?

(define (sum-iter term a next b)
    (display "sum-iter")
    (define (iter a result)
        (if (> a b)
            result
            (iter (next a) (+ result (term a)))))
    (iter a 0))
    
    

    
; for testing (took longer than the actual exercise itself...)

(define (test-1.30)                             ; hey, scheme syntax IS really lax
    ;(load "1.29-higher-order-functions.scm")    ; for simpsons-integral
    
    ; will this override the (sum) used by simpson-integral?? doesn't look like it... needs to be at file scope
    ;(define (sum term a next b) (sum-iter term a next b)) 
    
    (display (simpson-integral cube 0 1 0.001)))
    
    
; uncomment to override and test!
;(load "1.29-higher-order-functions.scm") (test-1.30) ; original answer
;(load "1.29-higher-order-functions.scm") (define (sum term a next b) (sum-iter term a next b)) (test-1.30)
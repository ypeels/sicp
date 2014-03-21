; based on the scribble in susan's textbook, i've DONE this problem, as part of CS 1...


; a. by analogy with (sum)
(define (product factor a next b)
    (if (> a b)
        1                           ; identity element for multiplication
        (*  (factor a)
            (product factor (next a) next b))))
    
; b. by analogy with (sum-iter)
(define (product-iter factor a next b)
    (define (iter x result)
        (if (> x b)
            result
            (iter 
                (next x) 
                (* result (factor x)))))
    (iter a 1))

            
            
; test suite - which is much longer than the actual code...
(define (test-1.31)
    (define (id x) x)
    (define (inc x) (+ x 1))
    
    ; for computing pi
    (define (add-two x) (+ x 2))
    (define (pi-factor x) 
        (/ 
            (* (- x 1) (+ x 1))
            (square x)))
    
    (define (test-productation x y prod)
        (newline)
        (display x) (display " * ... *  ") (display y) (display " = ") (display (prod id x inc y)))
        
    (define (test-suite f name)   
        (newline)
        (newline)
        (display name)
    
        ; hand-check, i guess. remember, this is PRODUCTATION, not multiplication!
        (test-productation 3 4 f) ; 12
        (test-productation 5 6 f) ; 30
        (test-productation 8 8 f) ; 8
        (test-productation 1 4 f) ; 24
        (test-productation 2 5 f) ; 120
        
        (newline)
        (display "pi is approximately: ")        
        (display (* 4 (f pi-factor 3.0 add-two 9999)))  ; 3.14174973 [(product) exceeds maximum recursion depth for 99999]
    )
    
    (test-suite product "recursive productation of i")
    (test-suite product-iter "iterative productation of i")
)

(test-1.31) ; uncomment to test...
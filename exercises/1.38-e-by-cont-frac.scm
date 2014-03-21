(load "1.37-continued-fractions.scm")

   ; i  d
   ; 2, 2
   ; 5, 4
   ; 8, 6
   ; i  (i+1)/3 * 2

(define (euler K)
    (define (D i)
        (cond 
            ((= 2 (remainder i 3))
                (* (+ i 1) (/ 2 3)))
            (else 1)))
            
    (+ 2. (cont-frac-iter (lambda (x) 1) D K)))
    
    

    
(define (test-1.38)

    
    (define (test k)
        (newline)
        (display k)
        (display " : ")
        (display (euler k)))
    
    
    (test 5)    ; 2.71875
    (test 10)   ; 2.718281718...
    (test 20)   ; 2.718281828459045 (converged to display precision!)
    
    (display "\nexact: ")
    (display (exp 1))
    "goodbye world"
)
        
        
(test-1.38)
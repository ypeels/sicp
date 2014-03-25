; this feels like CS 1 too...
(load "2.33-37-accumulate.scm")

(define (horner-eval x coefficient-sequence)
  (accumulate 
    (lambda (this-coeff higher-terms) 
        
        ; <??> vvvvvvvvv my answer.
        (+ this-coeff (* x higher-terms))   ; "higher-terms" is really the RESULT of evaluating the higher powers of x. see (accumulate) definition...
    )                                       ; answer takes this VERY simple form because (accumulate) has "Horner form"
    0
    coefficient-sequence))
              
              
(define (brute-eval x coeffs)
    (define (iter n result)
        (if (>= n (length coeffs))
            result
            (iter (+ n 1) (+ result (* (list-ref coeffs n) (expt x n))))
        )
    )
    (iter 0 0)
)
    
    
(define (test-2.34)
    
    
    
    (let ((poly (list 1 3 0 5 0 1)))
    
        (define (test x)
            (newline)
            (display "\nx = ") (display x)
            (display "\nbrute eval: ") (display (brute-eval x poly))
            (display "\nhorner-eval: ") (display (horner-eval x poly))
        )
        
        (test 0)
        (test 2)
        (test 1.5)
    )
    

    
)
              

(test-2.34)
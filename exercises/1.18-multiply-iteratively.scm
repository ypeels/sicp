; analogous to fast-expt-iter
; so the "result" that we're using from 1.16 is the isomorphic algorithm
; the "result" that we're using from 1.17 is the mapping of operators from expt to mult





(define (fast-mult-iterative base factor)



    
    ; C = a + b*n = loop invariant
    ; C = a + (2b)(n/2) for even n
    ; C = (a+b) + b(n-1) for odd n
    ; C = a + b(0) for n = 0, so just return a.
    
    (define (iter a b n)
        (cond
        
            ; loop termination
            ((= n 0) a)
            
            ; even case: exactly analogous to (fast-expt-iterative), with (square) replaced by (double)
            ((even? n) 
                (iter
                    a
                    (double b)
                    (halve n)))
                    
            ; odd case: exactly analogous to (fast-expt-iterative), with (*) replaced by (+)
            (else
                (iter
                    (+ a b)
                    b
                    (- n 1)))))
                    
    ; initialize "a" to the identity element for ADDITION
    ; can only be "called" AFTER (iter) has been defined
    (iter 0 base factor))
            
            
(define (double x) (* x 2))
(define (halve x) (/ x 2))  ; mentioned in the problem statement, but they never bothered in (fast-expt)...
(define (even? x) (= (remainder x 2) 0))

(define (f x y) (fast-mult-iterative x y)); for testing
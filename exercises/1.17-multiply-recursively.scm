(define (fast-mult b n)      ; instead of a*b - to preserve isomorphism with fast-expt
    (cond   
    
        ; end of recursion. identity element for addition is 0, not 1!
        ((= n 0) 0)
        
        ; even case is EXACTLY analogous to fast-expt, with (square) replaced with (double)
        ((even? n) (double (fast-mult b (halve n))))
        
        ; odd case is EXACTLY analogous to fast-expt, with (*) replaced with (+)
        (else (+ b (fast-mult b (- n 1))))))
        
        






(define (double x) (* x 2))
(define (halve x) (/ x 2))  ; mentioned in the problem statement, but they never bothered in (fast-expt)...
(define (even? x) (= (remainder x 2) 0))

;(define (f b n) (fast-mult b n)); for testing

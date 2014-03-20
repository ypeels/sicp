; built-in functions
; (square x)
; (remainder x m)

; isn't this just a trivial modification of fast-expt?
; actually, it's not. i blundered upon the solution without having the right derivation...? 
; or just the right intuition but not the math?

; Let C := b^N be the loop invariant.
; C = (b^a)^n       defines the state variables.

; C = (b^1)^N           initial state variables a = b, n = N. (b is a constant)
; C = (b^2)^(N/2)       a = b^2, n = N/2
; C = (b^4)^(N/4)       a = b^4, n = N/4. now suppose N/4 is ODD.
; C = (b^5)^[(N/4)-1]   a = b^5, n = N/4 - 1. now n is EVEN, and you can square up again!
; ok, with the loop invariant on solid footing, i feel much happier putting it in code

;(define (fast-expt-iterative b N)
;    (define (iter a b k)
;        (cond 
;        
;            ; "loop" termination (includes trivial case)
;            ((= k 0) a)
;            
;            ; first iteration OR odd k
;            ((or (= a 1) (odd? k))
;                (iter
;                    (* a b)         ; a *= b
;                    b
;                    (- k 1)))       ; loop invariant: a b^(k-1) = b^n (scheme is case INSENSITIVE!? come ON)    
;            
;            ((even? n) 
;                (iter 
;                    (square a)      ; a = a^2
;                    b
;                    (/ k 2)         ; before, invariant = b^j b^k = b^n; after: invariant = b^2j b^k/2
;            
;            ; there should be no other cases...
;            (else -1)
;            
;            
;        
;        
;        
;        ; if n == 0:
;        ;   return a
;        ; elif 
        
        
        
; from p. 45
(define (even? n)
    (= (remainder n 2) 0))
    
(define (odd? n)
    (not (even? n)))
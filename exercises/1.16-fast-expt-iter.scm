; built-in functions
; (square x)
; (remainder x m)

; isn't this just a trivial modification of fast-expt? NO...

; ohhhhh here's what they meant by the hint:
; Let C = b^N
; C = a b^n defines the loop invariant from the problem.
; Let a = b^j to symmetrize.
; a = 1 and thus j = 0 initially.

; C = b^j b^n for n odd
; C = b^(j+1) b^(n-1)

; What does the even case mean? (Still following the Hint)
; C = b^j b^n
; C = b^j (b^2)^(n/2). AHA, you need to SQUARE THE BASE, not the accumulator!!!

; termination
; C = b^j b^1 - just another odd case; it'll terminate when n == 0


(define (fast-expt-iterative base exponent)    

    (define (iter a b n)
        (cond 
            ((<= n 0) a)        ; "loop termination"         
        
            ((even? n)                
                (iter           
                    a           ; a = a
                    (square b)  ; b = b**2
                    (/ n 2)))   ; n = n/2
                    
            (else  ; n is odd
                (iter
                    (* a b)     ; a = a*b
                    b           ; b = b
                    (- n 1))))) ; n = n-1
              
           
    (iter 1 base exponent))

        
        
        
; from p. 45
(define (even? n)
    (= (remainder n 2) 0))
    
(define (odd? n)
    (not (even? n)))

; for testing
(define (f b e) (fast-expt-iterative b e))




; actually, it's not. i blundered upon the solution without having the right derivation...? 
; or just the right intuition but not the math?

; Let C := b^N be the loop invariant.
; C = (b^a)^n       defines the state variables.

; C = (b^1)^N           initial state variables a = b, n = N. (b is a constant)
; C = (b^2)^(N/2)       a = b^2, n = N/2
; C = (b^4)^(N/4)       a = b^4, n = N/4. now suppose N/4 is ODD.
; C = (b^5)^[(N/4)-1]   - NO, THIS STEP IS WRONG. the math doesn't add up!!!
; also, this FORM of the loop invariant is not following the Hint...


; except this algorithm is WRONG FOR ODD N...
; try N = 3 case
; C = (b^1)^3
; C = (b 
        ; this was wrong
        ;    ; "loop initialization" - kinda nontrivial
        ;    ((= a 1)   ; n exponent)  no, can't say n == exponent case is NECESSARILY the first iteration...
        ;        (cond
        ;            ; corner case AND invalid input...
        ;            ((<= exponent 0) 1)  
        ;            
        ;            ; exponent > 1, so seed the process... otherwise b^(2^k) will just return 1...
        ;            (else (iter b b n))))
        ;    
        ;    ; "loop" termination       
        ;    ;((= n 0) a) 
        ;    
        ;    ((= n 1) a) ; "loop" termination       
        ;    
        ;    ((even? n) 
        ;        (iter 
        ;            (square a)      ; a *= a
        ;            b
        ;            (/ n 2)))       ; n /= 2
        ;    
        ;    (else  ; odd n > 1
        ;        (iter
        ;            (* a b)         ; a *= b
        ;            b
        ;            (- n 1)))))     ; n -= 1
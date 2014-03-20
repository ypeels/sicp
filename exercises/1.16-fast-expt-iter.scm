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

;(define (f b e) (fast-expt-iterative b e)) ; for testing


; afterword
; this problem was TRICKY! the "accumulator" was split into both a and b.
; the hint that the initial and final value would be stored in a was MISLEADING!!
; but working things around polya-style yielded results in a few minutes
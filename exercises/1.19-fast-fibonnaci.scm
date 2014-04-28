; hey, they basically give the algorithm for 1.16 right here
; kind of hard to decipher as written, but pretty transparent in matrix notation

; linear transformation matrix T
; --         --
; | p+q     q |
; | q       p |   
; --         --

; By simple matrix multiplication, T^2 is given by
; (p+q)^2 + q^2     (p+q)q + pq
; (p+q)q + pq       p^2 + q^2

; But for their Scheming purposes, we have to go a BIT further 
; and HOPE that T^2 can be written in the same form as T
; Reading it off...
; p' = p^2 + q^2
; q' = q^2 + 2pq
; check: p' + q' = (p+q)^2 + q^2, QED.

; Algorithm is the same as iterative exponentiation.
; C = T^n A is the loop invariant, where A is the column vector (a b)'
; C = (T^2)^(n/2) A for even n
; C = T^(n-1) (TA) for odd n
; C = T^0 A for termination (return A, or, i guess, whatever element of A is relevant)
; so this is just ANOTHER variation on a Scheme (sigh, i think they use this phrase in their book somewhere)




                  

(define (fast-fib-iterative count)
    (define (iter a b p q n)
        (cond 
        
            ; book's termination. couldn't i save one iteration by treating count == 0 as a special case?
            ; doesn't look like the bookkeeping works out unless you end with one more "half iteration" anyway...
            ; and the resulting extra case makes this code even HARDER to unerstand
            ;((= n 0) b) 
            
            ; my first shot at a compound termination 
            ((= count 0) b) ; handles corner case
            ;((= n 1) a) ; saves an iteration but is WRONG
            ((= n 1) (+ (* q a) (* p b))) ; saves HALF an iteration (no computation of the new a)
            
            ; even case: T = T^2, A unchanged
            ((even? n)
                (iter 
                    a 
                    b
                    
                    ; my answer-----------------------------------
                    (+ (* p p) (* q q))     ; p'
                    (+ (* q q) (* 2 p q))   ; q'
                    ; --------------------------------------------
                    
                    (/ n 2)))
                 
            ; odd case: A = T*A, T unchanged
            (else
                (iter
                    (+ (* (+ p q) a) (* q b))
                    (+ (* q a) (* p b))
                    p
                    q
                    (- n 1)))))
                    
    (iter 1 0 0 1 count))
                    
                    

            
;(define (even? n) (= (remainder n 2) 0))


;(define (f n) (fast-fib-iterative n)); for testing



; by analogy, a RECURSIVE version should be EASIER
; but to express this in scheme, you need a way to return the (p, q)' VECTOR. this hasn't been introduced in the book yet...


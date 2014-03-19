; x, y integers?
(define (A x y)
    (cond   ((= y 0) 0)
            ((= x 0) (* 2 y))
            ((= y 1) 2)
            (else (A 
                    (- x 1)
                    (A x (- y 1))))))  ; omfg it's CONVENTIONAL to leave all those stupid trailing parens??
                    

(A 1 10)    ; 1024
(A 2 4)     ; 65536
(A 3 3)     ; 65536


(define (f n) (A 0 n))
; empirically, f(n) = 2n
; proof: (A 0 n) always evaluates into the (= x 0) branch, which is just (* 2 y), QED


(define (g n) (A 1 n))
; empirically, g(n) =   0 for n = 0, 
;                       2^n for n >= 1
; proof: n=0 case is trivial from the (cond)
; A(1,n)    = A(0, A(1,n-1))
;           = A(0, A(0, A(1,n-2)))
;           = A(0, ... A(0, A(1, 1))...)  ; where there are n = 1 + (n-1) [1 initial, and (n-1) decrements of n]
;           = A(0, ... A(0, 2) ...)
; Since there are n more "A(0"s left to evaluate, and each doubles the second argument,
; A(1, n) = 2^n for n >= 1, QED.

; Alternate proof: induction?
; A(1,1)    = 2 trivially
; A(1,2)    = A(0, A(1,1))
;           = A(0, 2) = 4 = 2^2, which checks out.
; A(1,n+1)  = A(0, A(1, n))
;           = A(0, 2^n)
;           = 2^(n+1), QED. MUCH cleaner!!!

(define (h n) (A 2 n))
; empirically, h(n) = 2^(2^(...2^2)), where there are n 2's in that expression...
; Try induction again
; A(2,1)    = 2 trivially
; A(2,2)    = A(1, A(2,1))
;           = A(1, 2)
;           = 4 = 2^(2^(2-1)) = 2^2, which checks out.
; A(2,n+1)  = A(1, A(2,n))
;           = A(1, 2^...2 [n 2's]
;           = 2^{ 2^...2 [n 2's] } - so there are (n+1) 2's now, QED.

; not at ALL obvious just looking at the definitions...
; I shudder to think what (A 3 n) looks like...
; - oh wait, it can just be written IN TERMS OF A(2,n)
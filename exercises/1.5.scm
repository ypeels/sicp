(define (p) (p))

(define (test x y)
  (if (= x 0)
      0
      y))
      
; (write (test 0 (p)))   ;
; since 0 == 0, the if test returns 0
; thus test(0, p) returns 0
; what's wrong with that??
; is there the possibility of an infinite loop? YES!? stupid scheme


; from 1.1.5
; normal-order: would not evaluate the operands until their values were needed (i.e. lazy evaluation?)
; applicative-order: evaluate the operator and operands, then apply 

; This is "an instance of an ``illegitimate'' value where normal-order and applicative-order evaluation do not give the same result."

; I guess here's what they mean by illegitimate:
    ; (define (p) (p))  ; did not crash - this is the REAL problem... why is this not illegal??
    ; (write (p))       ; crashes
    ; (p)               ; crashes
    

    
; Normal-order expansion
; (test 0 (p))
; (if   (= 0 0)     0       (p))
; (                 0           )    ; does not evaluate "(p)" since it's never needed
; no crash

; Applicative-order expansion              
; (test 0 (p))
; (if   (= 0 0)     0       (p))
; (if   (= 0 0)     0       (???))   ; interpreter doesn't know what (p) is



; in any case, this problem isn't exploring "(define (p) (p))", but rather, whether function arguments are evaluated lazily
; (and it looks like they're not, in MIT Scheme)
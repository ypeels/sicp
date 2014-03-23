; This one is a recursive process
; - there is a deferred 
; - it uses "a" as a counter for how many times to (inc b)
;   - well, i mean, so does add2... except here, the "inc" is DEFERRED
(define (add1 a b)
  (if (= a 0)
      b
      (inc (add1 (dec a) b))))
      
      
      
; This one is tail-recursive and (therefore?) iterative
; - there are NO deferred operations
; - state is fully specified by the 2 arguments
(define (add2 a b)
  (if (= a 0)
      b
      (add2 (dec a) (inc b))))
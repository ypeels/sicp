; oh very clever, mr. scheme
; most of the exercises in this book are actually sprinkled "inline" throughout the text
; so i guess i WILL be suckered into doing them...

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))
        

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)            ; this is the only line that is changed from section 1.1.7
          guess
          (sqrt-iter (improve guess x)
                     x)))        
        




;;;;;;;;;;;;;;;;;;;;;; old stuff, unmodified
(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))
  

; but function CALLS can only occur after definitions  
; (write (average 1 2))


; this will probably hang, again because of "applicative-order" stupidity
; (a non-special if will evaluate both arguments before returning
; thus there is no end to the recursion of sqrt-iter)
(write (sqrt-iter 2 4))     ; "Aborting!: maximum recursion depth reached"

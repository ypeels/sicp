; I'm curious whether what happens if seeded with an integer value
; will it return a RATIONAL approximation to sqrt()?



; hey look, the scheme interpreter is smart enough it doesn't need prototypes or pre-defined functions!?
; that's actually an ADVANTAGE it has over python (the first i've seen...)
(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(write (sqrt-iter 1 4)) ; Value: 21523361/10761680

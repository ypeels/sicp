; from text
(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))

; from problem statement
(define (factorial n)
  (unless (= n 1)
          (* n (factorial (- n 1)))     ; infinite recursion in ordinary applicative-order Scheme
          1))                           ; this is because (unless) is an ordinary function, NOT a special form like if.
          
          
(display "\nentering infinite loop...")
(display (factorial 4))                     ; Aborting!: maximum recursion depth exceeded
(display "\ngoodbye world")

; The definitions WOULD work in a normal-order language, because
    ; in such a language, all expressions are evaluated lazily.
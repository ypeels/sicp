; ok, this is a little more twisted than my minor modification of section 2.1.3

; from problem statement
(define (cons x y)
  (lambda (m) (m x y)))
(define (car z)
  (z (lambda (p q) p)))
  
; my contribution, by analogy
(define (cdr z)
  (z (lambda (p q) q)))     ; look ma, no index range-checking!
  
; test code, copied from 2.1.3 notes
(define x (cons 1 2))
(define y (cons x x))
(newline) (display (car x))
(newline) (display (cdr x))
(newline) (display (car (car y)))
  
; now let's step through it and make sure it makes sense theoretically.
; (car (cons x y))
    ; = (car (lambda (m) (m x y)))
    ; = ((lambda (m) (m x y))           ; how do you evaluate a lambda? SUBSTITUTE!
    ;       (lambda (p q) P))       
    ; = ((lambda (p q) P) x y)          ; ditto
    ; = x
    ; similarly for (cdr) - just substitute Q for P above (case insensitive, remember?)
    
; so the logic/design is twisted and backwards, but the same principle applies:
    ; the "data members" x and y are getting BOUND INTO A LAMBDA by (cons).
; but now, to implement a selector, you need to pass as an ARGUMENT to that lambda, a function that selects 1 of its 2 arguments


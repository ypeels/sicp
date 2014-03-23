; just a minor point - the book didn't NEED to give "dispatch" a name
    ; they could have just returned a lambda equivalently, right? looks like it...
    ; why DIDN'T they? to make the main section more independent of Chapter 1?
    ; but in the exercises, they assume full and fluent familiarity with lambdas...
    
    
; also, rewriting it this way makes it transparent that all that's happening is that x and y are BINDING into the lambda
    ; there's nothing mysterious going on here... "conservation of data entry"
; ALSO, they've DONE this before in section 1.3.2. (hey, that means i could have figured this out in the (double double) problem... meh)
; are they deliberately TRYING to make this harder, not easier, to understand??
(define (cons x y)
  ;(define (dispatch m)
  (lambda (m)               ; <------ my change
    (cond ((= m 0) x)
          ((= m 1) y)
          (else (error "Argument not 0 or 1 -- CONS" m))))
  ;dispatch)
  )

(define (car z) (z 0))

(define (cdr z) (z 1))

(define x (cons 1 2))
(define y (cons x x))
(newline) (display (car x))
(newline) (display (cdr x))
(newline) (display (car (car y)))
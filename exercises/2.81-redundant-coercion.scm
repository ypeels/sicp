(load "2.81-86-type-coercion.scm")

; Just the fact that Louis Reasoner is involved means he's gonna be wrong somehow...poor Louis...

(define (install-louis-2.81)
    (define (scheme-number->scheme-number n) n)
    (define (complex->complex z) z)
    (put-coercion 'scheme-number 'scheme-number
                  scheme-number->scheme-number)
    (put-coercion 'complex 'complex complex->complex)
)


(define (test-2.81)
    (display (apply-generic 'foo (make-scheme-number 1) (make-scheme-number 2)))
)


; a. 
; (apply-generic only tries coercion if (get op type-tags) returns null.
; (apply-generic op (t1->t2 a1) a2) will be called with the type of a1 unchanged

(define (test-2.81a)

    ; part a: the infinite loop
    (install-louis-2.81)
    (test-2.81)
)
; (test-2.81) ; INFINITE RECURSION! Try it for yourself. (But you'd have to roll back part c. in (apply-generic)


; b. Surprise, surprise, Louis is wrong. (apply-generic will "work correctly" in the sense that 
; unavailable ops will result in an error message, as long as you do NOT implement self-coercion.
; However, it WILL unnecessarily TRY coercion even though the types are identical.
; Moreover, the error messages are uninformative.
(define (test-2.81b)
    (test-2.81)
)
; (test-2.81b)


; c. Modifications were made to (apply-generic in the shared file "2.81-86"...
(test-2.81)

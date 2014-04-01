; ugh, like 2.79, probably best implemented by modifying 2.77-80, so you have access to "private" routines
    ; not TOO unjustified, since we ARE adding features to the implementation?
    ; the end user just knows that there's a new "(=zero?" procedure available
    
(load "2.77-80-generic-arithmetic.scm")
(define (=zero? z) (apply-generic '=zero? z))
    ; implemented in "2.77-80"
    
    
    
(define (test-2.80)

    (define (test z)
        (newline)
        (display (=zero? z))
        (display z)
    )
    
    (test (make-scheme-number 0))
    (test (make-scheme-number 1))
    (test (make-rational 0 1))
    (test (make-rational 1 2))
    (test (make-complex-from-real-imag 3 4))
    (test (make-complex-from-real-imag 0 0))
    (test (make-complex-from-mag-ang 3 2))
    (test (make-complex-from-mag-ang 0 5))
    (test (make-complex-from-mag-ang 0 0))
)

; (test-2.80)

    
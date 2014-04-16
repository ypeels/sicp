(load "4.27-31-ch4-leval.scm")

(define (install-lazy-cons)
    (leval
        '(define (cons x y) (lambda (m) (m x y)))
        '(define (car z) (z (lambda (p q) p)))
        '(define (cdr z) (z (lambda (p q) q)))
    )
)
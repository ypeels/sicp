(load "2.81-86-type-coercion.scm")

; hmm i solved the WRONG PROBLEM accidentally...
; this is how you could re-define add, sub, mul, div to take n-arguments, for ANY type
; but the problem wants n-argument COERCION, NOT decomposition into pairwise accumulation
(define (add-n-2.82 . terms) 
    (let ((n (length terms)))
        (cond
            ((<= n 1)
                (error "it takes 2 to tango: ADD-N-2.82" terms))
            ((= n 2)
                (add (car terms) (cadr terms)))
            (else
                (apply 
                    add-n-2.82 
                    (append 
                        (list (add (car terms) (cadr terms)))       ; evaluate sum for first 2 terms
                        (cddr terms)
                    )
                )
            )
        )
    )
)

(define (test-2.82-the-wrong-problem)

    (install-sample-coercion)   ; scheme-number to complex
    
    (define (test . args)
        (newline)
        (newline) (display args)
        (newline) (display (apply add-n-2.82 args))        
    )
    
    
    (let (
            (x (make-scheme-number 1))
            (z (make-complex-from-real-imag 1 1)))
        (test x z)
        (test x x)
        (test x x x)            ; hmm this doesn't work ANYWAY, since there is no n-arg add implemented...
    )
    
)

;(test-2.82-the-wrong-problem)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; end dead end




(define (coercion-n-args . unused-args) (error "giggity")) ; yes, this lets us override as desired


(define (install-3-arg-function)

    (define (foo3 x y z)
        (display "\nWelcome to foo3")
        (newline) (display x)
        (newline) (display y)
        (newline) (display z)
        (newline)
    )
    
    (put 'foo3 '(complex complex complex) foo3)
    (put 'foo3 '(rational rational rational) foo3)
    (put 'foo3 '(scheme-number scheme-number scheme-number) foo3)
    
    "\nInstalled foo3, a trivial function that REQUIRES three arguments."
)
(define (foo3 a b c) (apply-generic 'foo3 a b c))
    
    
(define (test-2.82)
    (install-3-arg-function)
    
    (define (test a b c)
        (foo3 a b c)
    )
    
    (let (
            (x (make-scheme-number 1))
            (z (make-complex-from-real-imag 1 1)))
        (test x x x)
        (test z z z)
        (test x x z)
    )
)
(test-2.82)
        





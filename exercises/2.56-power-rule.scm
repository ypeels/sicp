(load "2.56-58-symbolic-differentiation.scm")

; top-down...
(define (deriv-2.56 expr var)
    (if (exponentiation? expr)
        (let ((u (base expr)) (n (exponent expr)))    
            (make-product
                n
                (make-product 
                    (** u (- n 1))
                    (deriv-2.56 u var)
                )
            )
        )    
        (deriv expr var)
    )
)

; analagous to (make-sum) and (make-product), etc. p. 148
(define (** a1 a2)
    (cond                           ; Build in the rules that 
        ((= 0 a2) 1)                ; anything raised to the power 0 is 1 and 
        ((= 1 a2) a1)               ; anything raised to the power 1 is the thing itself.
        (else (list '** a1 a2))
    )
)

(define (exponentiation? x)
    (and (pair? x) (eq? (car x) '**)))
(define (base x)
    (cadr x))
(define (exponent x)
    (caddr x))
    
    
    
(define (test-2.56)
    (define (test expr)
        (display "\nd[ ")
        (display expr)
        (display " ] / dx = ")
        (display (deriv-2.56 expr 'x))
    )
    
    (test '(+ x 3))                 ; x
    (test '(* x y))                 ; y
    (test '(* (* x y) (+ x 3)))     ; (+ (* x y) (* y (+ x 3)))
    (test '(** x 7))
    (test '(** x 1))
    (test '(** x 0))
    ;(test '(** x x))               ; fails with "x cannot be passed to integer-subtract"
)

(test-2.56)
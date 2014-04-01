(load "2.77-80-generic-arithmetic.scm") 
(load "2.77-complex-number-selectors.scm") (install-complex-reps-2.77) ; omfg i'm louis
(load "2.81-86-type-coercion.scm")

; you can raise scheme-number to rational using the public constructor (make-rational
; but you CAN'T raise rational to real ...
; but you CAN raise real to complex!
; so let's patch rational and make (numer and (denom public.
(define (denom-rational r) (apply-generic 'denom r))
(define (numer-rational r) (apply-generic 'numer r))

; the TOWER
(install-builtin-number-package 'integer)
(install-builtin-number-package 'real)
(define (make-integer x)
    (if (is-integer? x)
        ((get 'make 'integer) x)
        (error "Bad input - MAKE-INTEGER" x)))
(define (make-real x)
    (if (is-real? x)
        ((get 'make 'real) x)
        (error "Bad input - MAKE-REAL" x)))
        

; check if UNTAGGED number is a particular type
(define (is-integer? i)
    (integer? i))
;(define (is-rational? r)
;    (eq? 'rational (type-tag r)))
(define (is-real? r)                            ; had to nerf all the way for Exercise 2.84; probably wasn't working well enough here anyway...
    (and (real? r))); (not (integer? r))));  (not (rational? r)))) ; scheme is smart enough to know "1.5" is rational. but THAT'S NOT WHAT THIS PROBLEM WANTS
;(define (is-complex? z)
;    (eq? 'complex (type-tag z)))
    
    
; ugh, most of this exercise was spent struggling with the syntax of building the stupid infrastructure of 'integer and 'real
    

; sols http://community.schemewiki.org/?sicp-ex-2.83
; apparently the preparer didn't realize that our generic system doesn't HAVE 'integer or 'real...
             


(define (install-raise-2.83)
    
    

    (define (raise-int-to-rat x)                                               ; x = BARE integer!!
        (if (is-integer? x)                                                    ; these private functions are accessible only via (apply-generic,
            (make-rational x 1)                                                ; which strips type information
            (error "Bad input - RAISE-INT-TO-RAT" x)
        )
    )
    (put 'raise '(integer) raise-int-to-rat)
    
    (define (raise-rat-to-real x)        
        (let ((r (attach-tag 'rational x)))                                    ; stupid custom rationals breaking my symmetry
            (make-real (/ (numer-rational r) (denom-rational r) 1.0))
        )
    )
    (put 'raise '(rational) raise-rat-to-real)
    
    (define (raise-real-to-comp x)
        (if (is-real? x)
            (make-complex-from-real-imag x 0)
            (error "Bad input - RAISE-REAL-TO-COMP" x)
        )
    )
    (put 'raise '(real) raise-real-to-comp)
    
    
    "\nInstalled int-rat-real-complex tower for Exercise 2.83."
)

(define (raise-2.83 x)
    (if (can-raise?-2.83 x)
        (apply-generic 'raise x)
        x))
(define (can-raise?-2.83 x)
    (get 'raise (list (type-tag x))))








(define (test-2.83)

    (display (install-raise-2.83))
    (define raise raise-2.83)

    (define (test x)
        (display "\n\nx = ") (display x)
        (display "\nraised = ") (display (raise x))
    )
    
    ;(define raise raise-2.83)
    
    ;(test (make-integer (/ 3 2))) ; should give "bad input" error
    (test (make-integer 5))
    (test (make-rational 3 2))
    (test (make-real (sqrt 2)))
    (test (make-complex-from-real-imag 1 2))
    
    (load "2.77-complex-number-selectors.scm") (install-complex-reps-2.77)
    (display (real-part (make-complex-from-real-imag 1 2)))
    
)

; (test-2.83)
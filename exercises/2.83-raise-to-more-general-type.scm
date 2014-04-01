(load "2.77-80-generic-arithmetic.scm")
;(load "2.81-86-type-coercion.scm")

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
(define (is-real? r)
    (and (real? r) (not (integer? r))));  (not (rational? r)))) ; scheme is smart enough to know "1.5" is rational. but THAT'S NOT WHAT THIS PROBLEM WANTS
;(define (is-complex? z)
;    (eq? 'complex (type-tag z)))
    

        
            


(define (install-raise-2.83)
    
    

    (define (raise-int-to-rat x)                                               ; x = BARE integer!!
        (if (is-integer? x)                                                    ; these private functions are accessible only via (apply-generic,
            (make-rational x 1)                                                ; which strips type information
            (error "Bad input - RAISE-INT-TO-RAT" x)
        )
    )
    
    (define (raise-rat-to-real x)        
        (let ((r (attach-tag 'rational x)))                                    ; stupid custom rationals breaking my symmetry
            (make-real (/ (numer-rational r) (denom-rational r) 1.0))
        )
    )
    
    (define (raise-real-to-comp x)
        (if (is-real? x)
            (make-complex-from-real-imag x 0)
            (error "Bad input - RAISE-REAL-TO-COMP" x)
        )
    )
    
    
    ;; install coercions into the table. this made me realize i needed 'real and 'integer...
    ;(put-coercion 'integer 'rational raise-int-to-rat)
    ;(put-coercion 'rational 'real raise-rat-to-real)
    ;(put-coercion 'real 'complex raise-real-to-comp)
    
    
    (put 'raise '(integer) raise-int-to-rat)
    (put 'raise '(rational) raise-rat-to-real)
    (put 'raise '(real) raise-real-to-comp)
    
    "\nInstalled int-rat-real-complex tower for Exercise 2.83."
)

(define (raise-2.83 x)
    (apply-generic 'raise x))














(define (test-2.83)

    (display (install-raise-2.83))

    (define (test x)
        (display "\n\nx = ") (display x)
        (display "\nraised = ") (display (raise x))
    )
    
    (define raise raise-2.83)
    
    ;(test (make-integer (/ 3 2))) ; should give "bad input" error
    (test (make-integer 5))
    (test (make-rational 3 2))
    (test (make-real (sqrt 2)))
    
)

; (test-2.83)
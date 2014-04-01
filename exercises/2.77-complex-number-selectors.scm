(load "2.77-80-generic-arithmetic.scm")


(define (install-complex-reps-2.77)

    ; this would break alyssa's patch, because the (put would prioritize local scope over global (magnitude
    ; (define (magnitude z) (display z) 'giggity )

    ; alyssa hacker's patch from problem statement
    (put 'real-part '(complex) real-part)
    (put 'imag-part '(complex) imag-part)
    (put 'magnitude '(complex) magnitude)
    (put 'angle '(complex) angle)
    'done
)


; after alyssa's patch
; (magnitude '(complex rectangular 3 4))
; = (apply-generic 'magnitude '(complex rectangular 3 4))
    ; (apply-generic op . args) 
        ; (let (type-tags = (type-tag args) = ('complex))
        ; (get 'magnitude ('complex)) = magnitude ONLY after it has been installed by (put in (install-complex-reps-2.77
; = (apply magnitude '(rectangular 3 4))
    ; so (magnitude has forwarded to ITSELF, because the only (magnitude in the scope of (install-complex-reps-2.77 is the global one.
    ; all it does in the case of (one or more) 'complex tags is to strip them off    


    ; in louis' case, (apply-generic gets called TWICE.

(define (test-2.77)
    (define (test z)
        (newline) (display (magnitude z))
    )
    
    (test (make-from-real-imag 3 4))                        ; 5 - works out of the box.
    
    ; out of the box: "No method for these types -- APPLY GENERIC (magnitude (complex))"
    ;(test (cons 'complex (cons 'rectangular (cons 3 4))))
    ;(test (make-complex-from-real-imag 1 2))    
    
    (install-complex-reps-2.77)
    (test (cons 'complex (cons 'rectangular (cons 3 4))))   ; 5
    ; (test '(complex rectangular 3 4)) ; actually doesn't work... why??
    
    ; should fail (keeps loop-forwarding until the 'rectangular)
    (test (cons 'complex (cons 'complex (cons 'complex (cons 'rectangular (cons 3 4))))))   ; 5
    
    ; all these should fail, because 'rectangular is the END OF THE LINE, not a forwarder
    ;(test (cons 'rectangular (cons 'rectangular (cons 3 4))))
    ;(test (cons 'rectangular (cons 'complex (cons 3 4))))
    
    ; these require alyssa's patch too.   
    (test (make-complex-from-real-imag 1 2))    
    (test (make-complex-from-mag-ang 3 1.57))    
)
        
        
; (test-2.77)


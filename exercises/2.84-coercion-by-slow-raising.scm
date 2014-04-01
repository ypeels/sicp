(load "1.43-repeat-by-lambda.scm")
(load "2.83-raise-to-more-general-type.scm")



(define (can-raise? type)
    (get 'raise (list type)))

; using this function to climb the tower in (get-coercion 
; all because i don't want to modify the upstream code at all...
; adding a new level to the tower, you'd have to install a new default value
; - but you wouldn't have to modify the existing code at all.
    ; - but you would still have to read the stupid api to see what NEW code to write. 
    ; - relatively regression-proof, but still hard to extend...
(define (install-default-values-2.84)

    ; registering these by RETURN value, just like constructors... 
    ; feasible because, like the "make" functions, we are NOT using (apply-generic...
    (define (default-int) (make-integer 0))
    (put 'default 'integer default-int)
    
    (define (default-rational) (make-rational 0 1))
    (put 'default 'rational default-rational)
    
    (define (default-real) (make-real 0.1))
    (put 'default 'real default-real)
    
    (define (default-complex) (make-complex-from-real-imag 0 0))
    (put 'default 'complex default-complex)
)
(define (default-value type)
    ((get 'default type))
)
    
    
    
; i'm gonna do this by overriding (get-coercion.
(define (get-coercion-2.84 type1 type2)
    (define (iter rising-type n)
        (cond 
            ((eq? rising-type type2)                        ; positive termination
                (repeated raise n))                         ; i don't remember or CARE to remember how to repeat an operation...
            ((not (can-raise? rising-type))                 ; negative termination (can raise no further)
                false)
            (else
                (iter                                       ; a hack to get the next higher type...
                    (type-tag (raise (default-value rising-type))) 
                    (+ n 1)
                )
                
            )
        )
    )

    (iter type1 0)
)


(display "\nExercise 2.84 installations...") (install-raise-2.83) (install-default-values-2.84) (define get-coercion get-coercion-2.84) (display "done.")



(define (test-2.84)
    
    (define (test x y)
        (newline) 
        (display x) (display " + ") (display y) (display " = ")
        (display (add x y))
    )        
    
    (test (make-integer 1) (make-integer 2))                ; shouldn't invoke coercions at all
    (test (make-integer 1) (make-complex-from-real-imag 2 3))
)

; (test-2.84)

    
        
    
    
    
    

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




(define (coercion-n-args-2.82 op args)

    (define (coerce-a-to-b a b)
        (let ((coercer (get-coercion a b)))
            (cond 
                ((eq? a b)
                    (lambda (x) x))                     ; remember exercise 2.81?
                (coercer 
                    (lambda (x)                         ; watch out!! the syntax here is tricky. (i had the cond inside the lambda for a bit)
                        (if (eq? a (type-tag x))
                            (coercer x)
                            (error "invalid argument: COERCE-A-TO-B" x a b)
                        )
                    )
                )
                (else false)                            ; signal that the requested coercion does not exist
            )
        )
    )   


    (define (coerce x target-type)
        ((coerce-a-to-b (type-tag x) target-type) x))
    
    (define (nlist x n)
        (if (<= n 0)
            '()
            (cons x (nlist x (- n 1)))))
            
    (define (can-coerce-list L target-type)             ; could pull in (accumulate, but i'm too lazy
        (cond
            ((null? L)
                true)
            ((not (coerce-a-to-b (type-tag (car L)) target-type))   ; accounts for self-coercion too
                false)
            (else 
                (can-coerce-list (cdr L) target-type))
        )
    )
    
    (define (op-n op type)
        (get op (nlist type (length args))))
                
    
    
    ; attempt to coerce all the arguments to the type of the first argument, then to the type of the second argument, and so on.
    (define (iter n)
        (if (>= n (length args))
            (error "No coerced function available: COERCION-N-ARGS-2.82" args)
            (let ((nth-type (type-tag (list-ref args n))))
                (if (or
                        ; check via if a function taking n x nth type exists
                        (not (op-n op nth-type))
                        
                        ; check that all of args CAN be coerced to nth type 
                        (not (can-coerce-list args nth-type))
                    )
                    
                    ; conditions not met; move on to next argument
                    (iter (+ n 1))
                    
                    ; all clear! invoke the function on the coerced arguments
                    (apply 
                        (op-n op nth-type)
                        (map 
                            contents 
                            (map (lambda (x) (coerce x nth-type)) args)
                        )
                    )
                )
            )
        )
    )
    ; this is soooo ugly... sols? meh, they're not short either. i guess there's no short, "scheming" way to do this? (hence relegation to exercise)

        
    (iter 0)
)
; this strategy fails in the case mentioned in the text, right? (the last paragraph before "Hierarchies of types"
; "On the other hand, there may be applications for which our coercion scheme is not general enough. 
; Even when neither of the objects to be combined can be converted to the type of the other it may still be possible to 
; perform the operation by converting both objects to a third type."

; but i can't really think of any CONCRETE examples off the top of my head... sols??
    ; they didn't answer this part. meh.
            
    


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

    
    
(define (test-2.82)
    (install-3-arg-function)
    (install-sample-coercion)   ; scheme-number to complex    
    (define (foo3 a b c) (apply-generic 'foo3 a b c))
    
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
; (define coercion-n-args coercion-n-args-2.82) (test-2.82)
        





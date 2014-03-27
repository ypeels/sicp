(define (make-vect . args)         ; should generalize directly to n-dimensions (just loosen the validation)
    (make-vect-from-list args)
)    

(define 2d-only #t)                 ; set to #t for "production" (2-d painters)
                  

(define (make-vect-from-list v)
    (define (is-valid? v)
        (and
            (list? v)
            ;(= 2 (length v))    ; extra error checking for the Painter system, which should be 2-d only
            (if 2d-only (= 2 (length v)) #t)
            (number? (car v))
            (number? (cadr v))  ; TODO: generalize to n-element check for numberhood
        )
    )

    (if (is-valid? v)
        v                       ; v should be a LIST consisting of all arguments. using (cons x y) would not be generalizable to n dimensions
        (error "make-vect bad input" v)
    )
)


; with all the error-checking in the constructor, fly fast and free in the selectors    
(define (xcor-vect v) 
    (car v))
(define (ycor-vect v)           ; not actually used 
    (cadr v))
    
    
(define (add-vect v1 v2) (op2-vect + v1 v2))
(define (sub-vect v1 v2) (op2-vect - v1 v2))
(define (op2-vect op v1 v2)
    (make-vect-from-list (map op v1 v2)))

(define (scale-vect scale vect)
    (make-vect-from-list 
        (map 
            (lambda (t) (* t scale))
            vect)))


(define (test-2.46)

    (define (test . args)        
        (let ((v (make-vect-from-list args)))
            (display "\n\nv: ") (display v)
            (display "\nv+v: ") (display (add-vect v v))
            (display "\nv-v: ") (display (sub-vect v v))
            (display "\nv-2v: ") (display (sub-vect v (scale-vect 2 v)))
        )
    )
    
    (test 1 2)
    ;(test 3 4 5) ; should raise error in the "2d-only" case
    (test -3 6)
)

;(test-2.46)

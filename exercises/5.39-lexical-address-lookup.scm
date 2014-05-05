 ; It should take two arguments -- a lexical address and a run-time environment -- 
    ; [n.b. env = RUN-TIME environment, NOT compile-time environment]

; syntax procedures for lexical addresses
(define (frame-lexical-address address)
    (car address))
(define (displacement-lexical-address address)
    (cadr address))

    
    
    ; refactor to a driver for (lexical-address-set!) - use (list-set!)
(define (lexical-address-lookup address env)
    (lexical-address-driver address env
        (lambda (frame displacement)
            (let ((val (list-ref frame displacement)))
                (if (eq? val '*unassigned*)
                    (error "Unassigned variable - LEXICAL-ADDRESS-LOOKUP" address env)
                    val
                )
            )            
        )
    )
)

(define (lexical-address-set! address env val)
    (lexical-address-driver address env
        (lambda (frame displacement)
            (list-set! frame displacement val)
        )
    )
)

(define (lexical-address-driver address env op)

    ; frame API from ch5-eceval-support.scm
    (define (iter frame displacement env)
        (cond
            ((null? env)
                (error "Bad address? -- LEXICAL-ADDRESS-DRIVER" address))
            ((< frame 0) ; wow this prefix inequality order STILL bites me with stupid bugs
                (error "Negative frame number -- LEXICAL-ADDRESS-DRIVER" address))
            ((= frame 0)
            
                ; and return the value of the variable stored at the specified lexical address.
                ;(list-ref (frame-values (first-frame env)) displacement))
                (op (frame-values (first-frame env)) displacement))
                
            (else
                (iter (- frame 1) displacement (enclosing-environment env)))
        )
    )
    
    (iter 
        (frame-lexical-address address)
        (displacement-lexical-address address)
        env
    )
)







    
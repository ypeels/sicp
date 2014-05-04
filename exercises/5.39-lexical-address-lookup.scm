 ; It should take two arguments -- a lexical address and a run-time environment -- 
    ; [n.b. env = RUN-TIME environment, NOT compile-time environment]

; syntax procedures for lexical addresses
(define (frame-lexical-address address)
    (car address))
(define (displacement-lexical-address address)
    (cadr address))

    
    
    ; refactor to a driver for (lexical-address-set!) - use (list-set!)
(define (lexical-address-lookup address env)

    ; frame API from ch5-eceval-support.scm
    (define (iter frame displacement env)
        (cond
            ((null? env)
                (error "Bad address? -- LEXICAL-ADDRESS-LOOKUP" address))
            ((< 0 frame)
                (error "Negative frame number -- LEXICAL-ADDRESS-LOOKUP" address))
            ((= 0 frame)
            
                ; and return the value of the variable stored at the specified lexical address.
                (list-ref (frame-values (first-frame env)) displacement))
                
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







    
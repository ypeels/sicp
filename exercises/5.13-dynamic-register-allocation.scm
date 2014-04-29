(define (make-machine-5.13 register-names ops controller-text)
    (make-machine-regsim '() ops controller-text))                      ; equivalently, change signature of (make-machine)
                                                                            ; but i don't want to bother rewriting test code
(define (make-new-machine-5.13)                                           
    (let (  (machine (make-new-machine-regsim))                         ; base class / delegate
            (register-list '(pc flag))
            )
    
        (define (allocate-register-5.13 name)                               
          ;(display "\nnot allocating ")
          ;(display name)
          'empty-stub) ; doesn't get passed to base class's allocate-register.
        
        ; actually, just hijack the base class's register table!    
        ; maintain a local list of allocated registers, to avoid (lookup)'s (error).
        (define (lookup-register-5.13 name)                                 
            (if (memq name register-list)
                ((machine 'get-register) name)
                (begin
                    ;(display "\nAllocating register: ") (display name)
                    (set! register-list (cons name register-list))
                    ((machine 'allocate-register) name)                     ; inefficient, but should work             
                    ((machine 'get-register) name)
                )
            )
        )
        ; that should do 'er!

        (define (dispatch message)
          (cond 
                ; overrides
                ((eq? message 'allocate-register) allocate-register-5.13)   
                ((eq? message 'get-register) lookup-register-5.13)  
                
                ; base class
                (else (machine message))))
        dispatch
    )
)
    
(load "ch5-regsim.scm")
(load "5.06-fibonacci-extra-push-pop.scm")
(define make-machine-regsim make-machine) (define make-machine make-machine-5.13)
(define make-new-machine-regsim make-new-machine) (define make-new-machine make-new-machine-5.13)

(define fib-machine (make-fib-machine-5.6))
(test-5.6-long) ; regression test
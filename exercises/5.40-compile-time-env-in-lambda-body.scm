; wow, i JUST thought of this
(define (install-compile-lambda-body-5.40)
    (set! compile-lambda-body-compiler compile-lambda-body)
    (set! compile-lambda-body compile-lambda-body-5.40)
)
(define compile-lambda-body-compiler '*unassigned*) ; need this so that you can use set! uniformly

; TODO: make other-args a TABLE - if there are more optional arguments added
(define (compile-time-environment other-args)
    (car other-args))
(define (set-compile-time-environment! other-args ctenv)
    (set-car! other-args ctenv))
(define (has-compile-time-environment? other-args)  
    (cond
        ((null? other-args)
            false)
        (else true)
    )
)


(define (compile-lambda-body-5.40 expr proc-entry . other-args)
    (let (  (ctenv (compile-time-environment other-args));'*unassigned*);
            (formals (lambda-parameters expr))
            )
            
        ; for backwards compatibility? no, this function is never called unless INSTALLED
        ;(if (has-compile-time-environment? other-args)
        ;    (set! ctenv (compile-time-environment other-args))
        ;    ;(set! ctenv '(()) )
        ;    (error "Compile-time environment not found -- COMPILE-LAMBDA-BODY-5.40")
        ;)
            
        ; oh you only need to extend ctenv INSIDE the body, not outside in the return value!
            ; that makes life easier
        
            
        ; extend the compile-time environment! see 5.41 for data structure
        ; other-args is passed in by VALUE! just what i wanted...
        (set-compile-time-environment! other-args (cons formals ctenv))
        ;(display "\nother-args inside procedure = ") (display other-args)
        
        
        ; still need to extend the run-time environment in base class
            ; that's where the values are stored!!
            ; what ctenv does is speed up LOOKUP in rtenv
        (apply compile-lambda-body-compiler 
            (append (list expr proc-entry) other-args))        
        
    
    )
)


; testing
(define (test-5.40)
    ;(install-compile-lambda-body-5.40)
    (load "ch5-syntax.scm")
    (set! compile-lambda-body-compiler (lambda ? 'nop)) ; Exercise 2.20 for varargs in lambdas
    
    
    (define ctenv (list '()))
    (compile-lambda-body-5.40 '(blah expr) 'proc-entry ctenv)
    (display "\nctenv outside procedure = ") (display ctenv)
)
;(test-5.40)
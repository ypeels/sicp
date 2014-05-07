; there's no WAY i'm gonna do 5.51 or 5.52
; this is the end of the line for me
; and i do NOT feel like modifying ch5-compiler.scm if i can avoid it
; instead, i'll modify mceval to avoid, e.g., compiling (let)

(load "5.50-mceval-simplified.scm")


(define apply-in-underlying-scheme '*undefined-aius*) ; hmm, can't be part of mceval-text??
(define the-global-environment '*undefined-tge*)
(define factorial-test '(begin
    (define (factorial n)
        (if (= n 1)
            1
            (* n (factorial (- n 1)))))
    (factorial 5)
))

(define mceval-batch-text
    '(define (mceval expr)
        (prompt-for-input ";;; Input from batch file")
        (user-print expr)
        (newline)
        
        (announce-output output-prompt)
        (user-print (eval expr the-global-environment))
        expr
    )
)



; reality check / regression test
(define (test-mceval)
    (set! apply-in-underlying-scheme apply) ; must precede mceval-text, else apply gets overwritten
    
    ;(eval mceval-text user-initial-environment)    
    (eval ; can only be called once? has to do with stupid env...
        `(begin
            ,mceval-batch-text
            ,mceval-text
        )
        user-initial-environment
    )    
    
    (set! the-global-environment (setup-environment)) ; must follow mceval-text, else (setup-env) is undefined
    (mceval factorial-test)    
    (driver-loop)
)
;(test-mceval)


(define (install-eceval-5.50)
    (load "ch5-compiler.scm")
    (load "load-eceval-compiler.scm")
    
    ; extending the list in ch5-eceval-support.scm - basically responding to any "compile-time errors"
    ; procedures accessible at EC-Eval prompt, and to compile-and-go code
    ; watch out! this is NOT "primitive-procedures" in mceval-simplified 
        ; oh yeah, what a great idea to write ANYTHING metacircularly... it's not confusing at all...
        ; on the bright side, i don't think it gets much MORE confusing than this...
    (append! primitive-procedures (list
    
        ; "compile-time" requirements - to (compile-and-go) mceval-text
        (list 'list list)
        
        ; required to (define) (apply-in-underlying-scheme)
        (list 'apply apply)
        
        ; iirc, you're not supposed to do this... it's a louis reasoner exercise, isn't it? 4.14
        ; instead, "type" it into EC-Eval.
        ;;(list 'map map) 
        
        ; "link-time" requirements? - to execute  (setup-environment)
        (list 'cadr cadr)
        (list 'length length)
        (list 'eq? eq?)
        (list 'set-car! set-car!)
        (list 'set-cdr! set-cdr!)
        
        ; required by (driver-loop)
        (list 'newline newline)
        (list 'display display)
        (list 'read read)
        
        ; "run-time" requirements - mceval searches EC-Eval's "primitives" for these
        ; need to forward to the "real" underlying scheme primitive
        ; let's go as far as it takes to run factorial
        (list 'number? number?)
        (list 'pair? pair?)
        (list 'string? string?)
        (list 'symbol? symbol?)
        (list 'cddr cddr)
        (list 'cdadr cdadr)
        (list 'caadr caadr) ; oh come ON
        (list 'cadddr cadddr)
        (list 'caddr caddr)
        
        ;
        ;
        ;
    ))
)


; go for it!!!
(define (test-5.50)
    (install-eceval-5.50)
    ;(compile mceval-text 'val 'return)
    (compile-and-go `(begin

        ; reproducing anything i had to type in (test-mceval)
        (define apply-in-underlying-scheme apply)
        ,mceval-text
        
        ; and then there's Exercise 4.14 - using code from 2.2.1 p. 105
        ; this is required for (setup-environment) to run AND not to crash
        (define (map proc items)
            (if (null? items)
                '()
                (cons (proc (car items))
                      (map proc (cdr items)))))
        
        (define the-global-environment (setup-environment))
        
        ; finishing touch
        (set! input-prompt ";;; M-Eval on EC-Eval input:")
        (set! output-prompt ";;; M-Eval on EC-Eval value:")
        
        ; laziness
        ,mceval-batch-text
        ;(mceval ',factorial-test)
        ;(mceval '(begin (define (f x) (+ x 1)) (f 3)))
        
        (driver-loop)
    ))
)
(test-5.50)

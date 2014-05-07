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
            ,mceval-text
            ,mceval-batch-text            
        )
        user-initial-environment
    )    
    
    (set! the-global-environment (setup-environment)) ; must follow mceval-text, else (setup-env) is undefined
    (mceval factorial-test)    
    (driver-loop)
)
;(test-mceval)



; ok, now the REAL code (everything above is basically test data/code)
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
        ;(list 'apply apply)  ; have to dig twice as deep! i don't really feel like figuring out why        
        ; makes more sense to redefine this than to redefine (apply-primitive-procedure) in mceval.
        (list 'apply (lambda (proc args) (apply (primitive-implementation proc) args)))
        
        ; iirc, you're not supposed to do this... it's a louis reasoner exercise, isn't it? 4.14
        ; declaring a lambda doesn't work here because it's recursive! (maybe a y-operator would work?)
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
        
        ; "run-time" requirements - mceval searches EC-Eval's "primitives" for these (i.e., anything you can call at the EC-Eval prompt, without defining it)
        ; just forward to the "real" underlying scheme primitive
        ; let's go as far as it takes to run factorial
        (list 'number? number?)
        (list 'pair? pair?)
        (list 'string? string?)
        (list 'symbol? symbol?)
        (list 'cddr cddr)   ; needed for factorial, somehow
        (list 'cdadr cdadr)
        (list 'caadr caadr) ; oh come ON
        (list 'cadddr cadddr)
        (list 'caddr caddr)
        (list 'not not)
        (list 'cdddr cdddr)
    ))
)


; go for it!!!
(define (test-5.50)
    (install-eceval-5.50)
    ;(compile mceval-text 'val 'return)
    (compile-and-go     
        `(begin

            ; this code is on equal footing with everything in mceval.scm
        
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
            (mceval '(+ 1 1))
            (mceval ',factorial-test) ; yes, that syntax is right!
            ;(mceval '(begin (define (f x) (+ x 1)) (f 3)))
            
            (driver-loop)
        )
    )
)
(test-5.50)

; gahahahahaha!!!
; scheme (MC) on top of 
; scheme (EC) on top of 
; scheme (MIT)
; got runtime library working as far as factorial, and that's as far as i'll take her.

; l0stman's solution is strangely shorter... but wtf cares!?!? that's IT FOR SICP!!!



; i still hate scheme
; i guess i don't HATE the book anymore
; but i still hate scheme, just maybe not with a passion

; now i definitely think anybody who proselytizes this book is either being pretentious, or never worked the exercises
    ; omfg the stupid exercises
    ; how many hours have i wasted on stupid scheme syntax bugs? 
    ; the parentheses.... the parentheses...
        ; if the developer tools had been better, i might have rated this book at 4/5
            ; but definitely not a 5/5 classic must-read, not like godel escher bach
                ; this book is inescapably "language-dependent" and therefore not truly timeless
            ; the tools are just so horribly unfriendly and archaic (can't a brother get a line number for an error??)
    
                
; for every field there is a suitable language
    ; for systems programming, C
    ; for numerical analysis, Fortran
    ; for metalinguistic analysis, Lisp
    ; for short networking scripts, Python?
    ; in such field-language combinations, common tasks are expressed CONCISELY and CLEARLY
    


; in the end, it IS pretty impressive how far they can take their toy language
    ; metalinguistic analysis/implementation is only possible with such a syntactically simple language
    ; and the symbol processing capabilities (inherited from Lisp) make it pretty natural for metalinguistic stuff
    ; BUT such ideas are DEFINITELY not suitable for a first/required course
        ; 99%+ of your students won't be writing compilers    
        ; 99%+ of your students would benefit from learning a more mainstream language as their "mother language"
        ; although important ideas like encapsulation are there in nascent form, they are 
            ; poorly structured  
            ; too loosely enforced
            ; outdated
        ; but i guess any serious student of CS should read it eventually...
            
; it is also impressive how the chapters are "cumulative"
    ; Chapter 1 shows how far you can go with JUST lambda
    ; Chapter 2 shows how far you can go with lambda + lists
    ; Chapter 3 shows how far you can go with lambda + lists + assignment
    ; Chapter 4 takes that knowledge to implement (Scheme) interpreters
    ; Chapter 5 takes the same knowledge to simulate computer hardware, and then run Scheme on the simulated hardware
    
; the book should really be subtitled "more than you wanted to know about the scheme programming language"

; 2001 review score: 2/5 stars (recalled through the hazy lens of memory)
    ; i think i DESPISED the class CS 1, but thought the book was ok, if a bit time-consuming to read? but hated scheme
; 2014 review score: 3.5/5 stars
    


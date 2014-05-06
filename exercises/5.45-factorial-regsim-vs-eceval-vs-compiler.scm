;(load "5.02-factorial-via-register-machine.scm") 
; oops, that's not even the register machine i want...
; that iterative machine doesn't even USE the stack!


(define test-values '(5 10 25 50 100 250 500 1000))

; for checking correctness
(define (factorial n)
  (if (= n 1)
      1
      (* (factorial (- n 1)) n)))


; "special-purpose [virtual register] machine"
(define (test-regsim)

    (load "5.14-monitoring-factorial.scm")

    ; modified from (test-5.14)    
    (load "ch5-regsim.scm")
    (define (test n)
        (let ((machine (make-factorial-machine)))    
            (set-register-contents! machine 'n n)
            ((machine 'stack) 'initialize)
            (start machine)
            (display "\n\nFactorial of ")(display n) (display ": ")
            (let ((val (get-register-contents machine 'val)))
                (if (= val (factorial n))
                    (display "correct")
                    (error "factorial-machine computed a wrong answer! " val)
                )
            )
            ((machine 'stack) 'print-statistics)
        )
    )

    (for-each test test-values)
)
;(test-regsim)   
    
; stack statistics    
; n       total   max  
; 5       8       8
; 10      18      18
; 25      48      48
; 50      98      98
; 100     198     198
; 250     498     498
; 500     998     998
; 1000    1998    1998



; interpreter - running on a general-purpose [virtual register] machine
(define (test-eceval)

    ;(load "5.26-29-eceval-batch.scm")
    (load "5.27-recursive-factorial-stack.scm")
    
    ; ugh, don't have any way to 
    (set! eceval-prebatch-command
        (lambda ()
            `(begin
                   
                ;(define test-values ',test-values) ; WOW that's ugly
                ,(eceval-prebatch-command-recursive-5.27) 
                "Run (f) interactively... no easy way to reset stack between each call"
                ;'hello
                
            )
        )
    )
    
    (run-eceval)
)
;(test-eceval)
; stack statistics    
; n       total   max  
; 5       144     28
; 10      304     53
; 25      784     128    
; 50      1584    253
; 100     3184    503
; 250     7984    1253
; 500     15984   2503
; 1000    31984   5003 holy cow!
; Inf     16x     2.5x regsim
; looks like interpreted code uses
    ; 16x the time of special-purpose (metric: total pushes)
    ; 2.5x the space of special purpose (metric: max depth)

(define (test-compiler) ; actually, it's JUST make-factorial-machine that lets me run multiple experiments non-interactively
    (load "5.38-open-coded-primitives.scm")
    (set! install-compile-5.38 (lambda () (display "Uninstalled open-coding.")))
    (test-5.38c)
)
;(test-compiler)
; stack statistics    
; n       total   max  
; 5       31      14 
; 10      61      29
; 25      151     74
; 50      301     149
; 100     601     299
; 250     1501    749
; 500     3001    1499
; 1000    6001    2999
; Inf     3x      1.5x regsim
; looks like compiled code uses
    ; 3x the time of special-purpose (metric: total pushes)
    ; 1.5x the space of special purpose (metric: max depth)
    
    
    
; instinct: you'll probably get more savings from open coding than lexical addressing
; here's results from (test-compiler), with open-coding disabled (not disabling install-compile-5.38)
; n       total   max  
; 5       13      8
; 10      23      18    
; 25      53      48
; 50      103     98
; 100     203     198 ; hmm, a little disturbing... oh, total is just growing that SLOWLY
; 250     503     498
; 500     1003    998
; 1000    2003    1998
; Inf     1x      1x regsim

; yep, open-coding is practically as efficient as the special-purpose machine!!



; lexical addressing for completeness
(define (test-lexical-addressing)
    
    ; for factorial definition
    (load "5.27-recursive-factorial-stack.scm")

    ; modified from (test-5.42)
    (load "ch5-compiler.scm") 
    (load "load-eceval-compiler.scm")
    (load "5.39-lexical-address-lookup.scm")
    (load "5.40-compile-time-env-in-lambda-body.scm") (install-compile-lambda-body-5.40)
    (load "5.41-find-variable-in-ct-env.scm")
    (load "5.42-lexical-address-integration.scm") (install-compile-var-set-5.42) 
    
    
    (set! eceval (make-machine 
        eceval-compiler-register-list
        (append eceval-operations (list 
            (list 'lexical-address-lookup lexical-address-lookup)
            (list 'lexical-address-set! lexical-address-set!)
        ))
        eceval-compiler-main-controller-text
    ))
    
    (compile-and-go    
        (eceval-prebatch-command-recursive-5.27) 
        (empty-compile-time-environment)
    )
)
;(test-lexical-addressing)
; same stack statistics as standard compiler!
    ; yep, (lookup-variable-value) might execute more slowly, 
        ; but that is NOT REFLECTED IN STACK STATISTICS!!
        ; don't feel like timing my meta-/nested-code or whatever it's called


    

; the problem calls this "an upward-compatible extension", i.e., forward-compatible.
; but don't they really mean BACKWARDS compatible??

; looks like if you maintain the argument list unmodified, you can "lazily" procrastinate handling it until (apply)
    ; compound procedure case
    ; parse the arguments here into a result list, before calling (extend-environment)
    
    ; but what about handling memoization? probably just tweak the tags and add an extra conditional to (force-it)
    
    
; but i THINK that you can use the rest of the infrastructure unmodified?? detailed trace
    ; (lambda-parameters) just (cadr) - it'll just be a NESTED list now
    ; (definition-value) when expr = (define (f <NESTED-arg-list>) <body>)
        ; (make-lambda (cdadr expr) (cddr expr)), which still works fine.
    ; it all boils down to whether whoever PROCESSES (lambda-parameters) will be ok
    ; (lambda-parameters) is used in only one place - (make-procedure)
        ; (make-procedure) just throws parameters into a list without parsing
        ; it'll be accessed via (procedure-parameters)
    ; (procedure-parameters) is called in only TWO places
        ; one is a trivial read in (user-print)
        ; the other is in (apply)

; and don't forget (procedure-parameters) are the INSTRUCTIONS on how to process arguments in (apply).
        
(load "4.27-31-ch4-leval.scm")
 


 
; modified from ch4-leval.scm
(define (apply procedure arguments env)

    ; new helper functions
    (define (parameter-type param)
        (cond
            ((symbol? param) 'normal)
            ((and (list? param) (eq? (cadr param) 'lazy)) 'lazy)
            ((and (list? param) (eq? (cadr param) 'lazy-memo)) 'lazy-memo)            
            (else (error "Unknown type -- PARAMETER-TYPE" param))
        )
    )
    
    (define (parameter-name param)
        (cond
            ((symbol? param) param)
            ((list? param) (car param))
            (else (error "Unknown name -- PARAMETER-NAME" param))
        )
    )
    
    
    (define (eval-arg proc-env)
        (lambda (param arg)
            (let ((type (parameter-type param)))
            
                ;(newline) (display "EVAL-ARG: ")(display (parameter-name param)) (display type);(display proc-env)
            
                (cond 
                    ((eq? type 'normal)
                        (actual-value arg proc-env))
                    ((eq? type 'lazy-memo)
                        ;(actual-value arg proc-env))
                        (delay-it arg proc-env))
                        
                    ; make modifications to leval as MINIMAL as possible
                    ((eq? type 'lazy)
                        (delay-it-without-memoization arg proc-env))
                        
                    (else
                        (error "unimplemented type -- PROCESS-ARG" type))
                )        
            )
        )
    )
            

  ; original logic
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure
          procedure
          (list-of-arg-values arguments env)))                      ; leave this alone, i think; buck stops here
        ((compound-procedure? procedure)

            ;(display (map parameter-name (procedure-parameters procedure)))
        
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
           
           ;(procedure-parameters procedure)                        ; changed
           (map parameter-name (procedure-parameters procedure))    
           
           ;(list-of-delayed-args arguments env)                    ; changed
           (map 
                (eval-arg env) ;(procedure-environment procedure)) ; oops
                (procedure-parameters procedure) 
                arguments
           )
           
           (procedure-environment procedure))))                        
        (else
         (error
          "Unknown procedure type -- APPLY" procedure))))


; SLIGHTLY modified from ch4-leval.scm (2-line modification)
(define (force-it obj)
  (cond ((thunk? obj)                                               
         (let ((result (actual-value
                        (thunk-exp obj)
                        (thunk-env obj))))
           (set-car! obj 'evaluated-thunk)                          
           (set-car! (cdr obj) result) 
           (set-cdr! (cdr obj) '())    
           result))
        ((evaluated-thunk? obj)                                     
         (thunk-value obj))
        ((unmemoized-thunk? obj)                                    ; new case
            (actual-value (thunk-exp obj) (thunk-env obj)))
        (else obj)))          



; just (delay-it) with a different tag.
(define (delay-it-without-memoization expr env)
    (list 'thunk-no-memo expr env))
(define (unmemoized-thunk? obj)
    (tagged-list? obj 'thunk-no-memo))
    

          


(append! primitive-procedures (list (list '> >)))
(define the-global-environment (setup-environment))




; utility function for running a command in "batch mode" - because i'm sick and tired of typing interactively
; based on (driver-loop)
(define (leval . input-expr-list )
    (define (leval-single-input input)
        (let ((output (actual-value input the-global-environment)))
        
            (announce-output input-prompt)
            (user-print input)
            (newline)
            
            (announce-output output-prompt)
            (user-print output)
            (newline)
            
        )
    )

    (for-each leval-single-input input-expr-list)
)     

(leval 
    '"hello world"
    
    '(define (f a (b lazy)) (if (> a 0) a b))
    '(f 1 2)
    '(f 2 (/ 1 0)) ; turn off lazy evaluation in (eval-arg) above and watch this crash and burn! OR make b non-lazy in definition.
    ;'(f (/ 1 0) 3) ; first argument ain't lazy, so this won't work
    
    
    '(define (countdown-fast (n lazy-memo)) (display n) (display " ") (if (> n 0) (countdown-fast (- n 1)) 0))
    '"Starting fast countdown - see Exercise 4.29..."
    '(countdown-fast 300)
    
    '(define (countdown-slow (n lazy)) (display n) (display " ") (if (> n 0) (countdown-slow (- n 1)) 0))
    '"Starting SLOW countdown to 300 - see Exercise 4.29..."
    '(countdown-slow 300)
    

)     
(driver-loop)




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
 

; utility function for running a command in "batch mode" - because i'm sick and tired of typing interactively
; based on (driver-loop)
(define (leval . input-expr-list )
    (define (leval-single-input input)
        (let ((output (actual-value input the-global-environment)))
            (announce-output output-prompt)
            (user-print output)
        )
    )

    (for-each leval-single-input input-expr-list)
)


; from ch4-leval.scm - start without memoization for simplicity
;; non-memoizing version of force-it

(define (force-it obj)
  (if (thunk? obj)
      (actual-value (thunk-exp obj) (thunk-env obj)) 
      obj))


 
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
            
                (cond 
                    ((eq? type 'normal)
                        (actual-value arg proc-env))
                    ((eq? type 'lazy)
                        ;(actual-value arg proc-env))
                        (delay-it arg proc-env))
                        
                        ; TODO: different delay-it for memoized
                    (else
                        (error "unimplemented type -- PROCESS-ARG" type))
                )        
            )
        )
    )
            
    
    


  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure
          procedure
          (list-of-arg-values arguments env)))                      ; leave this alone, i think
        ((compound-procedure? procedure)
        
            ;(newline) (display (procedure-parameters procedure))
            ;(let* ( (parameters (procedure-parameters procedure))
            ;        (names (map parameter-name parameters))
            ;        (types (map parameter-type parameters))
            ;        )
            ;    (newline) (display names)
            ;    (newline) (display types)
            ;)         

        
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
           
           ;(procedure-parameters procedure)
           (map parameter-name (procedure-parameters procedure))
           
           ;(list-of-delayed-args arguments env) ; changed           ; delays arguments instead of evaluating them - originally just arguments 
           (map 
                (eval-arg (procedure-environment procedure))
                (procedure-parameters procedure) 
                arguments
           )
           
           (procedure-environment procedure))))                         ; (pre-evaluated via list-of-values in eval)
        (else
         (error
          "Unknown procedure type -- APPLY" procedure))))


(append! primitive-procedures (list (list '> >)))
(define the-global-environment (setup-environment))
     

(leval 
    '"hello world"
    
    '(define (f a (b lazy)) (if (> a 0) a b))
    '(f 1 2)
    '(f 2 (/ 1 0)) ; turn off lazy evaluation in (eval-arg) above and watch this crash and burn!
    ;'(f (/ 1 0) 3) ; first argument ain't lazy, so this won't work

)     
(driver-loop)

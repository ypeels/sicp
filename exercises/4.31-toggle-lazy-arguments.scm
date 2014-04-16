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



 
; modified from ch4-leval.scm
(define (apply procedure arguments env)

    ; new helper function - returns pair (argument names . argument types)?


  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure
          procedure
          (list-of-arg-values arguments env)))                      ; leave this alone, i think
        ((compound-procedure? procedure)
        
         (newline) (display (procedure-parameters procedure))
        
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
           (procedure-parameters procedure)
           (list-of-delayed-args arguments env) ; changed           ; delays arguments instead of evaluating them - originally just arguments 
           (procedure-environment procedure))))                         ; (pre-evaluated via list-of-values in eval)
        (else
         (error
          "Unknown procedure type -- APPLY" procedure))))
     

(leval 
    '"hello world"
    
    '(define (f a (b lazy)) (+ 1 1))
    '(f 1 2)

)     
(driver-loop)
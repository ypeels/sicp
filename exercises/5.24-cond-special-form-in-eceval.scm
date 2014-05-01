(load "load-eceval.scm")



; i don't think we've ever IMPLEMENTED cond as a special form...?
;(define (cond-first-clause clauses)
;    (car clauses))
;(define (cond 
; meh, just use first-exp and rest-exps


; this was MUCH harder than using a derived expression
    ; then again, it's not like we had to rewrite cond->if for the latter...
(define eceval-cond-text-5.24 '(
    
    ; based on ev-if and ev-begin
    ; (eval expr=(cond ...) env)
ev-cond
    (save continue)
    (assign unev (op cond-clauses) (reg expr))
    ;(goto (label ev-cond-clause-loop)) ; glen george style
    
ev-cond-clause-loop

    ; just in case there is no else clause - pointed out by meteorgan
    (test (op null?) (reg unev))
    (branch (label ev-cond-no-else-clause-found))

    ; are we at an else clause?
    (assign expr (op first-exp) (reg unev))                     ; meh, not gonna bother creating (cond-first-clause), etc.
    (test (op cond-else-clause?) (reg expr))
    (branch (label ev-cond-perform-action))
    
    ; handle non-else clause
    ; val = (eval (cond-predicate first-clause) env)
    (save unev)
    (save env)
    (save expr)
    (assign expr (op cond-predicate) (reg expr))
    (assign continue (label ev-cond-test-clause))
    (goto (label eval-dispatch))
    
ev-cond-test-clause     
    (restore expr)
    (restore env)
    (restore unev)
    ; result: val = true or false
    
    (test (op true?) (reg val))
    (branch (label ev-cond-perform-action))
    
    ; if predicate was false, perform next loop iteration
    (assign unev (op rest-exps) (reg unev))
    (goto (label ev-cond-clause-loop))    
    
ev-cond-perform-action
    (assign expr (op cond-actions) (reg expr))
    
    ;(perform (op user-print) (const "calling eval with expr = "))
    ;(perform (op user-print) (reg expr)) ; ahhh you need to wrap it with a (begin)
    (assign expr (op sequence->exp) (reg expr)) 
    
    (restore continue)
    (goto (label eval-dispatch))
    
ev-cond-no-else-clause-found    ; doesn't reproduce the error for an empty (cond). oh well.
    (restore continue)
    (goto (reg continue))
    
))

(define (test-5.24)

    ;(append! eceval-operations (list (list 'cond->if cond->if)))
    (append! eceval-operations 
        (list 
            (list 'cond-clauses cond-clauses)
            (list 'cond-else-clause? cond-else-clause?)  ; p. 373
            (list 'cond-predicate cond-predicate)
            (list 'cond-actions cond-actions)
            (list 'sequence->exp sequence->exp)
            (list 'null? null?)
        )
    )
    

    (define eceval-5.24
        (make-eceval 
            eceval-main-controller-text
            eceval-cond-text-5.24))
    (start eceval-5.24)
)
(define the-global-environment (setup-environment)) (test-5.24)

; (define (f x) (cond (x 'yes) (else 'no)))
; (define (f x) (cond ((< x 0) '-) ((> x 0) '+) (else 'zero)))
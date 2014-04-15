(load "4.27-31-ch4-leval.scm")
(driver-loop)

; ; Exercise 4.27.  Suppose we type in the following definitions to the lazy evaluator:
; 
; (define count 0)
; (define (id x)
;   (set! count (+ count 1))
;   x)
; (define w (id (id 10)))
; 
; ; Give the missing values in the following sequence of interactions, and explain your answers.
; 
; ;;; L-Eval input:
; count
; 
; ;;; L-Eval value:             (a)
; <response> = 1 (non-lazy: 2)
; 
; ;;; L-Eval input:
; w
; 
; ;;; L-Eval value:             (b)
; <response> = 10 (non-lazy: 10)
; 
; ;;; L-Eval input:         
; count
; 
; ;;; L-Eval value:             (c)
; <response> = 2 (non-lazy: 2). what about non-memoized?


; (a)
; A bit of experimentation shows that count is 0 until after w is (define)d.
; hmmmm i THOUGHT that lazy evaluation meant that (id) would never be applied until w was ever USED...

; well, in any case, the line that causes count to increment is (define w...), so let's just trace through that...
    ; (driver-loop)
    ; input = (read) = '(define w (id (id 10)))
    ; output = (eval input the-global-environment)
    ; will eventually return 'ok. we are concerned with the "side effects" on the environment...
    
    ; note that all these functions are from ch4-mceval.scm! only (eval) itself has changed.
    ; (eval-definition exp env) because it's a 'define
    ; (define-variable! 'w (eval '(id (id 10)) env) env)
        ; (define-variable!) uses super low-level operations and searches frame; it is not responsible for side effects.
    ; (eval '(id (id 10)) env). this is a procedure application (falls through cond in eval)
    ; (apply (actual-value 'id env) '((id 10)) env)
        ; (actual-value 'id env) should just return id's lambda(x) + env, and not execute it yet. no side effect...
    ; (apply id '((id 10)) env)
    ; (eval-sequence
    ;     (procedure-body id)   <================== here's your side effect! the outer (id) gets evaluated by (define w)!
    ;     (extend-environment
    ;         (procedure-parameters id)
    ;         (list-of-delayed-args '((id 10)) env)
    ;         (procedure-environment id)
    ;     )
    ; )
    ; 

    




; (b) 
; this is trivial - the return value of (id x) is just x.
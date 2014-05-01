(load "5.23-24-cond-in-eval-dispatch.scm")


(define eceval-cond-text-5.23 '(
    
ev-cond

    ;(assign val (const "hello world\n"))
    ;(goto (label signal-error))
    
    ; (eval (cond->if expr) env)
    (assign expr (op cond->if) (reg expr))
    ;(save continue) ; is this needed? probably harmful...?
    (goto (label eval-dispatch))
        ; is this IT??
        
))

(define (test-5.23)

    ; no, this had to be hard coded into ch5-eceval.scm, to allow "backwards compatibility" with the default eceval object
    ;(append! eceval-operations (list (list 'cond? cond?))))
    (append! eceval-operations (list (list 'cond->if cond->if)))
    (append! eceval-main-controller-text eceval-cond-text-5.23)
    (run-eceval-5.23-24)

    ;(define eceval-5.23
    ;    (make-eceval (append
    ;        eceval-main-controller-text
    ;        eceval-cond-text-5.23)))
    ;(start eceval-5.23)
)
(define the-global-environment (setup-environment)) (test-5.23)

; (define (f x) (cond (x 'yes) (else 'no)))
(load "load-eceval.scm")

; must be done at global scope
(define the-global-environment (setup-environment))

(define (eceval-prebatch-command)
    "Hello from eceval-prebatch-command! Override this function in your own file to return EC-Eval input (1 line).\n"
)


(define eceval-prebatch-text-5.26-29 '(

    (perform (op initialize-stack))
    (perform (op prompt-for-input) (const ";;; Input from eceval-prebatch-command:"))
    (assign expr (op eceval-prebatch-command))
    (perform (op user-print) (reg expr))
    
    (assign env (op get-global-environment))
    (assign continue (label eceval-prebatch-output))
    (goto (label eval-dispatch))
    
eceval-prebatch-output
    (perform (op announce-output) (const ";;; Output from eceval-prebatch-command:"))
    (perform (op user-print) (reg val))
    ;(goto (label read-eval-print-loop)    

))

(define (run-eceval)
    (append! eceval-operations 
        (list 
            (list 'eceval-prebatch-command eceval-prebatch-command)
        )
    )

    (define eceval
        (make-eceval 
            (append eceval-prebatch-text-5.26-29 eceval-main-controller-text)
            eceval-cond-text))
            
    (start eceval)
)
            

            
(define (test-5.26-29)
    (run-eceval)
)
;(test-5.26-29)
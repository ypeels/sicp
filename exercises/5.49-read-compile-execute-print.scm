; the exercise gives you the hints you need
; you're not supposed to modify the compiler, or even eceval.
; create a NEW STUPID MACHINE that
    ; takes scheme expressions as input
    ; calls (compile 'val 'return) and assemble on the input
    ; prints the result in val
    ; uses the eceval-operations runtime (I think)
    ; maintains eceval's register set so that env, etc. 
    
    
(define eceval-5.49 '*unassigned*)
    
(define the-global-environment '())

(define (assemble-for-eceval-5.49 compiler-output)
    
    (for-each
        (lambda (line) (display line) (newline))
        (statements compiler-output)
    )
    

    ; cf. 5.48 and (compile-and-go)
    (assemble (statements compiler-output) eceval-5.49)
)


; same register set as eceval - which is what the compiler expects.
(define eceval-registers-5.49 '(expr env val proc argl continue unev))

    
(define eceval-controller-text-5.49 '(

; first parrot the outermost loop of eceval-compiler
read-compile-exec-print-loop
    (perform (op initialize-stack))
    (perform (op prompt-for-input) (const ";;; EC-Eval-5.49 input:"))
    (assign expr (op read))
    (assign env (op get-global-environment))
    ;(assign continue (label print-result))
    (goto (label comp-exec-dispatch))
print-result
    ;(perform (op print-stack-statistics))
    (perform (op announce-output) (const ";;; EC-Eval-5.49 value:"))
    (perform (op user-print) (reg val))
    (goto (label read-compile-exec-print-loop))
  
  
  ; expr = scheme expression from user
  ; continue = print-result
comp-exec-dispatch  
    (assign val (op compile) (reg expr) (const val) (const return)) ; you DON'T quote val/return here. ehhhh?
    (assign val (op assemble-for-eceval-5.49) (reg val))
    (assign continue (label print-result)); moved here from main loop for clarity
    (goto (reg val)) ; will return linkage automagically handle everything??
))


; all (op)'s needed by eceval-instructions-5.49, and nothing more? 
    ; no, assembler needs lookup-variable-value, etc. runtime
(define eceval-operations-5.49 '*unassigned*)
(define (install-eceval-operations-5.49)
;    (set! eceval-operations-5.49
;        (list
;            ;(list 'initialize-stack ; this and print-stack-statistics are declared in (make-new-machine)
;            
;            ; in order of appearance - all from ch5-eceval-support.scm unless marked otherwise
;            (list 'prompt-for-input prompt-for-input) 
;            (list 'read read) ; scheme built-in, of course
;            (list 'get-global-environment get-global-environment) 
;            (list 'announce-output announce-output) 
;            (list 'user-print user-print)
;            (list 'compile compile) ; from ch5-compiler.scm, of course
;            (list 'assemble-for-eceval-5.49 assemble-for-eceval-5.49) ; gee, i wonder where this comes from
;        )
;    )

    (set! eceval-operations-5.49 
        (append
            eceval-operations
            (list
                (list 'compile compile)
                (list 'assemble-for-eceval-5.49 assemble-for-eceval-5.49)
            )
        )
    )
)

;; ohh now the burden for all the crazy operations is on the ASSEMBLER...
;(define (install-primitives-5.49)
;    (append! 
;            


(define (test-5.49)
    (load "ch5-regsim.scm") ; for (make-machine) and (assemble)
    (load "ch5-compiler.scm") ; for (compile)
    (load "ch5-eceval-support.scm") ; for syntax and utility procedures
    (load "ch5-eceval-compiler.scm") ; for operation list
    
    
    (set! the-global-environment (setup-environment))
    (install-eceval-operations-5.49)
    (set! eceval-5.49 (make-machine
        eceval-registers-5.49
        eceval-operations-5.49
        eceval-controller-text-5.49
    ))
    
    (eceval-5.49 'start)
)
(test-5.49)
        
        
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
    (perform (op initialize-stack)) ; better name inspired by l0stman
    (perform (op prompt-for-input) (const ";;; EC-Comp-Exec input:"))
    (assign expr (op read))
    (assign env (op get-global-environment))
    ;(assign continue (label print-result)) ; moved to comp-exec-dispatch
    (goto (label comp-exec-dispatch))
print-result
    (perform (op print-stack-statistics))
    (perform (op announce-output) (const ";;; EC-Comp-Exec value:"))
    (perform (op user-print) (reg val))
    (goto (label read-compile-exec-print-loop))
  
  
; basically, this entire exercise is just about writing these 3 new lines of assembly code!
    ; expr = scheme expression from user
    ; continue = print-result
comp-exec-dispatch  
    (assign val (op compile) (reg expr) (const val) (const return)) ; you DON'T quote val/return here. ehhhh?
    (assign val (op assemble-for-eceval-5.49) (reg val))
    (assign continue (label print-result)); moved here from main loop for clarity. unlike eceval, this exit point is unconditional
    (goto (reg val)) ; will return linkage automagically handle everything?? yes!
))


; another cursed existence with little to no utility
    ; 5.48 yielded a compiling interpreter - typing expressions is slower than compiling in batch
    ; 5.49 yielded an interpreting compiler - compiling expressions is (possibly?) slower than interpreting


; all (op)'s needed by eceval-instructions-5.49, and nothing more? 
    ; no, assembler needs lookup-variable-value, etc. runtime
(define eceval-operations-5.49 '*unassigned*)
(define (install-eceval-operations-5.49)
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



(define (test-5.49)
    (load "ch5-regsim.scm") ; for (make-machine) and (assemble)
    (load "ch5-compiler.scm") ; for (compile)
    (load "ch5-eceval-support.scm") ; for syntax and utility procedures
    (load "ch5-eceval-compiler.scm") ; for operation list, needed by assembler
    
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
        
        
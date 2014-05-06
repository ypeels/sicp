; this should be pretty easy, right?
; just do something similar to (compile-and-go), and make it accessible to eceval


(define (compile-and-run expression)
    (let (  (instructions 
                (assemble                 
                    (statements 
                        (compile expression 'val 'return)
                    ) 
                    eceval ; hmm, accessing the global variable directly...
                ))
            )
        
        (display "\nhello from compile-and-run")
        
        ; uh, how to jump to instructions??
        ; hmm, it's a little creepy that eceval would call the following within a "primitive"...
        ;(set-register-contents! eceval 'val instructions)
        ;(set-register-contents! eceval 'flag true)
        
        
        ; this is ugly and completely wrong.     
        ;(set-register-contents! eceval 'pc instructions) 
        
        'compile-and-run-done
    )
)
        
        
        
        
        
(define (test-5.48)
    (load "ch5-compiler.scm")
    (load "load-eceval-compiler.scm")
    
    ; these are the procedures accessible via (op) in assembly code
    ;(set! eceval (make-machine 
    ;    eceval-compiler-register-list
    ;    (append eceval-operations (list (list 'compile-and-run compile-and-run)))
    ;    eceval-compiler-main-controller-text
    ;))
    
    ; these are procedures accessible at the EC-Eval prompt
    ;(set! primitive-procedures (list (list '+ +)))
    (append! primitive-procedures (list (list 'compile-and-run compile-and-run)))
    
    
    (start-eceval)
)
(test-5.48)
    
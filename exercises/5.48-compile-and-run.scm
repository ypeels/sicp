; this should be pretty easy, right?
; just do something similar to (compile-and-go), and make it accessible to eceval

(load "5.33-38-compiling-to-file.scm")

(define (compile-and-run expression)
    (let (  (instructions 
                (assemble                 
                    (statements 
                        (compile expression 'val 'return)
                    ) 
                    eceval ; hmm, accessing the global variable directly...
                ))
            (pc ((eceval 'get-register) 'pc))
            (continue ((eceval 'get-register) 'continue))
            (stack (eceval 'stack))
            )
        
        (display "\nhello from compile-and-run\n")
        (compile-to-file expression 'val 'return "test.txt")
        
        ; uh, how to jump to instructions??
        ; hmm, it's a little creepy that eceval would call the following within a "primitive"...
        ;(set-register-contents! eceval 'val instructions)
        ;(set-register-contents! eceval 'flag true)
        
        
        ; this is ugly and completely wrong. "empty stack"
        ; or maybe i should add some additional assembly instructions and then (assemble)?
        ; or maybe i should manipulate the stack directly??
        ;(advance-pc pc)
        ;(push stack (pc 'get))

        ; ohhhhh if i jump directly, i also need to make sure i emulate the end of primitive-apply, from whence this came
        ;((stack 'push) (continue 'get)) ; my first instinct was the REVERSE of what i need
        ((continue 'set) (stack 'pop)) ; return linkage will get it, right?
        
        ; empirically: if i jump directly, there are TWO unbalanced pops.
        (set-register-contents! eceval 'pc instructions) 
        
        ;'compile-and-run-done
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
    
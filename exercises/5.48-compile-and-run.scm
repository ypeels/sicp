; this should be pretty easy, right?
; just do something similar to (compile-and-go), and make it accessible to eceval



(define (compile-and-run expression)
    (let* ( (pc ((eceval 'get-register) 'pc))
            (continue ((eceval 'get-register) 'continue))
            (stack (eceval 'stack))
            
            (scheme-code
                (begin
                    ;(cond
                    ;    ((or (self-evaluating? expression) (symbol? expression))
                    ;        expression)
                    ;    ((pair? expression)
                    ;        (text-of-quotation expression))
                    ;    (else
                    ;        (error "Unknown expression type -- COMPILE-AND-RUN" expression))
                    ;)
                    (display "\ncompile-and-run: expression = ") 
                    (display expression)
                    (newline)
                    expression
                )
            )
            
            (asm-code 
                (begin
                    (display "scheme-code = ") 
                    (display scheme-code)
                    (newline)
                    (statements ; works without text-of-quotation, but this makes the syntax consistent with the normal compiler
                        (compile scheme-code 'val 'return);'next) ;
                    ) 
                )
            )
            
            (instructions
                (begin
                    ;(display asm-code)
                    (assemble
                        (append
                            asm-code
                            
                            ; ohhh assembler doesn't know about labels not in this code
                                ; likewise, can't assemble 'print-result linkage directly
                            ; hence the text's use of compadd
                            ;'((goto (label print-result))) 
                            ;'((goto (reg printres)))
                        )
                        eceval ; hmm, accessing the global variable directly...
                    )
                )
            )            
          )
        
        ;(display "\nhello from compile-and-run\n")
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
        ';((stack 'push) (continue 'get)) ; nope. my first instinct was the REVERSE of what i need
        ;((continue 'set) (stack 'pop)) ; return linkage will get it, right? yeah!
        ; not QUITE, since you want the interpreter to print the output
        ; don't need to worry about clearing the stack, since (op initialize-stack) should clear it?
        ; but then if i don't, there's some weird behavior
        ;(stack 'pop)
        ;((continue 'set) (stack 'pop))
        
        ; empirically: if i jump directly, there are TWO unbalanced pops.
        ;(disp
        ;(display instructions)
        
        (set-register-contents! eceval 'pc instructions) 
        ;(display "giggity")

        
        ;'compile-and-run-done
    )
)
        
        
        
        
        
(define (test-5.48)
    (load "ch5-compiler.scm")
    (load "load-eceval-compiler.scm")
    (load "5.33-38-compiling-to-file.scm")
    
    (set! eceval (make-machine
        (cons 'printres eceval-compiler-register-list)
        eceval-operations   ; these are the procedures accessible via (op) in assembly code
        (cons 
            '(assign printres (label print-result)) ; hack to print result after compile-and-run
            eceval-compiler-main-controller-text 
        )
    ))
    
    ; these are procedures accessible at the EC-Eval prompt
    (append! primitive-procedures (list (list 'compile-and-run compile-and-run)))
    
    
    (start-eceval)
)
(test-5.48)
; ;;; EC-Eval input:
; (compile-and-run 
    
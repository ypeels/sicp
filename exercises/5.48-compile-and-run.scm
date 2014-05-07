; this should be pretty easy, right?
; just do something similar to (compile-and-go), and make it accessible to eceval
    ; ugh, grappled with syntax for QUITE a while
    
; l0stman, on the other hand, just calls (start eceval) from within (compile-and-run)
    ; impressive that this works, but i worry about garbage buildup...


;(load "5.33-38-compiling-to-file.scm")
(define (compile-and-run-development expression)
    (let* ( ;(pc ((eceval 'get-register) 'pc))
            ;(continue ((eceval 'get-register) 'continue))
            ;(printres ((eceval 'get-register) 'printres))
            (stack (eceval 'stack))
            (target 'val)
            (linkage 'next)
            
            (scheme-code
                (begin
                    ;(display "\ncompile-and-run: expression = ") (display expression) (newline)
                    expression
                )
            )
            
            (asm-code 
                (begin
                    ;(display "scheme-code = ") (display scheme-code) (newline)
                    (statements 
                        (compile scheme-code target linkage)
                    ) 
                )
            )
            
            (instructions
                (begin
                    ;(display asm-code)
                    (assemble
                        (append
                        
                            ; can use this + return linkage, or post-goto + next linkage
                            ;'((assign continue (reg printres)))
                        
                            asm-code
                            
                            ; compile linkage=print-result is fine...
                            ; the problem is that the assembler doesn't know about labels not in its input code
                                ; can't assemble explicit (goto (label print-result))
                                ; can't assemble compile(linkage=print-result), which gives the same thing
                                ; hence the text's use of compadd
                            ;'((goto (label print-result))) 
                            '((goto (reg printres))) 
                        )
                        eceval ; hmm, accessing the global variable directly...
                    )
                )
            )            
         )
        
        ;(display "\nhello from compile-and-run\n")
        ;(compile-to-file expression target linkage "test.txt")
        
        ; remember: this code hooks into primitive-apply! test/trace from  there.
        (stack 'pop) ; get rid of old value of continue - optional if you're using 'next linkage + goto
        ((stack 'push) instructions) ; now primitive-apply will jump to newly compiled/assembled code
        
        'compile-and-run-done
    )
)



; condensed version for uploading to wiki
; http://community.schemewiki.org/?sicp-ex-5.48

; this code will get executed by primitive-apply in ch5-eceval-compiler.scm
; specifically, by (apply-primitive-procedure)
(define (compile-and-run expression)
    (let ((stack (eceval 'stack))
          (instructions
            (assemble
                (append
                    (statements (compile expression 'val 'next))
                    
                    ; print the result after executing statements
                    '((goto (reg printres))))
                eceval)))
            
        ; get rid of old value of continue
        ; this is optional, because (initialize-stack) will 
        ; clear the stack after print-result
        (stack 'pop) 
        
        ; the next 2 commands in primitive-apply are:
        ; (restore continue)
        ; (goto (reg continue))
        ; this forces eceval to jump to and execute instructions
        ((stack 'push) instructions)))
        

; --------------------------------------------------        
        
(define (test-5.48)
    (load "ch5-compiler.scm")
    (load "load-eceval-compiler.scm")
    
    ; add and initialize new register printres to expose label print-result
    ; cf. compadd from 5.47
    (set! eceval (make-machine
        (cons 'printres eceval-compiler-register-list)
        eceval-operations   ; procedures accessible via (op) in asm code
        (cons 
            '(assign printres (label print-result)) 
            eceval-compiler-main-controller-text)))
    
    ; procedures accessible at the EC-Eval prompt
    (append! primitive-procedures 
        (list (list 'compile-and-run compile-and-run)))    
    
    (start-eceval)
)
(test-5.48)

; ;;; EC-Eval input:
; (compile-and-run '(define (factorial n) (if (= n 1) 1 (* (factorial (- n 1)) n))))
; ;;; EC-Eval value:
; ok
; ;;; EC-Eval input:
; (factorial 5)
; ;;; EC-Eval value:
; 120
    
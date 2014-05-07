; this should be pretty easy, right?
; just do something similar to (compile-and-go), and make it accessible to eceval
    ; ugh, grappled with syntax for QUITE a while
    
; l0stman, on the other hand, just calls (start eceval) from within (compile-and-run)
    ; impressive that this works, but i worry about garbage buildup...

; for development code, see previous git commits.

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
; (compile-and-run '(define (f n) (if (= n 1) 1 (* (f (- n 1)) n))))
; ;;; EC-Eval value:
; ok
; ;;; EC-Eval input:
; (f 5)
; ;;; EC-Eval value:
; 120
    
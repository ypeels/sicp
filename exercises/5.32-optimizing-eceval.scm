; avoid saving and restoring env around the evaluation of the operator of a combination in the case where 
; the operator is a symbol [variable]

;(load "5.26-29-eceval-batch.scm")
(load "5.26-tail-iterative-factorial-stack.scm") ; for regression test


(define (install-5.32)
(append! eceval-prebatch-text-5.26-29
    '(
        ; override (cf. 5.28)
        ev-application                                           
          (save continue)                                        
          (assign unev (op operands) (reg expr))                ; reordered slightly
          (assign expr (op operator) (reg expr))        
          
          ; is the operator a symbol [variable]?
          (test (op variable?) (reg expr))
          (branch (label ev-appl-do-symbolic-operator))
          
          ; if not, save env [and unev]
          (save env)    
          (save unev)                                           ; don't need to save unev when just looking up                                
          (assign continue (label ev-appl-did-operator))            ; the operator as a variable (read-only operation!)
          (goto (label eval-dispatch))     
          
        ev-appl-do-symbolic-operator
          (assign continue (label ev-appl-did-operator-now-do-operands))
          ;(goto (label eval-dispatch)) 
          (goto (label ev-variable)) ; equivalent. too low-level?
          
        ev-appl-did-operator                                     
          (restore unev)
          (restore env)                                          
          
        ev-appl-did-operator-now-do-operands                    ; new label for the SHARED post-operator code
          (assign argl (op empty-arglist))                       
          (assign proc (reg val))                                
          (test (op no-operands?) (reg unev))                
          (branch (label apply-dispatch))                    
          (save proc)     
          (goto (label ev-appl-operand-loop))                   ; new - to complete the override.
    )
))


(install-5.32)

; regression test
(define eceval-prebatch-command eceval-prebatch-command-iterative-5.26) (run-eceval)
; (f n) should return n!

; (f 5)
; 120
; total-pushes = 158, maximum-depth = 10 with the new optimization
; total-pushes = 204, maximum-depth = 10 without the new optimization


; b. 
; If you add too much "optimization" logic, the parser will get bogged down!
; If you optimize an "analyzing evaluator" that parses only once, aren't you just implementing a compiler??
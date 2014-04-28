; ((op <op-name>) <input1> ... <inputN>)
    ; now, i could use a raw assoc...
        ; but that makes an assumption about the syntax of the expression
    ; use the same level of abstraction as (make-operation-exp)
        ; (make-primitive-exp (operation-exp-operands expr) machine labels)
        ; (label-exp? (operation-exp-operands expr))
(load "2.33-37-accumulate.scm")
(define (operation-exp-operands-with-labels-forbidden operation-exp)
    (let ((operands (cdr operation-exp)))                                               ; still determines syntax of operands
        (if (accumulate (lambda (x y) (or x y)) false (map label-exp? operands))
            (error "Label in operand list -- OPERATION-EXP-OPERANDS" operation-exp)
            operands
        )
    )
)
      

(define (test-5.9)

    (load "ch5-regsim.scm") ; for (label-exp?), not just the full simulator
    (load "5.06-fibonacci-extra-push-pop.scm") ; to get its stupid output lines out of the way
    
    (define (test expr)
        (newline)
        (display expr)
        (display " operands: ")
        (display (operation-exp-operands-with-labels-forbidden expr))
    )
    
    (test '((op live) (reg a) (reg giggity)))
    
    ;(test-5.6-long) ; eats too much screen sapce
    (test-fib-5.6 15) ; didn't break anything
    
    (test '((op DIE) (reg c) (label goo) (const 'aaaaa)))
    
)
;(define operation-exp-operands operation-exp-operands-with-labels-forbidden) (test-5.9)      
        
    
; it's SOO TEMPTING to forbid labels outright in (operation-exp-operands). is it right??
    ; users need, e.g., (assign continue (label afterfib-n-1))
        ; this is needed in the general case, and is NOT a pre-stack kludge
        ; BUT, there is no operation in this!!!
        
        
; so from my notes, 
    ; (operation-exp-operands) is ONLY called from (make-operation-exp)
    ; (make-operation-exp) is only called from (make-assign), (make-test), and (make-perform)  
        ; and ONLY in those cases where (operation-exp?) returned true for some expression
    ; it looks PERFECTLY FINE to modify 
        ; the usage (op <blah>) (label <bleh>) is NOT INTENDED
            ; they were just lazy with their error handling. or perhaps wanted this exercise to be easy...
            
; meteorgan's solution modifies (make-operation-exp) instead. how crude!

    
  
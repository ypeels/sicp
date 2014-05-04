(load "5.33-38-compiling-to-file.scm") ; and override below

; Spread-arguments should take an operand list and compile the given operands targeted 
; to successive argument registers.
(define (spread-arguments operands)
    (let* ( (op1 (first-operand operands))
            (op2 (first-operand (rest-operands operands)))
            (op1-code (compile op1 'arg1 'next))
            (op2-code (compile op2 'arg2 'next))
            )
            
            (newline)(display op2-code)(newline)
            
        ; i don't think you can use (preserving) directly... since i want to wrap the SECOND seq, not the first
        (make-instruction-sequence
            '() ; needs
            '(arg1 arg2) ; modifies
            (statements
                (if (modifies-register? op2-code 'arg1) ; oops, i had (needs-register?) incorrecvtly for a while
                    
                    (append-instruction-sequences
                        op1-code
                        
                        (make-instruction-sequence '(arg1) '() '((save arg1)))
                        op2-code
                        (make-instruction-sequence '() '(arg1) '((restore arg1)))
                    )
                    (append-instruction-sequences
                        op1-code
                        op2-code
                    )
                )
            )
        )
    )
)





; For each of the primitive procedures =, *, -, and +, 
; takes a combination with that operator, together with a target and a linkage descriptor,
(define (compile-plus expr target linkage)
    (let ((arguments (operands expr)))
        (cond
            ((no-operands? arguments)
                (compile '0 target linkage))
            ((no-operands? (rest-operands arguments))
                (compile (first-operand arguments) target linkage))
            ((= 2 (length arguments))

                (end-with-linkage linkage
                    (append-instruction-sequences
                    
                        ; and produces code to spread the arguments into the registers [arg1 and arg2]
                        (spread-arguments arguments)

                        ; and then perform the operation targeted to the given target with the given linkage
                        (make-instruction-sequence
                            '(arg1 arg2); needs
                            (list target); modifies
                            `(
                                (assign
                                    ,target
                                    (op +)
                                    (reg arg1)  ; what a bad name - it looks exactly like argl...
                                    (reg arg2)
                                )
                            )
                        )
                    )
                )
            
            )
            (else (error "Bad number of arguments" (length arguments)))
        )
    )
)



(define compile-compiler compile)
(define (compile expr target linkage)                            
    (cond 
        ((plus? expr)
            (display "\nplusssss!!!!!\n")
            (compile-plus expr target linkage))
        (else
            (compile-compiler expr target linkage))
    )
)



(define (plus? expr)
    (tagged-list? expr '+))




(define (test-5.38)
    (compile-to-file
        '(+ (+ 1 2) (+ 3 4));'(+ 1 2)
        'val
        'next
        "5.38-open-coded-primitives.txt"
    )
)
(test-5.38)
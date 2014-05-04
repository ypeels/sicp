(load "5.33-38-compiling-to-file.scm") ; and override below

; for (compile-and-go) testing
;(load "ch5-compiler.scm")(load "load-eceval-compiler.scm")

; Spread-arguments should take an operand list and compile the given operands targeted 
; to successive argument registers.
(define (spread-arguments operands)
    (let* ( (op1 (first-operand operands))
            (op2 (first-operand (rest-operands operands)))
            (op1-code (compile op1 'arg1 'next))
            (op2-code (compile op2 'arg2 'next))
            (seq1 op1-code)
            
            ; i don't think you can use (preserving) directly to save arg1... 
            ; i want to wrap the SECOND seq, not the first
            (seq2
                (if (modifies-register? op2-code 'arg1)
                    (append-instruction-sequences
                        (make-instruction-sequence '(arg1) '() '((save arg1)))
                        op2-code
                        (make-instruction-sequence '() '(arg1) '((restore arg1))))
                    op2-code))
            )
        
        ; BUT you also need to preserve env for seq2, in case it needs it.
        ; remember, this is an ALTERNATIVE to (compile-application)/(construct-arglist)!!
        (preserving '(env) seq1 seq2)

    )
)





; For each of the primitive procedures =, *, -, and +, 
; takes a combination with that operator, together with a target and a linkage descriptor,
(define (compile-open-code expr target linkage operation null-value)
    (let ((arguments (operands expr)))
        (cond
            ((no-operands? arguments)
                (compile null-value target linkage))
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
                                    (op ,operation)
                                    (reg arg1)  ; what a bad name - it looks exactly like argl...
                                    (reg arg2)
                                )
                                
                                ;(perform (op user-print) (const "\n("))
                                ;(perform (op user-print) (const ,operation))
                                ;(perform (op user-print) (const " "))
                                ;(perform (op user-print) (reg arg1))
                                ;(perform (op user-print) (const " "))
                                ;(perform (op user-print) (reg arg2))
                                ;(perform (op user-print) (const ") = "))
                                ;(perform (op user-print) (reg ,target))
                                
                                
                            )
                        )
                    )
                )
            
            )
            (else (error "Bad number of arguments" (length arguments)))
        )
    )
)

(define (compile-plus expr target linkage)
    (compile-open-code expr target linkage '+ '0))
(define (compile-times expr target linkage)
    (compile-open-code expr target linkage '* '1))
(define (compile-minus expr target linkage)
    (compile-open-code expr target linkage '- '0))   ; actually, (-) crashes scheme, but whatever
(define (compile-equals expr target linkage)
    (compile-open-code expr target linkage '= #t))

(define (plus? expr) (tagged-list? expr '+))
(define (times? expr) (tagged-list? expr '*))
(define (minus? expr) (tagged-list? expr '-))
(define (equals? expr) (tagged-list? expr '=))




(define (compile-5.38 expr target linkage)                            
    (cond 
        ((plus? expr)
            (compile-plus expr target linkage))
        ((times? expr)
            (compile-times expr target linkage))
        ((minus? expr)
            (compile-minus expr target linkage))
        ((equals? expr)
            (compile-equals expr target linkage))
        (else
            (compile-compiler expr target linkage))
    )
)








(define (test-5.38)
    ;(compile-to-file
    ;    '(+ (+ 1 2) (+ 3 4));'(+ 1 2)
    ;    'val
    ;    'next
    ;    "test.txt"
    ;)
    
    ; Try your new compiler on the factorial example. 
    ; Compare the resulting code with the result produced without open coding.
    (compile-to-file
        '(define (factorial n)
          (if (= n 1)
              1
              (* (factorial (- n 1)) n)))
        'val
        'next
        "5.38-factorial-open-coded.asm"
    )
    ; the result is roughly HALF the length!
    
    
    
    ; used for testing, but you have to modify ch5-eceval-compiler.scm
    ;(compile-and-go 
    ;    '(define (f n)
    ;      (if (= n 1)
    ;          1
    ;          (* (f (- n 1)) n)))
    ;)
    
    ;(compile-and-go '(+ (+ 1 2) (+ 3 4)))
        
    
)
(define compile-compiler compile) (define compile compile-5.38) (test-5.38)
;(test-5.38)

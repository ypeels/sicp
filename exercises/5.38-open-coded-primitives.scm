(load "5.33-38-compiling-to-file.scm") ; and override below

; for (compile-and-go) testing
(load "ch5-compiler.scm")(load "load-eceval-compiler.scm")

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
; meteorgan does better http://community.schemewiki.org/?sicp-ex-5.38
    ; he returns seq1 and seq2 back from here
    ; then in (compile-open-code) he uses (preserving '(arg1) seq2 (assign)), which is MUCH cleaner
    ; but his code is severely bugged! 
        ; doesn't even run correctly
        ; he forgot to save env
        ; clearly he didn't test it
; l0stman does the same with spread-arguments https://github.com/l0stman/sicp/blob/master/5.38.tex
; both of these guys are disregarding the spec! it's part b that is supposed to perform the operation, NOT spread-argument





; For each of the primitive procedures =, *, -, and +, 
; takes a combination with that operator, together with a target and a linkage descriptor,
(define (compile-open-code arguments target linkage operation null-value)
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
        
        ; Extend your code generators for + and * so that they can handle expressions with arbitrary numbers of operands.
        ;  An expression with more than two operands will have to be compiled into a sequence of operations, each with only two inputs. 
        ((and (> 2 (length arguments)) (memq operation '(+ *)))
        
            ; sounds like they want us to fix this at the COMPILE level?
            ; l0stman used the PARSE level, but that seems like a cheap cop-out...
            
            ; first idea, but this seems like parse-level
            ;(compile-open-code
            ;    (list 
            ;        (operator expr)
            ;        (first-operand arguments)
            ;        (compile
            
            
            
            ;`((assign ,target (op ,operation) arg1 arg2))
            ; want arg2 to be a recursive result - so 
                ; (compile-open-code (cons (operator target linkage operation null-value)
                ; can't avoid parse-processing??
            ; want arg1 to be (compile (first-operand arguments) 'arg1 'next)
            ; throw (preserving) in there as appropriate?
            
            (error "empty stub")
        )
            
        (else (error "Bad number of arguments" (length arguments)))
    )
)


(define (compile-plus expr target linkage)
    (compile-open-code (operands expr) target linkage '+ '0))
(define (compile-times expr target linkage)
    (compile-open-code (operands expr) target linkage '* '1))
(define (compile-minus expr target linkage)
    (compile-open-code (operands expr) target linkage '- '0))   ; actually, (-) crashes scheme, but whatever
(define (compile-equals expr target linkage)
    (compile-open-code (operands expr) target linkage '= #t))

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
    (compile-and-go 
        '(define (f n)
          (if (= n 1)
              1
              (* (f (- n 1)) n)))
    )
    
    ;(compile-and-go '(+ (+ 1 2) (+ 3 4)))
    
    ;(compile-and-go '(+ 1 2 3 4))
        
    
)
(define compile-compiler compile) (define compile compile-5.38) (test-5.38)
;(test-5.38)

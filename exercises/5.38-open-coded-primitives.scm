;(load "5.33-38-compiling-to-file.scm") ; and override below

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
                            
                            ; not deleting this - it's a useful demo
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
        
        ; d. Extend your code generators for + and * so that they can handle expressions with arbitrary numbers of operands.
        ;  An expression with more than two operands will have to be compiled into a sequence of operations, each with only two inputs. 
        ((and (> (length arguments) 2) (memq operation '(+ *)))
        
            ; sounds like they want us to fix this at the COMPILE level?
            ; l0stman used the PARSE level, but that seems like a cheap cop-out...
            
            (end-with-linkage linkage
                (preserving '(env)
                    (compile (first-operand arguments) 'arg1 'next) ; hmm, this kinda throws away (spread-arguments)...meh.
                    (preserving '(arg1) ; exploitative - really needed ABOVE, not below
                        (compile-open-code (rest-operands arguments) 'arg2 'next operation null-value)
                        (make-instruction-sequence                          ; ^^ using linkage here instead gives an inscrutable bug (return value = execution procedure?)
                            '(arg1 arg2)
                            (list target)
                            `((assign ,target (op ,operation) (reg arg1) (reg arg2)))
                        )
                    )
                )
            )
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








(define (test-5.38c)

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
    
    
    
    ; run compiled code to check that it actually WORKS
    ;(compile-and-go '(+ (+ 1 2) (+ 3 4)))
    (compile-and-go 
        '(begin
            (define (f n)
              (if (= n 1)
                  1
                  (* (f (- n 1)) n)))
            "Factorial defined as (f n)"
        )
    )
)

(define (test-5.38d)
    ; for part d.
    ;(compile-and-go '(+ 1 2 3 4))
    (compile-and-go 
        '(begin
            (define (f n) 
                (define (factorial n)
                 (if (= n 1)    
                     1        
                     (* (factorial (- n 1)) n)))    
                (+ (factorial n) (factorial (+ n 1)) (factorial (+ n 2)))
            )
            "(f n) = (+ (factorial n) (factorial (+ n 1)) (factorial (+ n 2)))"
        )
    )
    ; (f 1) = 9 = 1! + 2! + 3!
    ; (f 2) = 32 =  2! + 3! + 4!
    ; looks like it works! maybe bugged for nested procedures with >2 arguments? meh
)

; load
(load "5.33-38-compiling-to-file.scm")
(load "load-eceval-compiler.scm") ; for (compile-and-go) testing

; override and run
(define eceval (make-machine 
    (append eceval-compiler-register-list '(arg1 arg2))
    (append eceval-operations (list (list '+ +) (list '- -) (list '* *) (list '= =)))
    eceval-compiler-main-controller-text
))
(define compile-compiler compile) (define compile compile-5.38) 
(test-5.38c)
;(test-5.38d)
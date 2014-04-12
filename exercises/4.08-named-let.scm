; generalize the following low-level selectors from 4.6, and (let-parameters), (let-values) are reusable.

(define (let? expr) 
    (and 
        (tagged-list? expr 'let)
        ; meh, pointless if you MUST parse length in (let-bindings) and (let-body)...
        ;(or
        ;    (= (length expr) 3) ; (let (bindings) body)
        ;    (= (length expr) 4) ; (let var (bindings) body)
        ;    
        ;    ; TODO: further error-checking that (bindings) is a list of 2-element lists
        ;)
    )
)

(define (let-bindings expr) 
    (cond
        ((= (length expr 3))    ; (let (bindings) body)
            (cadr expr))
        ((= (length expr 4))    ; (let var (bindings) body)
            (caddr expr))
        (else
            (error "Invalid expression -- LET-BINDINGS" expr))
    )
)

(define (let-body expr) 
    (cond
        ; TODO: maybe these should be cddr and cdddr, in case it's a SEQUENCE and not a single statement
        ((= (length expr 3))
            (caddr expr))
        ((= (length expr 4))
            (cadddr expr))  
        (else
            (error "Invalid expression -- LET-BODY" expr))
    )
)



;  (let fib-iter ((a 1)
;                 (b 0)
;                 (count n))
;    (if (= count 0)
;        b
;        (fib-iter (+ a b) a (- count 1))))
; here's the best "back-translation i could come up with...test this sucker to make sure it works! 
    ; the purpose of the surrounding lambda is to avoid polluting the global namespace...

(define (fib n)
    (
      (lambda ()
        ; recursive let/let* is forbidden, so must use define...
        (define fib-iter
            (lambda (a b count)
                (if (= count 0)
                    b
                    (fib-iter (+ a b) a (- count 1))))        
        )
        
        (fib-iter 1 0 n)
        
        ; or, to be more "literal", to illustrate the fact that the body is being used 2 ways
            ; 1 to define a function
            ; the other as a target for substitution to obtain the initial value, "let-style"
        ;(let ((a 1) (b 0) (count n))
        ;    (if (= count 0)
        ;        b
        ;        (fib-iter (+ a b) a (- count 1)))
        ;)
        
      )
    ); and evaluate this anonymous block of code
)
    ;(let ((a 1) (b 0) (count n))
        




; "Modify let->combination of exercise 4.6 to also support named let. "
(define (let->combination expr)
    
    (let (  (parameters (let-parameters expr))
            (value-list (let-values expr))
            (body (let-body expr))                
            )
            
        (cond
            ; the old case.
            ((= (length expr 3))
                (list
                    (make-lambda parameters body)
                    value-list
                )
            )
            
            ; the new case. see fib.
            ((= (length expr 4))
            
                (let ((procedure-name (cadr expr)))
            
                    (list
                        (make-lambda '()
                            
                            ; i don't THINK i need a "begin" here, do i? maybe sequence->exp, based on sols?
                            (list 
                                'define 
                                procedure-name
                                (make-lambda parameters body)
                            )
                            
                            (append (list procedure-name) value-list)
                        )
                    ) ; execute code by triggering application of the enclosing parameter-less lambda
                )
            )
            
            
            ; defensive code
            (else
                (error "Invalid expression -- LET->COMBINATION" expr))
        )
    )
)

; sols use map and sequence->exp to keep their implementation short.
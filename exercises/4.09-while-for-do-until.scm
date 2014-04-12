; until is "not while", so i won't do that
; what's a do loop? guaranteed first iteration? meh

; desired usage
(for (i 0 10)
    (begin (newline) (display i)))  ; require loop body to be a single statement to make my job easier, haha
    
; backend
(
    (lambda ()
        (define (iter i high)
            (if (< i high)
                (begin
                    ; body from user
                    (begin
                        (newline)
                        (display i)
                    )
                    
                    ; TODO: variable, possibly negative stride
                    (iter (+ i 1) high)
                )
            )
        )
        (iter 0 10)
    )
)


; implement as a NEW SPECIAL FORM, i think...? no, the exercise wants DERIVED EXPRESSIONS
; here is an outline of the implementation in the metacircular evaluator, since sols only implemented while...

; in eval
    ((for? expr)
        (eval (for->iteration expr) env))
        
        
; and the driver. not real code...but a lazy, hopefully-readable approximation
(define (for->iteration expr)

    (let (  (loop-params (cadr expr))
            (loop-body (caddr expr))
            )
            
        ; basically, what you have to realize here is that you're GENERATING source code, not executing it
        (list
            (make-lambda '()
            
                ('define ('iter loop-index loop-high)
                    (make-if 
                        ('< loop-index loop-high)
                        (sequence->exp
                            (loop-body ('iter ('+ loop-index 1) loop-high))
                        )
                        'for-done
                    )                    
                )
            )
        )
    )
)



; desired usage
(while predicate body)

; example
(while (< i 10)             ; hmm, i must exist OUTSIDE this loop, then.
    (begin                  ; again require loop body to be a single expression, for PARSER simplicity
        (newline)
        (display i)
        (set! (i (+ i 1)))
    )
)

; proposed backend
(define (iter)
    (if (< i 10)
        (begin
            (begin
                (newline)
                (display i)
                (set! (i (+ i 1)))
            ) 
            (iter)
        )
        'done-while
    )
)
(iter)

; in eval
    ((while? expr)
        (eval (while->iteration expr) env))
        
; helpers
(define (while? expr) (tagged-list? expr 'while))
(define (while-predicate expr) (cadr expr))
(define (while-body expr) (caddr expr))
        
; driver 
(define (while->iteration expr)

    (let (  (predicate (while-predicate expr))
            (body (while-predicate expr))
            )
            
        (list
            (make-lambda '()
            
                (list 
                    'define
                    '(iter)
            
                    (make-if
                        predicate
                        
                        (sequence->exp
                            (list
                                body                ; and let body handle breaking out of the cycle of (iter)s
                                '(iter)
                            )
                        )
                        
                        'while-done
                    )
                )
                '(iter)
            )
        ) ; execute code by triggering application of the enclosing parameter-less lambda
    )
)



                
            
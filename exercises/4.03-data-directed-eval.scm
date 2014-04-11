; basic logical structure from exercise 2.73
(define (eval expr env)
    (cond
    
        ; irregulars that can't be handled in the table 
        ; i.e., anything that isn't a pair/list.
        ((self-evaluating? expr) expr)
        ((variable? expr) expr)
        
        ; data-directed table lookup
        ((pair? expr)
            (let ((evaluator (get 'eval (car expr))))   ; didn't use (operator expr): "You may use the car of a compound expression as the type of the expression"
                (if evaluator
                    (evaluator expr env)
                    
                    ; and as in Exercise 4.2a, an application by nature will not be found in the table
                    (apply 
                        (eval (operator expr) env)
                        (list-of-values (operands exp) env)
                    )
                )
            )
        )
              
        ; defensive case. is this even possible??
        (else (error "Unknown expression type -- EVAL" expr))
    )
)


; assume functions like (text-of-quotation) have been defined as in txt and ch3.scm
; assume (put) and (get) are available too
; i used a 2-d table like Exercise 2.73, which they mentioned. Allows 'eval and 'apply tables to coexist?
(define (install-evaluators)    
    (put 'eval 'quote (lambda (expr env) (text-of-quotation expr)))
    (put 'eval 'set! eval-assignment)
    (put 'eval 'define eval-definition)
    (put 'eval 'if eval-if)
    (put 'eval 'lambda 
        (lambda (expr env) (make-procedure (lambda-parameters expr) (lambda-body expr) env)))
    (put 'eval 'begin (lambda (expr env) (eval-sequence (begin-actions expr) env)))
    (put 'eval 'cond (lambda (expr env) (eval (cond->if expr) env)))
)
; this table can be extended with (install-evaluators2), etc.      



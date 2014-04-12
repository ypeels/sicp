; Exercise 4.6.  Let expressions are derived expressions, because
; 
; (let ((<var1> <exp1>) ... (<varn> <expn>))
;   <body>)
; 
; is equivalent to
; 
; ((lambda (<var1> ... <varn>)
;    <body>)
;  <exp1>
;  
;  <expn>)
; 
; Implement a syntactic transformation let->combination that reduces evaluating let expressions to 
; evaluating combinations of the type shown above, and add the appropriate clause to eval to handle let expressions. 

(define (let? expr) (tagged-list? expr 'let))
(define (let-bindings expr) (cadr expr))
(define (let-body expr) (caddr expr)) ; TODO: maybe this should be cddr, in case it's a SEQUENCE and not a single statement

(define (eval expr env)
  (cond 
    ; ...
    ((let? expr)
        (eval (let->combination expr) env))
    ; ...
  )
)

; doing this as a derived expression, so proceed as with cond.
; (make-lambda) will probably be useful.

; pulled out for reuse by (let*->nested-lets) in Exercise 4.7
(define (let-parameters expr)
    (let ((binding-list (let-bindings expr)))
        (if (null? binding-list)
            '()
            (cons 
                (caar binding-list) 
                (get-parameters (cdr binding-list))
            )
        )
    )
)

(define (let-values expr)
    (let ((binding-list (let-bindings expr)))
        (if (null? binding-list)
            '()
            (cons
                (cadar binding-list)
                (get-parameters (cdr binding-list))
            )
        )
    )
)


(define (let->combination expr)
    
    (let (  (parameters (let-parameters expr))
            (value-list (let-values expr))
            (body (let-body expr))                
            )

        (list
            (make-lambda parameters body)
            value-list
        )
    )
)

; oh is that it? when you break it down into digestible subroutines, it's really not that bad
; sol uses map, which is cleaner, but goes against Footnote 5.
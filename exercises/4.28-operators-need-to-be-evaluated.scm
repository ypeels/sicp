(load "4.27-31-ch4-leval.scm")

(define eval-leval-unmodified eval)
(define (eval expr env)
    (cond 
        ((or    (self-evaluating? expr)
                (variable? expr)
                (quoted? expr)
                (assignment? expr)
                (definition? expr)
                (if? expr)
                (lambda? expr)
                (begin? expr)
                (cond? expr)
                )
            (eval-leval-unmodified expr env)
        )
    
        ; ugh, you can only REALLY tell an application NEGATIVELY
        ((application? expr)
            (newline) (display (operator expr))
            (apply (eval (operator expr) env) (operands expr) env)  ; reverted from (actual-value (operator))
        )
        
        (else (eval-leval-unmodified expr env))
    )   
)

(display "\nExpressions that don't need (actual-value (operator exp) env)")
(display "\n- (+ 1 1)")
(display "\n- (define (foo x) (+ x 1)) (foo 2)")
(display "\n- (define (foo) (lambda (x y) (+ x y))) ok somehow...?")
(display "\n- (((lambda () (lambda (x y) (+ x y)))) 1 1)? ok somehow... because there's no args?")
(display "\n- (define (foo n) (if (< n 0) (lambda (x y) (- x y)) (lambda (x y) (+ x y)))) fine too...")
(display "\n- (define (bar x y) (* x y)) (define (foo n) (if (< n 0) bar +))? works too!?!?")
(display "\n- (define (foo n) (begin (display n) (+ n 1))) worked too")
(display "\n- (define (countdown n) (if (> n 0) (begin (newline) (display n) (countdown (- n 1)))))")
(display "\n- do you really need some stupid example involving state/assignment??")

; hmmmmmmm...
; "We still evaluate the operator, because apply needs the actual procedure to be applied in 
; order to dispatch on its type (primitive versus compound) and apply it."
; how about a case where (foo) determines whether an operator is primitive or compound??

(append! primitive-procedures (list (list '< <)))
(append! primitive-procedures (list (list '> >)))
(define the-global-environment (setup-environment))

(driver-loop)



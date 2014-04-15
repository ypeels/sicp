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
        
            ; probably a bad idea, cuz (actual-value) pre-forces, perforce, AND memoizes...
            ;(if (not (equal? (eval (operator expr) env) (actual-value (operator expr) env)))
            ;    (error "We have a winner!?" expr))
            ;
            ;(display "\nexpr: ") (display expr)
            ;(display "\n(operator expr): ") (user-print (operator expr))
            ;(display "\n(eval (operator expr) env): ") (user-print (eval (operator expr) env))
            ;(display "\n(actual-value (operator expr) env): ") (user-print (actual-value (operator expr) env))
            
            
            (apply (eval (operator expr) env) (operands expr) env)  ; reverted from (actual-value (operator))
            ;(eval-leval-unmodified expr env)
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
(display "\n- (define state true) (define (foo) (set! state (not state)) state) (define x (foo)) (define y (foo))- no WOULD BE a state/evaluation issue, NOT an operator issue")

; hmmmmmmm...
; "We still evaluate the operator, because apply needs the actual procedure to be applied in 
; order to dispatch on its type (primitive versus compound) and apply it."
; how about a case of doubly-nested functions??

; hmmmm so (actual-value) is (force-it)
; force-it is only important if there was a (list-of-delayed-args) somewhere?
    ; how about the (define w (id (id 10))) example from before, but without assignment?
    
    
; hmmmmmmmmm so (operator expr) would have to be something DIFFERENT if passed to (actual-value)
    ; that means it should contain some sort of delayed expression of its own?
        ; (delay-it) is ONLY called in (list-of-delayed-args)
        ; (list-of-delayed-args) is ONLY called in (apply)!? if it's passed a compound procedure...
        ; ok, so (operator expr) should itself be a procedure application. figured as much... 
        ; how about if you use (foo n) but use (foo (bar 1)) or something?
        
; LOOKS like it's gonna be some pathological corner case that this covers...?
    ; or are all the thunks getting evaluated thanks to the (actual-value) in (driver-loop)??
    
    
(display "\n\n\nGave up and peeked at solutions, hoping for hints, but the example was SHORT:")
(display "\n- (define (g x) (+ x 1)) (define (f h x) (h x)) (f g 10)")

(display "\n\nD'OH i was approaching from the wrong direction. When passed as an ARGUMENT, g will become a thunk.")
(display "\n(f g 10) evaluates to (#thunk(g) 10) - need to force the operator!")
(display "\nMy imperative-programming instincts were pretty useless here...")


(append! primitive-procedures (list (list '< <)))
(append! primitive-procedures (list (list '> >)))
(append! primitive-procedures (list (list 'not not)))
(append! primitive-procedures (list (list 'eq? eq?)))
(define the-global-environment (setup-environment))

(driver-loop)



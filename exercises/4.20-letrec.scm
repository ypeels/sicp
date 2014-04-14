; reuse some of Exercise 4.16's procedures? never really checked those...meh.

; NO NEED to modify (lookup-variable-value) - we're just adding a new special form (as a derived expression)

(define (eval expr env)
  (cond 
    ; ...
    ((letrec? expr)
        (eval (letrec->let expr) env))
    ; ...
  )
)

(define (letrec? expr)
    (tagged-list? 'letrec expr))
    
; reuse (let-bindings), (let-parameters), (let-values) from Exercise 4.6.
; this is actually much cleaner, because you don't have to scan the whole body and remove internal (define)'s!
(define (letrec->let expr)

    ; built on (wrap-with-let) technology from exercise 4.16
    (let (  (vars (let-parameters (let-bindings expr)))
            (vals (let-values (let-bindings expr))))
        (let (  (unassigned-bindings (map (lambda (var) (list var '*unassigned*)) vars))
                (assignments (map (lambda (var val) (list 'set! var val)) vars vals)))
                
            (make-let
                unassigned-bindings
                (append
                    assignments
                    (let-body expr)
                )
            )
        )
    )
)
                
                
                
; and then some frame analysis, just for louis
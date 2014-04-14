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
    
(define (f x)
  (let     ((even2?                      ; renamed from even? and odd?, which are built-in
            (lambda (n)
              (if (= n 0)
                  true
                  (odd2? (- n 1)))))
           (odd2?
            (lambda (n)
              (if (= n 0)
                  false
                  (even2? (- n 1))))))
                  
    ;<rest of body of f>
    (even2? x)))
    
;(display (f 2)) ; "Unbound variable: odd2?" works fine for letrec instead of let.


; Version letrec
; ==============
; Frame F: evaluate (f x)
; x: <value of x>
; 
; Evaluate the letrec in new frame LR, child of F.
; The specific process and even frame structure is unclear; for simplicity, use the implementation above, based on
; Exercise 4.16
; 
; Frame LR - child of F
; even2?: (lambda (n) ... (odd2? ... )), and this lambda lives HERE.
; odd2? : (lambda (n) ... (even2?... )), and this lambda lives HERE.
; <body> is evaluated in frame LR.
; 
; So this is what the description of letrec means by 
; "the expressions <exp_k> that provide the initial values for the variables <var_k> 
; are evaluated in an environment that includes all the letrec bindings"
; 
; 
; Version let
; ===========
; Frame F: evaluate (f x)
; x: <value of x>
; 
; Evaluate the let in new frame L, child of F.
; 
; Frame L - child of F
; even2?: (lambda (n) ... (odd2? ... )), but this lambda lives in F! (from whence it is passed in as an argument)
; odd2? : (lambda (n) ... (even2?... )), but this lambda lives in F!
; 
; So there is no syntactic problem defining and parsing (f) this way, but when it comes EVALUATION TIME,
; the lambdas for (even2?) and (odd2?) visible to <body> CANNOT RECURSE!
; They live in F, so they can't see the bindings in L!
; 
; A piece of tricky Scheme that doesn't happen with internal (define)! Sheesh...
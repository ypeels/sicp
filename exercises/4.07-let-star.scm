; omfg i didn't know about this
; i could have USED this, in a LOT of earlier exercises


    
;   (let* ( (x 3)
;           (y (+ x 2))
;           )
;       (+ x y)
;   )
;   
;   
;   ; order of evaluation
;   (
;       (lambda (x)
;           ((lambda (y) (+ x y)) (+ x 2))  ; this sets y = x+2, with x still undefined
;       )
;       3                                   ; this sets x = 3
;   )
;   
;   
;   ; the other way doesn't work, right?
;   (
;       (lambda (y) 
;           ((lambda (x) (+ x y)) 3)    ; well, this inner layer is fine...
;       )
;       ???                             ; but the dummy variable x has been eliminated!
;   )
;   
;   ; similarly
;   (let* ( (x 3)
;           (y (+ x 2))
;           (z (+ x y 5))
;           )
;   
;   (        
;       (lambda (x)        
;           (lambda (y)
;               ((lambda (z) (* x z)) (+ x y 5))
;           )
;           (+ x 2)
;       )
;       3
;   )

; but wait, that's not what the question is asking...

;   (let* ((x 3) (y (+ x 2)) (z (+ x y 5)))
;       (* x z)
;   )
;   
;   (let ((x 3))
;       (let ((y (+ x 2)))
;           (let ((z (+ x y 5)))
;               (* x z)
;           )
;       )
;   )

; so it looks emininently doable by just generating a nested list with 'let, and having that feed back into eval.
    
(define (eval expr env)
  (cond 
    ; ...
    ((let*? expr)
        (eval (let*->nested-lets expr) env))
    ; ...
  )
)

; use (let-parameters), (let-values), (let-body) from exercise 4.6; 
    ; not repeated here to keep things DRY
    ; not LOADed here to avoid overwriting my fake eval code
(define (let*->nested-lets expr)

    (define (iter parameters value-list body)
        (if (null? parameters)  ; TODO: error-check that value-list and parameters have the same length
            body
            
            ; construct the nested if expression
            (list 
                'let
                (list (list (car parameters) (car value-list)))
                (iter (cdr parameters) (cdr value-list) body)
            )
        )
    )
            

    (let (  (parameters (let-parameters (let-bindings expr)))
            (value-list (let-values (let-bindings expr)))
            (body (let-body expr))
            )
            
            
        (iter parameters value-list body)
    )
)

; sols are quite different, but i don't really see how mine could be wrong, if my (let->combination) was ok
    ; but apparently we both agree that we NEED NOT explicitly expand let* in terms of non-derived expressions.
    ; in fact, this seems LESS AWKWARD than trying to figure out how to chain lambdas correctly.
    ; the price is decreased performance? the meta-interpreter still needs to parse the nested let...
    


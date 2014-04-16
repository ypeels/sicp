(load "4.32-34-lazy-cons-in-leval.scm")

(define eval-leval eval)    ; "save state"
(define (eval-4.33 expr env)

    (define (quotation->list symbol-list)    
        (if (null? symbol-list)
            '()            
            (list 'cons 
                (list 'quote (car symbol-list)) 
                (quotation->list (cdr symbol-list))
            )
        )
    )                

    (if (quoted? expr)
        (if (list? (text-of-quotation expr))
            
            ; should i reconstruct the list here?? probably...
            ; WATCH OUT - you don't return the result, you EVALUATE it
            (eval-leval (quotation->list (text-of-quotation expr)) env)                          
            
            ; behavior unchanged for quotes that aren't lists
            (eval-leval expr env) ;(text-of-quotation expr). same thing, but intention is less clear.
        )
                    
        ; behavior unchanged for non-quotes
        (eval-leval expr env)
    )
)
(define eval eval-4.33)


(install-lazy-cons)
(leval
    '(car (cons 1 (cons 2 (cons 3 '()))))
    '(car (cons 'a (cons 'b (cons 'c '()))))
    '(car '(1 2 3))
    '(car '(a b c)) ; without eval-4.33: Unknown procedure type -- APPLY (a b c)
)
(driver-loop)
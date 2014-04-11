; first as a special form (ignoring exercise 3.3)
(define (eval expr env)
    (cond
        ; ... 
        
        ((and? expr) (eval-and expr env))
        ((or? expr) (eval-or expr env))
        ; ...
    )
)

(define (true? x) (not (false? x))) ; (true?) is mentioned in the book, but (false?) is what's built-in...

(define (and-or-conditions exps) (cdr exps))
(define (no-conditions? conds) (null? conds))
(define (last-condition? conds) (and (pair? conds) (null? (cdr conds))))
(define (first-condition conds) (car conds))
(define (rest-conditions conds) (cdr conds))

; sigh, there's a lot of common logic, but enough details are different that i'm not sure they can be combined...
; implement separately, and see if anything can be refactored
(define (eval-and exps env)
    ;(eval-and-or (and-or-conditions exps) false? and-abort-value env))
    
    (define (iter conds)
        (let ((current-value (eval (first-condition conds) env)))
    
    
            ;(cond
            ;    
            ;    ; If all the expressions evaluate to true values, the value of the last expression is returned
            ;    ((last-condition? conds)
            ;        (if (eq? #f current-value)
            ;            #f
            ;            current-value
            ;        )
            ;    )
            ;    
            ;    (else
            ;        (if (eq? #f current-value)
            ;            #f
            ;            (iter (rest-conditions conds))
            ;        )
            ;    )
            ;)
            
            (cond                
                ((false? current-value)
                    #f)
                ((last-condition? conds)
                    current-value)
                (else                       ; current-value is true AND it's not the last condition
                    (iter (rest-conditions conds)))
            )
        )
    )
                
    
    (let ((conds (and-or-conditions exps)))
        (if (no-conditions? conds)
        
            ; If there are no expressions then true is returned.
            #t
            
            (iter conds)
        )            
    )
)

; so you can see where you would refactor - in particular you'd need (abort-value current-value).
; but i really don't feel like it, especially since i don't have any regression tests i can run...
(define (eval-or exps env)
    
    (define (iter conds)
        (let ((current-value (eval (first-condition conds) env)))
        
            (cond
            
                ; If any expression evaluates to a true value, that value is returned
                ((true? current-value)
                    current-value)
                ((last-condition? conds)    ; current value is false AND it's the last condition
                    #f)
                (else                       ; current value is false and it's NOT the last condition
                    (iter (rest-conditions conds)))
            )
        )
    )
    
    
    (let ((conds (and-or-conditions exps)))
        (if (no-conditions? conds)
            
            ; If all expressions evaluate to false, or if there are no expressions, then false is returned. 
            #f
            
            (iter conds)
        )
    )
)
            
    

;(define (eval-and-or conds abort? abort-value env)
;
;    (if (no-conditions? conds)
;    
;        ; and: If there are no expressions then true is returned.
;        ; or: If all expressions evaluate to false, or if there are no expressions, then false is returned
;        (abort-value '())
;        
;        (let ((current-value (eval (first-condition conds) env)))
;        
;            ; it ain't cheating! eval-sequences uses cond, and so shall i. 
;            (cond 
;                
;                ((last-condition? conds)
;                    (if current-value
;                        current-value
;        
;        )
;        
;    )
;        
;
;
;        ((
;            
;        ((last-condition? conds)
;        
;            (let ((last-value 
;            
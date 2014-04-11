; shared helpers / data representations
(define (true? x) (not (false? x))) ; (true?) is mentioned in the book, but (false?) is what's built-in...

(define (and? expr) (tagged-list? expr 'and))
(define (or? expr) (tagged-list? expr 'or))
(define (and-or-conditions exps) (cdr exps))
(define (no-conditions? conds) (null? conds))
(define (last-condition? conds) (and (pair? conds) (null? (cdr conds))))
(define (first-condition conds) (car conds))
(define (rest-conditions conds) (cdr conds))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; first as a special form (ignoring exercise 3.3)
(define (eval expr env)
    (cond
        ; ... 
        
        ((and? expr) (eval-and expr env))
        ((or? expr) (eval-or expr env))
        ; ...
    )
)



; sigh, there's a lot of common logic, but enough details are different that i'm not sure they can be combined...
; implement separately, and see if anything can be refactored
(define (eval-and exps env)
    
    (define (iter conds)
        (let ((current-value (eval (first-condition conds) env)))
            
            ; it ain't cheating! eval-sequences uses cond, and so shall i. 
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
            
       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       
; but it is really more in the spirit of this section (minimalism) to implement as a derived expression
; it's pretty instructive to work through this both ways
; but this chapter is getting to the point where WRITING this code isn't really that fulfilling (can't run it!) should i (gasp) start skipping exercises??

(define (eval expr env)
    (cond
        ; ... 
        
        ((and? expr) (eval (and->if expr) env))
        ((or? expr) (eval (or->if expr) env))
        ; ...
    )
)

(define (and->if exps) ; no env! (eval) will take care of that.
    (define (expand conds)  ; cf. (expand-clauses)
        (if (null? conds)
            #t   ; sols: 'true                  ; default value == surviving value! couldn't find a #f, so must be #t!
            (make-if                            ; return an if statement in the TARGET LANGUAGE
                (first-condition conds)
                (expand (rest-conditions conds))
                #f;(first-condition conds)      ; sols: 'false         
            )
        )
    )
    
    ;(let ((conds (and-or-conditions exps)))
    ;    (if (no-conditions? conds)
    ;        #t
    ;        (iter conds)
    ;    )
    ;)
    (expand (and-or-conditions exps))
)

(define (or->if exps)
    (define (expand conds)
        (if (null? conds)
            #f   ; sols: 'false                 ; default value == surviving value! couldn't find a #t, so must be #f!
            (make-if
                (first-condition conds)
                (first-condition conds)         ; again, a combined and/or would require (abort-value current-value)
                (expand (rest-conditions conds)); also, it'd have to take the swapped order here into account. meh.
            )
        )    
    )
    (expand (and-or-conditions exps))
)

; sols BOTH miss the fact that if and/or evaluates to true, you return the EXPRESSION, not #t
    
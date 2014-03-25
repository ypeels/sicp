; you've been using these all along (+, -, *, /)
; but here is how you actually IMPLEMENT them.
; note that *args (in Python terms) is a LIST, so this had to be postponed till here.
    ; but still, you don't have to relegate it to a friggin exercise...
    
(define (g2 . w) (newline) (display w))     
(g2 1 2 3)  ; (1 2 3)
    
; (define g (lambda ( . w) (display w))) ; no, lambda taking 0+ arguments has WEIRDLY INCONSISTENT SYNTAX
(define g (lambda w (newline) (display w)))   ; if you added parens, it'd be ONE mandatory argument, and no variable argument list
(g 1 2 3)   ; (1 2 3)


(define (have-same-parity? x y)
    (= (remainder x 2) (remainder y 2)))  ; could use an enclosing let, but that'd increase nesting


; the only point of variable arguments in this problem: (same-parity) will take MANY INTEGERS as input, NOT a list
(define (same-parity decider . args)


        
    (define (iter input)
    
        ; ripped off from (map) in the following section...
        ; using this algorithm, can't use local variables...
        (cond 
            ((null? input) ())                  ; termination: reached end of list
            ((have-same-parity? decider (car input))
                (cons (car input) (iter (cdr input))))
            (else                               
                (iter (cdr input)))))           ; skip this item
                
    (cons decider (iter args)))
    
    
    
; my C++ instincts tell me this would be clearer with some local variables...
(define (same-parity-with-let decider . args)      

    (define (iter input)
    
        (let (  (current (car input))           ; sigh... the price of clear variable names? MURKIER LOGIC (less DRY too!?)
                (remaining (cdr input)))
                
            
            (if (null? remaining)               
                
                ; last iteration: have to be careful not to call iter on a null list, because cdr would be undefined    
                (if (have-same-parity? decider current)
                    (cons current ())           ; i mean, why can't i set a "next" local variable to (), 
                    ()                          ; and then merge it in with shared code OUTSIDE the (if)s?? stupid scheme
                )

                ; normal iteration (remaining is not null)
                (if (have-same-parity? decider current)
                    (cons current (iter remaining))
                    (iter remaining)
                )
            )
        )
    )
    
    ;(cons decider (iter args))         ; unpatched
    
    (if (null? args)                    ; patched to handle corner case    
        (list decider)
        (cons decider (iter args))
    )
)
                
                
        

            
        ; have to be careful 

    
(define (test-2.20)

    (define (test method)
        (newline)
        (newline) (display (method 1 2 3 4 5 6 7))     ; (1 3 5 7)
        (newline) (display (method 2 3 4 5 6 7))       ; (2 4 6)
        (newline) (display (method 1))                 ; should fail for unpatched same-parity-with-let
        (newline) (display (method 1 2))               ; does not fail for unpatched same-parity-with-let!
        (newline) (display (method ()))                ; surprisingly does not fail for patched!
    )
    (test same-parity)
    (test same-parity-with-let)
)

(test-2.20)
                
            
        


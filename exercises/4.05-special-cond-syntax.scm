; if nothing else, this chapter REALLY teaches you about Scheme... 
; great, just what I've always wanted...


; i think all you have to do is to change the following
(define (expand-clauses clauses)
    ; ...
            (make-if (cond-predicate first)
                     (cond-value first);(sequence->exp (cond-actions first))
                     ; ...
)

(define (cond-value clause)

    (let (  (predicate (cond-predicate clause)) ; TODO: error-checking
            (actions (cond-actions clause))
            )
    
        (if (and (pair? actions) (eq? '=> (car actions)))
        
            ; the new special case
            (let ((operator (cadr actions)))
                (list operator predicate))      ; sols: (list operator predicate) - i had cons...
             
            ; the original case
            (sequence->exp actions)
        )
    )
)
            
                     




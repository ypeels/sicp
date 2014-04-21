;  (Hint: Use append-to-form.)
; from Section 4.4.1. apparently i haven't used this in an exercise before
(define (install-append-to-form)
    (query '(assert! (rule (append-to-form () ?y ?y)) ))
    (query '(assert! (rule (append-to-form (?u . ?v) ?y (?u . ?z)) (append-to-form ?v ?y ?z)) ))
)

(define (install-reverse)

    

    ;from Exercise 2.18
    ;(if (null? (cdr L))
    ;    (list (car L))
    ;    (append (reverse (cdr L)) (list (car L))))
    
    ; this rule is SOLID.
    (query '(assert! (rule (reverse (?x) (?x)))))
    
    ; this works from left to right, but gives an infinite loop from right to left...
    (query '(assert! (rule (reverse (?x . ?y) ?z) (and (reverse ?y ?yr) (append-to-form ?yr (?x) ?z)))))
    ; why?? e.g. (reverse ?r (1 2))
         ; ?z = (1 2)
         ; ?r = (?x . ?y)
         ; (reverse ?y ?yr). aha, this is no longer a definition, but a louis-reasoner-style infinite loop.
    
    ; what if i add a symmetric rule in the other direction??
    ; CAREFUL! need to swap order of ?yr and ?y in nested (reverse)
    ;(query '(assert! (rule (reverse ?z (?x . ?y)) (and (reverse ?yr ?y) (append-to-form ?yr (?x) ?z)))))
    ; this enables right to left, but infinite loop from left to right
    ; more importantly though, cannot coexist with the left-to-right
    
    ; probably need to symmetrize the arguments...?
    
    ; MEH, sols stop at a unidirectional implementation
    
    ;(query '(assert! (rule (reverse (?u . ?v) (?x . ?y)) ; hmmm car/cdr not helpful...?
    ;    (and
    ;        (reverse ?v ?x)
    ;       
    ;        
    ;        ; doesn't get list structure correct even left to right
    ;        ; doesn't work from right to left either
    ;        ; and most tellingly, doesn't use append-to-form
    ;        ;(same ?u ?y)
    ;       
    ;       
    ;        ;(append-to-form (?x) ?u (?x . ?y))
    ;        
    ;        
    ;    )
    ;)))
            


)

(define (test-4.68)
    (load "ch4-query.scm")
    (init-query)
    (install-append-to-form)
    (install-reverse)
    
    ; this should work first... (syntax check)
    ;(query '(reverse ?x (1)))
    
    ; this should work second... (list-structure check)
    ;(query '(reverse (1 2) ?x))
    
    ; and the reverse reverse...
    ;(query '(reverse ?x (1 2)))
    
    ; from problem statement
    (query '(reverse (1 2 3) ?x))
    ; (3 2 1)
    
    ;(query '(reverse ?x (1 2 3)))
    ; infinite loop!
    ; like Exercise 4.62, answer "no", my rules can't answer both directions.
    ; this exercise could just as easily have come in the previous batch
    ; is it just so we can appreciate the infinite loop a little more?
    
    (query-driver-loop)
)
;(test-4.68)

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
    
    (query '(assert! (rule (reverse (?x) (?x)))))
    (query '(assert! (rule (reverse (?x . ?y) ?z) (and (reverse ?y ?yr) (append-to-form ?yr (?x) ?z)))))


)

(define (test-4.68)
    (load "ch4-query.scm")
    (init-query)
    (install-append-to-form)
    (install-reverse)
    
    ; this should work first...
    (query '(reverse (1) ?x))
    
    ; from problem statement
    (query '(reverse (1 2 3) ?x))
    ; (3 2 1)
    
    (query '(reverse ?x (1 2 3)))
    ; infinite loop!
    
    (query-driver-loop)
)
(test-4.68)
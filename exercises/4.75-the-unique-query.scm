(define (install-unique)

    ; from problem statement
    (put 'unique 'qeval uniquely-asserted)
)

; function signature must match other special form handlers', since this is a GENERIC operation
; (unique <query>)
; (qeval) sees 'unique and dispatches here
; query-pattern = <query>
;(define (uniquely-asserted query-pattern frame-stream))


(define (test-4.75)
    (load "ch4-query.scm")  
    (install-unique)
    
    (query '(unique (job ?x (computer wizard))))
    ; correct answer: (unique (job (Bitdiddle Ben) (computer wizard)))
    
    (query '(unique (job ?x (computer programmer))))
    ; correct answer: the empty stream, since there is more than one computer programmer
    
    (query '(and (job ?x ?j) (unique (job ?anyone ?j))))
    ; should list all the jobs that are filled by only one person, and the people who fill them.
    
    
    ; a query that lists all people who supervise precisely one person
    (query '(and (job ?who ?what) (unique (supervisor ?slave ?who)))) ; will this work?? is there no simpler alternative?
)
;(test-4.75)
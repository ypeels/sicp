(define (install-outranked-by-4.64)

    ; modified from problem statement
    (query '(assert!
        (rule (outranked-by-4.64 ?staff-person ?boss)
              (or (supervisor ?staff-person ?boss)
                  (and (outranked-by-4.64 ?middle-manager ?boss)        ; louis switched the order of the (and)
                       (supervisor ?staff-person ?middle-manager))))
    ))
    
    ; i think the problem here is that recursion occurs before ?middle-manager was defined/queried
        ; this will send the system into an infinite search for ?middle-manager
    
)


(define (test-4.64)

    (load "ch4-query.scm")
    (init-query)
    (install-outranked-by-4.64)
    
    (query '(outranked-by (Bitdiddle Ben) ?who))
    ; (outranked-by (bitdiddle ben) (warbucks oliver))
    
    (display "\nAnd now to start an infinite loop:")
    (query '(outranked-by-4.64 (Bitdiddle Ben) ?who))
    (display "\nnever gets here")
    
    (query-driver-loop)
)
(test-4.64)

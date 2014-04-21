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
    
    ; sols: use unification - unify query with rule conclusion
    ; (query '(outranked-by-4.64 (Bitdiddle Ben) ?who))
    ; ?staff-person = (bitdiddle ben)
    ; ?boss = ?who
        ; one possibility from the (or) is (supervisor (bitdiddle ben) ?boss)
            ; only ?boss = (warbucks oliver) satisfies that.
        ; the other possibility is the (and)
            ; original: 
                ; remember, the (and) is evaluated IN SERIES
                ; (supervisor (bitdiddle ben) ?middle-manager)
                    ; ?middle-manager = (warbucks oliver)
                ; (outranked-by (warbucks oliver) ?boss)
                    ; in the recursion, (supervisor (warbucks oliver) ?boss) will have 0 query results
                    ; there will be 0 frames left, and the recursion terminates
            ; 4.64 (louis)
                ; (outranked-by-4.64 ?middle-manager ?boss). uh oh, BOTH of these are undefined
                ; recursion
                    ; (supervisor ?middle-manager ?boss): returns a finite list of all supervisors. ok so far...
                    ; (and)
                        ; the PROBLEM is that (outranked-by-4.64 ?middle-manager ?boss) is triggered AGAIN,
                            ; and with both variables still undefined!!
                
    
    
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
;(test-4.64)

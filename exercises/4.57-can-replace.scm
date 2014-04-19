(define (install-can-replace)

    ; hmm, batch mode input isn't working for RULES?
    ; apparently rules AREN'T entered interactively, but rather as part of the database!?!?
    (query
        '(rule 
            (can-replace ?person-1 ?person-2)
            ;(and
            ;        
            ;    (or 
            ;        ; person 1 does the same job as person 2
            ;        (and (job ?person-2 ?job-2) (job (?person-1 ?job-2)))
            ;        
            ;        ; someone who does person 1's job can also do person 2's job
            ;        (and (job ?person-1 ?job-1) (job ?person-2 ?job-2) (can-do-job ?job-1 ?job-2))
            ;    )
            ;    
            ;    (not (same ?person-1 ?person-2))
            ;)
            
            
            (and 
                ; need to have a VALID QUERY for a person to exist, right?
                (job ?person-1 ?job-1)
                (job ?person-2 ?job-1)
                
                ;(not (same ?person1 ?person2))
            )
        )
    ) ; ehhh what's wrong now??
)
 

(define (test-4.57)
 
    (load "ch4-query.scm")
    (init-query)    
    (install-can-replace)
    
    
    ;(query '(can-replace (Warbucks Oliver) (Aull DeWitt)))
    (query '(can-replace (Warbucks Oliver) ?who))

    
    (query-driver-loop)
)
(test-4.57)
(define (install-can-replace)

    ; apparently rules AREN'T entered interactively, but rather must install as part of the database!?!?
    ;(query
    ;(install-rule
    (query 
        '(assert! ; ohhhhhh (from sols). why do they give exercises before showing how to DO them??
            (rule 
                (can-replace ?person-1 ?person-2)
                (and
                
                    ; define variables - i think. otherwise, what is the context for ?job-1 and ?job-2?
                    ; could use the much less legible "context-free" versions below, and forego this "declaration", but...
                    ; sols do it this way too!
                    (job ?person-1 ?job-1) (job ?person-2 ?job-2)
                        
                    (or 
                        ; person 1 does the same job as person 2
                        ;(and (job ?person-2 ?job-2) (job (?person-1 ?job-2))) ; alternative "context-free"
                        (same ?job-1 ?job-2) ; using it in spite of Footnote 65...
                        
                        ; someone who does person 1's job can also do person 2's job
                        ;(and (job ?person-1 ?job-1) (job ?person-2 ?job-2) (can-do-job ?job-1 ?job-2))
                        (can-do-job ?job-1 ?job-2)
                    )
                    
                    (not (same ?person-1 ?person-2))
                )
            )
        )
    ) 
)
 

(define (test-4.57)
 
    (load "ch4-query.scm")
    (init-query)    
    (install-can-replace)
    
    
    
    ; remember, it's p1 CAN REPLACE p2, NOT the other way around
    ;(query '(can-replace (Aull DeWitt) (Warbucks Oliver)))
    (query '(can-replace ?who (Warbucks Oliver))) ; Aull DeWitt
    
    
    (display "\n4.57a: all people who can replace Cy D. Fect:\n")
    (query '(can-replace ?who (Fect Cy D)))
    ; Bitdiddle Ben
    ; Hacker Alyssa P
    
    (display "\n4.57b: all people who can replace someone who is being paid more than they are\n")
    (query 
        '(and
            ; declaration
            (salary ?person-1 ?salary-1) (salary ?person-2 ?salary-2)
            
            ; requirement 1: P1 can replace P2
            (can-replace ?person-1 ?person-2)
            
            ; requirement 2: P2 is being paid more than P1
            (lisp-value > ?salary-2 ?salary-1)
        )
    )
    ; Aull DeWitt $25,000 can replace Warbucks Oliver $150,000
    ; Fect Cy D $35000 can replace Hacker Alyssa P $40000
            
            
            

    
    (query-driver-loop)
)
(test-4.57)
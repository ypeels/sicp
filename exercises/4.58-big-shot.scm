(define (install-big-shot)

    (install-rule   
    ;(query 
        ;'(assert!
            '(rule 
                (big-shot ?person)                                
                (and
                    ; declaration
                    (job ?person (?division . ?job-type))
                    
                    (or 
                    
                        ; does not have a supervisor who works in the [same] division
                        (and
                            (supervisor ?person ?master) ; "sub-declaration"
                            (not (job ?master (?division . ?master-job-type)))
                        )
                        
                        ; my addition: does not have a supervisor
                        (not (supervisor ?person ?master))
                    )
                )   
            )
        ;)
    )
)


(define (test-4.58)

    (load "ch4-query.scm")
    (install-big-shot)
    (init-query)    
    
    (query '(big-shot ?who))
    ; Scrooge Eben
    ; Bitdiddle Ben
    
    ; with my "no supervisor" addendum 
    ; Warbucks Oliver
    
    (query-driver-loop)
)
(test-4.58)
(define (install-big-shot)
    (query
        '(assert!
            (rule 
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
                        
                        ; my addition: does not have a supervisor at all (implies no supervisor in division; sols have this too)
                        (not (supervisor ?person ?master))
                    )
                )   
            )
        )
    )
    
    'ok
)


(define (test-4.58)

    (load "ch4-query.scm")
    (init-query)    
    (install-big-shot)
    
    (query '(big-shot ?who))
    ; (big-shot (Scrooge Eben))
    ; (big-shot (Bitdiddle Ben))
    
    ; with my "no supervisor" addendum 
    ; (big-shot (Warbucks Oliver))
    
    (query-driver-loop)
)
;(test-4.58)
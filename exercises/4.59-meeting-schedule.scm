(define (install-meetings)

    (query '(assert! (meeting accounting (Monday 9am))       ))
    (query '(assert! (meeting administration (Monday 10am))  ))
    (query '(assert! (meeting computer (Wednesday 3pm))      ))
    (query '(assert! (meeting administration (Friday 1pm))   ))
    (query '(assert! (meeting whole-company (Wednesday 4pm)) ))
    
    
    ; 4.59b: rule for a person's meetings
    (query '(assert!
        (rule (meeting-time ?person ?day-and-time)
            (and
                ; declaration
                (job ?person (?division . ?job-type))
                
                (or
                    ; all whole-company meetings 
                    (meeting whole-company ?day-and-time)
                    
                    ; all meetings of that person's division
                    (meeting ?division ?day-and-time)
                )
            )
        )
    ))
                
            
)



(define (test-4.59)

    (load "ch4-query.scm")
    (init-query)
    (install-meetings)

    (display "\n4.59a. all meetings that occur on Friday\n")
    (query '(meeting ?division (Friday ?time)))
    ; (meeting-time administration (friday 1pm))
    
    
    (display "\n4.59c. testing (meeting-time)\n")
    (query '(meeting-time (Hacker Alyssa P) (Wednesday ?time)))
    ; (meeting-time (hacker alyssa p) (wednesday 4pm))
    ; (meeting-time (hacker alyssa p) (wednesday 4pm))
    ; hmm.. doesn't say what meeting is when... oh well, that's alyssa's problem
    
    (query-driver-loop)
)
;(test-4.59)
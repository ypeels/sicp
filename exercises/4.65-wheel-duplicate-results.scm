(define (test-4.65)

    (load "ch4-query.scm")
    (init-query)
    
    (query '(wheel ?who))
    ; (wheel (warbucks oliver))
    ; (wheel (warbucks oliver))
    ; (wheel (bitdiddle ben))
    ; (wheel (warbucks oliver))
    ; (wheel (warbucks oliver))
    ; warbucks oliver satisfies the wheel criterion in MULTIPLE WAYS.
        ; the definition of wheel is that a person supervises a supervisor.
        ; scrooge (1 underling)
        ; ben (3 underlings - alyssa, cy, lem; louis escapes this because he answers to alyssa)
    
    (query-driver-loop)
)
;(test-4.65)
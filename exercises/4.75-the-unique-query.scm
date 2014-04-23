(define (install-unique)

    ; from problem statement
    (put 'unique 'qeval uniquely-asserted)
)

; function signature must match other special form handlers', since this is a GENERIC operation
; (unique <query>)
; (qeval) sees 'unique and dispatches here
; query-pattern = <query>
(define (unique-query exps) (car exps)) ; cf. (negated-query) in (negate)

(define (uniquely-asserted-V1 operands frame-stream)

    
    ; ugh, read from inside out... the alternative (let)s are either ugly or illegible
            
    ; The remaining streams should be passed back to be accumulated into one big stream that is the result of the unique query.
    (stream-flatmap         ; using this as a lazy (accumulate)
        (lambda (str) str)
    ;(stream-accumulate     ; meh, couldn't get this to work
    ;    (lambda (x y) (cons-stream x y));stream-cons DAMN YOU SCHEME
    ;    the-empty-stream
        
        ; Any stream that does not have exactly one item in it should be eliminated.
        ; [not QUITE a solution to 4.66]
        (stream-filter
            (lambda (str) (= 1 (stream-length str)))
        
            ; use qeval to find the stream of all extensions to the frame that satisfy the given query
            ; can't call (qeval query-pattern frame-stream) directly, since it uses FLATMAP.
            (stream-map
                (lambda (frame) (qeval (unique-query operands) (singleton-stream frame)))
                frame-stream
            )
        )
    )
)
    
    
        
; "This is similar to the implementation of the not special form."
; i can probably refactor into something cleaner, based on the logic in (negate)
    ; yeah, this is the same logic that the solutions use.
(define (uniquely-asserted-v2 operands frame-stream)
    (define (is-singleton? stream)
        (= 1 (stream-length stream)))   ; TODO: make this infinite-stream-friendly (not null and stream-cdr is null)
    (stream-flatmap
        (lambda (frame)        
            (let ((query-result (qeval (unique-query operands) (singleton-stream frame))))
                (if (is-singleton? query-result)
                    query-result
                    the-empty-stream
                )
            )
        )
        frame-stream
    )
)
; yes, this seems to work fine too.


;(define uniquely-asserted uniquely-asserted-v1)
(define uniquely-asserted uniquely-asserted-v2)
    


(define (test-4.75)
    (load "ch4-query.scm")  
    (init-query)
    (install-unique)
    
    (query '(unique (job ?x (computer wizard))))
    ; correct answer: (unique (job (Bitdiddle Ben) (computer wizard)))
    
    (query '(unique (job ?x (computer programmer))))
    ; correct answer: the empty stream, since there is more than one computer programmer
    
    (query '(and (job ?x ?j) (unique (job ?anyone ?j))))
    ; should list all the jobs that are filled by only one person, and the people who fill them.
    ; DeWitt Aull, administration secretary
    ; Robert Cratchet, accounting scrivener
    ; Eben Scrooge, accounting chief accountant
    ; Oliver Warbucks, administration big wheel
    ; Louis Reasoner, computer progrmamer trainee
    ; Lem E Tweakit, computer technician
    ; Ben Bitdiddle, computer wizard
    
    ; a query that lists all people who supervise precisely one person
    (query '(and (job ?who ?what) (unique (supervisor ?slave ?who)))) ; will this work?? is there no simpler alternative?
    ; scrooge supervises cratchet                                           ; sols use (and (supervisor) (unique (supervisor))), which i find unnecessarily confusing...    
    ; hacker supervises reasoner
    ; and that's IT! warbucks supervises EVERYBODY.
    
    (query-driver-loop)
)
;(test-4.75)
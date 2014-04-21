(define in-history-4.65?!
    (let ((history '()))
        (lambda (name)
            ;(display "\nin-history?! ") (display name)
            (if (member name history)
                #f
                (begin
                    (set! history (cons name history))
                    ;(append! history (list name))
                    #t
                )
            )        
        )        
    )
)

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
     
    ; works now after i fixed my stupid syntax error. still don't know scheme that well...
    (query '(and (wheel ?who) (lisp-value in-history-4.65?! ?who)))
    
    ; also, you'd need a way to clear the history before every query.
    ; how about a (clear-history) function that always returns false? then a query could call that with lisp-value
        ; of course, the history function would have to be shared between (clear) and (in)
        ; either by dispatching or via global variable. whatever...
    ;(query '(assert! (rule (wheel?! ?who) (and (wheel ?who) (lisp-value in-history-4.65?! ?who)))))
    ;(query '(wheel?! ?who))
    
    (query-driver-loop)
)
(test-4.65)
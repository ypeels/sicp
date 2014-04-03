(define (make-monitored f)

    (let ((num-calls 0))
        (define (dispatch x)
            (cond 
                ((eq? x 'how-many-calls?)
                    num-calls)
                ((eq? x 'reset-count)
                    (set! num-calls 0)
                    "Counter reset to 0."
                )
                (else
                    (begin 
                        (set! num-calls (+ num-calls 1))
                        (f x) ; NOT just f!  this binds a FUNCTION into the "lambda named dispatch"
                    )
                )
            )
        )
        dispatch    ; hey lookit, this has to be returned WITHIN dispatch's scope
    )
    
)


(define (test-3.02)

    (define s (make-monitored sqrt))
    (newline) (display (s 100))   ; 10
    (newline) (display (s 100))   ; 10
    (newline) (display (s 100))   ; 10
    (newline) (display (s 'how-many-calls?)) ; 3
)
(test-3.02)
    
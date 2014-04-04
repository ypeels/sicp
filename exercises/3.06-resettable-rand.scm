; from ch3support.scm
(define (rand-update x)
  (let ((a 27) (b 26) (m 127))
    (modulo (+ (* a x) b) m)))

; based loosely on (rand) from ch3.scm
(define random-init 7)			;**not in book**

(define rand                            ; DO NOT bind any arguments that you want actually PASSED to dispatch
                                        ; arguments of rand become part of dispatch's ENVIRONMENT.
    (let ((x random-init))              ; one-time initialization of x MUST take place outside of dispatch,
        (define (dispatch sym)
            (cond 
                ((eq? sym 'generate)
                    (set! x (rand-update x))
                    x         
                )
                ((eq? sym 'reset)
                    (lambda (new-x)
                        (set! x new-x)
                        x
                    )
                )
                (else (error "Unknown symbol - RAND" sym))
            )
        )
        dispatch
    )
)


(newline)(display (rand 'generate))
(newline)(display (rand 'generate))
(newline)(display (rand 'generate))
(newline)(display (rand 'generate))
(newline)(display "resetting: ")(display ((rand 'reset) random-init))
(newline)(display (rand 'generate))
(newline)(display (rand 'generate))
(newline)(display (rand 'generate))
(newline)(display (rand 'generate))            
            


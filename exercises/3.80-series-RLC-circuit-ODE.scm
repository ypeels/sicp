(load "3.53-62-stream-operations.scm") ; for add-streams, scale-stream
(load "3.78-80-integral.scm")

; takes as arguments the parameters R, L, and C of the circuit and the time increment dt
(define (RLC R L C dt)

    ; produce a procedure that takes the initial values of the state variables, vC0 and iL0
    (lambda (vC0 iL0)
        
        ; first things first
        (define vC (integral (delay dvC) vC0 dt))
        (define iL (integral (delay diL) iL0 dt))
        
        (define dvC (scale-stream iL (/ -1 C)))
        (define diL
            (add-streams
                (scale-stream vC (/ 1 L))
                (scale-stream iL (/ R L -1))
            )
        )
        (cons vC iL)     ; sol does something unnecessarily complex for the return value
    )
)

(define result ((RLC 1 1 0.2 0.1) 10 0))    ; useful for catching syntax errors
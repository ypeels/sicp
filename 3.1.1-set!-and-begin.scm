; FINALLY, this is how you have multiple statements in an if clause
    ; turns out subroutines and cond clauses (and let bodies) have an IMPLICIT begin

; set! is necessarily a special form because
    ; its arguments are treated asymmetrically
    ; it does something "non-functional" to its first argument

; is "begin" necessarily a special form? can't you think of it as a procedure that
    ; evaluates all of its arguments
    ; returns its last argument

    
(define deposit
    (let ((balance 0))              ; interestingly, this initial value binds ONLY ONCE
        (lambda (amt)
            (if (> amt 0)
                (begin
                    (set! balance (+ balance amt))
                    balance
                )
                "No non-positive deposits! nice try -- DEPOSIT"
            )
        )
    )
)


;(define deposit2
;    (begin    
;        (define balance 0)                      ; can't bind name in null syntactic environment
;        (lambda (amt)                           ; - "compile-time" error - even if uncalled!
;            (if (> amt 0)
;                (begin
;                    (set! balance (+ balance amt))
;                    balance
;                )
;                "No non-positive deposits! nice try -- DEPOSIT2"
;            )
;        )
;    )
;)


(define (deposit-wrong amt) 
    (let ((balance 0))          ; nope, this REINITIALIZES balance on each invocation of (deposit-wrong
        (if (> amt 0)
            (begin
                (set! balance (+ balance amt))
                balance
            )
            "No non-positive deposits! nice try -- DEPOSIT"
        )
    )
)

(define (test n)
    (display "\n\ndeposit:  ") (display (deposit n))
    ;(display "\ndeposit2: ") (display (deposit2 n))
    (display "\ndeposit-wrong: ") (display (deposit-wrong n))
)


(test 1)
(test 10)
(test 0)
(test -1)
(test 100)


; footnote 2: The value of a set! expression is implementation-dependent. Set! should be used only for its effect, not for its value.
(define x 0)                      ; result in MIT-Scheme 9.1
(newline) (display (set! x 1))    ; 0
(newline) (display (set! x 2001)) ; 1
(newline) (display (set! x 3))    ; 2001    

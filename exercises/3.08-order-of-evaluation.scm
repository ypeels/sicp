; the stupidest example i can think of
; latch onto any incoming value, and if it's nonnegative, KEEP it.
(define f
    (let ((state -1))
        (lambda (t)
            (if (< state 0)
                (begin
                    (set! state (/ t 2))        ; divided by 2 to normalize results as desired
                    state
                )
                state
            )
        )
    )
)

;(display (f 0)) (display (f 1))    ; 00 - if run alone
;(display (f 1)) (display (f 0))    ; 1/21/2 - if run alone
(display (+ (f 0) (f 1)))           ; 1 - which shows that the arguments are evaluated from right to left
;(display (+ (f 0) (f 1) (f 0) (f 0) (f 1))) ; 5/2
;(display (+ (f 1) (f 1) (f 1) (f 1) (f 0))) ; 0
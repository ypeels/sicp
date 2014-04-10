(load "3.78-80-integral.scm")

; analogously to p. 348
(define (solve-2nd a b y0 dy0 dt)

    (define y (integral (delay dy) y0 dt))
    (define dy (integral (delay ddy) dy0 dt))
    (define ddy 
        (add-streams
            (scale-stream dy a)
            (scale-stream y b)
        )
    )
    y
) ; is that IT?? apparently so - matches sols...


; i COULD test on a = 0, b = -1, but i don't feel like it...
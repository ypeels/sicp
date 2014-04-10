(load "3.78-80-integral.scm")

; analogously to p. 348
(define (solve-2nd f y0 dy0 dt)

    (define y (integral (delay dy) y0 dt))
    (define dy (integral (delay ddy) dy0 dt))
    (define ddy (stream-map f dy y))        ; this is actually SHORTER
    y
) 

; i COULD match results with 3.78, but i don't feel like it...
; x^2 = x + 1
; x = 1 + 1/x, QED

(load "1.35-36-fixed-point.scm")
(newline)
(display 
    (fixed-point
        (lambda (x) (+ 1 (/ 1 x)))
        1.  ; first guess
    )
)


(newline)
(display (/ (+ 1 (sqrt 5)) 2))
(display " = exact")

; 1.6180327868854258
; 1.618033988749895 = exact
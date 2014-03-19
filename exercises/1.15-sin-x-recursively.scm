(define (cube x) (* x x x))
(define (p x) (- (* 3 x) (* 4 (cube x))))
(define (sine angle)
    (if (not (> (abs angle) 0.1))
        angle
        (p (sine (/ angle 3.0)))))              ; the key step: start with sine x ~ x for sufficiently small x, then TRIPLE UP
        
; 1. sin x ~ 3 sin (x/3) - 4 sin^3 (x/3)
; 2. sin (x/3) ~ 3 sin (x/9) - 4 sin^3 (x/9) - substitute into 1.
; 3. sin (x/9) ~ 3 sin (x/27) - 4 sin^3 (x/27)

; a simple recursion makes this MUCH MORE than a simple polynomial


;       |x| <= 0.3 never invokes p()
; 0.3 < |x| <= 0.9 invokes p(x) 1 time
; 0.9 < |x| <= 2.7 invokes p(x) 2 times
; 2.7 < |x| <= 8.1 invokes p(x) 3 times
; 8.1 < |x| <= 24.3 invokes p(x) 4 times
; 


; x     (sine x) / (sin x)
;-------------------------
; 0.29  1.002
; 0.31  1.0002
; 0.89  1.001
; 0.91  1.0001
; 2.69  0.991
; 2.71  0.9989
; 8.09  0.997
; 8.11  0.9996
; 24.29 0.963
; 24.31 0.996

; This is amazingly accurate, giving >95% accuracy out to 4 full cycles in EITHER DIRECTION!!
; Notice how accuracy "refreshes" after an additional recursion.


; So far the main message of this book seems to be "recursion rulez"


; looks like space and steps grow logarithmically
; accuracy seems more relevant for this particular case
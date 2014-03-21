; and i had to do this exercise, since i'd already done 1.35...

(load "1.35-36-fixed-point.scm")

(define (average x y) (/ (+ x y) 2))
(define (f x) (/ (log 1000) (log x)))
(define (f-damped x) (average x (f x)))

(display "\nUndamped\n")
(fixed-point f 2.)
; 4.555532270803653 after 34 iterations (oscillates even when close)

(display "\nDamped\n")
(fixed-point f-damped 2.)
; 4.555537551999825 after only 9 iterations (converges monotonically)

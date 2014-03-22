(load "1.43-repeat-by-lambda.scm")
;(define repeat repeated)
(define repeat fast-repeated-iter) ; sadly, this doesn't seem that much faster... maybe for powers of 2? no...
                                   ; i think that's because fast-repeated just saves you INVOCATIONS OF COMPOSE
                                   ; what that does is CONSTRUCT the composite function (smooth (smooth (smooth (smooth...)))
                                   ; but there's no shortcut for EVALUATING the function
(define (smooth f)
    (let ((dx 0.00001))
        
        ; lambda (x) [f(x-dx) + f(x) + f(x+dx)] / 3
        (lambda (x)
            (/ 
                (+  (f x)
                    (f (- x dx))
                    (f (+ x dx)))
                3
            )
        )
    )
)



(define (n-smooth f n) ((repeated smooth n) f))



; uh, how to test this? hmmmmm
(define (test-1.44)

    (let ((reps 14) (x0 1))     ; reps = 14 is MUCH SLOWER than reps = 10, but it still finishes in a matter of seconds
        
        (display "\nstarting the linear case...")
        (define id (lambda (x) x))
        (define (id-n n) (n-smooth id n))
        (newline) (display ((id-n reps) x0))  ; should do nothing to a linear function
        
        (display "\nstarting the quadratic case...")
        (define sq (lambda (x) (square x)))
        (define (sq-n n) (n-smooth sq n))
        (newline) (display ((sq-n reps) x0))  ; should alter a parabola
    )
)
    
; (test-1.44) ; hmmmmm this is so slow by reps = 20 that i'm not sure it's right... nonlocality and exponentially duplicated effort?

; the current implementation scales EXPONENTIALLY ("order of growth")
; (define f1 (smooth f))
    ; (f1 x) requires THREE evaluations of (f).
; (define f2 (smooth f1))
    ; (f2 x) requires three evaluations of (f1), and therefore
    ; (f2 x) requires NINE evaluations of (f)
    
; a more REASONABLE algorithm would create a (sufficiently large) grid of f(x + n*dx) and get ALL of f1 in 1 pass.
    ; i think that scales as n^2? (it's a pyramid)
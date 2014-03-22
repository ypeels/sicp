(load "1.35-36-fixed-point.scm")        ; (newtons-method) punts to (fixed-point)

; from ch1.scm ;;;;;;;;;;;;;;;;;;;;;; 
;; Newton's method

(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))
(define dx 0.00001)


(define (cube x) (* x x x))

;: ((deriv cube) 5)

(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))

(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(define (cubic a b c)
    (lambda (x)
        (+
            (cube x)
            (* a (square x))
            (* b x)
            c)))
            

            
            
(define (test-1.40)

    (define (test a b c)
        (let ((x (newtons-method (cubic a b c) 1)))
            (newline)
            (display x)
            (display "\ncubic(x) = ")
            (display ((cubic a b c) x))))
            
    (test -1 1 -1)
    (test 1 1 1)
    ;(test 0 0 0) ; too many iterations - fixed-point's temp output clogs up the screen
)

(test-1.40)
    
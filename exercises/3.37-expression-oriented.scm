(load "3.33-37-propagation-of-constraints.scm")


; from problem statement
(define (c+ x y)
  (let ((z (make-connector)))
    (adder x y z)
    z))
    
    
; code monkey see, code monkey do
(define (c* x y)
    (let ((z (make-connector)))
        (multiplier x y z)
        z
    )
)

(define (c- x y)
    (let ((x-minus-y (make-connector)))
        (adder y x-minus-y x)
        x-minus-y
    )
)

(define (c/ x y)
    (let ((x-over-y (make-connector)))
        (multiplier y x-over-y x)
        x-over-y
    )
)

(define (cv value)
    (let ((c (make-connector)))
        (constant value c)
        c
    )
)




(define (test-3.37)

    ; from problem statement
    (define (celsius-fahrenheit-converter x)
      (c+ (c* (c/ (cv 9) (cv 5))
              x)
          (cv 32)))
    (define C (make-connector))
    (define F (celsius-fahrenheit-converter C))

    (probe "Celsius" C)
    (probe "Fahrenheit" F)
    
    (display "\n\nsetting F - should propagate to C")
    (set-value! F 77 'user)
    
    (display "\n\nforgetting F")
    (forget-value! F 'user)
    
    (display "\n\nsetting C - should propagate to F")
    (set-value! C 100 'user)
)

;(test-3.37)
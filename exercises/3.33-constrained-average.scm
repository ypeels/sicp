(load "3.33-37-propagation-of-constraints.scm")


; analogous with p. 287f "Using the constraint system"
(define (average-constraint a b c)
    (let ((sum (make-connector)) (half (make-connector)))
    
        ; here it is, SIMPLER than the fahrenheit/celsius converter
        (adder a b sum)        
        (constant (/ 1 2) half)
        (multiplier sum half c)        
    
        'ok
    )
)

(define (test-3.33)

    (let (  (A (make-connector)) 
            (B (make-connector))
            (Average (make-connector))
            )
        (average-constraint A B Average)
        (probe "A" A)
        (probe "B" B)
        (probe "Average(A, B)" Average)
        
        (display "\n\nSet A = 2")
        (set-value! A 2 'user)
        
        (display "\n\nSet B = 4, which should determine the average")
        (set-value! B 4 'user)
        
        (display "\n\nTry to forget a value, but invalid retractor should have no effect")
        (forget-value! A 'giggity)
        
        (display "\n\nForget A, which should unset the average")
        (forget-value! A 'user)
        
        (display "\n\nSet Average, which should determine A")
        (set-value! Average 7 'user)
        
        ;(set-value! C 
    )
)

;(test-3.33)
; another chapter in the misadventures of Louis Reasoner

(load "3.33-37-propagation-of-constraints.scm")

(define (squarer a b)
    (multiplier a a b))
    
(define (test-3.34)
    (let ((A (make-connector)) (Square (make-connector)))


        (squarer A Square)

        (probe "A" A)
        (probe "A**2" Square)

        (display "\n\nsetting A - should propagate to square, right?")
        (set-value! A 2 'user)

        (display "\n\nforgetting A - should propagate to square")
        (forget-value! A 'user)

        (display "\n\nhere's the rub: setting Square leaves A undefined")
        (set-value! Square 5 'user)
        (display "\nThis is because multiplier assumes 2 of the 3 constraints are defined, to determine the third")
        (display "\nIt isn't smart enough to take sqrts if 2 inputs are identical")


        (display "\n\nat least it's not an infinite loop - not Louis' worst work")
    )
)
;(test-3.34)
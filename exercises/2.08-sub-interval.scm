; Using reasoning analogous to Alyssa's, describe how the difference of two intervals may be computed. 
(define (sub-interval x y)
    (let (  (p1 (- (lower-bound x) (lower-bound y)))
            (p2 (- (lower-bound x) (upper-bound y)))
            (p3 (- (upper-bound x) (lower-bound y)))
            (p4 (- (upper-bound x) (upper-bound y))))
        (make-interval (min p1 p2 p3 p4) (max (p1 p2 p3 p4)))
    )
)
        

    ; use 4 cases like mul-interval, cuz MAYBE there are NEGATIVE numbers here...
    ; ADDITION is the special case that doesn't need min/max testing...

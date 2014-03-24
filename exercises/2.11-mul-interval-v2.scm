(load "2.07-interval-arithmetic.scm")


; "By testing the signs of the endpoints of the intervals, it is possible to break mul-interval into nine cases, 
; only one of which requires more than two multiplications."

; each interval can be 
    ; strictly positive (lower bound is positive)
    ; strictly negative (upper bound is negative)
    ; or span 0 (the rest)
    ; that looks like 3x3 to me!
    
    
(define (interval-is-strictly-positive? x)
    (positive? (lower-bound x)))
(define (interval-is-strictly-negative? x)
    (negative? (upper-bound x)))
(define (interval-spans-zero? x)
    (and 
        (not (interval-is-strictly-positive? x))
        (not (interval-is-strictly-negative? x))))

    
(define (mul-interval-v2 x y)

    ; no, most of the typing is "lower-bound" and "upper-bound"
    ;(define (make-product a b c d)
    ;    (make-interval (* a b) (* c d)))
    (define l lower-bound)
    (define u upper-bound)
    (define pos? interval-is-strictly-positive?)
    (define neg? interval-is-strictly-negative?)
    (define neither? interval-spans-zero?)

    (cond 
        ((interval-is-strictly-positive? x)
            (cond
                ((interval-is-strictly-positive? y)
                    (make-interval 
                        (* (l x) (l y)) 
                        (* (u x) (u y))))
                ((interval-is-strictly-negative? y)
                    (make-interval 
                        (* (u x) (l y))         ; most negative
                        (* (l x) (u y))))       ; least negative
                        
                (else                           ; y must straddle 0
                    (error "empty stub"))
            )
        )
        
        ((interval-is-strictly-negative? x)
            (cond
                ((interval-is-strictly-positive? y)
                    (make-interval
                        (* (l x) (u y))         ; most negative product
                        (* (u x) (l y))))       ; least negative product
                        
                ((interval-is-strictly-negative? y)
                    (make-interval
                        (* (u x) (u y))         ; (u x) and (u y) are both the least negative
                        (* (l x) (l y))))       ; (l x) and (l y) are both the most negative
                        
                (else                           ; y must straddle 0
                    (error "empty stub"))
            )
        )
        
        (else                                   ; x must straddle 0!!!
            (error "empty stub")
        )
    )                                           ; end cond(x)
)
                
                        
        

    
(define mul-interval mul-interval-v2)







; test code...
(load "2.09-width.scm")     ; should revert to mul-interval-v1...? yes it does.
(test-2.9)
(display "\nAnd now to test mul-v2\n")
(define mul-interval mul-interval-v2)
(test-2.9)

    
    
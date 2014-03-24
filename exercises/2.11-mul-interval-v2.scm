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

    (define l lower-bound)
    (define u upper-bound)
    
    ; shared cases require FLIPPING the arguments as appropriate
    (define (positive-times-negative positive negative)
        (if (or     (not (interval-is-strictly-positive? positive))
                    (not (interval-is-strictly-negative? negative)))
            (error "bad input in positive-times-negative")              ; i mean, i COULD just HANDLE the error... but meh
            (make-interval
                (* (u positive) (l negative))   ; lower = most negative product
                (* (l positive) (u negative))   ; upper = least negative product
            )
        )
    )
    
    (define (positive-times-straddle positive straddle)
        (if (or     (not (interval-is-strictly-positive? positive))
                    (not (interval-spans-zero? straddle)))
            (error "bad input in positive-times-straddle")
            (make-interval
                (* (u positive) (l straddle))   ; lower = max(positive) * straddle-
                (* (u positive) (u straddle))   ; upper = max(positive) * straddle+
            )
        )
    )
    
    (define (negative-times-straddle negative straddle)
        (if (or     (not (interval-is-strictly-negative? negative))
                    (not (interval-spans-zero? straddle)))
            (error "bad inputin negative-times-straddle")
            (make-interval
                (* (l negative) (u straddle))   ; lower = most negative * straddle+
                (* (l negative) (l straddle))   ; upper = most negative * straddle-
            )
        )
    )
    
    
    (cond 
        ((interval-is-strictly-positive? x)
            (cond
                ((interval-is-strictly-positive? y)
                    (make-interval 
                        (* (l x) (l y)) 
                        (* (u x) (u y))  
                    )
                )
                ((interval-is-strictly-negative? y)                   
                    (positive-times-negative x y)
                )
                (else                           ; y must straddle 0
                    (positive-times-straddle x y)
                )
            )
        )
        
        ((interval-is-strictly-negative? x)
            (cond
                ((interval-is-strictly-positive? y)
                    (positive-times-negative y x)     
                )
                ((interval-is-strictly-negative? y)
                    (make-interval
                        (* (u x) (u y))         ; (u x) and (u y) are both the least negative
                        (* (l x) (l y))         ; (l x) and (l y) are both the most negative
                    )
                )                        
                (else                           ; y must straddle 0
                    (negative-times-straddle x y)
                )
            )
        )
        
        (else                                   ; x must straddle 0!!!
            (cond
                ((interval-is-strictly-positive? y)
                    (positive-times-straddle y x)
                )
                ((interval-is-strictly-negative? y)
                    (negative-times-straddle y x)
                )
                (else                           ; both straddle! then lx, ly < 0 and ux, uy > 0.
                    (make-interval
                        (min (* (l x) (u y)) (* (u x) (l y)))
                        (max (* (l x) (l y)) (* (u x) (u y)))
                    )
                )
            )
        )
    )                                           ; end cond(x)
)
   
(define mul-interval mul-interval-v2)



(define (equal-intervals? x y)
    (and    (= (upper-bound x) (upper-bound y))
            (= (lower-bound x) (lower-bound y))))
            
            
; if you test with integers and mul only, there will be no floating point issues.
(define (test-2.11)

    (load "2.09-width.scm")  ; for (print-interval)

    (define (test a b c d)
        (newline)
        (let (  (x (make-interval a b))
                (y (make-interval c d)))
                
            (print-interval x) (display "   times   ") (print-interval y)
            (cond   
                ((equal-intervals? (mul-interval-v1 x y) (mul-interval-v2 x y))
                    (display "   are equal! ") 
                    (print-interval (mul-interval-v1 x y))
                )
                (else
                    (error "not equal" (mul-interval-v1 x y) (mul-interval-v2 x y))
                )
            )
        )
        "unused return value"
    )
    
    ;(test -1 -2 -3 -4)  ; should return constructor error
    (test 1 2 3 4)
    (test 1 2 -4 -3)
    (test -2 -1 3 4)
    (test -2 -1 -4 -3)
    (test 1 2 -2 3)
    (test -2 -1 -8 6)
    (test -3 5 2 3)
    (test -3 5 -3 -1)
    (test 0 0 0 0)
    (test -1 1 -1 1)
    (test -1 1 -9 4)
    (test -1 1 -4 9)
    (test -2 1 -4 9)
    (test -1 2 -4 9)
)

; (test-2.11)

                

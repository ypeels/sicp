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
    ;(define pos? interval-is-strictly-positive?)
    ;(define neg? interval-is-strictly-negative?)
    ;(define neither? interval-spans-zero?)

    
    ; shared cases require FLIPPING
    (define (positive-times-negative positive negative)
        (if (or     (not (interval-is-strictly-positive? positive))
                    (not (interval-is-strictly-negative? negative)))
            (error "bad input in positive-times-negative")
            (make-interval
                (* (u positive) (l negative))   ; most negative product
                (* (l positive) (u negative))   ; least negative product
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
                    ;(make-interval 
                    ;    (* (u x) (l y))         ; most negative
                    ;    (* (l x) (u y))         ; least negative
                    ;)
                    
                    (positive-times-negative x y)
                )                        
                (else                           ; y must straddle 0
                    (make-interval                        
                        (* (u x) (l y))         ; max(x) * negative value of y
                        (* (u x) (u y))         ; max(x) * positive value of y
                    )
                )
            )
        )
        
        ((interval-is-strictly-negative? x)
            (cond
                ((interval-is-strictly-positive? y)
                    ;(make-interval
                    ;    (* (l x) (u y))         ; most negative product
                    ;    (* (u x) (l y))         ; least negative product
                    ;)
                    (positive-times-negative y x)
                )                        
                ((interval-is-strictly-negative? y)
                    (make-interval
                        (* (u x) (u y))         ; (u x) and (u y) are both the least negative
                        (* (l x) (l y))         ; (l x) and (l y) are both the most negative
                    )
                )                        
                (else                           ; y must straddle 0
                    (make-interval
                        (* (l x) (u y))         ; most negative x * positive value of y
                        (* (l x) (l y))         ; most negative x * negative value of y
                    )
                )
            )
        )
        
        (else                                   ; x must straddle 0!!!
            (error "empty stub")
            ;(cond 
            ;    ((interval-is-strictly-positive? y)
            ;        (make-interval
        )
    )                                           ; end cond(x)
)
                
                        
        

    
(define mul-interval mul-interval-v2)







; test code...
;(load "2.09-width.scm")     ; should revert to mul-interval-v1...? yes it does.
;(test-2.9)
;(display "\nAnd now to test mul-v2\n")
;(define mul-interval mul-interval-v2)
;(test-2.9)

    
    
    
; (define (equal-intervals? x y)
; then use mul-interval-v1 and mul-interval-v2, comparing the results.
; it's really tempting to write the test code first - that way i know how close i am to finished...
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
            (if (equal-intervals?
                    (mul-interval-v1 x y)
                    (mul-interval-v2 x y))
                (display "   are equal!")
                (error "not equal" (mul-interval-v1 x y) (mul-interval-v2 x y))
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
)

(test-2.11)

                

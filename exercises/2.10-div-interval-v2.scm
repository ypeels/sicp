(load "2.07-interval-arithmetic.scm")

(define (interval-spans-zero? x)
    (and 
        (>= (upper-bound x) 0) 
        (<= (lower-bound x) 0)
    )
)

(define (div-interval-v2 x)
    (if (interval-spans-zero? x)    ; oh you clever, clever ben bitdiddle...
        (error "Interval spans 0!" (lower-bound x) (upper-bound x))
        (div-interval-v1 x)))

(define div-interval div-interval-v2)
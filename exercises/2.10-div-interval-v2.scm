(load "2.07-interval-arithmetic.scm")

(define (div-interval-v2 x)

    (define (interval-spans-zero? x)    ; made internal to avoid name collision in exercise 2.11
        (and 
            (>= (upper-bound x) 0)      ; could alternatively use (not (negative?)
            (<= (lower-bound x) 0)))

    (if (interval-spans-zero? x)        ; oh you clever, clever ben bitdiddle...
        (error "Interval spans 0!" (lower-bound x) (upper-bound x))
        (div-interval-v1 x)))

(define div-interval div-interval-v2)
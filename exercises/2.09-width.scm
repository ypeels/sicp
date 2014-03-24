(load "2.07-interval-arithmetic.scm")   ; for main definitions
(load "2.08-sub-interval.scm")          ; for sub-interval


; Exercise 2.9.  The width of an interval is half of the difference between its upper and lower bounds.
(define (width-interval x)
    (/ (- (upper-bound x) (lower-bound x)) 2))
    
; Show that the width of the sum (or difference) of two intervals is a function only of the widths of the intervals being added (or subtracted).
; ---------------------
; Addition is trivial
    ; let x = (ax, bx), y = (ay, by)
    ; x + y = (ax, bx) + (ay, by) = (ax+ay, bx+by)
    ; width(x) = bx - ax
    ; width(y) = by - ay
    ; width (x+y) = (bx-ax) + (by-ay) = width(x) + width(y)
    
; Subtraction is just a subcase of addition, and there is no need to consider it separately.

; For multiplication, it suffices to give a counterexample:
    ; Let x and y be defined as for addition.
    ; Consider further the special case where ax, bx, ay, by > 0.
    ; width(x*y) = width[ (ax*ay, bx*by) ] = bx*by - ax*ay
        ; there is no way to extract width(x) and width(y) out of here (is there?)
        ; width(x) * width(y) = (bx-ax)(by-ay) = (bx*by + ax*ay) - (bx*ay + by*ax). it's not even an additive correction!
        
; Division is just a subcase of multiplication, and there is no need to consider it separately.

(define (print-interval i)
    (display (lower-bound i))
    (display " to ")
    (display (upper-bound i)))

(define (test-2.9)

    (define (test-interval i name)
        (display name) (display " = ") (print-interval i)        
        (display " width = ") (display (width-interval i))
        (newline))
        
        

    (define (test lx ux ly uy)
        (newline)
        (let (  (x (make-interval lx ux))
                (y (make-interval ly uy)))
            (test-interval x "x")
            (test-interval y "y")
            (test-interval (add-interval x y) "x+y")
            (test-interval (sub-interval x y) "x-y")
            (test-interval (mul-interval x y) "x*y")
            (test-interval (div-interval x y) "x/y")
        )
    )
    
    (test 3 4 1 2)
    (test -2 -1 -4 -3)
    (test 98 100 6 9)
)

; (test-2.9) ; run my test code to see my examples.
            
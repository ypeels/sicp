; this problem is on the trivial side... but it's needed for 2.3...

; from problem statement
(define (print-point p)
  ;(newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")")
  (newline)
  )

; random utility function
(define (average a b) (/ (+ a b) 2))
  
; Point constructor and selectors - tightly coupled
(define (make-point x y) (cons x y))
(define (x-point p) (car p))
(define (y-point p) (cdr p))
(define (midpoint p1 p2) 
    (make-point 
        (average (x-point p1) (x-point p2))
        (average (y-point p1) (y-point p2))))
(define (points-are-equal? p1 p2)   ; added for exercise 2.3
    (and (= (x-point p1) (x-point p2)) (= (y-point p1) (y-point p2))))
; Note that there is no type checking: who KNOWS whether arguments are correct!?
; Does that mean Scheme is dynamically typed and uses duck-typing??

; Segment constructor and selectors. 
(define (make-segment p1 p2) (cons p1 p2))
(define (start-segment s) (car s))
(define (end-segment s) (cdr s))
(define (midpoint-segment s) 
    (midpoint (start-segment s) (end-segment s)))
    


; added for exercise 2.3  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
(define (x-distance-segment s) (axis-distance-segment s x-point))
(define (y-distance-segment s) (axis-distance-segment s y-point)) ; is this more "Scheming"? at least it's DRYer
(define (axis-distance-segment s axis-point)
    (abs (- (axis-point (start-segment s)) (axis-point (end-segment s)))))

; some convenience functions
(define (is-horizontal-segment? s) (= 0 (y-distance-segment s)))
(define (is-vertical-segment? s) (= 0 (x-distance-segment s)))

(define (length-segment s)  
    (cond 
        ((is-horizontal-segment? s) (y-distance-segment s))
        ((is-vertical-segment? s)   (x-distance-segment s))
        (else (error "unimplemented: diagonal segment"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Test code
(define (test-2.2)
    
    (define (test x1 y1 x2 y2)
        (newline)
        (let ((p1 (make-point x1 y1)) (p2 (make-point x2 y2)))
            (display "start ") (print-point p1)
            (display "end   ") (print-point p2)
            (display "midpt ") (print-point (midpoint-segment (make-segment p1 p2)))
        )
    )
    
    (test 0 0 0 0)
    (test 0 0 4 6)
    (test 1 2 5 6)
    (test -4 0 0 -2)
)

; (test-2.2)
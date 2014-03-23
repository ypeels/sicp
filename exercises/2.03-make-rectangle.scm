(load "2.02-make-point.scm") ; for points AND segments (2 different representations)

; rectangle manipulation api, independent of implementation. writing this down really makes it clear how to proceed.
(define (area-rectangle r) (* (base-rectangle r) (height-rectangle r)))
(define (perimeter-rectangle r) (* 2 (+ (base-rectangle r) (height-rectangle r))))

; rectangle implementation from points. by convention: base = x-direction, height = y-direction
(define (make-rectangle-from-points p1 p2) (cons p1 p2))
(define (base-rectangle-from-points r) (abs (- (x-point (car r)) (x-point (cdr r)))))
(define (height-rectangle-from-points r) (abs (- (y-point (car r)) (y-point (cdr r)))))

; rectangle implementation from segments...? constructor will need LOTS of error handling...
(define (make-rectangle-from-segments s1 s2)

    ; limitation: only making rectangles with sides parallel to x- and y-axes...
    (define (is-segment-parallel-to-an-axis? s) 
        (or (is-horizontal-segment? s) (is-vertical-segment? s)))
        
    (define (are-segments-perpendicular? s1 s2)
        (or (and (is-horizontal-segment? s1) (is-vertical-segment? s2))
            (and (is-vertical-segment? s1) (is-horizontal-segment? s2))))
            
    (define (do-segments-share-an-endpoint? s1 s2)
        (let (  (p1a (start-segment s1)) (p1b (end-segment s1))
                (p2a (start-segment s2)) (p2b (end-segment s2)) )
            (or (points-are-equal? p1a p2a)
                (points-are-equal? p1a p2b)
                (points-are-equal? p1b p2a)
                (points-are-equal? p1b p2b))))

    (cond 
    
        ; error-checking first.
        ((or (not (is-segment-parallel-to-an-axis? s1)) (not (is-segment-parallel-to-an-axis? s2)))
            (error "segments must be parallel to axes"))            
        ((not (are-segments-perpendicular? s1 s2))
            (error "segments must be perpendicular"))
        ((not (do-segments-share-an-endpoint? s1 s2))
            (error "segments must share an endpoint"))
            
        ; the nominal case... 
        ; CONVENTION: base before height
        (else 
            (if (is-horizontal-segment? s1)
                (cons s1 s2)
                (cons s2 s1)))
    )
)

(define (base-rectangle-from-segments r) (x-distance-segment (car r)))
(define (height-rectangle-from-segments r) (y-distance-segment (cdr r)))




; choose implementation. no easier way to toggle than commenting out??
;(define base-rectangle base-rectangle-from-points) (define height-rectangle height-rectangle-from-points) 
;(define base-rectangle base-rectangle-from-segments) (define height-rectangle height-rectangle-from-segments) 



(define (test-rectangle r title)
    (newline)
    (display title)
    (display "\narea = ") (display (area-rectangle r))
    (display "\nperimeter = ") (display (perimeter-rectangle r)))
        
    
;    ; ugh, API "selector" must be at file scope, and therefore so must this test code and data...?
;    (define p0 (make-point 1 1))
;
;    ; COULD in principle define an data structure for this crap... meh
;    (define p1 (make-point 3 4))
;    (define p1a (make-point (x-point p1) (y-point p0)))
;    (define p1b (make-point (x-point p0) (y-point p1)))
;    (define s1a (make-segment p0 p1a))
;    (define s1b (make-segment p0 p1b))
;
;    (define p2 (make-point -5 -6))
;    (define p2a (make-point (x-point p2) (y-point p0)))
;    (define p2b (make-point (x-point p0) (y-point p2)))
;    (define s2a (make-segment p0 p2a))
;    (define s2b (make-segment p0 p2b))
;
;    (define Rp1 (make-rectangle-from-points p0 p1))  
;    (define Rp2 (make-rectangle-from-points p0 p2))
;    (define Rs1 (make-rectangle-from-segments s1a s1b))
;    (define Rs2 (make-rectangle-from-segments s2a s2b))
;
;    ; test cases that should terminate with error from constructor
;    ;(define R (make-rectangle-from-segments (make-segment p0 p1) (make-segment p0 p2))) ; not parallel to axes
;    ;(define R (make-rectangle-from-segments (make-segment p0 p1a) (make-segment p2 p2))) ; no common endpoint
;    ;(define R (make-rectangle-from-segments s1a s1a)) ; not perpendicular
;    ;(define R (make-rectangle-from-segments s1a s2a)) ; not perpendicular
;
;
;
;    (define base-rectangle base-rectangle-from-points) (define height-rectangle height-rectangle-from-points) 
;    (display "\n\nPoints implementation")
;    (test-rectangle Rp1 "rectangle 1")
;    (test-rectangle Rp2 "rectangle 2")
;
;    (define base-rectangle base-rectangle-from-segments) (define height-rectangle height-rectangle-from-segments) 
;    (display "\n\nSegments implementation")
;    (test-rectangle Rs1 "rectangle 1")
;    (test-rectangle Rs2 "rectangle 2")



; this "data abstraction methodology" is like a really undisciplined version of object-oriented programming...

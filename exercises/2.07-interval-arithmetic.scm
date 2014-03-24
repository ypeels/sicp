; pre-exercise definitions
(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))
                   
(define (div-interval-v1 x y)
  (mul-interval x 
                (make-interval (/ 1.0 (upper-bound y))
                               (/ 1.0 (lower-bound y)))))
                               
(define div-interval div-interval-v1)                       ; for Exercise 2.10

; from problem statement
(define (make-interval a b) (cons a b))



; Exercise 2.7: my additions
(define (upper-bound interval) (cdr interval))  ; oops, had car/cdr switched incorrectly (noticed during Exercise 2.9 testing)
(define (lower-bound interval) (car interval))  ; actually, this only matters once i start calling (make-interval)...
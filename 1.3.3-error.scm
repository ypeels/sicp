; i've been LOOKING for a way to signal an error

(define (search f neg-point pos-point)
  (let ((midpoint (average neg-point pos-point)))
    (if (close-enough? neg-point pos-point)
        midpoint
        (let ((test-value (f midpoint)))
          (cond ((positive? test-value)
                 (search f neg-point midpoint))
                ((negative? test-value)
                 (search f midpoint pos-point))
                (else midpoint))))))

(define (close-enough? x y)
  (< (abs (- x y)) 0.001))

(define (half-interval-method f a b)
  (let ((a-value (f a))
        (b-value (f b)))
    (cond ((and (negative? a-value) (positive? b-value))
           (search f a b))
          ((and (negative? b-value) (positive? a-value))
           (search f b a))
          (else
           (error "Values are not of opposite sign" a b))))) ; <--------------
           
(define (test-1.3.3) 
    (display "\nhello world\n")
    (half-interval-method (lambda (x) x) 1 2) ; trigger error. what will happen?
    (display "\ngoodbye world - this line never gets executed")
    "bye now - this value never gets returned")
    

(test-1.3.3)
    
    
    
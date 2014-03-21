
;;; modified from ch1.scm
(define (fixed-point f first-guess)

  (let ((tolerance 0.00001))                 ; preferred to internal (define), for technical reasons?

      (define (close-enough? v1 v2)
        (< (abs (- v1 v2)) tolerance))
      (define (try guess)
        (let ((next (f guess)))
          (if (close-enough? guess next)
              next
              (try next))))
      (try first-guess)
      
  )
  
)
  
  
(define (test-fixed-point)
    (newline)
    (display (fixed-point cos 1.0))         ; this DOES work on a calculator, as per footnote 57. fun!
    ; .7390822985224023
    
    (newline)
    (display (fixed-point (lambda (y) (+ (sin y) (cos y))) 1.0))
    ; 1.2587315962971173
    
    0
)
    
    
    
    
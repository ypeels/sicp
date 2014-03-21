
;;; modified from ch1.scm
(define (fixed-point f first-guess)

  (let ((tolerance 0.00001))                 ; preferred to internal (define), for technical reasons?

      (define (close-enough? v1 v2)
        (< (abs (- v1 v2)) tolerance))
      (define (try guess counter)
        (let ((next (f guess)))
          
          (display counter) (display ") ")  ; also added in Exercise 1.36, because i can't scroll up in the stupid Scheme window?
          (display next)                    ; added in Exercise 1.36
          (newline)
          
          (if (close-enough? guess next )
              next
              (try next (+ counter 1)))))
      (try first-guess 1)
      
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
    
    
    
    
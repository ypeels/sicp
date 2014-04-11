; from ch3support.scm
;;;SECTION 3.1.2

;; *following uses rand-update -- see ch3support.scm
;; *also must set random-init to some value
(define random-init 7)			;**not in book**
(define (rand-update x)
  (let ((a 27) (b 26) (m 127))
    (modulo (+ (* a x) b) m)))
    
    
    
; my work
(define (make-random-numbers request-stream)
    ;(define random-init 42)

    (define (update old-rand request)
        (cond 
            ((eq? request 'reset)
                random-init)
            ((eq? request 'generate)
                (rand-update old-rand))
            (else
                (error "Unknown request -- UPDATE" request))
        )
    )                
                
    (define random-numbers
        (cons-stream
            random-init
            (stream-map update random-numbers request-stream)
        )
    )
    random-numbers
    
    
)

(define (test-3.81)

    (define request-stream
        (cons-stream 'generate
            (cons-stream 'generate
                (cons-stream 'generate
                    (cons-stream 'generate
                        (cons-stream 'reset request-stream))))))
                        
    (define random-stream (make-random-numbers request-stream))
        
    ; from ch3support.scm
    (define (print-n s n)
      (if (> n 0)
          (begin (newline)
             (display (stream-car s))
                 (print-n (stream-cdr s) (- n 1)))))
                 
    (print-n random-stream 20)
)
;(test-3.81)
                            
            
        
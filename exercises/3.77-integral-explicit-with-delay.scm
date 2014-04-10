; original p. 343
; (define (integral integrand initial-value dt)
;   (define int
;     (cons-stream initial-value
;                  (add-streams (scale-stream integrand dt)
;                               int)))
;   int)

; delayed argument p. 347
; (define (integral delayed-integrand initial-value dt)
;   (define int
;     (cons-stream initial-value
;                  (let ((integrand (force delayed-integrand)))
;                    (add-streams (scale-stream integrand dt)
;                                 int))))
;   int)

; modified from problem statement, based on difference between integral pp. 347, 343
(define (integral delayed-integrand initial-value dt)
  (cons-stream initial-value
        
        (let ((integrand (force delayed-integrand)))    ; that's all!?
  
               (if (stream-null? integrand)
                   the-empty-stream
                   (integral (stream-cdr integrand)     ; sol has (delay (stream-cdr integrand)). who knows...
                             (+ (* dt (stream-car integrand))
                                initial-value)
                             dt))
                         
                             
        )
))
(load "3.53-3.62-stream-operations.scm")


; from text
(define (integral integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (add-streams (scale-stream integrand dt)
                              int)))
  int)
  
  
; RC should take as inputs the values of R, C, and dt and 
; should return a procedure 
    ; that takes as inputs 
        ; a stream representing the current i and 
        ; an initial value for the capacitor voltage v0 
    ; and produces as output the stream of voltages v.
    
(define (RC R C dt)

    (lambda (current-stream initial-voltage)
    
        ; v = v0 + (1/C) [Q(t) - Q(0)] + R i(t) 
        ; where Q(t) = integral of i(t).
        
        (add-streams
            (scale-stream
                (integral current-stream (* v0 C) dt)
                (/ 1 C)
            )
            (scale-stream current-stream R)
        )
    )
)

; uh, that's it...don't really feel like testing this...

(define (make-zero-crossings input-stream last-value last-average)      ; added last-average argument


  (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
  
    ; bug 1 - louis should be looking for a sign change in the SMOOTHED signal
    (cons-stream (sign-change-detector avpt last-average);last-value)
    
                 (make-zero-crossings (stream-cdr input-stream)
                 
                                      ; bug 2 - louis should be passing RAW data forward. added this argument
                                      (stream-car input-stream)
                                      
                                      avpt))))
                                      
; uh, how should i check this?? meh just look at sols
    ; yeah, mine matches
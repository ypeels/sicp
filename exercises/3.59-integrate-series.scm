(load "3.53-62-stream-operations.scm")

; and now some vaguely familiar exercises about power series.
; did i just have them on the brain from Ma 1a?



(define (div-streams s1 s2)
  (stream-map / s1 s2))

  
; "takes as input a stream a0, a1, a2... and returns returns the stream a0, (1/2)a1, (1/3)a2, ... "
(define (integrate-series stream)
    (div-streams stream integers))
    
    
    
; Show how to generate the series for sine and cosine, starting from the facts that the derivative of sine 
; is cosine and the derivative of cosine is the negative of sine: 
(define cosine-series
  (cons-stream 1 (scale-stream (integrate-series sine-series) -1))) ;<??>))
(define sine-series
  (cons-stream 0 (integrate-series cosine-series))) ;<??>))  
    ; is this REALLY going to work!?!?! wow...
    
; as for the constant term:
; "when we use integrate-series, we will cons on the appropriate constant"
    
    
(define (test-3.59)

    (define (test n series)
        (define (iter i)
            (newline) (display (stream-ref series i))
        
            (if (< i n)
                (iter (+ i 1)))
        )
        (iter 0)
    )
    
    (newline) (newline) (display "power series coefficients for cosine")
    (test 6 cosine-series)
    
    (newline) (newline) (display "power series coefficients for sine")
    (test 6 sine-series)
)
; (test-3.59)
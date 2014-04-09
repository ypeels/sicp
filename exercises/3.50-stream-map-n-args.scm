; skeleton from problem statement
(define (stream-map-3.50 proc . argstreams)
  (if (stream-null? (car argstreams))                       ; <??> (car argstreams)) car == stream-car, so this is fine
      the-empty-stream
      (cons-stream                                          ; <??> - must use cons-stream if you want to return a stream
       (apply proc (map car argstreams))                    ; <??> argstreams)) - again, can use car instead of stream-car on streams
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))   ; <??> argstreams)))))) - but MUST not use cdr! that wouldn't force the delay.

(define (test-3.50)

    (define nil '())

    ; from ch2.scm
    (define (enumerate-interval low high)
      (if (> low high)
          nil
          (cons low (enumerate-interval (+ low 1) high))))

    ; from ch3.scm
    (define (stream-enumerate-interval low high)
      (if (> low high)
          the-empty-stream
          (cons-stream
           low
           (stream-enumerate-interval (+ low 1) high))))           
    (define (display-stream s)
      (stream-for-each display-line s))
    (define (display-line x)
      (newline)
      (display x))
           

    (define (test mapper filterer enumerator)    
        (filterer
            integer? 
            (mapper  
                (lambda (x y) (sqrt (+ x y)));(square x) (square y))))
                (enumerator 1 50) 
                (enumerator 1 50)
            )
        )
    )
    
    
    (newline) (display (test map filter enumerate-interval))                            ; (2 4 6 8 10
    (newline) (display (test stream-map stream-filter stream-enumerate-interval))       ; (2 . #[promise 11])
    (newline) (display (test stream-map-3.50 stream-filter stream-enumerate-interval))  ; (2 . #[promise 12])
    (newline) (display-stream (test stream-map-3.50 stream-filter stream-enumerate-interval))   ; 2 4 6 8 10
    
)
; (test-3.50)
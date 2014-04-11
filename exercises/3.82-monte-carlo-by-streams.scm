(load "3.53-62-stream-operations.scm") ; for scale-streams

; kinda plug-and-chug since we're just reusing the monte-carlo stream API from 3.5.5
; also, we can use exercise 3.5's work as a starting point


; from ch3.scm
(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
     (/ passed (+ passed failed))
     (monte-carlo
      (stream-cdr experiment-stream) passed failed)))
  (if (stream-car experiment-stream)
      (next (+ passed 1) failed)
      (next passed (+ failed 1))))
      

; meh, let's build the stream on the primitive random, from Exercise 3.5 (and way back in Fermat test!)
; from Exercise 3.5 problem statement
(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

; this SEEMS to work
(define (random-numbers-in-range low high)
    (cons-stream
        (random-in-range low high)
        (random-numbers-in-range low high)
    )
)
    


      
      


    
    

; formulating in a form consumable by the MC stream API
; takes as arguments a predicate P, upper and lower bounds x1, x2, y1, and y2 for the rectangle, and the number of trials
    ; P(x, y) that is true for points (x, y) in the region and false for points not in the region
(define (estimate-integral P x1 x2 y1 y2)

    ; sampling region
    (define experiment-stream
        (stream-map
            P
            (random-numbers-in-range x1 x2)
            (random-numbers-in-range y1 y2)
        )
    )
    
    (scale-stream
        (monte-carlo experiment-stream 0 0)
        (* (abs (- x2 x1)) (abs (- y2 y1)))
    )
)
; I can't really say this is any CLEARER than the original Exercise 3.5...
; plus you have these weird streams to worry about...



(define (test-3.82)

    ; from exercise 3.5
    (define (in-circle? xc yc r)
        (lambda (x y)
            (<= (+ (square (- x xc)) (square (- y yc)))
                (square r))))

    (define test-stream (estimate-integral (in-circle? 0 0 1.) -1. 1 -1. 1))
    
    (define (test n)
        (newline) (display n) (display " trials:\t")(display (stream-ref test-stream n))
    )
    (test 100)      ; 3.287
    (test 1000)     ; 3.217
    (test 10000)    ; 3.162
    (test 100000)   ; 3.146
)
;(test-3.82)
            
    
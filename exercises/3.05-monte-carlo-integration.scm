; from ch3.scm
(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) (+ trials-passed 1)))
          (else
           (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))
  
  
; from problem statement
(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))
  
  
; Monte Carlo integration
; takes as arguments a predicate P, upper and lower bounds x1, x2, y1, and y2 for the rectangle, and the number of trials
    ; P(x, y) that is true for points (x, y) in the region and false for points not in the region
(define (estimate-integral P x1 x2 y1 y2 num-trials)

    ; formulate sampling region here
    (define (experiment)
        (P  (random-in-range x1 x2)
            (random-in-range y1 y2)))
            
    
            

    (*  (monte-carlo num-trials experiment)
        (abs (- x2 x1))
        (abs (- y2 y1))
    )
)


(define (test-3.05)

    (define (in-circle xc yc r)
        (lambda (x y)
            (<= (+ (square (- x xc)) (square (- y yc)))
                (square r))))
                
    (define (test xc yc r num-trials)
        (newline) (display num-trials) (display " trials: ") 
        (let (  (x1 (- xc r)) (x2 (+ xc r))
                (y1 (- yc r)) (y2 (+ yc r))
                )
            
            ; integral should converge to pi * r**2            
            (display (/ (estimate-integral (in-circle xc yc r) x1 x2 y1 y2 num-trials) r r))
        )
    )

    (test 5 7 3. 100)       ; 3.24
    (test 5 7 3. 1000)      ; 3.196    
    (test 5 7 3. 10000)     ; 3.1152
    (test 5 7 3. 100000)    ; 3.14944
    
    (test 5 7 1. 100)       ; 3.28      ; i got your unit circle right here...
    (test 5 7 1. 1000)      ; 3.124
    (test 5 7 1. 10000)     ; 3.1136
    (test 5 7 1. 100000)    ; 3.13968
)
(test-3.05)



    
        
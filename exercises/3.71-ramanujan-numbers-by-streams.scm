; Numbers that can be expressed as the sum of two cubes in more than one way are sometimes called 
; Ramanujan numbers, in honor of the mathematician Srinivasa Ramanujan. [1729!]


(load "3.70-weighted-pairs.scm")

(define (ramanujan-weight pair)
    (let ((i (car pair)) (j (cadr pair)))
        (+ (expt i 3) (expt j 3))
    )
)

(define cubed-stream (weighted-pairs integers integers ramanujan-weight))

(define (display-ramanujan-numbers how-many)

    (define (iter stream countdown)
        (if (> countdown 0)            
            (let ((current (stream-car stream)) (next (stream-car (stream-cdr stream))))
                (let ((current-weight (ramanujan-weight current)) (next-weight (ramanujan-weight next)))
                    
                    (if (= current-weight next-weight)
                        (begin
                            (newline)
                            (display current-weight)
                            (display current)
                            (display next)
                            (iter (stream-cdr stream) (- countdown 1))
                        )
                        (iter (stream-cdr stream) countdown)
                    )
                )
            )
        )
    )
;    
    (iter cubed-stream how-many) 
)
;
;
;; problem wants 6 including 1729, but MAYBE there are "doubly-Ramanujan" numbers?
(display-ramanujan-numbers 60)
; 1729 = 1**3 + 12**3 = 9**3 + 10**3
; 4104 = 2**3 + 16**3 = 9**3 + 15**3
; 13832 = 2**3 + 24**3 = 18**3 + 20**3
; 20683 = 10**3 + 27**3 = 19**3 + 27**3
; 32832 = 4**3 + 32**3 = 18**3 + 30**3
; 39312 = 2**3 + 34**3 = 15**3 + 33**3
; 40033
; 46683
; 64232
; 65728
                
                    

; curiosity: where is the first DOUBLY ramanujan number??        
    ; http://en.wikipedia.org/wiki/Taxicab_number - it's 87539319
    
        

    
        
    
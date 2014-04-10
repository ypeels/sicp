(load "3.70-weighted-pairs.scm")

; generate a stream of all numbers that can be written as the sum of two squares in three different ways
; unlike 3.71, the result here should ITSELF be a stream (ugh)

(define (pythagorean-weight pair)
    (let ((i (car pair)) (j (cadr pair)))
        (+ (expt i 2) (expt j 2))
    )
)

(define squared-stream (weighted-pairs integers integers pythagorean-weight))

; meh, make a rolling stream of consecutive triples and then filter it
(define (make-triple stream)
    (list
        (stream-car stream)
        (stream-car (stream-cdr stream))
        (stream-car (stream-cdr (stream-cdr stream)))
    )
)
    

(define (make-rolling-triple-stream stream)
    (cons-stream
        (make-triple stream)
        (make-rolling-triple-stream (stream-cdr stream))
    )
)


(define rolling-stream (make-rolling-triple-stream squared-stream))

(define (triply-pythagorean? triple-of-pairs)
    (let (  (w0 (pythagorean-weight (list-ref triple-of-pairs 0)))
            (w1 (pythagorean-weight (list-ref triple-of-pairs 1)))
            (w2 (pythagorean-weight (list-ref triple-of-pairs 2)))
            )
        (= w0 w1 w2)
    )
)


(define result-stream
    (stream-filter
        triply-pythagorean?
        rolling-stream
    )
)
        
    
(define (display-triply-pythagorean triple-of-pairs)
    (if (not (triply-pythagorean? triple-of-pairs))
        (error "uh oh" triple-of-pairs)
        (begin
            (newline) 
            (display (pythagorean-weight (car triple-of-pairs))) 
            (display triple-of-pairs)         
        )
    )
)

(define (iter n stream)
    (if (<= n 0)
        (display "that's all, folks")
        (begin
            (display-triply-pythagorean (stream-car stream))
            (iter (- n 1) (stream-cdr stream))
        )
    )
)
(iter 20 result-stream)
; 325 = 1**2 + 18**2 = 6**2 + 17**2 = 10**2 + 15**2
; 425
; 650
; 725
; 845
; 850
; 925
; 1025
; 1105 - 4 ways!
; ...
; 1625 - 4 ways!



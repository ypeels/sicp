(load "2.07-interval-arithmetic.scm")

; from main text
(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))
(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))
(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))
  

  
; Exercise 2.12 - yet another alternate constructor
(define (make-center-percent c p)
    (make-center-width c (* c p .01)))                  ; insidiously insert .01 to convert to floating point
; center selector is same as from (make-center-width)
(define (percent i)
    (/  (width i) 
        (center i) .01))                                ; yes, that's right, (/ 1 2 3) = 1/6. such a strange strange language...

        
; uh... i don't really feel like testing this...
; wow super easy... but i'm so far down the rabbit hole that i'll just do it
; the required API is dictated by (frame-coord-map) on p. 135

; problem statement
(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))  

(define (origin-frame frame)            
    (car frame))
    
(define (edge1-frame frame)             
    (cadr frame))
    
(define (edge2-frame frame)             ; the only difference with the list version
    (cddr frame))
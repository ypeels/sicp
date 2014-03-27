; kept as separate file JUST in case you want to toggle between the two using (load)


; problem statement
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))  

(define (origin-frame frame)
    (car frame))
    
(define (edge1-frame frame)
    (cadr frame))
    
(define (edge2-frame frame)
    (caddr frame))
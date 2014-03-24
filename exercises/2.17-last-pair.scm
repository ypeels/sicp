(define (last-pair L)   ; this'll just fail for empty lists...
    (if (null? (cdr L)) ; are we on the last item?
        L
        (last-pair (cdr L))))
        
(define (last-pair-by-indexing L) ; this just doesn't feel Scheming enough...also fails for empty lists
    (list 
        (list-ref L (- (length L) 1))))
        
        
(define (test-2.17)    
    (let ((L (list 23 72 149 34)))
        (newline) (display (last-pair L))               ; (34)
        (newline) (display (last-pair-by-indexing L))   ; (34)
    )
)

;(test-2.17)
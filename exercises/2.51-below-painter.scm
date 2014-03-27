; first by analogy with (beside)
(define (below painter1 painter2)
    (let ((split-point (make-vect 0 0.5)))
        (let (  (paint-bottom
                    (transform-painter
                        painter1
                        (make-vect 0 0)
                        (make-vect 1 0)
                        split-point
                    )
                )
                (paint-top
                    (transform-painter
                        painter2
                        split-point
                        (make-vect 1 0.5)
                        (make-vect 0 1)
                    )
                )
                
            )
            
            (lambda (frame)
                (paint-bottom frame)        ; this order doesn't matter, does it?
                (paint-top-frame)
            )            
        )
    )
)


; then by (beside) + (rotateX)
(define (below painter1 painter2)
    (rotate90
        (beside 
            (rotate270 painter1) 
            (rotate270 painter2)
        )
    )
)
                        
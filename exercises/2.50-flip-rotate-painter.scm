; by analogy with (flip-vert) p. 138
(define (flip-horiz painter)
    (transform-painter 
        painter
        (make-vect 1 0)
        (make-vect 0 0)
        (make-vect 1 1)
    )
)


; bwahahahahaha. too cheap?
(define (rotate180-cheap painter)
    (rotate90 (rotate90 painter))) ; or maybe (define rotate180 (rotate90 (rotate90)))? dunno if syntax is right
(define (rotate270-cheap painter)
    (rotate90 (rotate180 painter)))
    
    
; "non-cheap" - but still by simple analogy with (rotate90) p. 139
(define (rotate180 painter)
    (transform-painter
        painter
        (make-vect 1 1)
        (make-vect 0 1)
        (make-vect 1 0)
    )
)

(define (rotate270 painter)
    (transform-painter
        painter
        (make-vect 0 1)
        (make-vect 0 0)
        (make-vect 1 1)
    )
)
        
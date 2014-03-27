; a. The painter that draws the outline of the designated frame.
(define painter-2.49a
    (segment->painter   ; "pointer notation" - yeah, that's not confusing/provocative... but it DOES illustrate how flexible names are... "anything but parens"?
        (list
            (make-segment (make-vect 0 0) (make-vect 0 1))
            (make-segment (make-vect 0 1) (make-vect 1 1))
            (make-segment (make-vect 1 1) (make-vect 1 0))
            (make-segment (make-vect 1 0) (make-vect 0 0))
        )
    )
)
    
    
; b. The painter that draws an ``X'' by connecting opposite corners of the frame.    
(define painter-2.49b
    (segment->painter
        (list
            (make-segment (make-vect 0 0) (make-vect 1 1))
            (make-segment (make-vect 1 0) (make-vect 0 1))
        )
    )
)


; c. The painter that draws a diamond shape by connecting the midpoints of the sides of the frame.
(define painter-2.49c
    (let ((half (/ 1 2)))
        (segment->painter
            (list
                (make-segment (make-vect half 0) (make-vect (1 half)))
                (make-segment (make-vect (1 half)) (make-vect (half 1)))
                (make-segment (make-vect (half 1)) (make-vect (0 half)))
                (make-segment (make-vect (0 half)) (make-vect (half 0)))
            )
        )
    )
)


; d. The wave painter. 
; I'm NOT doing this busywork. Especially not this shit isn't testable.
; from Figure 2.10 p. 129, this consists of 17 segments.
; similarly minded: http://community.schemewiki.org/?sicp-ex-2.49
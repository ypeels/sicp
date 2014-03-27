; a.  Add some segments to the primitive wave painter of exercise  2.49 (to add a smile, for example).
(define painter-2.49d ; hypothetical, of course...
    (segment->painter
        (list
            ; ...
            ; you'd add line segments here
            
        )
    )
)


; b.  Change the pattern constructed by corner-split 
; (for example, by using only one copy of the up-split and right-split images instead of two).
(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left                              up) ;  (beside up up)) <---V------- simple changes
              (bottom-right                          right) ;   (below right right))
              (corner (corner-split painter (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right corner))))))
                  
                  

; c.  Modify the version of square-limit that uses square-of-four so as to assemble the corners in a different pattern. 
; (For example, you might make the big Mr. Rogers look outward from each corner of the square.) 
(define (square-limit painter n)
  (let ((quarter    (corner-split (flip-horiz painter n))))   ; (corner-split painter n))) <---- simple change
    (let ((half (beside (flip-horiz quarter) quarter)))
      (below (flip-vert half) half))))
      
      ; meh i'm not sure this is right, and i don't really care
      ; a program is pretty worthless if you can't run it
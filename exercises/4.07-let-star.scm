; omfg i didn't know about this
; i could have USED this, in a LOT of earlier exercises


    
;   (let* ( (x 3)
;           (y (+ x 2))
;           )
;       (+ x y)
;   )
;   
;   
;   ; order of evaluation
;   (
;       (lambda (x)
;           ((lambda (y) (+ x y)) (+ x 2))  ; this sets y = x+2, with x still undefined
;       )
;       3                                   ; this sets x = 3
;   )
;   
;   
;   ; the other way doesn't work, right?
;   (
;       (lambda (y) 
;           ((lambda (x) (+ x y)) 3)    ; well, this inner layer is fine...
;       )
;       ???                             ; but the dummy variable x has been eliminated!
;   )
;   
;   ; similarly
;   (let* ( (x 3)
;           (y (+ x 2))
;           (z (+ x y 5))
;           )
;   
;   (        
;       (lambda (x)        
;           (lambda (y)
;               ((lambda (z) (* x z)) (+ x y 5))
;           )
;           (+ x 2)
;       )
;       3
;   )

; but wait, that's not what the question is asking...

;   (let* ((x 3) (y (+ x 2)) (z (+ x y 5)))
;       (* x z)
;   )
;   
;   (let ((x 3))
;       (let ((y (+ x 2)))
;           (let ((z (+ x y 5)))
;               (* x z)
;           )
;       )
;   )

; so it looks emininently doable by just generating a nested list with 'let, and having that feed back into eval.
    



(load "2.87-91-polynomial-algebra.scm")

; =zero-poly
; requires "private member functions" and so had to be written in the installer.


; the actual WORK is in "2.87-91"; the code below just CHECKS it.
(define (test-2.87)

    (define (test p1 p2)
        (newline)
        (display p1) (display p2) (newline)
        (display "\nadd: ") (display (add p1 p2))
        (display "\nmul: ") (display (mul p1 p2))
    )
    
    (let (  (y (make-polynomial 'y '((1 1))))
            (y0 (make-polynomial 'y '((0 1))))  ; screw coercion for now
            )
        (let ((p (make-polynomial 'x (list (list 1 y0) (list 0 y)))))
        
            (test y y)
            (test p p)
            ; add: (polynomial x (1 (polynomial y (0 2))) (0 (polynomial y (1 2)))) = 2x + 2y
            ; mul: even uglier, but if you work through it, it is indeed x**2 + 2xy + y**2
        
        )
    )
)
(test-2.87)
; this does indeed confirm that installing =zero? for polynomials 
    ; further proof: commenting out "(put '=zero? '(polynomial)..." makes this test FAIL
                        ; "No method for these types -- APPLY-GENERIC (=zero (polynomial))"
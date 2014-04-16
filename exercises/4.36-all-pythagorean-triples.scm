;(load "ch4-ambeval.scm")
;(append! primitive-procedures (list (list 'display display) (list 'newline newline)))
;(define the-global-environment (setup-environment))
; doesn't work from here?

;(load "4.35-37-require.scm")
(load "4.35-an-integer-between-by-amb.scm")



(ambeval-batch 
    
    '(define (a-pythagorean-triple-broken) ; execute to start a fruitless, misguided search
      (let ((i (an-integer-starting-from 1)))
        (let ((j (an-integer-starting-from (+ i 1))))
            (display "\n\ni, j = ") (display i) (display ", ") (display j) (display ", and searching k:\n")
          (let ((k (an-integer-starting-from (+ j 1)))) ; this is gonna search to forever on (1, 2, k)
            (display k) (display " ")
            (require (= (+ (* i i) (* j j)) (* k k)))
            (list i j k)))))
                
    '(define (a-pythagorean-triple)
        (let ((k (an-integer-starting-from 3))) ; cheating from knowledge that isosceles right triangle won't have 3 integral side lengths
            (let ((i (an-integer-between 1 (- k 2)))) ; thus, i j and k must be distinct
                (let ((j (an-integer-between (+ i 1) (- k 1))))
                    (require (= (+ (* i i) (* j j)) (* k k)))
                    (list i j k)
                )
            )
        )
    )
    
    '(define t a-pythagorean-triple)
    ; 3 4 5
    ; 6 8 10
    ; 5 12 13 - notice how these are ordered on k, not i
    ; 9 12 15
    ; 8 15 17
    ; 12 16 20
    ;  7 24 25. oh yeah, i remember you...
    ; 15 20 25
    ; 10 24 26
    ; 20 21 29
)
(driver-loop)

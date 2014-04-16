(load "4.35-37-require.scm")

(ambeval-batch 
            
    ; based on (an-integer-starting-from n)
    '(define (an-integer-between low high)
        (if (>= low high)
            high
            (amb low (an-integer-between (+ low 1) high))
        )
    )
)

(define (test-4.35)

    (ambeval-batch

        '(define x 1)
        'x
        
        '(define (a-pythagorean-triple-between low high)
          (let ((i (an-integer-between low high)))
            (let ((j (an-integer-between i high)))
              (let ((k (an-integer-between j high)))
                (require (= (+ (* i i) (* j j)) (* k k)))
                (list i j k)))))


        '(define (i) (an-integer-between 1 5)) ; call (i) to get 1, then (try-again) to cycle through to 2, 3, ...
        
        '(define (t) (a-pythagorean-triple-between 1 20)) ; 1-100 is too slow for initial setup...
        ; 3 4 5
        ; 5 12 13
        ; 6 8 10
        ; 8 15 17
        ; 9 12 15
        ; 12 16 20
        ; there are no more values
        ; there is no current problem
    )
    (driver-loop)
)
;(test-4.35)

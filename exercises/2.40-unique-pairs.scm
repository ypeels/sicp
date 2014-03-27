(load "2.40-43-flatmap.scm")

; this function generates all pairs of distinct integers 1 <= j < i <= n
; actually i've done this already in my notes on 2.2.3 flatmap, but let's see if i can do it from scratch too
; also, it might be illuminating to do it without lambdas?
    ; this is much clearer than using lambdas, because you can assign each action a DESCRIPTIVE NAME
(define (unique-pairs n)  

    
    ; this function generates ((i 1) (i 2) ... (i i-1))
    (define (unique-pairs-with-i i)
    
        (define (pair-with-i j)                 ; originally (lambda (j) (list i j))    
            (list i j))                         ; must be nested, because it needs to bind i
    
        (map 
            pair-with-i
            (enumerate-interval 1 (- i 1))
        )
    )
    
    ; map generates ( ((2 1))  ((3 1) (3 2))  ((4 1) (4 2) (4 3))  ... ((n 1) ... (n n-1)) )
    ; flatmap takes it a step further and concatenates all the results to ((2 1) (3 1) (3 2) ... (n n-1))
    (flatmap ;(map 
        unique-pairs-with-i    
        (enumerate-interval 1 n)
    )
    
)




(define (test-2.40)
    
    (define (test n)
        (newline)
        (display (unique-pairs n))
    )
    
    (test 1)
    (test 2)
    (test 3)
    (test 4)
    (test 7)
)

; (test-2.40)

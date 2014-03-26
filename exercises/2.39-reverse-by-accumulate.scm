(load "2.38-fold-left-right.scm")

(define nil ())

(define (reverse-right sequence)
    (fold-right 
        (lambda (x result)                  ; should help a LOT to mark in the lambda which argument is the running total
            (append result (list x))        ; <??>
        ) 
        nil 
        sequence
    )
)

(define (reverse-left sequence)
    (fold-left 
        (lambda (result y)  
            (cons y result)                 ; <??>
        ) 
        nil 
        sequence
    )
)


; both worked first try. my exploration of exercise 2.18 paid off, i guess
  
  
  
  
  
(define (test-2.39)

    (define (test seq)
        (display "\nbuilt-in: ") (display (reverse seq))
        (display "\nfold-right: ") (display (reverse-right seq))
        (display "\nfold-left: ") (display (reverse-left seq))
    )
    
    (test (list 1 2 3 4))
)

; (test-2.39)

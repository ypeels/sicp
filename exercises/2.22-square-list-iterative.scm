(define nil ()) ; stupid outdated textbook, stupid scheme language

; Louis Reasoner's first bugged version
(define (square-list-iter-v1 items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things) 
              (cons (square (car things))
                    answer))))
  (iter items nil))
  
  
; *** (list a b c) = (cons a (cons b (cons c nil)))
; but Louis is iterating through the list constructing
    ; (cons a nil)
    ; (cons b (cons a nil))
    ; (cons c (cons b (cons a nil))) = (list c b a).

  
  
(define (square-list-iter-v2 items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items nil))
; now Louis is constructing
    ; (cons nil a)
    ; (cons b (cons nil a))
    ; (cons c (cons b (cons nil a)))
    ; this is not even a scheme list, which must have the structure of *** above (Figure 2.4 and following)


; ugh, getting this correct requires FAIRLY LOW LEVEL knowledge of how scheme's stupid lists work
(define (square-list-iter-v3 items)

    (define (iter things answer)
        (if (null? things)
            answer
            (iter   (cdr things)
                    (append answer (list (square (car things))))
            )
        )
    )
    (iter items ())     ; apparently you can append stuff onto an empty list
)
    
  

(define (test-2.22)

    (define (test proc name)
        (newline) (display name)
        (newline) (display (proc (list 1 2 3 4)))       ; SHOULD be (1 4 9 16)...
        (newline) (display (proc ()))
        (newline)
    )
    
    (test square-list-iter-v1 "Louis Reasoner v1")
    (test square-list-iter-v2 "Louis Reasoner v2")
    (test square-list-iter-v3 "my version using append")
)



; (test-2.22)
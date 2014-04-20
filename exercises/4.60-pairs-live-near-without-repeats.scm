; to break the symmetry between person1 and person2,
; maybe add additional restriction lisp-value that person1 >= person2 alphanumerically

(define (test-4.60)

    (load "ch4-query.scm")
    (init-query)
    
    (query '(lives-near ?p1 ?p2))
    ; lists pairs with duplicates
    
    ; hmm had to look stuff up not in book - string<=? and symbol->string
    ; still, it's good to know that full-fledged lambdas work.
    ; also, looks like the query system (unlike mceval, leval, ambeval) has access to FULL scheme via (lisp-value)
    (query 
        '(and 
            (lives-near (?last-name-1 . ?n1) (?last-name-2 . ?n2))
            (lisp-value 
                (lambda (s1 s2) (string<=? (symbol->string s1) (symbol->string s2)))
                ?last-name-1 
                ?last-name-2
            )
        )
    )
    ; (aull dewitt) (reasoner louis)
    ; (aull dewitt) (bitdiddle ben)
    ; (fect cy d) (hacker alyssa p)
    ; (bitdiddle ben) (reasoner louis)
    
    
    (query-driver-loop)
)
;(test-4.60)
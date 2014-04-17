(define (install-liars-puzzle)
    (ambeval-batch
    
        
        '(define (both-true? p1 p2)
            (if p1
                (if p2
                    true
                    false
                )
                false
            )
        )
        
        '(define (both-false? p1 p2)
            (both-true? (not p1) (not p2)))
        
        ; cf. (require) - the passing case is undefined. annoyingly, and/or are not implemented...
        '(define (require-half-truth p1 p2)
            (cond
                ((both-true? p1 p2) (amb))
                ((both-false? p1 p2) (amb))
            ) ; dangling (else) - equivalent to (if) without alternative, right?
        )
        
        '(define (liars-puzzle)
            (let (  (betty (amb 1 2 3 4 5))
                    (ethel (amb 1 2 3 4 5))
                    (joan (amb 1 2 3 4 5))
                    (kitty (amb 1 2 3 4 5))
                    (mary (amb 1 2 3 4 5))
                    )
                    
                (require-half-truth (= kitty 2) (= betty 3))
                (require-half-truth (= ethel 1) (= joan 2))
                (require-half-truth (= joan 3) (= ethel 5))
                (require-half-truth (= kitty 2) (= mary 4))
                (require-half-truth (= mary 4) (= betty 1))
                (require (distinct? (list betty ethel joan kitty mary)))
                
                
                (list 
                    (list 'betty betty)
                    (list 'ethel ethel)
                    (list 'joan joan)
                    (list 'kitty kitty)
                    (list 'mary mary)
                )
            )
        )
    
        '(define L liars-puzzle)
    )
)


(define (test-4.42)

    (load "ch4-ambeval.scm")
    
    (load "4.35-37-require.scm")
    (install-require)
    
    (load "4.38-44-distinct.scm")
    (install-distinct)
    
    (install-liars-puzzle)
    
    
    (driver-loop)
)
;(test-4.42)

; (betty, ethel, joan, kitty, mary) = (3, 5, 2, 1, 4), unique solution.
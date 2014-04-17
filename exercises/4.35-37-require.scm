;(load "ch4-ambeval.scm") ; DO NOT OVERWRITE apply-in-underlying-scheme!!

(define (install-require)
    (ambeval-batch
        
        ; from Section 4.3.1
        '(define (require p)
            (if (not p) (amb)))
            
        ; and another utility function
        '(define (an-integer-starting-from n)
          (amb n (an-integer-starting-from (+ n 1))))
    )
)

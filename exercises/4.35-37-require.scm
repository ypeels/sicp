(load "ch4-ambeval.scm")

(ambeval-batch
    
    ; from Section 4.3.1
    '(define (require p)
        (if (not p) (amb)))
        
    ; and another utility function
    '(define (an-integer-starting-from n)
      (amb n (an-integer-starting-from (+ n 1))))
)

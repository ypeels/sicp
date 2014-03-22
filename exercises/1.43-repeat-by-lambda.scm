; Hint: You may find it convenient to use compose from exercise 1.42. 
(load "1.42-composition-by-lambda.scm")

; no need to ASSUME n is an integer - just ERROR-CHECK it
; use a RECURSIVE process because that's simpler? (and i'm not QUITE sure how to do this iteratively)
; use a SIMPLE algorithm to make sure it works (the problem didn't say to use the fast-squaring algorithm)

(define (repeated foo n)

    (cond
        ((not (integer? n)) (error "n is not an integer" n))    ;(error) from 1.3.3, (integer?) from google search
        ((<= n 1)           (lambda (x) (foo x)))
        (else               (compose foo (repeated foo (- n 1))))))
        

        

            


(define (test-1.43)

    (newline)
    (display ((repeated square 2) 5)) ; should be 625
)

(test-1.43)
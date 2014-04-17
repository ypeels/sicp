(define (install-multiple-dwelling)
    (ambeval-batch

        ; from 4.3.2
        ; there's no WAY i was gonna type this in
        '(define (multiple-dwelling)
          (let ((baker (amb 1 2 3 4 5))
                (cooper (amb 1 2 3 4 5))
                (fletcher (amb 1 2 3 4 5))
                (miller (amb 1 2 3 4 5))
                (smith (amb 1 2 3 4 5)))
            (require
             (distinct? (list baker cooper fletcher miller smith)))
            (require (not (= baker 5)))
            (require (not (= cooper 1)))
            (require (not (= fletcher 5)))
            (require (not (= fletcher 1)))
            (require (> miller cooper))
            (require (not (= (abs (- smith fletcher)) 1)))
            (require (not (= (abs (- fletcher cooper)) 1)))
            (list (list 'baker baker)
                  (list 'cooper cooper)
                  (list 'fletcher fletcher)
                  (list 'miller miller)
                  (list 'smith smith))))
                  
        '(define m multiple-dwelling)
        ; hmm, sample program fails with "Unknown procedure type -- APPLY"
    )
)


(define (test-4.38)

    (load "ch4-ambeval.scm")
    
    (load "4.35-37-require.scm")
    (install-require)
    
    (load "4.38-44-distinct.scm")
    (install-distinct)

    (install-multiple-dwelling)
    (ambeval-batch '(define m multiple-dwelling))
    
    (driver-loop)
)
;(test-4.38)
(define (install-multiple-dwelling-4.38)
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
            (require (not (= (abs (- smith fletcher)) 1)))         ; disabled for Exercise 4.38
            (require (not (= (abs (- fletcher cooper)) 1)))
            (list (list 'baker baker)
                  (list 'cooper cooper)
                  (list 'fletcher fletcher)
                  (list 'miller miller)
                  (list 'smith smith))))
                  
        '(define m multiple-dwelling-4.38)
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

; ordered tuples (baker, cooper, fletcher, miller, smith)
; original answer (3, 2, 4, 5, 1)
; answers unrestricted by smith/fletcher
; (1,2,4,3,5)
; (1,2,4,5,3)
; (1,4,2,5,3)
; (3,2,4,5,1) 
; (3,4,2,5,1)
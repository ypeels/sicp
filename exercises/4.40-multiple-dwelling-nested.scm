; without requiring (distinct?), there are 5**5 = 3125 possibilities
; requiring (distinct?), there are 5! = 120 possibilities.
; it would be more efficient (and more work) to pre-prune for this, but not sure how to do THAT...

; the exercise insteads asks:
; "For example, most of the restrictions depend on only one or two of the person-floor variables, 
; and can thus be imposed before floors have been selected for all the people. 
; Write and demonstrate a much more efficient nondeterministic procedure that solves this problem 
; based upon generating only those possibilities that are not already ruled out by previous restrictions."

(define (install-multiple-dwelling-4.40)
    (ambeval-batch
        '(define (multiple-dwelling)
            (let ((fletcher (amb 1 2 3 4 5)))                       ; fletcher has the most 1-person restrictions
                (require (not (= fletcher 5)))                      ; this right here should cut things down by 40%!
                (require (not (= fletcher 1)))
                (let ((cooper (amb 1 2 3 4 5)))                     ; there's a fletcher-cooper too
                    (require (not (= cooper 1)))        
                    (require (not (= (abs (- fletcher cooper)) 1)))
                    (let ((miller (amb 1 2 3 4 5)))                 ; cooper-miller seems more restrictive than smith-fletcher
                        (require (> miller cooper))
                        (let ((smith (amb 1 2 3 4 5)))
                            (require (not (= (abs (- smith fletcher)) 1)))
                            (let ((baker (amb 1 2 3 4 5)))
                                (require (not (= baker 5)))
                                
                                ; must wait until all 5 are defined (sadly this is the MOST restrictive)
                                (require (distinct? (list baker cooper fletcher miller smith)))
            
                                (list (list 'baker baker)
                                      (list 'cooper cooper)
                                      (list 'fletcher fletcher)
                                      (list 'miller miller)
                                      (list 'smith smith))
                            )
                        )
                    )
                )
            )
        )
                  
        '(define m multiple-dwelling)
    )
)


(define (test-4.40)

    (load "ch4-ambeval.scm")
    
    (load "4.35-37-require.scm")
    (install-require)
    
    (load "4.38-44-distinct.scm")
    (install-distinct)

    (install-multiple-dwelling-4.40)
    (ambeval-batch '(define m multiple-dwelling))
    
    (driver-loop)
)
(test-4.40)


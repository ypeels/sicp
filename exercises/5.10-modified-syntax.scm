

; here, modify this fella from exercise 5.2
(define factorial-machine
    (make-machine ; register-names ops controller-text
        '(counter product t n)                          ; sols actually SKIP the intermediate register t. hmmmmm...
        (list (list '* *) (list '+ +) (list '> >))      ; oh actually, i guess t is unnecessary here, because counter update is INDEPENDENT of product!
        '(
            (assign counter (const 1))
            (assign product (const 1))

; here's my original answer            
; (controller        
            test-counter
                (test (op >) (reg counter) (reg n))
                (branch (label fact-done))
                (assign t (op *) (reg product) (reg counter))
                (assign product (reg t))
                (assign t (op +) (reg counter) (const 1))
                (assign counter (reg t))
                (goto (label test-counter))
            fact-done
;)

        )
    )
)
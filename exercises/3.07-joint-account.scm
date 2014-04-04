; well, i think i can do this by using make-joint to WRAP the original account...
    ; is this really the best way though? would this work for a double joint? (that's not in the spec though...)
    ; is this the most SCHEMING way to do things??
    



(define (make-joint old-acc old-pw new-pw)

    (define (dispatch password transaction)                 ; sols: this is perhaps clearer as a LAMBDA!
        (if (eq? password new-pw)
            (old-acc old-pw transaction)
            (lambda (x) "Incorrect password - MAKE-JOINT")  ; sols: ooh you can invoke (old-acc bad-pw) to leverage existing lockout
        )
    )
    dispatch
)



(define (test-3.07)
    
    (load "3.03-04-password-protected-account.scm")
    (define peter-acc (make-account 666 'open-sesame))      
    (define paul-acc (make-joint peter-acc 'open-sesame 'rosebud))    ; problem statement
    
    
    (newline) (display ((peter-acc 'open-sesame 'deposit) 34))  ; 700
    (newline) (display ((paul-acc 'rosebud 'withdraw) 666))     ; 34, hopefully
    (newline) (display ((peter-acc 'open-sesame 'deposit) 1))   ; 35, hopefully....
    
)
;(test-3.07)
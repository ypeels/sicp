(load "load-eceval.scm")


(define eceval-cond-text-5.23 '(
    
    
    
    ev-cond
    

        (assign val (const "hello world\n"))
        (goto (label signal-error))
        
))

(define (test-5.23)

    ; no, this had to be hard coded into ch5-eceval.scm, to allow "backwards compatibility" with the default eceval object
    ;(append! eceval-operations (list (list 'cond? cond?))))

    (define eceval-5.23
        (make-eceval 
            eceval-main-controller-text
            eceval-cond-text-5.23))
    (start eceval-5.23)
)
(define the-global-environment (setup-environment)) (test-5.23)
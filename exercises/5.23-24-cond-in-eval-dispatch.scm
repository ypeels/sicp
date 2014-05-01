(load "load-eceval.scm")

; inspired by Exercise 5.28
(define eval-dispatch-override-5.23-24 '(
    
  (goto (label read-eval-print-loop))
eval-dispatch                              
  (test (op self-evaluating?) (reg expr))  
  (branch (label ev-self-eval))            
  (test (op variable?) (reg expr))         
  (branch (label ev-variable))             
  (test (op quoted?) (reg expr))           
  (branch (label ev-quoted))               
  (test (op assignment?) (reg expr))
  (branch (label ev-assignment))
  (test (op definition?) (reg expr))
  (branch (label ev-definition))
  (test (op if?) (reg expr))
  (branch (label ev-if))
  (test (op lambda?) (reg expr))
  (branch (label ev-lambda))
  (test (op begin?) (reg expr))
  (branch (label ev-begin))
  
  (test (op cond?) (reg expr))                                          ; added for Exercises 5.23-24
  (branch (label ev-cond))
  
  (test (op application?) (reg expr))
  (branch (label ev-application))
  (goto (label unknown-expression-type))   
))




(define (run-eceval-5.23-24)
    (append! eceval-operations (list (list 'cond? cond?)))
    
    (define eceval
        (make-eceval
            (append eval-dispatch-override-5.23-24 eceval-main-controller-text)
        )
    )
    
    (start eceval)
)
            
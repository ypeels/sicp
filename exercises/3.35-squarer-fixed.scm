;(load "3.33-37-propagation-of-constraints.scm")
(load "3.34-squarer-flawed.scm")

; Ben Bitdiddle's skeleton from problem statement. will override Louis'
(define (squarer a b)
  (define (process-new-value)
    (if (has-value? b)
        (if (< (get-value b) 0)
            (error "square less than 0 -- SQUARER" (get-value b))
            
            ;<alternative1>)
            (set-value! a (sqrt (get-value b)) me)  ; NOT just (sqrt b)
            
        )
            
        ;<alternative2>))
        (set-value! b (expt (get-value a) 2) me)
  ))
  (define (process-forget-value) ;<body1>)
  
    (display "process-forget")
    (forget-value! a me)
    (forget-value! b me)
    
    ; why do does this MESS things up?? oh because ben used if's, lazily
    ; luckily/craftily for him, there ARE no extra third values that might need to be propagated...?
    ;(process-new-value)                            
  
  )
  
  (define (me request) ;<body2>)
  
    (cond 
        ((eq? request 'I-have-a-value)
            (process-new-value))
        ((eq? request 'I-lost-my-value)
            (process-forget-value))
        (else
            (error "Unknown request -- SQUARER" request))
    )
  
  )
  
  ;<rest of definition>
  (connect a me)
  (connect b me)
  
  
  
  me)
  
(test-3.34) (display "\n\nBut here in Exercise 3.35, everything above should have worked fine")
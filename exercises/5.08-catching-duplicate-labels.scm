(load "ch5-regsim.scm")

(define args-5.8 (list
    '(a)
    '()
    '(
        start
          (goto (label here))
        here
          (assign a (const 3))
          (goto (label there))
        here
          (assign a (const 4))
          (goto (label there))
        there
    )
))

(define test-machine (apply make-machine args-5.8))

(start test-machine) 
(display (get-register-contents test-machine 'a)) (newline)
; 3

; this is because (lookup-label) uses (assoc), which returns the FIRST hit, regardless of subsequent ones.
(display (assoc 'here (list (cons 'here 3) (cons 'here 4)))) (newline)
; (here . 3)


; now fix it
(define (extract-labels text receive)                        
  (if (null? text)
      (receive '() '())
      (extract-labels (cdr text)                             
       (lambda (insts labels)                                
         (let ((next-inst (car text)))                       
           (if (symbol? next-inst)    
               (if (not (assoc next-inst labels))                           ; added this additional check. that should do 'er...
                   (receive insts                                               ; just use the same mechanism as (lookup-label). could conceivably use memq or member....
                            (cons (make-label-entry next-inst    
                                                    insts)       
                                  labels))     
                   (error "Duplicate label - EXTRACT-LABELS" next-inst))    ; this line is new too. that's IT!                              
               (receive (cons (make-instruction next-inst)   
                              insts)                         
                        labels)))))))                        
  
(display "and now to raise the 'Duplicate label' error:")
(apply make-machine args-5.8) 
(display "never gets here")
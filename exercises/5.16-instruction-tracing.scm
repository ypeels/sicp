(load "5.15-17-instruction-counting-and-tracing.scm")

(load "ch5-regsim.scm")

; overrides
;(define make-new-machine-regsim make-new-machine) (define make-new-machine make-new-machine-5.16)
(define make-new-machine (make-make-new-machine-5.16 make-new-machine))

;(define make-execution-procedure-regsim make-execution-procedure) (define make-execution-procedure make-execution-procedure-5.16)
(define make-execution-procedure (make-make-execution-procedure-5.16 make-execution-procedure))

; regression test
(load "5.06-fibonacci-extra-push-pop.scm")
(test-5.6-long)


; modified from 5.11c
(define recursive-expt-machine (make-machine          
                                                      
    '(b n val continue)                               
    (list
        (list '= =)
        (list '- -)
        (list '* *)
    )
    '(                                                
           (assign continue (label expt-done))         
         expt-loop                                        
           (test (op =) (reg n) (const 0))            
           (branch (label base-case))    
           (save continue)                                
           (assign n (op -) (reg n) (const 1))    
           (assign continue (label after-expt))    
           (goto (label expt-loop))    
         after-expt    
           (restore continue) 
           (trace-on)                                   ; <------------ new
           (assign val (op *) (reg b) (reg val))    
           (trace-off)                                  ; <------------ new                
           (goto (reg continue))                       
         base-case    
           (assign val (const 1))                      
           (goto (reg continue))                       
         expt-done    
    )    
))

(set-register-contents! recursive-expt-machine 'b 2)
(set-register-contents! recursive-expt-machine 'n 5)
(start recursive-expt-machine)
(display "\nAnd what is 2**5? ")
(display (get-register-contents recursive-expt-machine 'val)) 
; seems to work
; but it's pretty worthless without being able to print register values too... is that what breakpoints are for?
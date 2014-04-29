(define (make-new-machine-5.16)
    (let (  (machine (make-new-machine-regsim))
            (trace #f)
            )    
        (define (set-trace! value)
            (set! trace value))
        (define (dispatch message)
            (cond 
                ((eq? message 'set-trace!) set-trace!)
                ((eq? message 'trace?) trace)
                (else (machine message))
            )
        )
        dispatch
    )
)

; new special forms trace-on and trace-off.
(define (make-execution-procedure-5.16 inst labels machine pc flag stack ops) 
    (let ((proc (cond
                    ((eq? (car inst) 'trace-on)
                        (make-trace machine true pc))
                    ((eq? (car inst) 'trace-off)
                        (make-trace machine false pc))
                    (else
                        (make-execution-procedure-regsim inst labels machine pc flag stack ops))
                )
            ))

        ; i really don't feel like fiddling with (execute) again. i think this'll work...
        ; wrap ALL execution procedures with a check for trace            
        (lambda ()
        
            (if (machine 'trace?)
                (begin 
                    (newline)
                    (display inst)
                )
            )   

            (proc)
        )
    )
)
    

(define (make-trace machine value pc)
    (lambda ()                                                          ; generate execution procedure
        ((machine 'set-trace!) value)
        (advance-pc pc)
    )
)


(load "ch5-regsim.scm")

; overrides
(define make-new-machine-regsim make-new-machine) (define make-new-machine make-new-machine-5.16)
(define make-execution-procedure-regsim make-execution-procedure) (define make-execution-procedure make-execution-procedure-5.16)

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
; seems to work
; but it's pretty worthless without being able to print register values too... is that what breakpoints are for?
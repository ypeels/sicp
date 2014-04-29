; Extreme Overkill
; c.  (restore y) puts into y the last value saved from y regardless of what other registers were saved after 
;       y and not restored. Modify the simulator to behave this way. You will have to associate a separate 
;       stack with each register. You should make the initialize-stack operation initialize all the register stacks. 


; starting point: (initialize-stack). 
    ; when is this ever called?? not in the existing regsim code
    ; i guess you just have to remember to call this yourself?
        ; ((machine 'stack) 'initialize-stack) outside the assembly program
        ; (perform (op initialize-stack)) inside the assembly program
            ; (make-operation-exp): (apply op (map (lambda (p) (p))) '()) should just call (op). should be fine.
            
            
; one BAD idea:
; modify the unmonitored version (the monitored version hasn't been introduced yet!)
; store register-specific stacks as a table of stacks
    ; i.e., mirroring the structure of register-table

    
; a better idea?
; use the existing (make-stack) API, and just add "stack-table" to (make-new-machine)!?
    ; this is a more "modular" modification
    ; sure, the changes to (make-save) and (make-restore) might not be as clean...
        ; but this prevents you from reinventing the wheel, or in this case, the stack
        ; this also means you can use the monitored stack no problem!
    ; doing it this way minimizes the amount of changes to existing code!
        ; in particular, the stack implementation is untouched!! this has to do with stack USAGE.
            ; yep, meteorgan modified (make-stack), and it looks like he had to change a LOT...?
            ; l0stman's solution is closer to mine - he modified the register-table. but i think he has a syntax error with his execution procedures??
    
    

; modified from ch5-regsim.scm - changes have been annotated on the right.
; TODO: fix initialize-stack and print-stack-statistics API, which is currently broken
    ; should print out/initialize ALL stacks in the table.
    ; would probably have to modify the base class... meh
(define (make-new-machine-5.11c)
    (let (  (machine (make-new-machine-regsim)) 
            (stack-table                                                      ; <----- new, by analogy with register-table. (user COULD in principle push/pop these!!)                       
                (list (list 'pc (make-stack)) (list 'flag (make-stack)))))
                                  
           
           
      ; overrides
      (define (allocate-register-5.11c name)
        (set! stack-table                                          
            (cons (list name (make-stack)) stack-table))
        ((machine 'allocate-register) name))                                ; defer to base class error-checking
              
              
      (define (lookup-stack name)                                           ; <----- new, by analogy with lookup-register                         
        (let ((val (assoc name stack-table)))                         
          (if val                                                        
              (cadr val)
              (error "Unknown stack:" name))))
              
                                         
      (define (dispatch message)
        (cond
        
            ; overrides
            ((eq? message 'allocate-register) allocate-register-5.11c)
                

        
            ; full breakdown
            ; (machine 'stack) is ONLY called from (update-insts!)
            ; the stack object is passed as an object to (make-execution-procedure)
            ; but ONLY (make-save) and (make-restore) actually use it further, and i CONTROL these!
            ;((eq? message 'stack) stack)  
            ((eq? message 'stack) 'unused-return-value)
            
            
            ; new
            ((eq? message 'get-stack) lookup-stack)
            
            ; punt
            (else (machine message))))

      dispatch))    
      
    
    
; by analogy with (get-register)
(define (get-stack machine stack-name)
    ((machine 'get-stack) stack-name))
    
(define (make-save-5.11c inst machine unused-argument pc) 
    (let ((stack (get-stack machine (stack-inst-reg-name inst))))
        (make-save-regsim inst machine stack pc)))

(define (make-restore-5.11c inst machine unused-argument pc)                         
    (let ((stack (get-stack machine (stack-inst-reg-name inst))))
        (make-restore-regsim inst machine stack pc))) 

    


(define (test-5.11c)

    ; first a regression test. yes indeed, it passes...
    (load "5.06-fibonacci-extra-push-pop.scm")
    (test-5.6-long)
    
    ; modify a non-trivial push-pop example (the factorial example from 5.2 will not do, since it HAS no push/pops...)
    ; how about the recursive exponentiation from 5.4, which is just factorial?
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
               (save n)                                      ; <---- extra, unbalanced push will not affect the program
               (assign n (op -) (reg n) (const 1))    
               (assign continue (label after-expt))    
               (goto (label expt-loop))    
             after-expt    
               ;(restore n) (restore n)                      ; but, of course, unbalanced pops will raise stack error
               (restore continue)                          
               (assign val (op *) (reg b) (reg val))          
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
    (display (get-register-contents recursive-expt-machine 'val)) ; 32, right? yeahh!!!
    
)
    
    
; override and run
(load "ch5-regsim.scm") 
(define make-new-machine-regsim make-new-machine) (define make-new-machine make-new-machine-5.11c) 
(define make-save-regsim make-save) (define make-save make-save-5.11c) 
(define make-restore-regsim make-restore) (define make-restore make-restore-5.11c) 
(test-5.11c)

; i think i'm finally starting to understand the mit/scheme philosophy
    ; "slow and steady", or "take the time to do it right", or "thoughtful", or "non-hacky"
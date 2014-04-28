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
    
    

; modified from ch5-regsim.scm - changes have been annotated on the right.
(define (make-new-machine-5.11c)
  (let ((pc (make-register 'pc))                                         
        (flag (make-register 'flag))                                     
        ;(stack (make-stack))                                               ; <---- commented out.
        (the-instruction-sequence '()))                                  
    (let ((the-ops                                                       
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))                  
                 ;;**next for monitored stack (as in section 5.2.4)
                 ;;  -- comment out if not wanted
                 (list 'print-stack-statistics                           
                       (lambda () (stack 'print-statistics)))))
          (stack-table                                                      ; <----- new, by analogy with register-table. (user COULD in principle push/pop these!!)                       
           (list (list 'pc (make-stack)) (list 'flag (make-stack))))        
          (register-table                                                
           (list (list 'pc pc) (list 'flag flag))))                         ; alternative: (list 'pc pc (make-stack)). BUT then more dependent code would change...
      (define (allocate-register name)                                      
        (if (assoc name register-table)                                  
            (error "Multiply defined register: " name)
            (begin                                                          
                (set! stack-table                                           ; <----- new, by analogy with register-table. why bother thinking??
                    (cons (list name (make-stack)) stack-table))                ; why modify (initialize-stack) when this is error-prone??
                (set! register-table
                      (cons (list name (make-register name))
                            register-table));)
            )
        )
        'register-allocated)
      (define (lookup-register name)                                     
        (let ((val (assoc name register-table)))                         
          (if val                                                        
              (cadr val)
              (error "Unknown register:" name))))
      (define (lookup-stack name)                                           ; <----- new, by analogy with lookup-register                         
        (let ((val (assoc name stack-table)))                         
          (if val                                                        
              (cadr val)
              (error "Unknown stack:" name))))
      (define (execute)
        (let ((insts (get-contents pc)))                                 
          (if (null? insts)
              'done
              (begin                                                     
                ((instruction-execution-proc (car insts)))               
                (execute)))))                                            
      (define (dispatch message)
        (cond ((eq? message 'start)                                      
               (set-contents! pc the-instruction-sequence)
               (execute))
              ((eq? message 'install-instruction-sequence)               
               (lambda (seq) (set! the-instruction-sequence seq)))
              ((eq? message 'allocate-register) allocate-register)       
              ((eq? message 'get-register) lookup-register)              
              ((eq? message 'install-operations)                         
               (lambda (ops) (set! the-ops (append the-ops ops))))
              
              ; full breakdown
              ; (machine 'stack) is ONLY called from (update-insts!)
              ; the stack object is passed as an object to (make-execution-procedure)
              ; but ONLY (make-save) and (make-restore) actually use it further, and i CONTROL these!
              ;((eq? message 'stack) stack)                                 
              ((eq? message 'stack) 'unused-return-value)
              
              ((eq? message 'get-stack) lookup-stack)                       ; <----- new, by analogy with get-register
              
              ((eq? message 'operations) the-ops)                        
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))    
      
    
    
; ok, so (push) and (pop) are ONLY called inside (save) and (restore).
    ; can keep the syntax from part b: (push (<name> . <value>))
    ; but the (push) and (pop) convenience functions are going to have to do something different.
    
; by analogy with (get-register)
(define (get-stack machine stack-name)
    ((machine 'get-stack) stack-name))
    
(define (make-save-5.11c inst machine unused-argument pc)   ; kept unused-argument to minimize changes to existing code                         
  ;(let ((reg (get-register machine
  ;                         (stack-inst-reg-name inst)));)
  (let ((name (stack-inst-reg-name inst)))
    (let (  (reg (get-register machine name))
            (stack (get-stack machine name))
            )

        (lambda ()        
          (push stack (get-contents reg))         ;(push stack reg) ; no need to modify this, though!!          
          (advance-pc pc));))                                             
    )
  )
)

(define (make-restore-5.11c inst machine unused-argument pc)                         
  ;(let ((reg (get-register machine
  ;                         (stack-inst-reg-name inst)));)
  (let ((name (stack-inst-reg-name inst)))
    (let (  (reg (get-register machine name))
            (stack (get-stack machine name))
            )
        (lambda ()    
          (set-contents! reg (pop stack))      ; (pop! stack reg) ; modifies stack AND reg. ah, that's a nice and pleasing symmetry      
          (advance-pc pc));))
    )
  )
)
    


(define (test-5.11c)

    ; first a regression test. yes indeed, it passes...
    (load "5.06-fibonacci-extra-push-pop.scm")
    (test-5.6-long)
)
    
    
; override and run
(load "ch5-regsim.scm") (define make-new-machine make-new-machine-5.11c) (define make-save make-save-5.11c) (define make-restore make-restore-5.11c) (test-5.11c)


; (set-breakpoint <machine> <label> <n>)
; ohhh <n> is the OFFSET AFTER THE LABEL

; for simplicity, let's only implement this OUTSIDE the assembly code, as in 5.18.

; however, labels are only accessible at ASSEMBLY time??
    ; would it be easier to modify instructions and store labels alongside them???
    ; i still think it'd be easier to NOT throw away the label list in (assemble)
        ; you could have the (receive) in (assemble) return (cons insts labels)
        ; then you'd have to modify (make-machine) to install its instruction sequence AND label list.
    
(define (assemble-5.19 controller-text machine)   
  (extract-labels controller-text            
    (lambda (insts labels)                   
      (update-insts! insts labels machine)   
      
      ;insts)))                                                                     ; <---- changed
      (cons insts labels))))
      
      
(define (make-machine-5.19 register-names ops controller-text)            
  (let ((machine (make-new-machine)))                                
    (for-each (lambda (register-name)                                
                ((machine 'allocate-register) register-name))      
              register-names)      
    ((machine 'install-operations) ops)                              
    
    ;((machine 'install-instruction-sequence) (assemble controller-text machine))   ; <---- changed                              
    (let ((insts-and-labels (assemble controller-text machine)))
        ((machine 'install-instruction-sequence) (car insts-and-labels))
        ((machine 'install-label-list) (cdr insts-and-labels))
    )
    
    machine))                                                        
    
    
; clearly, maintain a list of breakpoints in the machine
    ; each breakpoint would just be a pointer to the corresponding pc
    ; disallow duplicates, for simplicity (do a memq before inserting a new breakpoint)
        ; (append!) and (remove!) ?
    ; simplest and least efficient implementation would scan the entire breakpoint list at the start of (execute)
    
(define (make-new-machine-5.19)
    (let* ( (machine (make-new-machine-regsim))
            (the-label-list '())
            (the-breakpoint-list '())
            (local-instruction-sequence '())
            (pc ((machine 'get-register) 'pc))
            )
            
        
            
        ; override - modified from regsim's (execute)
        (define (execute-5.19)
            (let ((insts (get-contents pc)))  
                (cond
                    ((null? insts)
                        'done)
                    ((have-breakpoint-at-location? insts) ; here's where my knowledge of the assembler's data structures should pay off
                        (display 
                            (label-and-offset-breakpoint 
                                (breakpoint-at-location insts)
                            )
                        )
                        (newline)
                        (label-and-offset-breakpoint 
                            (breakpoint-at-location insts))                        
                    )
                    (else
                        (begin     
                            ((instruction-execution-proc (car insts)))           
                            (execute-5.19)
                        )
                    ) 
                )
            )
        )
                  
        
                  
            
        ; public procedures (can be invoked directly by messages)
        (define (set-breakpoint! label offset)
            (manipulate-breakpoint!
                label
                offset
                (lambda (loc) (not (have-breakpoint-at-location? loc)))
                (lambda (loc)
                    (set! 
                        the-breakpoint-list 
                        (cons (make-breakpoint label offset loc) the-breakpoint-list)
                    )
                )
                "Duplicate breakpoint not set"
            )
        )
        
        (define (cancel-breakpoint! label offset)
            (manipulate-breakpoint!
                label
                offset
                have-breakpoint-at-location?
                (lambda (loc)
                    (set!
                        the-breakpoint-list
                        (filter 
                            (lambda (bp) (not (eq? loc (location-breakpoint bp))))
                            the-breakpoint-list
                        )
                    )
                )
                "Could not delete non-existent breakpoint"
            )
        )
        
        
        
        ; private procedures 
        (define (manipulate-breakpoint! label offset good? good-action bad-warning)
            (let ((breakpoint-location (find-breakpoint-location label offset)))
                (cond
                    ((null? breakpoint-location)
                        (error "Offset out of range" label offset))
                    ((good? breakpoint-location)
                        (good-action breakpoint-location))
                    (else
                        (display "WARNING - ")
                        (display bad-warning)
                        (display ": ")
                        (display label)
                        (display " + ")
                        (display offset)
                        (newline)
                    )
                )
            )
            'done
        )
        
        ; returns pointer to remaining instruction list starting at label + offset
            ; or '() if this runs out of range
        (define (find-breakpoint-location label offset)        
            (define (iter remaining-instructions n)
                (cond
                    ((< n 0)
                        (error "No negative offsets! -- GET-INSTRUCTIONS" label offset))
                    ((or (null? remaining-instructions) (= n 0))
                        remaining-instructions)
                    (else
                        (iter (cdr remaining-instructions) (- n 1)))
                )
            )
            (iter (lookup-label the-label-list label) offset)
        )
        
        (define (make-breakpoint label offset location)
            (list location label offset)) ; location is first entry so that (have-breakpoint?) can just use assoc
            
        (define (location-breakpoint breakpoint)
            (car breakpoint))
            
        (define (label-and-offset-breakpoint breakpoint)
            (list (cadr breakpoint) '+ (caddr breakpoint)))
        
        (define (breakpoint-at-location location)
            (assoc location the-breakpoint-list)) ; inefficient, since it uses equal? instead of eq? - meh
        
        (define (have-breakpoint-at-location? location)
            (breakpoint-at-location location))  ; exploit default value of assoc
            

            
        
        
        
            
        ; expose public API    
        (define (dispatch message)
            (cond
                ; this MUST be overridden, since base class's (execute) does NOT support breakpoints!
                ((eq? message 'start) 
                    (set-contents! pc local-instruction-sequence)
                    (dispatch 'proceed)) ;(execute-5.19))
                
                ; override because 'start needs a pointer to the instruction sequence initialize pc
                ((eq? message 'install-instruction-sequence)
                    (lambda (seq)
                        (set! local-instruction-sequence seq)
                        ((machine 'install-instruction-sequence) seq)
                    )
                )
                
                
                ; alyssa's requested API                 
                ((eq? message 'set-breakpoint) set-breakpoint!)                    
                ((eq? message 'cancel-breakpoint) cancel-breakpoint!)  
                ((eq? message 'cancel-all-breakpoints)
                    (set! the-breakpoint-list '()) ; easy!   
                    'done) 
                    
                ; can't just be (execute), cuz that'd freeze on the breakpoint forever!
                ((eq? message 'proceed) 
                    (let ((insts (get-contents pc)))
                        (if (null? insts)
                            'goodbye-world
                            (begin
                                ; execute the code at the breakpoint and proceed past it
                                ; better alternative: (step), which would be useful for users too
                                ((instruction-execution-proc (car insts)))  
                                (execute-5.19)
                            )
                        )
                    )
                )
                                                                            
                
                ; required by (make-machine-5.19)
                ; persistently store (a pointer to?) the label list generated by assembly
                ; should be a list of (label-text . pc)
                ; no error-checking, just like 'install-instruction-sequence
                ((eq? message 'install-label-list) 
                    (lambda (labels) (set! the-label-list labels)))
                    

                
                
                ; punt to base class
                (else (machine message))
            )
        )
        dispatch
    )
)

; ok, all that's left now is to actually implement the breakpoints' functionality...

    
; alyssa's requested syntactic sugar
(define (set-breakpoint machine label offset)
    ((machine 'set-breakpoint) label offset))
    
(define (cancel-breakpoint machine label offset)
    ((machine 'cancel-breakpoint) label offset))
    
(define (cancel-all-breakpoints machine)
    (machine 'cancel-all-breakpoints))
    
(define (proceed-machine machine)
    (machine 'proceed)
    'done
)

    
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
; overrides
(load "ch5-regsim.scm")
(define assemble assemble-5.19)
(define make-machine make-machine-5.19)
(define make-new-machine-regsim make-new-machine) (define make-new-machine make-new-machine-5.19)



(define (regression-test-5.19)
    (load "5.06-fibonacci-extra-push-pop.scm")
    (test-5.6-long)
)

(define (unit-test-5.19)

    (define fib-machine (make-fib-machine-5.6))
    ;(set-breakpoint fib-machine 'nonexistent-label 0) ; error: label does not exist
    ;(set-breakpoint fib-machine 'immediate-answer 2) ; error: offset out of range
    ;(set-breakpoint fib-machine 'immediate-answer 0) (set-breakpoint fib-machine 'immediate-answer 0) ; warning: duplicate breakpoint not set
    ;(cancel-breakpoint fib-machine 'immediate-answer 0) ; warning: could not delete non-existent breakpoint
    ;(set-breakpoint fib-machine 'immediate-answer 0) ; ok for testing, but boring
    ;(cancel-breakpoint fib-machine 'immediate-answer 0)
    (set-breakpoint fib-machine 'afterfib-n-2 4)
    (set-register-contents! fib-machine 'n 7)
    (fib-machine 'start)
)

; from 5.11c; kept at global scope so you can continue to probe it
(define recursive-expt-machine-5.19 (make-machine          
                                                      
    '(b n val continue)                               
    (list
        (list '= =)
        (list '- -)
        (list '* *)
    )
    '(                                                
           (assign continue (label expt-done))         
         expt-loop  
         expt-loop-extra-label
           (test (op =) (reg n) (const 0))            
           (branch (label base-case))    
           (save continue)                                
           (assign n (op -) (reg n) (const 1))    
           (assign continue (label after-expt))    
           (goto (label expt-loop))    
         after-expt    
           (restore continue)                
           (assign val (op *) (reg b) (reg val))                   
           (goto (reg continue))                       
         base-case    
           (assign val (const 1))                      
           (goto (reg continue))                       
         expt-done    
    )    
))


(define (test-5.19)

    (display "Let's step through 2**5...\n")
    (set-register-contents! recursive-expt-machine-5.19 'b 2)
    (set-register-contents! recursive-expt-machine-5.19 'n 5)
    (set-breakpoint recursive-expt-machine-5.19 'after-expt 2)
    
    (start recursive-expt-machine-5.19)
    
    (define (iter)    
        (display "val = ") (display (get-register-contents recursive-expt-machine-5.19 'val)) (newline)
        ;(display "n left = ") (display (get-register-contents recursive-expt-machine-5.19 'n)) (newline) ; always 0
        (proceed-machine recursive-expt-machine-5.19)
    )
    
    (iter)
    (iter)
    (iter)
    (iter)
    (iter)
    (iter)
    (iter)
    
    
)
    
(define (test)
    (proceed-machine fib-machine)
    (display "val = ") (display (get-register-contents fib-machine 'val)) (newline)  
    'ok    
)

(define t test)




(regression-test-5.19)
(test-5.19)




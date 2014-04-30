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
    (let (  (machine (make-new-machine-regsim))
            (the-label-list '())
            (the-breakpoint-list '())
            )
            
        ; public procedures (can be invoked directly by messages)
        (define (set-breakpoint! label offset)
            (manipulate-breakpoint!
                label
                offset
                (lambda (breakpoint) (not (have-breakpoint? breakpoint)))
                (lambda (breakpoint)
                    (set! 
                        the-breakpoint-list 
                        (cons breakpoint the-breakpoint-list)
                    )
                )
                "Duplicate breakpoint not set"
            )
        )
        
        (define (cancel-breakpoint! label offset)
            (manipulate-breakpoint!
                label
                offset
                have-breakpoint?
                (lambda (breakpoint)
                    (set!
                        the-breakpoint-list
                        (filter (lambda (x) (not (eq? x breakpoint))) the-breakpoint-list)
                    )
                )
                "Could not delete non-existent breakpoint"
            )
        )
        
        ; private procedures 
        (define (manipulate-breakpoint! label offset good? good-action bad-warning)
            (let ((breakpoint (find-breakpoint-location label offset)))
                (cond
                    ((null? breakpoint)
                        (error "Offset out of range" label offset))
                    ((good? breakpoint)
                        (good-action breakpoint))
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
        
        (define (have-breakpoint? breakpoint)
            (memq breakpoint the-breakpoint-list))          

            
        
        
        
            
            
        (define (dispatch message)
            (cond
                ; the only override 
                ; - actually, this need not be an override, since (proceed-machine) is a SEPARATE procedure.
                ; probably check if pc is '*unassigned*
                ;((eq? message 'start) (error "empty stub - execute"))
                ((eq? message 'start) (machine 'start))
                    
                
                ; required by (make-machine-5.19)
                ; persistently store (a pointer to?) the label list generated by assembly
                ; should be a list of (label-text . pc)
                ; no error-checking, just like 'install-instruction-sequence
                ((eq? message 'install-label-list) 
                    (lambda (labels) (set! the-label-list labels)))
                    
                ((eq? message 'cancel-all-breakpoints)
                    (set! the-breakpoint-list '())) ; easy!
                    
                ((eq? message 'set-breakpoint) set-breakpoint!)
                    
                ((eq? message 'cancel-breakpoint) cancel-breakpoint!)
                
                
                ; punt to base class
                (else (machine message))
            )
        )
        dispatch
    )
)

    
; alyssa's requested syntactic sugar
(define (set-breakpoint machine label offset)
    ((machine 'set-breakpoint) label offset))
    
(define (cancel-breakpoint machine label offset)
    ((machine 'cancel-breakpoint) label offset))
    
(define (cancel-all-breakpoints machine)
    (machine 'cancel-all-breakpoints))
    
    
    
    
    
    
    
; overrides
(load "ch5-regsim.scm")
(define assemble assemble-5.19)
(define make-machine make-machine-5.19)
(define make-new-machine-regsim make-new-machine) (define make-new-machine make-new-machine-5.19)

; regression test
(load "5.06-fibonacci-extra-push-pop.scm")
(test-5.6-long)

; "unit testing"
(define fib-machine (make-fib-machine-5.6))
;(set-breakpoint fib-machine 'nonexistent-label 0) ; error: label does not exist
;(set-breakpoint fib-machine 'immediate-answer 2) ; error: offset out of range
;(set-breakpoint fib-machine 'immediate-answer 0) (set-breakpoint fib-machine 'immediate-answer 0) ; warning: duplicate breakpoint not set
;(cancel-breakpoint fib-machine 'immediate-answer 0) ; warning: could not delete non-existent breakpoint
(set-breakpoint fib-machine 'immediate-answer 0) ; i am here
(cancel-breakpoint fib-machine 'immediate-answer 0)




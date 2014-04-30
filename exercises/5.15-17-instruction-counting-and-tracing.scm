; initially had these separate
; but nooo, 5.17 wants it to be cumulative...


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Exercise 5.15: instruction counting

; a facade once again, to avoid code duplication.
(define (make-make-new-machine-5.15 old-factory)                
    (lambda ()                           
        (let (  (machine (old-factory))                         ; base class / delegate
                (instruction-count 0)
                (local-instruction-sequence '())                            ; local pointer for 'start
                )
                
            (define (execute)
                (let ((insts (get-contents ((machine 'get-register) 'pc)))) ;pc)))                              
                  (if (null? insts)        
                      'done        
                      (begin  
                        (set! instruction-count (+ instruction-count 1))    ; <---- 1 new line
                        ;(display instruction-count)
                        ((instruction-execution-proc (car insts)))                    
                        (execute))))) 

            (define (print-and-reset-count!)
                (display "\nInstructions executed: ")
                (display instruction-count)
                (set! instruction-count 0)
            )
                
            (define (dispatch message)
              (cond 
                    ; overrides
                    ((eq? message 'start) 
                        (set-contents! ((machine 'get-register) 'pc) local-instruction-sequence)
                        (execute) 
                    )
                    
                    ((eq? message 'install-instruction-sequence)    ; required by 'start
                        (lambda (seq)
                            (set! local-instruction-sequence seq)
                            ((machine 'install-instruction-sequence) seq)
                        )
                    )                        
                    
                    ; new
                    ((eq? message 'print-instruction-count) (print-and-reset-count!))
                    
                    ; base class
                    (else (machine message))))
            dispatch
        )
    )
)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Exercise 5.16: instruction tracing
(define (make-make-new-machine-5.16 old-factory)
    (lambda ()
        (let (  (machine (old-factory));make-new-machine-regsim))
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
)

; new special forms trace-on and trace-off.
(define (make-make-execution-procedure-5.16 old-proc);(make-execution-procedure-5.16 inst labels machine pc flag stack ops) 
    (lambda (inst labels machine pc flag stack ops)
        (let ((proc (cond
                        ((eq? (car inst) 'trace-on)
                            (make-trace machine true pc))
                        ((eq? (car inst) 'trace-off)
                            (make-trace machine false pc))
                        (else
                            (old-proc inst labels machine pc flag stack ops))
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
)
    

(define (make-trace machine value pc)
    (lambda ()                                                          ; generate execution procedure
        ((machine 'set-trace!) value)
        (advance-pc pc)
    )
)

; moved in here to share with 5.17
(define (test-5.16)

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
               (trace-off)                                  ; <------------ new                
               (test (op =) (reg n) (const 0))            
               (branch (label base-case))    
               (save continue)                                
               (assign n (op -) (reg n) (const 1))    
               (assign continue (label after-expt))    
               (trace-on)                                   ; <------------ new - labels should display in 5.17
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

    (set-register-contents! recursive-expt-machine 'b 2)
    (set-register-contents! recursive-expt-machine 'n 5)
    (start recursive-expt-machine)
    (display "\nAnd what is 2**5? ")
    (display (get-register-contents recursive-expt-machine 'val)) 
    ; seems to work
    ; but it's pretty worthless without being able to print register values too... is that what breakpoints are for?
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Exercise 5.17: instruction tracing that prints labels too

; "You will have to make the simulator retain the necessary label information. "
    ; OR, i could just rescan the label list at each instruction?
        ; not QUITE in the "assembler" spirit, where everything is done at assembly time
        
        
; how about scanning at assembly time, and binding the label text into the execution procedure??
    ; i don't really see what this has to do with instruction counting...
        ; oh, i see, i guess i was supposed to implement that in (make-execution-procedure) too?
    ; actually, you don't HAVE the full information at assembly time...?
        ; for example, the fibonacci program starts with (assign continue <label>) before <label> is declared
    ; therefore, the CLEANEST idea seems to be to scan the label list at EXECUTION time
        ; this indeed could conflict with my instruction counting in (execute).
        
        
; "inverse" of (lookup-label), at the same level of abstraction (i.e., raw table manipulation...)
    ; unfortunately, i think this is CONCEPTUALLY flawed, because labels aren't initialized yet...?
    ; how about scanning the label list EVERY time
(define (labels-for-instruction inst labels)

    ; http://www.gnu.org/software/mit-scheme/documentation/mit-scheme-ref/File-Ports.html
    (define file (open-output-file "test.txt" #t)) ; second argument is append

    
    ; good news: labels = (list (<label> (<instruction-text> . <xx>)) )
        ; <xx> = either '(), or is initialized to an execution procedure
        ; but either way, should be able to use pointer equality (eq?) to see if it's label printing time
    (display (instruction-text inst) file ) 
    ;(display (map (lambda (x) (car x)) labels) file) 
    (if (not (null? labels)) (begin (display "\nLabel: " file) (display (car labels) file)))
    ;(display (map (lambda (x) (cdar x)) labels)
    (display "\n\n" file)
    (close-all-open-files)
    
    
    (cond
        ((null? labels)
            '())
        ((eq? inst (cdar labels)) ; damn you scheme (impenetrable error message for cadr)
            (display "\nfound label: ") (display (caar labels))
            (cons (caar labels) (labels-for-instruction inst (cdr labels))))
        (else
            (labels-for-instruction inst (cdr labels)))
    )
)
            
        
        
; this approach doesn't work DIRECTLY
    ; the "inst" input into (make-execution-procedure) is JUST the text...
    ; have to modify (update-insts!)!
(define (make-make-execution-procedure-5.17 old-proc)

    (define (print-all-labels label-list)
        (if (null? label-list)
            'done
            (begin
                (display "Label: ")
                (display (car label-list))
                (newline)
                (print-all-labels (cdr label-list))
            )
        )
    )

    (lambda (inst-and-exec-proc labels machine pc flag stack ops)
        (let (  
                ; no new special forms, so just call (old-proc) unconditionally...
                (proc (old-proc 
                    (instruction-text inst-and-exec-proc)                   ; but this argument processes differently
                    labels machine pc flag stack ops))     
                (inst-labels (labels-for-instruction inst-and-exec-proc labels)); but scan the label list at assembly time
                )                                                               ; inefficient! scans the ENTIRE list each time...

            (lambda ()            
                (print-all-labels inst-labels)
                (proc)            
            )        
        )
        
    )
)



(define (update-insts-5.17! insts labels machine)        
  (let ((pc (get-register machine 'pc))             
        (flag (get-register machine 'flag))
        (stack (machine 'stack))
        (ops (machine 'operations)))
    (for-each                                       
     (lambda (inst)
       (set-instruction-execution-proc!             
        inst
        (make-execution-procedure                
         ;(instruction-text inst) labels machine
         inst labels machine                                                ; requires (make-make-execution-procedure-5.17)!
         pc flag stack ops)))
     insts)))
     
     
; modify (execute)??
; BUT there is another problem with this, and that is that the label list is only used internally and
    ; THROWN AWAY after (assemble)

     
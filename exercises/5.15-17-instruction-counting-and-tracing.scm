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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Exercise 5.17: instruction tracing that prints labels too

; "You will have to make the simulator retain the necessary label information. "
    ; OR, i could just rescan the label list at each instruction?
        ; not QUITE in the "assembler" spirit, where everything is done at assembly time
        
        
; how about scanning at assembly time, and binding the label text into the execution procedure??
    ; i don't really see what this has to do with instruction counting...
        ; oh, i see, i guess i was supposed to implement that in (make-execution-procedure) too?
        
        
; "inverse" of (lookup-label), at the same level of abstraction (i.e., raw table manipulation...)
(define (labels-for-instruction inst labels)
    (cond
        ((null? labels)
            '())
        ((eq? inst (cdar labels)) ; damn you scheme (impenetrable error message for cadr)
            (cons (caar labels) (labels-for-instruction inst (cdr labels))))
        (else
            (labels-for-instruction inst (cdr labels)))
    )
)
            
        
        
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

    (lambda (inst labels machine pc flag stack ops)
        (let (  (proc (old-proc inst labels machine pc flag stack ops))     ; no new special forms 
                (inst-labels (labels-for-instruction inst labels))          ; but scan the label list at assembly time
                )                                                               ; inefficient! scans the ENTIRE list each time...

            (lambda ()            
                (print-all-labels inst-labels)
                (proc)            
            )        
        )
        
    )
)
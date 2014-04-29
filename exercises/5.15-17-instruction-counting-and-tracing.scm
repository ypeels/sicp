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
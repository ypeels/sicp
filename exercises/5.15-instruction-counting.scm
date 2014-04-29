; a facade once again, to avoid code duplication.
(define (make-new-machine-5.15)                                           
    (let (  (machine (make-new-machine-regsim))                         ; base class / delegate
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



(load "ch5-regsim.scm")
(load "5.06-fibonacci-extra-push-pop.scm")
(define make-new-machine-regsim make-new-machine) (define make-new-machine make-new-machine-5.15)

; regression test
(test-5.6-long)

(define fib-machine (make-fib-machine-5.6))

(define (test n)
    (display "\n\nFib of ")
    (display n)
    (set-register-contents! fib-machine 'n n)
    (start fib-machine)
    (fib-machine 'print-instruction-count)
)

(test 0)    ; 5
(test 1)    ; 5
(test 2)    ; 26
(test 3)    ; 47
(test 4)    ; 89
 
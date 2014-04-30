(define (make-register-5.18 name)
    (let (  (register (make-register-regsim name))
            (trace false)
            )
         
        ; override
        (define (set-register value)
            (if trace
                (begin
                    (display "Register ")
                    (display name)
                    (display ": ")
                    (display (register 'get))
                    (display " -> ")
                    (display value)
                    (newline)
                )
            )
            ((register 'set) value)
        )
    
        (define (dispatch message)
            (cond
                ; overrides
                ((eq? message 'set) set-register)
            
                ; new messages
                ((eq? message 'trace-on) (set! trace true))
                ((eq? message 'trace-off) (set! trace false))
                
                ; punt to delegate (actually, all that's left is 'get...
                (else (register message))
            )
        )
        dispatch
    )
)

; "Extend the interface to the machine model to permit you to turn tracing on and off for 
; designated machine registers. "
    ; uh, well, you can do it directly by accessing the registers
    ; do they just want stupid syntactic sugar like (register-trace-on)?
    ; i think it'd be more useful to be able to turn trace on INSIDE the assembly code, like i did for (trace-on)
        ; but meteorgan didn't bother for 5.16 OR this exercise, so neither will i, this time...
        ; the recipe is to modify (make-execution-procedure) to admit a new instruction type
        ; the execution procedure would flip the trace switch on the register
        ; i guess the problem with doing it IN ASM is that you modify the program itself
            ; the instruction count, for example, would be different for "release" builds
    ; and in fact, i think it's a lot CLEARER what you're doing when you use message passing explicitly
        ; if you're using a sugared function, who KNOWS what operation you're doing, exactly
            ; when done explicitly, it's clear you're calling a "member function"

; here's the stupid syntactic sugar, but i refuse to use it...
;(define (trace-on-register machine register-name)
;    ((get-register machine register-name) 'trace-on))
;(define (trace-off-register machine register-name)
;    ((get-register machine register-name) 'trace-off))





(define (test-5.18)

    (load "5.06-fibonacci-extra-push-pop.scm")
    
    ; regression test
    (test-5.6-long)
    
    (define (test n)
        (let ((machine (make-fib-machine-5.6)))
            (set-register-contents! machine 'n n)
            (((machine 'get-register) 'val) 'trace-on)
            (machine 'start) ; i really prefer this to (start machine) - it's like machine.start().
            (display (((machine 'get-register) 'val) 'get))
        )
    )
    
    (test 3) ; should be 2
)

(load "ch5-regsim.scm") (define make-register-regsim make-register) (define make-register make-register-5.18) (test-5.18)
            
            
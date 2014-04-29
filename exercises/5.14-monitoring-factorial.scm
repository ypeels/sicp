(define (make-factorial-machine) (make-machine
    '(continue n val)
    (list (list '= =) (list '- -) (list '* *))
    '(
       ; from Figure 5.11
       (assign continue (label fact-done))     ; set up final return address
     fact-loop
       (test (op =) (reg n) (const 1))
       (branch (label base-case))
       ;; Set up for the recursive call by saving n and continue.
       ;; Set up continue so that the computation will continue
       ;; at after-fact when the subroutine returns.
       (save continue)
       (save n)
       (assign n (op -) (reg n) (const 1))
       (assign continue (label after-fact))
       (goto (label fact-loop))
     after-fact
       (restore n)
       (restore continue)
       (assign val (op *) (reg n) (reg val))   ; val now contains n(n - 1)!
       (goto (reg continue))                   ; return to caller
     base-case
       (assign val (const 1))                  ; base case: 1! = 1
       (goto (reg continue))                   ; return to caller
     fact-done
    )
))



(define (test-5.14)

    (load "ch5-regsim.scm")

    ; this is my time-tested alternative to their suggestion to "modify the machine so that 
    ; it repeatedly reads a value for n, computes the factorial, and prints the result"
    (define (test n)
        (let ((machine (make-factorial-machine)))    
            
            ; you don't HAVE to augment the machine to initialize the stack
            ; just reach in and do it directly
            
            (set-register-contents! machine 'n n)
            ((machine 'stack) 'initialize)
            (start machine)
            (display "\n\nFactorial of ")(display n)
            ((machine 'stack) 'print-statistics)
        )
    )
    
    ;(test 0) ; crashes!
    (test 1)
    ; total pushes = 0 maximum depth = 0
    
    (test 2)
    ; total pushes = 2 maximum depth = 2
    
    (test 3)
    ; total pushes = 4 maximum depth = 4
    
    (test 4)
    ; total pushes = 6 maximum depth = 6
    
    (test 20)
    
    ; uh, 2(n-1)? boy they weren't kidding it's just linear...
    ; this is transparent from the assembly code! come on...
)
;(test-5.14)
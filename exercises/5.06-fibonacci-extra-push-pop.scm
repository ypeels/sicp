(load "ch5-regsim.scm")

(define (make-fib-machine-5.6) (make-machine

    '(n val continue)
    (list
        (list '< <)
        (list '- -)
        (list '+ +)
    )
    '(

          (assign continue (label fib-done))
        fib-loop
          (test (op <) (reg n) (const 2))
          (branch (label immediate-answer))
          ;; set up to compute Fib(n - 1)
          (save continue)
          (assign continue (label afterfib-n-1))
          (save n)                           ; save old value of n
          (assign n (op -) (reg n) (const 1)); clobber n to n - 1
          (goto (label fib-loop))            ; perform recursive call
        afterfib-n-1                         ; upon return, val contains Fib(n - 1)
          (restore n)
         ;(restore continue)                                                        ; <---------- superfluous push/pop pair.
          ;; set up to compute Fib(n - 2)                                           ;         |
          (assign n (op -) (reg n) (const 2))                                       ;         |
         ;(save continue)                                                           ; <-------|
          (assign continue (label afterfib-n-2))
          (save val)                         ; save Fib(n - 1)
          (goto (label fib-loop))
        afterfib-n-2                         ; upon return, val contains Fib(n - 2)
          (assign n (reg val))               ; n now contains Fib(n - 2)
          (restore val)                      ; val now contains Fib(n - 1)
          (restore continue)
          (assign val                        ;  Fib(n - 1) +  Fib(n - 2)
                  (op +) (reg val) (reg n)) 
          (goto (reg continue))              ; return to caller, answer is in val
        immediate-answer
          (assign val (reg n))               ; base case:  Fib(n) = n
          (goto (reg continue))
        fib-done
    )

))

(load "1.19-fast-fibonnaci.scm")
(define (test-fib-5.6 n)
    ; do NOT load regsim - allows reuse of this machine factory in other files where regsim has been modified
    
    (define machine (make-fib-machine-5.6))
    (set-register-contents! machine 'n n)
    (start machine)
    
    (newline)
    (display "Fib (") (display n) (display ")\n")
    (display (get-register-contents machine 'val))
    (display " from regsim\n")
    (display (fast-fib-iterative n)) 
    (display " exact\n")
    
)


(define (test-5.6)
    (load "ch5-regsim.scm")

    (test-fib-5.6 7)
    (test-fib-5.6 11)
    
      ; 13, correctly, with and without the superfluous push/pop.
)
(test-5.6)


; the (save continue) is GOOD PRACTICE, before a "subroutine call", and matched with a (restore continue) afterwards.
    ; ben bitbiddle basically proposes merging the end of 1 call with the beginning of another.
    ; this is a LOW-LEVEL assembly code optimization, best left to optimizing compilers...
    ; the price of the SLIGHT performance gain is LESS MODULAR code that is harder to modify/refactor/understand.

    
; the thing is, the "set up to compute" blocks were written as fairly independent, modular code

; ;; set up to compute Fib(n - 1)            ;; set up to compute Fib(n - 2) - reordered slightly to show parallelism     
; (save continue)                            (save continue)       
; (assign continue (label afterfib-n-1))     (assign continue (label afterfib-n-2))                
; (save n)                                   (save val)          
; (assign n (op -) (reg n) (const 1))        (assign n (op -) (reg n) (const 2))                    
; (goto (label fib-loop))                    (goto (label fib-loop))

; both subroutine calls (save continue) because it's THE RIGHT THING TO DO

; enrichment:
; Fib(n-1) saves n because it's the FIRST OF TWO calls for this n value.
    ; afterfib-n-1 does a (restore n) so that Fib(n-2) will be called with the same n.
    ; afterfib-n-1 also does (restore continue) because that fully POPS THE STACK pushed for the "subroutine call"
; Fib(n-2) saves val = Fib(n-1) result because it's the SECOND OF TWO calls.
    ; afterfib-n-2 will TRASH n as a temp register
    ; then it does (restore val) for symmetry.
        ; an assembly hacker might (restore n) instead, popping the old val into a DIFFERENT register, to save an instruction.
    


  
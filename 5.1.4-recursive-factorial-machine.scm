(load "5.2.4-ch5-regsim.scm")

; data path diagram Figure 5.11 on p. 511.

(define factorial-machine (make-machine ;registers primitives controller-text
    '(continue n val)
    (list
        (list '= =)
        (list '- -)
        (list '* *)
    )
    '(

        ; controller text copied from Figure 5.11
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


; To operate the machine, we put in register n the number whose factorial we wish to compute and start the machine.
(set-register-contents! factorial-machine 'n 5)
(start factorial-machine)

; When the machine reaches fact-done, the computation is finished and the answer will be found in the val register.
(display (get-register-contents factorial-machine 'val)) ; 120
; b.  (restore y) puts into y the last value saved on the stack, but only if that value was saved from y; 
;       otherwise, it signals an error.

; in the perhaps math-oriented Schemer's mind, this makes more sense
    ; you know, the same people to whom assignment and iteration are "strange"
    
; in other words, this modification is "Scheming" but not "assembling"
    ; it's interesting that you can make this modification
    ; but it's the right design choice to leave it out of the simulator
    
; this should still be doable with a small surgical modification


;(load "ch5-regsim.scm")


; overrides
(define (make-save-5.11b inst machine stack pc)                          
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      
      ;(push stack (get-contents reg))                              
      (push 
        stack
        (cons
            (stack-inst-reg-name inst)
            (get-contents reg)
        ))
      
      (advance-pc pc))))                                           

(define (make-restore-5.11b inst machine stack pc)                       
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
    
      ;(set-contents! reg (pop stack))                              
      (let* (   (name-and-value (pop stack))
                (name (car name-and-value))
                (value (cdr name-and-value))
            )
        (if (eq? name (stack-inst-reg-name inst))
            (set-contents! reg value)       
            (error "Popping to different register -- MAKE-RESTORE" name (stack-inst-reg-name inst))
        )
      )
      
      (advance-pc pc))))
      
(define (test-5.11b)
    
    ; regression test: this should still work
    (load "5.06-fibonacci-extra-push-pop.scm")
    (test-5.6-long)
    
    ; new: the exploit from part a shouldn't work anymore.
    (load "5.11a-stack-exploit.scm")
    (test-fib-5.11a 6) ; <--- should throw an error from make-restore
    (error "should never get here -- TEST-5.11B")
)
;(load "ch5-regsim.scm") (define make-save make-save-5.11b) (define make-restore make-restore-5.11b) (test-5.11b)
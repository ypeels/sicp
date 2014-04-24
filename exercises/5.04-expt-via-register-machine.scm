; a: recursive exponentiation      cf. factorial from 5.1.4
;(define (expt b n)                (define (factorial n)
;  (if (= n 0)                       (if (= n 1)
;      1                                 1
;      (* (expt b (- n 1)) b)))          (* (factorial (- n 1)) n)))

    ; termination condition is different because factorial exploits the n=1 multiplier
                                        ; really, factorial could have gone down to (if (= n 0) 1).
    ; and the base, of course, is FIXED in expt.
    
    
; so the data diagram is ALMOST identical to Figure 5.11, with the following changes:
    ; = checks (= n 0) instead of (= n 1)
    ; (* val b) instead of (* val n). n.b. (reg b) is "constant" - never modified during the run.
    ; thus, the left loop (* val b) is COMPLETELY DECOUPLED from the stack/n/continue apparatus
        ; the latter is just used by the controller to figure out when to stop pushing the left button.
        


(load "ch5-regsim.scm")

; likewise, we can simply modify the controller sequence for recursive factorial from 5.1.4.
(define recursive-expt-machine (make-machine            ; CHANGES FROM FACTORIAL
                                                        ; ------------------------------
    '(b n val continue)                                 ; added register b
    (list
        (list '= =)
        (list '- -)
        (list '* *)
    )
    '(                                                  
           (assign continue (label expt-done))          
         expt-loop                                      ; labels changed too
           (test (op =) (reg n) (const 0))              ; instead of (const 1)    
           (branch (label base-case))
           (save continue)                                                          
           ;(save n)                                    ; don't need to push n anymore!
           (assign n (op -) (reg n) (const 1))
           (assign continue (label after-expt))
           (goto (label expt-loop))
         after-expt
           ;(restore n)                                 ; balance push/pops
           (restore continue)                      
           (assign val (op *) (reg b) (reg val))        ; changed from (reg n) 
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
(display (get-register-contents recursive-expt-machine 'val)) ; 32, right? yes.
(newline)




; b. iterative exponentiation                           ; cf. factorial from Exercise 5.1
; (define (expt b n)                                    (define (factorial n)
;   (define (expt-iter counter product)                   (define (iter counter product)
;     (if (= counter 0)                                     (if (> counter n)
;         product                                               product
;         (expt-iter (- counter 1) (* b product))))             (iter (+ counter 1) (* counter product))))
;   (expt-iter n 1))                                      (iter 1 1))

; differences
    ; as if JUST to be obnoxious, they count UP in 5.1 but DOWN here.
        ; IC changes too, but that's not shown in the data path diagram OR the controller text

        
; differences in data diagram
    ; (=) 0 instead of (>) n
    ; - instead of +.
    ; (* product b) instead of (* product counter)
        ; this DECOUPLES the two halves, as in the recursive case
    
;
;        product              counter -----> (=) <---- 0
;         A  |                    A |
;         |  |     b              | |
;    p<-*(x) |     |             (x)|c<-+___
;         |  |     |              | |    \1/
;         |  |     |              | |     |
;         |  V     V              | V     V
;         | \---------/           |\---------/
;         |  \   *   /            | \   -   /        
;         |   -------             |  -------
;         |______|                |_____|
        

; modify the (fully refactored) controller sequence for recursive factorial from Exercise 5.2
(define iterative-expt-machine                                          ; CHANGES FROM FACTORIAL
    (make-machine                                                       ; ------------------------------
        '(b n counter product)                                          ; added register b    
        (list (list '* *) (list '- -) (list '= =))                      ; changed from +&> to -&=     
        '(
            (assign counter (reg n))                                    ; changed from (const 1) to (reg n)
            (assign product (const 1))
      
            test-counter
                (test (op =) (reg counter) (const 0))                   ; changed from (op >) ... (reg n)
                (branch (label expt-done))
                (assign product (op *) (reg product) (reg b))           ; changed from (reg n)
                (assign counter (op -) (reg counter) (const 1))         ; changed from (op -)
                (goto (label test-counter))
            expt-done

        )
    )
)

(set-register-contents! iterative-expt-machine 'b 5)
(set-register-contents! iterative-expt-machine 'n 4)
(start iterative-expt-machine)
(display (get-register-contents iterative-expt-machine 'product)) ; 625, right? yes.

; finally, i can't help taking a passing potshot at recursive-minded Schemers and point out the iterative machine is MUCH SIMPLER
    ; that is, our underlying computing hardware is MORE NATURALLY ITERATIVE than recursive. why fight that??
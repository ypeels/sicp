; Not really sure which language they want...
; 
; Note that we're deferring (black-boxing) the implementation of all operations...
; 
; Here's the first notation, although I doubt that's what they want.
; COULD use separate registers ts and tc for the sum/product, but that's not the spirit of this, is it?
;     - registers are few and precious
;     - 
;     - combining operations into shared t register makes the data flow harder to understand at a glance
; 
; (data-paths
;     (registers
;         ((name product)
;             (buttons ((name p<-t) (source (register t)))))
;         ((name t)
;             (buttons 
;                 ((name t<-*) (source (operation *)))
;                 ((name t<-+) (source (operation +)))
;             )
;         )            
;         ((name counter)
;             (buttons ((name c<-t) (source (register t)))))
;         ((name n)) ; no buttons
;     )
;     (operations
;         ((name *)
;             (inputs ((register product) (register counter))))
;         ((name +)
;             (inputs ((register counter) (constant 1))))
;         ((name >)
;             (inputs ((register counter) (register n))))
;     )
; )
;         
; (controller
;     test-counter
;         (test >)
;         (branch (label fact-done))
;         (t<-*)
;         (p<-t)
;         (t<-+)
;         (c<-t)
;         (goto (label test-counter))
;     fact-done
; )
            
    
; And here's the "assembly" version; much easier to write...
; Sols showed how to test this using (make-machine). A little premature, but I'd like to try it anyway...

(load "ch5-regsim.scm")

(define factorial-machine
    (make-machine ; register-names ops controller-text
        '(counter product t n)                          ; sols actually SKIP the intermediate register t. hmmmmm...
        (list (list '* *) (list '+ +) (list '> >))      ; oh actually, i guess t is unnecessary here, because counter update is INDEPENDENT of product!
        '(
            (assign counter (const 1))
            (assign product (const 1))

; here's my original answer            
; (controller        
            test-counter
                (test (op >) (reg counter) (reg n))
                (branch (label fact-done))
                (assign t (op *) (reg product) (reg counter))
                (assign product (reg t))
                (assign t (op +) (reg counter) (const 1))
                (assign counter (reg t))
                (goto (label test-counter))
            fact-done
;)

        )
    )
)




(set-register-contents! factorial-machine 'n 6)
(start factorial-machine)
(display (get-register-contents factorial-machine 'product)) ; 720. woohoo!

(newline)


;;  copy/pasted from sols http://community.schemewiki.org/?sicp-ex-5.2
; (define fact-machine 
;   (make-machine 
;    '(c p n) 
;    (list (list '* *) (list '+ +) (list '> >)) 
;    '((assign c (const 1)) 
;      (assign p (const 1)) 
;      test-n 
;      (test (op >) (reg c) (reg n)) 
;      (branch (label fact-done)) 
;      (assign p (op *) (reg c) (reg p))                                                ; no intermediate register...... oh, this is RIGHT.
;      (assign c (op +) (reg c) (const 1)) 
;      (goto (label test-n)) 
;      fact-done))) 
;  
; (set-register-contents! fact-machine 'n 5) 
; (start fact-machine) 
;  
; (display (get-register-contents fact-machine 'p) ) ; 120. hmmmmmm
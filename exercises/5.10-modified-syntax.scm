; Exercise 5.10.  Design a new syntax for register-machine instructions and modify the simulator to 
; use your new syntax. Can you implement your new syntax without changing any part of the simulator except 
; the syntax procedures in this section? 

; meteorgan adds a new special form (inc), but that's not what the question is asking for
; rather, it's like that mceval question that asked for a modification to the syntax
; - e.g., changing to a language with postfix notation


; well, i don't like how labels are asymmetric. i think they should be declared as, say, (label test-counter)
    ; but unfortunately, this syntax is hard-baked into (extract-label). meh.
    
; the full instruction set is on p. 513.
    ; well, (branch (label <name>)) and (goto (label <name>)) are redundant
        ; i propose (branch <name>) and (goto <name>)
        ; like, you don't say (assign (reg target) . <blah>), you just say (assign target . <blah>)
        ; you COULD similarly modify (test (op...)) and (perform (op...)), since the first argument there MUST be an operation
            ; the reason they make it explicit is because of (assign <reg> (label)) and (assign <reg> (op) <inputs>)
            
            
; meh, they didn't say to make GOOD, consistent, or judicious changes...
    ; you could, of course, change the keywords, but that's just silly
        ; or IS it? you could localize it to other languages, for instance...
    ; i GUESS their syntax on p. 513 is as good a tradeoff as you can get between concise and consistent...
        ; at the very least, you can't really increase one without decreasing the other...

(load "ch5-regsim.scm")

; overrides

; this is less efficient, however, with the extra tests...
(define (label-exp? expr) 
    (or (symbol? expr)
        (tagged-list? expr 'label)
    )
)
(define (label-exp-label expr) 
    (cond 
        ((symbol? expr) expr)
        ((tagged-list? expr 'label) (cadr expr))
        (else (error "Malformed label -- LABEL-EXP-LABEL"))
    )
)


; here, modify this fella from exercise 5.2
(define factorial-machine
    (make-machine ; register-names ops controller-text
        '(counter product n continue)                          
        (list (list '* *) (list '+ +) (list '> >))      ; oh actually, i guess t is unnecessary here, because counter update is INDEPENDENT of product!
        '(
            (assign counter (const 1))
            (assign product (const 1))
            
            ; unfortunately, this will be either:
            ;(assign continue test-counter)         ; inconsistent with reg/const/op,
            (assign continue (label test-counter))  ; or slower, having to handle this second case
     

        
            test-counter
                (test (op >) (reg counter) (reg n))
                
                ;(branch (label fact-done))
                (branch fact-done)                  ; well, this ONE instruction is strictly better...
                
                (assign product (op *) (reg product) (reg counter))
                (assign counter (op +) (reg counter) (const 1))
                
                ;(goto (label test-counter))
                ;(goto test-counter)                ; come to think of it, this is inconsistent too...
                (goto (reg continue))               
            fact-done

        )
    )
)



(set-register-contents! factorial-machine 'n 6)
(start factorial-machine)
(display (get-register-contents factorial-machine 'product)) ; 720. woohoo!
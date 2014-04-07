; by analogy with and USING full-adder
; (full-adder a b c-in sum c-out)
; arguments three lists of n wires each -- the Ak, the Bk, and the Sk -- and also another wire C

(define (make-n-wires n)
    (if (<= n 0)
        '()
        (cons (make-wire) (make-n-wires (- n 1)))
    )
)


(define (ripple-carry-adder a-list b-list s-list c-final)

    ; can i get local variables WITHOUT the nesting nightmare?? 
    ; the price seems to be internal arguments...
    
    ; initial error check
    (define (step1)
        (let ((n (length a-list)))    
            (if (not (and (n > 0) (= n (length b-list)) (= n (length c-list))))
                (error "List dimension mismatch -- RIPPLE-CARRY-ADDER" a-list b-list s-list)
                (step2 n)
            )
        )
    )
 
    ; allocate c-list
    (define (step2 n)
        (let ((c-list (make-n-wires n)))        
            (set-signal! (list-ref c-list (- n 1)) 0)   ; unnecessary/incorrect?
            (step3 n c-list)
        )
    )
    
    ; iteration. here, n will tick down to 1.
    (define (step3 n c-list)
    
        (define (check i)
            (if (not (and (<= 0 i) (< i n)))
                (error "Iteration out of bounds!? -- STEP3" i n)
                'ok
            )
        )
        
        (define (iter i)
            (check i)
    
            (let (  (a (list-ref a-list i))       ; Ai (having accounted for zero-indexing shift)
                    (b (list-ref b-list i))       ; Bi
                    (c-in (list-ref c-list i))    ; Ci
                    (c-out
                        (if (> i 0)
                            (list-ref c-list (- i 1))
                            c-final))
                    (s (list-ref s-list i))
                    )
                    
                ; finally, the main event
                (full-adder a b c-in s c-out)
                
                (if (> i 0)
                    (iter (- i 1))
                    'done
                )
            )
        )
        
        (iter (- n 1))
    )
    

    (step1)
)

; untested...read sols (which are much more Scheming - but i find harder to understand)

; What is the delay needed to obtain the complete output from an n-bit ripple-carry adder, 
; expressed in terms of the delays for and-gates, or-gates, and inverters? 

; Let o = or-delay, a = and-delay, i = inverter-delay
; (half-adder): o + a + i + a = 2a + i + o
; (full-adder): 2 x half-adder + or = 2(2a + i + o) + o = 4a + 2i + 3o.
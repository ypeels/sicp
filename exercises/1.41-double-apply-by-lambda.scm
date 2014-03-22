; susan's book has some scribble on this problem
; bleed-through from writing on top of the book, or did we actually do this problem?


(define (double foo)    ; takes a procedure [of one argument] as argument
    (lambda (x)         ; returns a procedure
        (foo (foo x)))) ; that applies the original procedure twice. (n.b. you can't say foo has one argument until it's invoked here.)
        
(define inc (lambda (x) (+ x 1)))

(newline)
(display ((double inc) 3))                  
; 5

(newline)
(display (((double double) inc) 5))
; 9 = 5 + 2^2

(newline)
(display (((double (double double)) inc) 5))
; 21 = 5 + 2^4, NOT 2^3 like you'd expect naively...

(newline)
(display ( ((double (double (double double))) inc) 5))
; 261 = 5 + 2^8, so indeed, it squared up again


; hmmmmmmmmm i guess the scribble is warranted...
; intuitively, the thing is that you're doing (double double) TWICE, and that squares up again to 16?

; all you need to do is SUBSTITUTE?
; (double double) = (lambda (x) (double (double x)))
    ; aha, nobody ever said x had to be data!
    ; rewrite as (double double) = (lambda (foo) (double (double foo))) = "(quadruple foo)" if you will...
    ; more explicitly:
        ; (double foo) = (lambda (x) (foo (foo x))) by my definition (i think this is correct)

; AHA here we go...
; (double (double double)) = (double quadruple)
;   = (lambda (bar) (quadruple (quadruple bar)))    ; QED (simple substitution!!!)
;   = (lambda (bar)                                 ; more explicitly...  no, that way lies madness
;       (double     
;           ( (lambda (foo) (double (double foo))) bar )))



;   != (lambda (foo) (double     (double (double foo))))  - that is WRONG.


;;;;;;;;;;;;;;;;;;;;
; the word "lambda" is just confusing...
; things are a lot clearer if you stick with a CONCRETE EXAMPLE.
; (double inc) = (lambda (x) (inc (inc x))) = (lambda (x) (+ x 2)) = add-2  ; unparenthesized, because it's a function, NOT its invocation
; (double double) inc = (lambda (foo) (double (double foo))) inc from above
    ; = (double (double inc)), substituting again
    ; = (double add-2)
    ; = (lambda (x) (add-2 (add-2 x))) = (lambda (x) (+ x 4)) = add-4
    
; no, due to the order of operations and the parentheses, you can't substitute (inc) until the END.
; (double (double double)) = (double (lambda (foo) (double (double foo))))
    ; = (lambda (bar)
    ;       ((lambda (foo) (double (double foo)))
    ;           ((lambda (foo2) (double (double foo2))) bar)))
    ; = (lambda (bar)                               ; mindlessly EVALUATE THE LAMBDA by substituting bar for foo2, and removing "lambda (foo2)"
    ;       ((lambda (foo) (double (double foo)))
    ;           (double (double bar))))
    ; = (lambda (bar)
    ;       (double (double (double (double bar)))))
    
; therefore, (double (double double)) inc
    ; = (lambda (bar) (double (double (double (double bar))))) inc 
    ; = (double (double (double (double inc))))
    ; = (double (double add-4))
    ; = (double (lambda (x) (add-4 (add-4 x)))) = (double add-8)
    ; = (lambda (x) (add-8 (add-8 x))) = add-16


; the moral of the story: just SUBSTITUTE, and looks like you'll be ok for now... 
; we'll see about exceptions in later chapters...
; the problem with doing these "deep" kind of problems at a time-constrained place like caltech is that you don't have time to DIGEST them...
; didn't help that deHon was such a piss-poor instructor/communicator, and i bet we had shitty solution sets
; either that, OR i just couldn't see past the parentheses-happy scheme syntax...
; no, i think the problem was not enough time to ponder and digest this book
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
; or, more explicitly:
; (double double) inc
    ; = (lambda (foo) (double (double foo))) inc
    ; = (double (double inc))
    ; = (double (lambda (x) (inc (inc x))))
    ; = (lambda (z)
    ;       ((lambda (y) (inc (inc y)))
    ;           ((lambda (x) (inc (inc x))) z)))    ; evaluate lambda(x) by substituting z for x, then removing "lambda(x)"
    ; = (lambda (z)
    ;       ((lambda (y) (inc (inc y)))             ; evaluate lambda (y) by substituting (inc (inc z)) for y, then removing "lambda (y)
    ;           (inc (inc z))))
    ; = (lambda (z)
    ;       (inc (inc (inc (inc z)))))              ; which is the answer (an unevaluated/unapplied lambda).

; so, due to the order of operations and the parentheses, you can't substitute (inc) until the END.
; (double (double double)) = (double (lambda (foo) (double (double foo))))
    ; = (lambda (bar)
    ;       ((lambda (foo) (double (double foo)))
    ;           ((lambda (foo2) (double (double foo2))) bar)))
    ; = (lambda (bar)                               ; mindlessly EVALUATE THE LAMBDA by substituting bar for foo2, and removing "lambda (foo2)"
    ;       ((lambda (foo) (double (double foo)))
    ;           (double (double bar))))
    ; = (lambda (bar)                               ; mindlessly evaluate lambda(foo) by substituting (double (double bar)) for foo, and removing "lambda (foo)"
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

; sub-moral: argument for a lambda is a DUMMY ARGUMENT
    ; but the argument for an outer lambda can be treated as concrete for any inner nested lambdas
    
; 
; passing note: to do the same thing with a lambda of TWO arguments, you'd have to 
; - pass it to itself TWICE AND
; - make sure it returns a LAMBDA that takes two arguments. hmmmmmm....... 

; ultimate goal: (double-2 double-2 double-2) where the 2nd and 3rd are ARGUMENTS

; you could easily do
; (define (double-2 foo1 foo2)
;   (lambda (x) (foo1 (foo2 (foo1 (foo2 x))))))
;   - but then you CAN'T NEST IT, because you'd have (double-2 x) on the innermost lambda.



; WANT something that looks like
; (define (double-2 foo1 foo2)
;   (lambda (x y) ( 
;       (foo1 x y) (foo2 x y))))  ; but what would this return when applied to DATA??
; 
; (display ((double-2 + +) 1 1)) ; "the function 2 is not applicable"
; (double-2 + +) 1 1
    ; = (lambda (x y) (+ x y) (+ x y)) 1 1
    ; = (+ 1 1) (+ 1 1)
    ; but 2 scalars in a row doesn't reall mean anything...
    ; hence my initial intuition that nested lambdas of 2 arguments are meaningles unless
    ; we can RETURN A DATA STRUCTURE. that's chapter 2... and i BET they're gonna talk about nesting them...

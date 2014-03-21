; curious question: can you NEST these (let) expressions too?


(define (foo z) 
    (newline)
    (display z)
    z)

    
; answer: YES.
(let ((x 1))
    (foo x)
    (let ((x 2))
        (foo x)
    )
    (foo x)
)
; 1 2 1
                
                
; but is this really that different from nested (define) statements??
; aha, i couldn't get nested (define)s to work without defining an ENCLOSING FUNCTION
; what's the matter, mr. scheme? extra names and invocations bother you? but ten parens in a row don't...)))))))))))
; i thought it's all "syntactic sugar" anyway...
(define (bar)
    (define x 3)
    (foo x)
    (define (nest)
        (define x 4)
        (foo x))
    (nest)
    (foo x)
)
(bar)       
; 3 4 3


(newline)
(define x 2)
(display 
    (let ((x 3)
          (y (+ x 2)))          ; omfg this x is the PRE-LET x, NOT the one from the line above...
      (* x y))                       ; this is such an annoyance that python just FORBIDS it outright...
)   
; 12 = 3 * (2+2)
; NOT  3 * (3+3)


; hey, they mention this at the end of this section:
; "Sometimes we can use internal definitions to get the same effect as with let. ...
; We prefer, however, to use let in situations like this and to use internal define only for internal procedures."
    ; footnote 54: this is actually a TECHNICAL reason and not a stylistic one...
(define (equal?-2.54 x y)                       ; (equal?) is a friggin built-in!
    (cond
        ((and (symbol? x) (symbol? y))
            (eq? x y))
        ;((and (list? x) (list? y))              ; will recurse into nested lists
        ;    (or
        ;        (and (null? x) (null? y))
        ;        (and 
        ;            (equal? (car x) (car y))   ; bwahahaha use this instead of (eq?)
        ;            (equal? (cdr x) (cdr y))
        ;        )
        ;    )
        ;)
        ((and (pair? x) (pair? y))              ; this should cover lists AND avoids (car ())
            (and    (equal? (car x) (car y))
                    (equal? (cdr x) (cdr y))))
                    
        ((and (number? x) (number? y))          ; some extra tests not mentioned in the text
            (= x y))
        ((and (null? x) (null? y))
            #t)
        (else #f)                       ; type mismatch, or MAYBE unknown type?
    )
)


(define (test-2.54)
    ;(define e? equal?-2.54)
    
    (define (test x y)
        (newline)
        (newline) (display x) (display " == ") (display y )
        (newline) (display "built-in: ") (display (equal? x y))
        (newline) (display "2.54: ") (display (equal?-2.54 x y))
        
        ; meh just manually inspect the results...
    )
    
    (test '(this is a list) '(this is a list))      ; #t
    (test '(this is a list) '(this (is a) list))    ; #f
    (test 1 1)                                      ; #t
    (test 'a 'a)                                    ; #t
    (test '(1 a 3) (list 1 'a 3))                   ; #t
    (test '() ())                                   ; #t
    (test (cons 'a 'b) (cons 'a 'b))                ; #t
        

)

(define e? equal?-2.54) (test-2.54) ; for interactive testing too
            
        
        
        
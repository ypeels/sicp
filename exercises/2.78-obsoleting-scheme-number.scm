(load "2.77-80-generic-arithmetic.scm")

; Modify the definitions of type-tag, contents, and attach-tag from section 2.4.2 so that 
; our generic system takes advantage of Scheme's internal type system [for number?].
(define (attach-tag-2.78 type-tag contents)     ; for backwards compatibility with any code that uses (make-scheme-number)
    (if (number? contents)
        contents                                ; hmmmmm...
        (attach-tag-2.4.2 type-tag contents)
    )
)

(define (type-tag-2.78 datum)
    (if (number? datum)                         ; the problem probably doesn't want us to punt, but...meh
        'scheme-number                          ; still have to return a tag, to maintain compatibility with (apply-generic
        (type-tag-2.4.2 datum)                  
    )
)

(define (contents-2.78 datum)
    (if (number? datum)
        datum
        (contents-2.4.2 datum)
    )
)
        
        

(define (test-2.78)
    (define (test x y)
        (display "\n\nx = ") (display x) (display ", y = ") (display y)
        (display "\nx + x = ") (display (add x y))
        (display "\nx - x = ") (display (sub x y))
        (display "\nx * x = ") (display (mul x y))
        (display "\nx / x = ") (display (div x y))
    )
    (test 0 1)
    (test 3 4)
    (test 3 (make-scheme-number 4))     ; still works
    (test 25 5)    
)


(display "\nExercise 2.78: allowing lazyfolk to skip (make-scheme-number\n") (define attach-tag attach-tag-2.78) (define type-tag type-tag-2.78) (define contents contents-2.78)

; (test-2.78)
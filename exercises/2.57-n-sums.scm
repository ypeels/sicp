(load "2.56-58-symbolic-differentiation.scm")


                                        ; "the addend of a sum would be the first term [i.e., unchanged], and
(define (addmul-2.57 expr symbol)       ; the augend would be the sum of the rest of the terms"
    (let ((end (cddr expr)))                  ; NOT caddr, which would be the FIRST of the rest of the terms. WATCH OUT, boy
        (if (> (length end) 1)
            (cons symbol end)           ; here's how you express "sum of the rest of the terms" - just tack the symbol on!
            (car end)                   ; surprisingly, the rest of deriv is enough to handle summing multiple terms!
        )                                     ; this is because (deriv (augend exp)) and (deriv multiplicand exp) 
    )                                         ; recurse down the exp...?
)                                       ; see http://community.schemewiki.org/?sicp-ex-2.57 for more and better sols
(define (augend-2.57 expr) 
    (addmul-2.57 expr '+))
(define (multiplicand-2.57 expr)
    (addmul-2.57 expr '*))





(define (test-2.57)

    (display "\noriginal results, for reference\n")
    (display (deriv '(* (* x y) (+ x 3)) 'x)) (newline)   
    (display (deriv '(* (* x x) x) 'x) ) (newline)

    (display "\nnew results using n-argument product/sum\n")
    (define augend augend-2.57) (define multiplicand multiplicand-2.57) 
    (display (deriv '(* x y (+ x 3)) 'x)) (newline)
    (display (deriv '(* x x x) 'x)) (newline)
)
; (test-2.57)


; (+ (* x y) (* y (+ x 3)))
; (* (+ x x) (* x (+ x x)))

; now, the original code never simplified (+ x x) into (* 2 x), so i'm not gonna bother here either...
; this exercise just asks for "sums and products of arbitrary numbers of terms"
; let's start from (reverse-scheming) in Exercise 2.27
;(define (reverse-scheming L)
;
;    (if (null? L)
;        ()  ; cleaned up a little from http://stackoverflow.com/questions/4092113/how-to-reverse-a-list
;        (append (reverse (cdr L)) (list (car L))))
;        
;)

;(newline)(display (reverse-scheming (list 1 2 3 4 5)))

; we should use the tree traversal technique shown previously
    ; hey, can we just add a conditional to the second argument to (append)?
    
(define (deep-reverse L)

    ; (let ((current (car L)) (next (cdr L))) ; nope, can't combine this with null-termination, remember?
        
    (if (null? L)
        ()
        (append
            (deep-reverse (cdr L))

            (list                           ; (append list1 list2)
                (if (not (pair? (car L)))
                    (car L)                 ; the shallow case
                    (deep-reverse (car L))
                )
            )
        )
    )
)


; ugh, if only there were an easy way to modify a list in-place in this stupid language
;(define (deep-reverse-iter L)
;    (define iter 


(define (test-2.27)

    (define (test x)        
        (newline)
        (display x) (newline)                   
        (display (reverse x)) (newline)          
        (display (deep-reverse x)) (newline)
    )

    (test (list 1 2 3 4))
    (test (list (list 1 2) (list 3 4)))
    ; ((1 2) (3 4))
    ; ((3 4) (1 2))
    ; ((4 3) (2 1))
    
    (test (list 1 2 (list 3 4 5) (list 6 (list 7 8)) 9 10))
    ; (1 2 (3 4 5) (6 (7 8)) 9 10)
    ; (10 9 (6 (7 8)) (3 4 5) 2 1)
    ; (10 9 ((8 7) 6) (5 4 3) 2 1)
)

(test-2.27)
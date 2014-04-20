; rules from problem statement
(define (install-next-to)

    ; first 2 elements are ?x and ?y
    (query '(assert! (rule (?x next-to ?y in (?x ?y . ?u)))))   ; notice "un-lisp-like" syntax with next-to and in
    
    ; recurse down (cdr list)
    (query '(assert! (rule (?x next-to ?y in (?v . ?z))  (?x next-to ?y in ?z))))
)

(define (test-4.61)

    (load "ch4-query.scm")
    (init-query) ; still need to do this so the newly asserted rules have a place to live
    (install-next-to)
    
    (query '(?x next-to ?y in (1 (2 3) 4)))
    ; my guess
    ; 1 next-to (2 3)
    ; (2 3) next-to 4
    
    (query '(?x next-to 1 in (2 1 3 1)))
    ; my guess: 2, 3
    
    ; guesses are right, but the program actually outputs them in REVERSE order, from right to left...
    ; a hint as to its implementation?

    (query-driver-loop)
)
;(test-4.61)

                           
        
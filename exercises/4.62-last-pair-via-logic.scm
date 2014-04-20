; apparently i did this in Exercise 2.17 too... almost a month ago!

(define (install-last-pair)

    ; end of the line - i think... yeah, this works! (1 2 3) doesn't match (?u).
    (query '(assert! (rule (last-pair (?u) (?u)))))

    ; recurse down the cdr of the list.
    (query '(assert! (rule (last-pair (?u . ?v) ?lp) (last-pair ?v ?lp)))) ; ?lp = "return value"
                                                                           ; sol has (?lp), but i don't think it matters

    ; order of these rules doesn't matter! i guess they're not overlapping?
)



(define (test-4.62)
    (load "ch4-query.scm")
    (init-query)
    (install-last-pair)
    
    (query '(last-pair (3) ?x))
    ; (3)
    
    (query '(last-pair (1 2 3) ?x))
    ; (3)
    
    (query '(last-pair (2 ?x) (3)))
    ; (last-pair (2 3) (3))
    
    ;(query '(last-pair ?x (3)))
    ; hangs forever. "the general methods may break down in more complex casesas we will see in section 4.4.3" ?
        ; yeah, the very first subsection of 4.4.3 is "infinite loops"
    
    (query-driver-loop)
)
;(test-4.62)
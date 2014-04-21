; like Exercise 4.68, this could have gone in the previous batch too...



(define (install-great-genealogy)

    ; Write rules that determine if a list ends in the word grandson.
    (query '(assert! (rule (ends-with-grandson (?L)) (last-pair (?L) grandson))))
        ; shouldn't ONE rule suffice? oh i guess last-pair is a rule in itself too...
        ; maybe allow for singleton too
        ;(query '(assert! (rule (ends-with-grandson grandson))))
    
        ; test it
        ;(query '(assert! ((great grandson) Lupin1 Lupin4)))
        (query '(assert! (rule (findgs ?p1 ?p2)
            (and
                (?relationship ?p1 ?p2)
                (ends-with-grandson ?relationship)
            )
        )))
        (query '(findgs ?p1 ?p2))
    
    ; works for a single great... but that's NOT what we want...
    ;(query '(assert! (rule ((great grandson) ?x ?y) (and (same ?rel (grandson)) (grandson ?x ?gs) (son ?gs ?y)))))
    
    
    ; Use this to express a rule that allows one to derive the relationship ((great . ?rel) ?x ?y), 
    ; where ?rel is a list ending in grandson.)
    (query '(assert! (rule ((great . ?rel) ?x ?y)
    
        (and
            (ends-with-grandson (?rel))
            (or
                (and (grandson ?x ?gs) (son ?gs ?y))
                
                ; no WAY this is gonna work...?
                ;(?rel (son ?x) ?y)
            )
        )
    )))
    
    
    ; don't forget the query (grandson ?G ?S)
)

(define (test-4.69)
    (load "ch4-query.scm")
    (init-query)
    
    (load "4.63-genealogy-of-ada.scm")
    (install-genesis)
    (install-genealogy) ; grandson, and son via wife
    
    (load "4.62-last-pair-via-logic.scm")
    (install-last-pair) ; for ends-in-grandson
    
    (install-great-genealogy)
    
    ; test cases from problem statement
    ;(query '((great grandson) ?g ?ggs))
    
    (query-driver-loop)
)
(test-4.69)

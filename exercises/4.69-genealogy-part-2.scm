; like Exercise 4.68, this could have gone in the previous batch too...



(define (install-great-genealogy)

    ; Write rules that determine if a list ends in the word grandson.
    (query '(assert! (rule (ends-with-grandson (?L)) (last-pair (?L) grandson))))
        ; shouldn't ONE rule suffice? 
        ; maybe allow for singleton too
        (query '(assert! (rule (ends-with-grandson grandson))))
    
    ; Use this to express a rule that allows one to derive the relationship ((great . ?rel) ?x ?y), 
    ; where ?rel is a list ending in grandson.)
    (query '(assert! (rule ((great . ?rel)
    
    ; don't forget the query (grandson ?S ?G)
)

(define (test-4.69)
    (load "ch4-query.scm")
    (init-query)
    
    (load "4.63-genealogy-of-ada.scm")
    (install-genesis)
    (install-genealogy) ; grandson, and son via wife
    
    (load "4.62-last-pair-via-logic.scm")
    (install-last-pair) ; for ends-in-grandson
    
    (query-driver-loop)
)
(test-4.69)

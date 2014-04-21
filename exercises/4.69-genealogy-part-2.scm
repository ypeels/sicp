; like Exercise 4.68, this could have gone in the previous batch too...



(define (install-great-genealogy)

    ; Write rules that determine if a list ends in the word grandson.
    (query '(assert! (rule (ends-with-grandson (?car . ?cdr)) (last-pair (?car . ?cdr) (grandson)))))
        ; shouldn't ONE rule suffice? oh i guess last-pair is a rule in itself too...
        ; maybe allow for singleton too
        ;(query '(assert! (rule (ends-with-grandson grandson))))
    
        ; test it
        (query '(ends-with-grandson (great grandson)))
        

    
    
    ; Use this to express a rule that allows one to derive the relationship ((great . ?rel) ?x ?y), 
    ; where ?rel is a list ending in grandson.)
    (query '(assert! (rule ((great . ?rel) ?x ?y)
    
        (and
            (ends-with-grandson ?rel)
            (or
                ; this gets great-grandson working
                (and (same ?rel (grandson)) (grandson ?x ?gs) (son ?gs ?y))
                
                ; this is all it takes to get arbitrarily many "great"s to work!
                (and (son ?x ?s) (?rel ?s ?y))
            )
            
            ; sol's version - with additional grandson rules to normalize the api
            ;(son ?x ?s) (rel ?s ?y)
        )
    )))
    
    ; additional normalizing rules from sols. ohhhh... that IS cleaner...
    ;(query '(assert! (rule (ends-with-grandson (grandson)))))
    ;(query '(assert! (rule ((grandson) ?x ?y) (grandson ?x ?y))))
    
    
    ; don't forget the query (grandson ?G ?S)
)


; https://github.com/l0stman/sicp/blob/master/4.69.tex
; by far the best solution i could find online
(define (install-great-genealogy-l0stman)
    (query '(assert! (rule (end-in-grandson (grandson)))))
    (query '(assert! (rule (end-in-grandson (?x . ?rest))
                           (end-in-grandson ?rest))))

    (query '(assert! (rule ((grandson) ?x ?y)
                            (grandson ?x ?y))))
    (query '(assert! (rule ((great . ?rel) ?x ?y)
          (and (end-in-grandson ?rel)
               (son ?x ?z)
               (?rel ?z ?y)))))
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
    ;(install-great-genealogy-l0stman)
    
    ; test cases from problem statement
    (query '((great grandson) Adam ?ggs))
    (query '((great grandson) ?g ?ggs))
    ; mehujael jubal
    ; irad lamech
    ; mehujael jabal
    ; enoch methushael
    ; cain mehujael
    ; adam irad    
    
    (query '((great great grandson) ?g ?gggs))
    ; irad jubal
    ; enoch lamech
    ; irad jabal
    ; cain methushael
    ; adam mehujael
    
    (query '((great great great great great grandson) ?g ?ggggs))
    ; adam jubal
    ; adam jabal
    
    (query '(?relationship Adam Irad))
    ; currently infinite loop... even for sols! 
    ; http://community.schemewiki.org/?sicp-ex-4.69
    ; https://github.com/l0stman/sicp/blob/master/4.69.tex
    ; meh.
    
    (query-driver-loop)
)
;(test-4.69)

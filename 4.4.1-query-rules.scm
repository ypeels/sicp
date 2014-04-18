(newline)
(display "\np. 448: (rule (same ?x ?x))")
(display "\nHow about (rule (different ?x ?y) (not (same ?x ?y)))?")
    (display "\n\tHmmmmmm..... why doesn't this work?? It'd be more legible than (not (same))...")
    (display "\n\tDoes it have to do with 'not's peculiarities' mentioned in Footnote 63??")

(load "4.4.4-ch4-query.scm")
;(run)


(init-query)
(query '(supervisor ?slave (Bitdiddle Ben)))

; this works
(query '(and (address ?person1 (?town . ?rest1))
             (address ?person2 (?town . ?rest2))
              (not (same ?person1 ?person2))) )
              
              
; but this doesn't!?
(query '(rule (different ?x ?y) (not (same ?x ?y))))
(query '(and (address ?person1 (?town . ?rest1))
             (address ?person2 (?town . ?rest2))
             (different ?person1 ?person2)) )
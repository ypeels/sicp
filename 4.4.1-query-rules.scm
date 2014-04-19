(newline)
(display "\np. 448: (rule (same ?x ?x))")
(display "\nHow about (rule (different ?x ?y) (not (same ?x ?y)))?")
    (display "\n\tHmmmmmm..... why doesn't this work?? It'd be more legible than (not (same))...")
    (display "\n\tDoes it have to do with 'not's peculiarities' mentioned in Footnote 63??")

(load "4.4.4-ch4-query.scm")
;(run)

; apparently rules have to be installed as part of the DATABASE - NOT as interactive or batch queries...??

;(append! microshaft-data-base '((rule (different ?x ?y) (not (same ?x ?y)))))
(init-query)




(query '(supervisor ?slave (Bitdiddle Ben)))

; this works
(query '(and (address ?person1 (?town . ?rest1))
             (address ?person2 (?town . ?rest2))
              (not (same ?person1 ?person2))) )
              
              
; new assertions and rules are installed using (query '(assert! (rule ...))) - from sols.
(query '(assert! (rule (different ?x ?y) (not (same ?x ?y)))))
(query '(and (address ?person1 (?town . ?rest1))
             (address ?person2 (?town . ?rest2))
             (different ?person1 ?person2)) )
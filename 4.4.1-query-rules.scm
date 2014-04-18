(newline)
(display "\np. 448: (rule (same ?x ?x))")
(display "\nHow about (rule (different ?x ?y) (not (same ?x ?y)))?")
    (display "\n\tHmmmmmm..... why doesn't this work?? It'd be more legible than (not (same))...")
    (display "\n\tDoes it have to do with 'not's peculiarities' mentioned in Footnote 63??")

(load "4.4.4-ch4-query.scm")
(run)
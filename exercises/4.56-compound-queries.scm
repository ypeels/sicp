(load "ch4-query.scm")
(init-query)

(display "\na. ")
(query '(and (supervisor ?slave (Bitdiddle Ben)) (address ?slave ?where)))
;(and (supervisor (tweakit lem e) (bitdiddle ben)) (address (tweakit lem e) (boston (bay state road) 22)))
;(and (supervisor (fect cy d) (bitdiddle ben)) (address (fect cy d) (cambridge (ames street) 3)))
;(and (supervisor (hacker alyssa p) (bitdiddle ben)) (address (hacker alyssa p) (cambridge (mass ave) 78)))


(display "\nb. ")
;(and (salary (bitdiddle ben) 60000) (salary (scrooge eben) 75000) (lisp-value > 75000 60000))
;(and (salary (bitdiddle ben) 60000) (salary (warbucks oliver) 150000) (lisp-value > 150000 60000))
(query 
    '(and 
        (salary (Bitdiddle Ben) ?ben-salary)
        (salary ?master ?master-salary)
        (lisp-value > ?master-salary ?ben-salary)
    )
)

(display "\nc.")   
(query
    '(and (supervisor ?slave ?master)
         (not (job ?master (computer . ?type)))
         (job ?master ?master-job)
    )
)
;(and (supervisor (aull dewitt) (warbucks oliver)) (not (job (warbucks oliver) (computer . ?type))) (job (warbucks oliver) (administration big wheel)))
;(and (supervisor (cratchet robert) (scrooge eben)) (not (job (scrooge eben) (computer . ?type))) (job (scrooge eben) (accounting chief accountant)))
;(and (supervisor (scrooge eben) (warbucks oliver)) (not (job (warbucks oliver) (computer . ?type))) (job (warbucks oliver) (administration big wheel)))
;(and (supervisor (bitdiddle ben) (warbucks oliver)) (not (job (warbucks oliver) (computer . ?type))) (job (warbucks oliver) (administration big wheel)))


(query-driver-loop)

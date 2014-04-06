;;;SECTION 3.3.3

(define (lookup key table)
  (let ((record (assoc key (cdr table))))
    (if record
        (cdr record)
        false)))

(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))))

(define (insert! key value table)
  (let ((record (assoc key (cdr table))))
    (if record
        (set-cdr! record value)
        (set-cdr! table
                  (cons (cons key value) (cdr table)))))
  'ok)

(define (make-table)
  (list '*table*))
  
  
; here's my table that MODIFIES the table pointer entity instead...
(define table2 'bleh)
(define (make-table2)   
    (set! table2 '())
    table2)             ; hmmmmm it's not really CONSTRUCTING a new table... but you could imagine another (define) that did
    
(define (insert2! key value table)
    (let ((new-pair (cons key value)))
        (set! table (cons new-pair table))
    )
    'ok
)

(define (lookup2 key table)
    (cond
        ((null? table)
            false)
        ((equal? key (caar table))
            (display (caar table))
            (car table))
        (else
            (display (caar table))
            (lookup2 key (cdr table)))
    )
)



; like i THOUGHT, their rationale for having that hokey dummy node (pp. 268-269, footnote 25) for table is WRONG
    ; this way, the value for the RESULT OF (make-table3) is unchanged
    ; the INTERNAL state variable pointer named "table" is changing, but that is not relevant to external users
    ; MAYBE their reason for adding the dummy node will have to do with their 2-d generalization??
(define (empty-table3) '())
(define (make-table3)
    (make-table3-concrete (empty-table3)))
(define (make-table3-concrete table) ; need argument passed in to allow multiple instances, right?

    (define (lookup key)
        
        (if (eq? table (empty-table3))
            false
            (let ((record (assoc key table))) ;(cdr table)))
                (if record
                    (cdr record)
                    false
                )
            )
        )
    )        

    ; unchanged? can i use the external version? the BUILT-IN version?
    (define (assoc key records)
      (cond ((null? records) false)
            ((equal? key (caar records)) (car records))
            (else (assoc key (cdr records)))))            
            
    (define (insert! key value)
      (let ((record (assoc key table)));(cdr table))))
        (if record
            (set-cdr! record value)
            
            ;(set-cdr! table
            ;          (cons (cons key value) (cdr table)))))]
            (let ((new-table (cons (cons key value) table)))
                (set! table new-table)
            )
        )
      )
      'ok
    )

    (define (dispatch m)
        (cond 
            ((eq? m 'insert!)
                insert!)
            ((eq? m 'lookup)
                lookup)
            (else
                "Unknown operation -- MAKE-TABLE3" m)
        )
    )
    dispatch
)

(define (insert3! key value table)
    ((table 'insert!) key value))
(define (lookup3 key table)    
    ((table 'lookup) key))
    

  
  
(define (test-3.3.3)

    (let ((t (make-table)) (t2 (make-table2)) (t3 (make-table3)))
    
        (define (test key value)
        
        
            (newline)
            (insert! key value t) (display "\ntable 1 (book): ") (display (lookup key t))
            
            (define t2-old t2) (insert2! key value t2) 
            (display "\ntable 2 (no dummy): ") (display (lookup2 key t2))
            (display "\nso is external t2 UNCHANGED by set!? ") (display (eq? t2-old t2)) 
 
            (insert3! key value t3) (display "\ntable 3 (no dummy + encapsulated): ") (display (lookup3 key t3))
            (newline)
        )
        
        (test 'a 1)
        (test 'b 2)
    )
    
    (display "\nAs I should have known, had I done the frame analysis (ugh), the set! in insert2! ")
    (display "\nmodifies a LOCAL COPY of table. that is, table is a pointer that is passed BY VALUE to insert2!")
    (display "\nok, so a feasible alternative would be to package tables as internal state variables")
    (display "\nthis would allow allow multiple non-conflicting 'instances'")
    (display "\nthe fact that the authors chose this hacky workaround just shows how AWKWARD THAT APPROACH IS")
    (display "\nIf something is awkward to do in a language, then PROGRAMMERS PROBABLY WON'T USE IT")
    (display "\n\nOR maybe there is some reason in the 2-d generalization to have these sacrifical dummy header nodes?")
)

(test-3.3.3)
            
(define (make-n-table)
    (list '*table-n*))

(define (n-lookup key-list table)
    (cond
        ((or (null? key-list) (not (list? key-list)))
            (error "Bad key-list -- N-LOOKUP" key-list))
        ((not (pair? table))
            (error "Bad table -- N-LOOKUP" table))
        (else        
            (let ((record (assoc (car key-list) (cdr table))))      ; (car key-list) instead of key
                (cond
                    ((not record)
                        false)
                    ((= (length key-list) 1)
                        (cdr record))
                    ((> (length key-list) 1)                        ; record exists and this is NOT the last key
                        (n-lookup (cdr key-list) record))           ; new case: recurse to next subtable, which is NOT (cdr record) - see Fig. 3.23 p. 269
                    (else
                        (error "Impossible key-list length!? -- N-LOOKUP" key-list))
                )
            )
        )
    )
)

; TODO: smart logic to overwriting value with table or table with value
(define (n-insert! key-list value table)
    (cond 
        ((or (null? key-list) (not (list? key-list)))
            (error "Bad key-list -- N-INSERT!" key-list))
        ((not (pair? table))
            (error "Bad table -- N-INSERT!" table))
        (else

            (let ((record (assoc (car key-list) (cdr table))))      ; assoc: look up 1 key at a time 
                (cond 
                    ((= (length key-list) 1)                        ; same as 1-d code
                        (cond
                            ((and record (pair? (cdr record)))
                                (error "Expected value, found table -- N-INSERT!" key-list record))
                            ((and record (not (pair? (cdr record)))); these 2 cases modified from ch3.scm
                                (set-cdr! record value))
                            (else                                   ; (not record)
                                (set-cdr! table
                                          (cons (cons (car key-list) value) (cdr table)))))
                    )
                    ((> (length key-list) 1)
                        (cond                            
                            ((and record (not (pair? (cdr record))))
                                (error "Expected table, found value -- N-INSERT!" key-list record))
                                
                            ; record = sought-after subtable. deeper down the rabbit hole
                            ((and record (pair? (cdr record)))      
                                (n-insert! (cdr key-list) value record))
                                
                            ; record (subtable) not found.
                            (else                                   
                            
                                ; append new subtable
                                (set-cdr!                               
                                    table
                                    (cons (cons (car key-list) '()) (cdr table)))
                                    
                                ; and recurse down it
                                (n-insert! (cdr key-list) value (cadr table))   ; NOT (cdr table) - see Fig. 3.23 p. 269
                            )
                        )
                    )
                    
                    (else
                        (error "Impossible key-list length!? -- N-INSERT!" key-list))
                )
            )
        )
    )
)
                            
                              
(define (test-3.25)

    ; from ch3.scm
    (define (lookup key-1 key-2 table)
      (let ((subtable (assoc key-1 (cdr table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (cdr record)
                  false))
            false)))

    (define (insert! key-1 key-2 value table)
      (let ((subtable (assoc key-1 (cdr table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key-2 value)
                                  (cdr subtable)))))
            (set-cdr! table
                      (cons (list key-1
                                  (cons key-2 value))
                            (cdr table)))))
      'ok)
    
    (define (make-table)
      (list '*table*))  
      
      
    ; my testing code
    (let ((t2 (make-table)) (tn (make-n-table)))
    
        ;(n-insert! '(1d-fodder) 1 tn) (display tn)
        
        (define (test key1 key2 value)
            (newline)
            (insert! key1 key2 value t2) (display "\nbook: ") (display (lookup key1 key2 t2)) (display t2)
            (n-insert! (list key1 key2) value tn) (display "\nn-table: ") (display (n-lookup (list key1 key2) tn)) (display tn)
        )
        
        (test 'a 'b 1)
        (test 'c 'd 2)
        (test 'a 'b 3)
        
        (n-insert! '(e f g h) 5 tn)
        (newline) (display (n-lookup '(e f g h) tn)) (display tn)
        
    )
    

)
; (test-3.25)
        
                    
                
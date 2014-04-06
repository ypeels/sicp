; modified from ch3.scm
; - also need a custom assoc function, which i moved in
; i THINK this is just a 2-line modification?!

;; local tables
(define (make-table same-key?);(make-table)                     ; <----------- modification 1

  ; moved in from outside
  (define (assoc key records)
    (cond ((null? records) false)                               ; vvvvvvvvvvvv modification 2
          ((same-key? key (caar records)) (car records));((equal? key (caar records)) (car records))
          (else (assoc key (cdr records)))))


  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (cdr record)
                  false))
            false)))
    (define (insert! key-1 key-2 value)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key-2 value)
                                  (cdr subtable)))))
            (set-cdr! local-table
                      (cons (list key-1
                                  (cons key-2 value))
                            (cdr local-table)))))
      'ok)    
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))
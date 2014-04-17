(define (install-distinct)
    (ambeval-batch
    
        ; from Footnote 48 in 4.3.2
        '(define (distinct? items)
          (cond ((null? items) true)
                ((null? (cdr items)) true)
                ((member (car items) (cdr items)) false)
                (else (distinct? (cdr items)))))
    )
)

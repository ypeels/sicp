; from ch2.scm
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))
        
        
(define (union-set set1 set2)
    (cond
        ((null? set2) set1)
        ((null? set1) set2)
        ((element-of-set? (car set1) set2)      ; loop over set1
            (union-set (cdr set1) set2))        ; no duplicates allowed!
        (else
            (cons (car set1) (union-set (cdr set1) set2)))))
            
(define (test-2.59)
    (newline)
    (display (union-set '(1 2 5) '(2 7)))
    
)

;(test-2.59)

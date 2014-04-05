; Implement like (make-queue) in Section 3.3.2, which even the authors seem to regard as more intuitive than Exercise 3.32.

; "internal" accessors and mutators, for "encapsulation"
(define (front-ptr deque) (car deque))  
(define (rear-ptr deque) (cdr deque))
(define (set-front-ptr! deque item) (set-car! deque item))
(define (set-rear-ptr! deque item) (set-cdr! deque item))

; specification from problem statement

; the [default and only] constructor
(define (make-deque) (cons '() '()))
    
    
; predicate
(define (empty-deque? deque)
    (and (null? (front-ptr deque)) (null? (rear-ptr deque))))
    
; selectors - using a shared driver to emphasize symmetry
(define (front-deque deque)
    (selector-deque deque front-ptr "FRONT-DEQUE"))
(define (rear-deque deque)
    (selector-deque deque rear-ptr "REAR-DEQUE"))    
(define (selector-deque deque select-item name)
    (if (empty-deque? deque)
        (error "Empty deque --" name)
        (select-item deque)
    )
)


; internal data type for doubly-linked list
(define (make-deque-item value)
    (list '() value '()))       ; looks more sensical than (value () ()). 

(define (ahead-item item) 
    (car item))
(define (set-ahead-item! item new-ahead)
    (set-car! item new-ahead))

(define (value-item item)
    (cadr item))
(define (set-value-item! item new-value)
    (set-car! (cdr item) new-value))
    
(define (behind-item item)
    (caddr item))
(define (set-behind-item! item new-behind)
    (set-car! (cddr item) new-behind))


; mutators - using a shared driver to emphasize symmetry, reduce code size, and consolidate bugs into one nontrivial routine
; my convention: (front-insert) and (front-delete) are push/pop pairs at the FRONT.
    ; in other words, the single-ended queue was using front-delete! and rear-insert!
    ; might be better to view this as a double-ended stack...
(define (front-insert-deque! deque value)
    (insert-deque! deque value front-ptr set-front-ptr! set-ahead-item! set-behind-item!))  ; phoowhee getting confused
(define (rear-insert-deque! deque value)
    (insert-deque! deque value rear-ptr set-rear-ptr! set-behind-item! set-ahead-item!))
(define (insert-deque! deque value select-deque-entry set-deque-entry! set-next-item! set-previous-item!)
        
    (let ((new-item (make-deque-item value)))    
        (if (empty-deque? deque)
            (begin
                (set-front-ptr! deque new-item) 
                (set-rear-ptr! deque new-item)
            ) 
            
            ; deque not empty. the new item is "next in line"
            (let ((old-entry (select-deque-entry deque)))            
                (set-next-item! old-entry new-item)
                (set-previous-item! new-item old-entry)
                (set-deque-entry! deque new-item)            
            )
        )

    )
    (printable-deque deque)    
)



; my custom convenience functions
(define (printable-deque deque)
    (define (iter item)  ;need to drop down from deque into item doubly-linked-list
       (if (null? item)
            '()
            (begin
                (cons 
                    (value-item item) 
                    (iter (behind-item item))
                )
            )
        )
    )
    (iter (front-deque deque))
)
        
       
       
(define (test-3.33)

    (let ((d (make-deque)))
        (newline) (display (front-insert-deque! d 1))
        (newline) (display (front-insert-deque! d 2))
        (newline) (display (front-insert-deque! d 3))
        (display "first rear-insert!")
        (newline) (display (rear-insert-deque! d 4))
        (display "second rear-insert!")
        (newline) (display (rear-insert-deque! d 5))
    )
)
;(test-3.33)
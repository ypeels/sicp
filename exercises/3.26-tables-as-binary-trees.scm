; Simplifying assumptions
    ; just gonna do the 1-key case, since they didn't say otherwise
        ; the n-dimensional generalization follows by nesting of trees?
        ; would we have to worry about overlap of keys? nah, we didn't have to in exercise 3.26...
    ; just gonna do integer keys, since i have no idea how to test greater/less keys for symbols/strings
        ; maybe i'll leave the infrastructure extensible
    
    
    
(define less-than 'less)
(define greater-than 'greater)
(define equal-to 'equal)
    
(define (compare a b)
    (cond
        ((and (number? a) (number? b))
            (cond
                ((< a b) less-than)
                ((> a b) greater-than)
                (else equal-to)
            )
        )
        (else
            (error "Unimplemented key types -- COMPARE" a b))
    )
)


; from Exercise 2.66
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))
  
(define (make-record key value);. args)
    (cons key value));(append (list key) args))
(define (key-record record)
    (car record))
    
; new
(define (set-left-branch! tree new-branch)
    (set-car! (cdr tree) new-branch))
(define (set-right-branch! tree new-branch)
    (set-car! (cddr tree) new-branch))

    
; adapted from Exercise 2.66 - use this instead of (assoc)
(define (lookup-in-tree search-key tree)
    (if (null? tree)
        false
        (let ((current-key (key-record (entry tree))))
            (cond 
                ((eq? equal-to (compare search-key current-key));(= search-key current-key)
                    (entry tree))
                ((eq? less-than (compare search-key current-key));(< search-key current-key)
                    (lookup-in-tree search-key (left-branch tree)))
                (else
                    (lookup-in-tree search-key (right-branch tree)))
            )
        )
    )
)
    
    
; new for this exercise
(define (insert-in-tree! new-record tree)
    (if (null? tree)
        (error "Bad tree - INSERT-IN-TREE!" tree)
        (let (  (current-key (key-record (entry tree)))
                (new-key (key-record new-record))
                )
            (cond
                ((eq? equal-to (compare new-key current-key))
                    (error "record MUTATION should be handled in insert! -- INSERT-IN-TREE!" key))
                ((eq? less-than (compare new-key current-key))
                    (if (null? (left-branch tree))
                        (set-left-branch! tree (make-tree new-record '() '()))
                        (insert-in-tree! new-record (left-branch tree))))
                (else ; new-key > current-key
                    (if (null? (right-branch tree))
                        (set-right-branch! tree (make-tree new-record '() '()))
                        (insert-in-tree! new-record (right-branch tree))))
            )
        )
    )
)
                
            
        



(define (lookup-3.26 key table)
    
    (let ((record (lookup-in-tree key (cdr table))))
        (if record
            (cdr record)
            false
        )
    )
)

(define (insert-3.26! key value table)

    (let ((tree (cdr table)))
        (if (null? tree)
        
            ; create new tree
            (set-cdr! 
                table 
                (make-tree (make-record key value) '() '())
            )  
        
            ; insert in existing tree
            (let ((record (lookup-in-tree key tree)))
                (if record
                    (set-cdr! record value)
                    (insert-in-tree! (make-record key value) tree)
                )
            )
        )
    )
)
    

(define (make-table-3.26)
    (list '*table-3.26*))
        
            
(define (test-3.26)
    (let ((t (make-table-3.26)))
    
        (define (test key value)
            (newline)
            (insert-3.26! key value t) (display (lookup-3.26 key t))  (display t)
        )
        
        (test 5 'a)
        (test 3 'b)
        (test 7 'c)
        (test 4 'd)
        (test 3 'e)
    )
)

;(test-3.26)
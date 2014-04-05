; Footnote 23: "Be careful not to make the interpreter try to print a structure that contains cycles."
; This suggests the design of (front-ptr . rear-ptr), where rear-ptr points INWARD toward front-ptr.

; Implement like (make-queue) in Section 3.3.2, which even the authors seem to regard as more intuitive than Exercise 3.32.

; "internal" accessors and mutators, for "encapsulation"
(define (front-ptr deque) (car deque))  
(define (rear-ptr deque) (cdr deque))
(define (set-front-ptr! deque pair) (set-car! deque pair))
(define (set-rear-ptr! deque pair) (set-cdr! deque pair))

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
(define (selector-deque deque select-pair name)
    (if (empty-deque? deque)
        (error "Empty deque --" name)
        (car (select-pair deque))
    )
)


; currently broken (well, it'll work up to n = 2)
    ; need DOUBLY linked list, which CANNOT be implemented by simple pairs.
    ; start with front-insert! and THEN generalize; don't go confusing yourself unnecessarily.

; mutators - using a shared driver to emphasize symmetry, reduce code size, and consolidate bugs into one nontrivial routine
(define (front-insert-deque! deque item)
    (insert-deque! deque item front-ptr set-front-ptr! rear-ptr set-rear-ptr!))
(define (rear-insert-deque! deque item)
    (insert-deque! deque item rear-ptr set-rear-ptr! front-ptr set-front-ptr!))
(define (insert-deque! deque new-item select-entry set-entry! select-exit set-exit!)
    (let ((new-pair (cons new-item '())))
    
        (if (empty-deque? deque)
            (begin
                (set-cdr! new-pair new-pair)
                (set-entry! deque new-pair)
                (set-exit! deque new-pair)
            ) ; damn you scheme nesting, damn you straight to hell
            
            (let (  (old-entry (select-entry deque))
                    (old-exit (select-exit deque))
                    )
            
                (define (regular-insert!)                    
                    (set-cdr! new-pair old-exit)
                    (set-cdr! old-exit new-pair)
                    (set-exit! deque new-pair)
                    'unused-return-value
                )
                
               
               ;
               ;    ; deque has 1 item: needs to be handled separately, to break the loop on the non-entry side
               ;    ; alternative to passing in the exit procedures: break the symmetry here by assigning another local variable based on whether select-entry eq? front-ptr
               ;    ; (but symmetry was ALREADY broken when choosing which fn to pass in as select-entry, so...)
               ;    ;(begin                        
               ;    ;    (set-cdr! (select-exit deque) new-pair) ; break the loop!                    
               ;        (regular-insert!)
               ;    ;)                    
                   (regular-insert!)   ; i think this is a little clearer than having the else clause do nothing
               ;)   
            
            )
            
            
        )
    )
    (display "\nshared exit")
    (printable-deque deque)
)



; 

;(define (rear-deque deque)  ; COULD combine into a driver with front-deque, but then 
;    (if (empty-deque? deque)
;        (error "Empty deque -- FRONT-DEQUE")
;        (car (rear-ptr deque))
;    )
;)

; my custom convenience functions
(define (printable-deque deque)
    (define (iter front rear)
        (if (eq? front rear)
            (cons (car front) '())
            (cons (car front) (iter (cdr front) rear))
        )
    )
    
    (if (empty-deque? deque)
        '()
        (iter (front-ptr deque) (rear-ptr deque))
    )
    ;'giggity
)
        
       
       
(define (test-3.33)

    (let ((d (make-deque)))
        ;(newline) (display (front-insert-deque! d 1))
        ;(newline) (display (front-insert-deque! d 2))
        (newline) (display (front-insert-deque! d 3))
        (display "first rear-insert!")
        (newline) (display (rear-insert-deque! d 4))
        ;(display "second rear-insert!")
        ;newline) (display (rear-insert-deque! d 5))
    )
)
(test-3.33)
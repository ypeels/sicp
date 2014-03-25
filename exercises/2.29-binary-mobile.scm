; this exercise feels familiar... did i do it in 2001?

; from problem statement
(define (make-mobile left right)
  (list left right))
(define (make-branch len structure)     ; don't use the keyword length... damn you mr. scheme...
  (list len structure))
  
  
; Exercise 2.29a
(define (left-branch mobile)            ; these follow directly from the definition of (make-mobile)
    (car mobile))
(define (right-branch mobile)
    (cadr mobile))
(define (branch-length branch)          ; these follow directly from the definition of (make-branch)
    (car branch))
(define (branch-structure branch)
    (cadr branch))
    
    
; Exercise 2.29b
(define (is-mobile? x)
    (and    (list? x)                   ; found this built-in by my own experimentation
            (not (null? x))             ; need to watch out because (list? ()) = #t
    )
)

(define (left-submobile m)
    (branch-structure (left-branch m)))
(define (right-submobile m)
    (branch-structure (right-branch m)))

(define (is-valid-weight? x) 
    (and (number? x) (>= x 0)); let's check for negative weights while we're at it
)
    
(define (total-weight x)
    (cond 
        ; careful! can't just use (left-branch) because a branch is itself a list...
        ((is-mobile? x)
            (+  (total-weight (left-submobile x))
                (total-weight (right-submobile x))))
        ((is-valid-weight? x)    
            x)
        (else
            (error "Bad input in total-weight" x))
    )
)
            

; Exercise 2.29c
(define (branch-torque branch) 
    (*  (branch-length branch)
        (total-weight (branch-structure branch))
    )
)

(define (mobile-is-balanced? m)

    (cond
        ((is-mobile? m)
            (let (  (lb (left-branch m))    (lm (left-submobile m))
                    (rb (right-branch m))   (rm (right-submobile m)))
            
                ; A mobile is said to be balanced if...
                (and 
                    ; the torque applied by its top-left branch is equal to that applied by its top-right branch...
                    (= (branch-torque lb) (branch-torque rb))
                    
                    ; and if each of the submobiles hanging off its branches is balanced.
                    (mobile-is-balanced? lm)
                    (mobile-is-balanced? rm)
                )
            )
        )
                
        ((is-valid-weight? m) #t)
        (else (error "unknown data? in mobile-is-balanced?" m))
    )
)



; for part d, see its own file




(define (test-2.29)

    ; test data from http://community.schemewiki.org/?sicp-ex-2.29
     ;; A test mobile: 
     ;; Level 
     ;; ----- 
     ;; 3                   4  |    8                                      
     ;;              +---------+--------+ 2                        
     ;; 2         3  |  9                                        
     ;;        +-----+----+ 1                                    
     ;; 1    1 | 2                                       
     ;;    +---+---+                             
     ;;    2       1 
     (define level-1-mobile (make-mobile (make-branch 2 1) 
                                         (make-branch 1 2))) 
     (define level-2-mobile (make-mobile (make-branch 3 level-1-mobile) 
                                         (make-branch 9 1))) 
     (define level-3-mobile (make-mobile (make-branch 4 level-2-mobile) 
                                         (make-branch 8 2))) 
    
    (newline)    
    
    (define (test-mobile m)
        (display "\nweight: ") (display (total-weight m))
        (display "\nbalanced? ") (display (mobile-is-balanced? m))
        (newline)
    )
    
    (test-mobile level-1-mobile) ; weight 3 and balanced
    (test-mobile level-2-mobile) ; weight 4 and balanced
    (test-mobile level-3-mobile) ; weight 6 and balanced
    
    
    
)

; (test-2.29)
                    
        
        
    

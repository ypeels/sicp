(load "2.29-binary-mobile.scm")

; overrides from problem statement
(define (make-mobile left right)
    (cons left right))                  ; instead of list
(define (make-branch len structure)
    (cons len structure))               ; instead of list
    
    
; 2.29a' - necessary overrides for selectors. (left-branch) and (branch-length) can stay unchanged
(define (right-branch mobile)
    (cdr mobile))                       ; instead of cadr
(define (branch-structure branch)
    (cdr branch))                       ; instead of cadr
    
; 2.29b
(define (is-mobile? x)
    (pair? x))                          ; no nil elements at all in this new tree!
    
    
; I think that's IT? that's all i need to change?
; - change low-level representation, and only a couple selectors need to change? 
; Since I was careful and wrote everything in terms of API's wherever possible
; This was not really something they taught that clearly, but that I did instinctively after years of practice...
(newline) (display "Exercise 2.29d\n") (test-2.29)
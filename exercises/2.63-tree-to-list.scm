(load "2.63-65-sets-as-binary-trees.scm")

; from problem statement
(define (tree->list-1 tree)
  (if (null? tree)
      '()                                                       ; my guess: bottom-up (recursive popping up)
      (append (tree->list-1 (left-branch tree))                 ; 1. left
              (cons (entry tree)                                ; 2. current
                    (tree->list-1 (right-branch tree))))))      ; 3. right
(define (tree->list-2 tree)                                     ; right!
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list                                             ; my guess: top-down (iterative percolating down)
        (copy-to-list (left-branch tree)                        ; 3. left
                      (cons (entry tree)                        ; 1. current
                            (copy-to-list (right-branch tree)   ; 2. right
                                          result-list)))))      ; WRONG!
  (copy-to-list tree '()))                                      ; but successive (cons builds a list from the RIGHT
  
  
; stepping through:
; (copy-to-list '(1 (2 () ()) (3 () ())) '())
    ; = (copy-to-list  
    ;       '(2 () ())  
    ;       (cons 1 (copy-to-list '(3 () ()) '())))
            ; sigh... (copy-to-list '(3 () ()) '()) = (copy-to-list '() (cons 3 (copy-to-list '() '())))
                ; = (copy-to-list '() (cons 3 '())
                ; = (cons 3 '())
    ; = (copy-to-list 
    ;       '(2 () ())              ; tree
    ;       (cons 1 (cons 3 '())))  ; result-list
    ; = (copy-to-list 
    ;       '()
    ;       (cons 2 (copy-to-list '() '(1 3))))
    ; = (copy-to-list '() '(2 1 3))
    ; = '(2 1 3).
  
; second glance
    ; new result-list = (cons entry (copy right)) = (cons entry right-subtree)
    ; then pass this along to the final call with the left-subtree
    
; third glance: v2
    ; (copy-to-list right) will return SOME result from the right 
    ; (cons current right) builds the result further
    ; pass this running result to the left
    ; always recurse right first
    ; builds list from right to left using cons, thus result is in ascending order
    
; third glance: v1
    ; a little easier to wrap your brain around, because (append) means traversal order == final list order
    
; subtle, insidious differences
    ; v1 returns null but appends return values. EXPLOITS (append L '()) == L.
    ; v2 returns result-list (unmodified at null nodes) and does NOT use append
    
    ; v1 has uncoupled recursions left then right, resulting in (append left center right)
    ; v2 sequentially recurses right then left 
        ; the building of its data structure is less transparent because it is passed as an argument


  
  
  
  
; both look O(n) to me... unless (append is not O(1)... 
; they both have to access each of the n nodes once.
; unlike searching, tree UNBUILDING is an O(n) operation.

; sols: v1 is O(n log n) but v2 is O(n). hmmmmm.....
    ; "append is O(n)". why?? couldn't you just change a null pointer to the head of the next list?
  
(define (test-2.63)

    (define (test tree)
        (display "\nversion 1: ") (display (tree->list-1 tree))
        (display "\nversion 2: ") (display (tree->list-2 tree))
    )
    
    ;(define (leaf x) (list x '() '())
    
    ;(test (make-tree 1 2 3)) ; no, to use their over-simple (entry, (left-branch, and (right-branch,
                                ; you have to add () nodes EXPLICITLY.
    (test (make-tree 1 () ()))
    
    (test '(1 () ()))
    (test '(1 (2 () ()) ()))
    (test '(1 () (3 () ())))
    (test '(1 (2 () ()) (3 () ())))
    
    ; trees from Figure 2.16
    (test '(7 (3 (1 () ()) (5 () ())) (9 () (11 () ()))))
    (test '(3 (1 () ()) (7 (5 () ()) (9 () (11 () ())))))
    (test '(5 (3 (1 () ()) ()) (9 (7 () ()) (11 () ()))))
    
    ; order is always the SAME for both methods, and ASCENDING.
)

; (test-2.63)


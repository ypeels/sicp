; just a basic example of traversing AND rebuilding a binary tree (with and without map)

; mimic (scale-tree)
(define (square-tree tree)
    (cond
    
        ; leave null nodes untouched
        ((null? tree) ())
        
        ; leaf node: square it!
        ((not (pair? tree))
            (square tree))
            
        ; climb that tree
        (else
            (cons 
                (square-tree (car tree))
                (square-tree (cdr tree))
            )
        )
    )
)


; mimic (scale-tree) with map
(define (square-tree-map tree)
    (map                                    ; (map) will handle horizontal traversal (within the current level)
        (lambda (subtree)
            (if (pair? subtree)
                (square-tree-map subtree)   ; recursion will handle vertical traversal (to the next level)
                (square subtree)
            )
        )
        tree
    )
)





(define (test-2.30)

    (let (  (tree  (list 1
                   (list 2 (list 3 4) 5)
                   (list 6 7))))
                   
        (newline) (display "(1 (4 (9 16) 25) (36 49)) - expected answer") 
        (newline) (display (square-tree tree))  
        (newline) (display (square-tree-map tree))
    )
)

; (test-2.30)

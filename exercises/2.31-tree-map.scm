; just a tiny modification to 2.30, right?
(define (tree-map proc tree)
    (map
        (lambda (subtree)
            (if (pair? subtree)             ; should really make this its own procedure "is-tree?"...
                (tree-map proc subtree)     ; these 2 lines are the only difference with (square-tree-map)
                (proc subtree)              
            )
        )
    )
)




; old test code seems to work fine
; (define (square-tree-map tree) (tree-map square tree)) (load "2.30-square-tree.scm") (test-2.30)